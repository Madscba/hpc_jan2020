/* jacobi.c - Poisson problem in 3d
 * 
 */
#include <math.h>
#include <float.h>
#include "frobenius.h"
#include <helper_cuda.h>
#include "transfer3d_gpu.h"

__global__
void
jacobi_0(double ***u, double ***u_old_d0,double ***u_old_d1, double ***f, int N, double delta) {
    //Handle top part of matrix
    int i, j, k;
	double tmpi, tmpj, tmpk;
	i = blockIdx.z * blockDim.z + threadIdx.x+1; //We ignore the boundaries
	j = blockIdx.y * blockDim.y + threadIdx.y+1;
	k = blockIdx.x * blockDim.x + threadIdx.z+1;
	if (j < N+1 && k < N+1 && i == (N+2)/2-1 ) // i == (N+2)/2-1  if we are on bottom of the top half of the matrix
	{ 
		tmpi = (u_old_d0[i-1][j][k] + u_old_d1[0][j][k]); //We want to retrieve data from the 0'th index of the u_old_d1
		tmpj = (u_old_d0[i][j-1][k] + u_old_d0[i][j+1][k]);
		tmpk = (u_old_d0[i][j][k-1] + u_old_d0[i][j][k+1]);
		u[i][j][k] = (tmpi + tmpj + tmpk + delta*f[i][j][k]) / 6.0;
	} else if(i < (N+2)/2-2 && j < N+1 && k < N+1)
	{
		tmpi = (u_old_d0[i-1][j][k] + u_old_d0[i+1][j][k]);
		tmpj = (u_old_d0[i][j-1][k] + u_old_d0[i][j+1][k]);
		tmpk = (u_old_d0[i][j][k-1] + u_old_d0[i][j][k+1]);
		u[i][j][k] = (tmpi + tmpj + tmpk + delta*f[i][j][k]) / 6.0;
	}
}


__global__
void
jacobi_1(double ***u, double ***u_old_d0,double ***u_old_d1, double ***f, int N, double delta) {
	//Handle bottom part of matrix
    int i, j, k;
	double tmpi, tmpj, tmpk;
	i = blockIdx.z * blockDim.z + threadIdx.z; //we start in the middle of the hosts version of u.
	j = blockIdx.y * blockDim.y + threadIdx.y + 1; ////We ignore the boundaries
	k = blockIdx.x * blockDim.x + threadIdx.x + 1;
	if (j < N+1 && k < N+1 && i == 0) // i == 0 if we are on top of the bottom half of the matrix
	{ 
		tmpi = (u_old_d0[(N+2)/2-2][j][k] + u_old_d1[i+1][j][k]); //We want to retrieve data from the ((N+2)/2-2)'th index of the u_old_d0
		tmpj = (u_old_d1[i][j-1][k] + u_old_d1[i][j+1][k]);
		tmpk = (u_old_d1[i][j][k-1] + u_old_d1[i][j][k+1]);
		u[i][j][k] = (tmpi + tmpj + tmpk + delta*f[i][j][k]) / 6.0;
	} else if(i < (N+2)/2-1 && j < N+1 && k < N+1) // i < (N+2)/2-1 lets us ignore the bottom boundary of matrix
	{
		tmpi = (u_old_d1[i-1][j][k] + u_old_d1[i+1][j][k]);
		tmpj = (u_old_d1[i][j-1][k] + u_old_d1[i][j+1][k]);
		tmpk = (u_old_d1[i][j][k-1] + u_old_d1[i][j][k+1]);
		u[i][j][k] = (tmpi + tmpj + tmpk + delta*f[i][j][k]) / 6.0;
	}
}

int
jacobi(double ***u_d0, double ***u_old_d0, double ***f_d0,double ***u_d1, double ***u_old_d1, double ***f_d1, double ***u_h, double ***u_old_h, double ***f_h, int N, double delta, int iter_max) {
	double*** temp0;
	double*** temp1;
	int k = 0;
    double d = 0.0;
	//dim3 dimBlock(10,10,10); //Threads per block
    //dim3 dimGrid((N+dimBlock.x-1)/dimBlock.x,(N+dimBlock.y-1)/dimBlock.y,1); // Block in grid
    
    const int BLOCK_SIZE = 10;
	dim3 dimBlock(BLOCK_SIZE,BLOCK_SIZE,BLOCK_SIZE);
	dim3 dimGrid(ceil((double)(N+2)/BLOCK_SIZE/2),ceil((double)(N+2)/BLOCK_SIZE),ceil((double)(N+2)/BLOCK_SIZE));
	
	while(k<iter_max)
    {
        // Execute kernel function
		cudaSetDevice(0);
		jacobi_0<<<dimGrid,dimBlock>>>(u_d0,u_old_d0,u_old_d1,f_d0,N,delta);
		cudaSetDevice(1);
        jacobi_1<<<dimGrid,dimBlock>>>(u_d1,u_old_d0,u_old_d1,f_d1,N,delta);
        checkCudaErrors(cudaDeviceSynchronize());
		cudaSetDevice(0);
		checkCudaErrors(cudaDeviceSynchronize());
        /*if ((k % 100) == 0)
		{   
			// Transfer back top part
			transfer_3d_to_1d(u_h[0][0],u_d0,(N+2)/2,(N+2),(N+2),cudaMemcpyDeviceToHost);
			transfer_3d_to_1d(u_old_h[0][0],u_old_d0,(N+2)/2,(N+2),(N+2),cudaMemcpyDeviceToHost);
            d = frobenius(u_h,u_old_h,N);
			printf("%i  %.5f\n", k, d);
        }*/
        temp0 = u_old_d0;
        u_old_d0 = u_d0;
        u_d0  = temp0;
        temp1 = u_old_d1;
        u_old_d1 = u_d1;
        u_d1  = temp1;
        k+=1;
    }
	return k;
}
