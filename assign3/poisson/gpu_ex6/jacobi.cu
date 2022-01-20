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
    double d = 0.0;
	printf("Also here! NB %i TB %i \n",NUM_BLOCKS,THREADS_PER_BLOCK);
	dim3 dimBlock(10,10,1);
    //dim3 dimBlock(NUM_BLOCKS,THREADS_PER_BLOCK,1);
	printf("dimBlock.x: %i dimBlock.y: %i dimBlock.z: %i",dimBlock.x,dimBlock.y,dimBlock.z);
    dim3 dimGrid((N+dimBlock.x-1)/dimBlock.x,(N+dimBlock.y-1)/dimBlock.y,1); 
	while(k<iter_max)
    {
        // Execute kernel function
		jacobi_kernel<<<dimGrid,dimBlock>>>(u_d,u_old_d,f_d,N,delta);        
		checkCudaErrors(cudaDeviceSynchronize());
		//  #Comment out when benchmarking!!#
        if ((k % 100) == 0)
		{   
			transfer_3d(u_h,u_d,N+2,N+2,N+2,cudaMemcpyDeviceToHost);
			transfer_3d(u_old_h,u_old_d,N+2,N+2,N+2,cudaMemcpyDeviceToHost);
            d = frobenius(u_d,u_old_d,N);
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
