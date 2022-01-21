/* jacobi.c - Poisson problem in 3d
 * 
 */
#include <math.h>
#
#include <float.h>
#include <helper_cuda.h>
#include "transfer3d_gpu.h"
#include "frobenius.h"


__global__ 
void
jacobi_reduction_baseline(double ***u, double ***u_old, double ***f, int N, double delta, double *d) {
	double *a[1];
	int i = blockIdx.z * blockDim.z + threadIdx.z+1;
	int j = blockIdx.y * blockDim.y + threadIdx.y+1;
	int k = blockIdx.x * blockDim.x + threadIdx.x+1; 
    if (i < N+1 && j < N+1 && k < N+1) {
		double tmpi = (u_old[i-1][j][k] + u_old[i+1][j][k]);
		double tmpj = (u_old[i][j-1][k] + u_old[i][j+1][k]);
		double tmpk = (u_old[i][j][k-1] + u_old[i][j][k+1]);
		u[i][j][k] = (tmpi + tmpj + tmpk + delta*f[i][j][k]) / 6.0;
		a[0] = sqrt((u[i][j][k]-u_old[i][j][k])*(u[i][j][k]-u_old[i][j][k]));
        atomicAdd(d,a);
    }
}

__inline__ __device__ 
double warpReduceSum(double value) { 
    for (int i = 16; i > 0; i /= 2) 
        value += __shfl_down_sync(-1, value, i);  
    return value; 
}

__inline__ __device__ 
double blockReduceSum(double value) { 
    __shared__ double smem[32]; // Max 32 warp sums 
 
    if (threadIdx.x < warpSize) 
        smem[threadIdx.x] = 0; 
    __syncthreads(); 
 
    value = warpReduceSum(value); 
 
    if (threadIdx.x % warpSize == 0) 
        smem[threadIdx.x / warpSize] = value; 
    __syncthreads(); 
 
    if (threadIdx.x < warpSize) 
        value = smem[threadIdx.x]; 
    return warpReduceSum(value); 
}

__global__ 
void jacobi_reduction_warp(double ***u, double ***u_old, double ***f, int N, double delta, double *d) 
{ 
	double value;
    int i = blockIdx.z * blockDim.z + threadIdx.z+1;
	int j = blockIdx.y * blockDim.y + threadIdx.y+1;
	int k = blockIdx.x * blockDim.x + threadIdx.x+1;
	if (i < N+1 && j < N+1 && k < N+1) {
		double tmpi = (u_old[i-1][j][k] + u_old[i+1][j][k]);
		double tmpj = (u_old[i][j-1][k] + u_old[i][j+1][k]);
		double tmpk = (u_old[i][j][k-1] + u_old[i][j][k+1]);
		u[i][j][k] = (tmpi + tmpj + tmpk + delta*f[i][j][k]) / 6.0;
		value = sqrt((u[i][j][k]-u_old[i][j][k])*(u[i][j][k]-u_old[i][j][k]));
	} else {
		value = 0.0;
	}
    value = warpReduceSum(value); 
    if (threadIdx.x % warpSize == 0){ // other idx?
		 atomicAdd(d, value);
	} 
}

__global__ 
void jacobi_reduction_presum(double ***u, double ***u_old, double ***f, int N, double delta, double *d) 
{ 
	double value = 0.0;
	int idx_i = blockIdx.z * blockDim.z + threadIdx.z+1;
	int idx_j = blockIdx.y * blockDim.y + threadIdx.y+1;
	int idx_k = blockIdx.x * blockDim.x + threadIdx.x+1; 
    //double value = 0; 
    for (int i = idx_i; i < N+1; i += blockDim.z * gridDim.z){
		for (int j = idx_j; j < N+1; i += blockDim.y * gridDim.y){
			for (int k = idx_k; k < N+1; i += blockDim.x * gridDim.x){
				double tmpi = (u_old[i-1][j][k] + u_old[i+1][j][k]);
				double tmpj = (u_old[i][j-1][k] + u_old[i][j+1][k]);
				double tmpk = (u_old[i][j][k-1] + u_old[i][j][k+1]);
				u[i][j][k] = (tmpi + tmpj + tmpk + delta*f[i][j][k]) / 6.0;
				value += sqrt((u[i][j][k]-u_old[i][j][k])*(u[i][j][k]-u_old[i][j][k]));
			}
		}
	}  
    value = blockReduceSum(value); 
    if (threadIdx.x == 0){
		atomicAdd(d, value); 
	} 
}


__global__
void
jacobi_kernel(double ***u, double ***u_old, double ***f, int N, double delta) {
    int i, j, k;
	double tmpi, tmpj, tmpk;
	i = blockIdx.z * blockDim.z + threadIdx.z+1;
	j = blockIdx.y * blockDim.y + threadIdx.y+1;
	k = blockIdx.x * blockDim.x + threadIdx.x+1;
	
	if (i < N+1 && j < N+1 && k < N+1){
		tmpi = (u_old[i-1][j][k] + u_old[i+1][j][k]);
		tmpj = (u_old[i][j-1][k] + u_old[i][j+1][k]);
		tmpk = (u_old[i][j][k-1] + u_old[i][j][k+1]);
		u[i][j][k] = (tmpi + tmpj + tmpk + delta*f[i][j][k]) / 6.0;
	}
}

int
jacobi(double ***u_d, double ***u_old_d, double ***f_d, double ***u_h, double ***u_old_h, double ***f_h, int N, double delta, int iter_max, int NUM_BLOCKS, int THREADS_PER_BLOCK) {
	double*** temp;
	int k = 0;
    double *d[1] = 10000000.0;
	double tolerance = 1.0; 
	dim3 dimBlock(10,10,10); //Threads per block
    dim3 dimGrid((N+dimBlock.x-1)/dimBlock.x,(N+dimBlock.y-1)/dimBlock.y,1); // Block in grid
	while(d[0]>tolerance && k<iter_max)
    {
        // Execute kernel function
		jacobi_reduction_baseline<<<dimGrid,dimBlock>>>(u_d,u_old_d,f_d,N,delta,d);        
		checkCudaErrors(cudaDeviceSynchronize());
		//  #Comment out when benchmarking!!#
        if ((k % 100) == 0)
		{   
			transfer_3d(u_h,u_d,N+2,N+2,N+2,cudaMemcpyDeviceToHost);
			transfer_3d(u_old_h,u_old_d,N+2,N+2,N+2,cudaMemcpyDeviceToHost);
            d = frobenius(u_h,u_old_h,N);
			printf("%i  %.5f\n", k, d);
        }
        //  #Comment out when benchmarking!!#
        temp = u_old_d;
        u_old_d = u_d;
        u_d  = temp;
        k+=1;
    }
	return k;
}
