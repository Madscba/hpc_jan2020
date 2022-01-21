/* jacobi.c - Poisson problem in 3d
 * 
 */
#include <math.h>
#include <float.h>
#include <helper_cuda.h>
#include "transfer3d_gpu.h"
#include "frobenius.h"


__global__ 
void
jacobi_reduction_baseline(double ***u, double ***u_old, double ***f, int N, double delta, double *d) {
	double a;
	int i = blockIdx.z * blockDim.z + threadIdx.z+1;
	int j = blockIdx.y * blockDim.y + threadIdx.y+1;
	int k = blockIdx.x * blockDim.x + threadIdx.x+1; 
    if (i < N+1 && j < N+1 && k < N+1) {
		double tmpi = (u_old[i-1][j][k] + u_old[i+1][j][k]);
		double tmpj = (u_old[i][j-1][k] + u_old[i][j+1][k]);
		double tmpk = (u_old[i][j][k-1] + u_old[i][j][k+1]);
		u[i][j][k] = (tmpi + tmpj + tmpk + delta*f[i][j][k]) / 6.0;
		a = sqrt((u[i][j][k]-u_old[i][j][k])*(u[i][j][k]-u_old[i][j][k]));
        atomicAdd(d,a);
    }
}

__inline__ __device__ 
double warpReduceSum(double value) { 
    for (int i = 16; i > 0; i /= 2) 
        value += __shfl_down_sync(-1, value, i);  
    return value; 
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
    if (threadIdx.x % warpSize == 0 && threadIdx.y % warpSize == 0 && threadIdx.z % warpSize == 0){
		 atomicAdd(d, value);
	} 
}

int
jacobi(double ***u_d, double ***u_old_d, double ***f_d, double ***u_h, double ***u_old_h, double ***f_h, int N, double delta, int iter_max, int NUM_BLOCKS, int THREADS_PER_BLOCK) {
	double*** temp;
	int k = 0;
	double frob;
    double *d;
	double *d_h0;
	double *d_h1;
	cudaMallocHost((void**)&d_h0, sizeof(double)*1);
	cudaMallocHost((void**)&d_h1, sizeof(double)*1);
	d_h1[0] = 1000000.0;	
	cudaMalloc((void**)&d, sizeof(double)*1);
	double tolerance = 1.0; 
	dim3 dimBlock(8,8,8); //Threads per block
    dim3 dimGrid((N+dimBlock.x-1)/dimBlock.x,(N+dimBlock.y-1)/dimBlock.y,(N+dimBlock.z-1)/dimBlock.z); // Blocks in grid
	while(d_h1[0]>tolerance && k<iter_max)
    {
		d_h0[0] = 0.0;
		cudaMemcpy(d,d_h0, sizeof(double), cudaMemcpyHostToDevice);
        // Execute kernel function
		jacobi_reduction_warp<<<dimGrid,dimBlock>>>(u_d,u_old_d,f_d,N,delta,d);        
		checkCudaErrors(cudaDeviceSynchronize());
		cudaMemcpy(d_h0,d, sizeof(double)*1, cudaMemcpyDeviceToHost);
		d_h1[0] = d_h0[0];
        temp = u_old_d;
        u_old_d = u_d;
        u_d  = temp;
        k+=1;
    }
	return k;
}