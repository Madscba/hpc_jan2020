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
jacobi_kernel(double ***u, double ***u_old, double ***f, int N, double delta) {
    int i, j, k;
	double tmpi, tmpj, tmpk;
	i = blockIdx.x * blockDim.x * gridDim.x + threadIdx.x+1;
	j = blockIdx.y * blockDim.y * gridDim.y  + threadIdx.y+1;
	k = blockIdx.z * blockDim.z * gridDim.z  + threadIdx.z+1;
	if (i < N+1 && j < N+1 && k < N+1){
		tmpi = (u_old[i-1][j][k] + u_old[i+1][j][k]);
		tmpj = (u_old[i][j-1][k] + u_old[i][j+1][k]);
		tmpk = (u_old[i][j][k-1] + u_old[i][j][k+1]);
		u[i][j][k] = (tmpi + tmpj + tmpk + delta*f[i][j][k]) / 6.0;
	}
}

int
jacobi(double ***u_d0, double ***u_old_d0, double ***f_d0,double ***u_d1, double ***u_old_d1, double ***f_d1, double ***u_h, double ***u_old_h, double ***f_h, int N, double delta, int iter_max) {
	double*** temp;
	int k = 0;
    double d = 0.0;
	dim3 dimBlock(10,10,10); //Threads per block
    dim3 dimGrid((N+dimBlock.x-1)/dimBlock.x,(N+dimBlock.y-1)/dimBlock.y,1); // Block in grid
	while(k<iter_max)
    {
        #ifdef _JACOBI
        // Execute kernel function
        jacobi_kernel<<<dimGrid,dimBlock>>>(u_d0,u_old_d0,f_d0,N,delta_sqr);
        jacobi_kernel<<<dimGrid,dimBlock>>>(u_d1,u_old_d1,f_d1,N,delta_sqr);
        checkCudaErrors(cudaDeviceSynchronize());
        #endif
        if ((k % 100) == 0)
		{   
    		transfer_3d(u_h,u_d0,N+2,N+2,N+2,cudaMemcpyDeviceToHost);
    		transfer_3d(u_h,u_d1,N+2,N+2,N+2,cudaMemcpyDeviceToHost);
    		transfer_3d(u_old_h,u_old_d0,N+2,N+2,N+2,cudaMemcpyDeviceToHost);
    		transfer_3d(u_old_h,u_old_d1,N+2,N+2,N+2,cudaMemcpyDeviceToHost);
            d = frobenius(u_h,u_old_h);
			printf("%i  %.5f\n", k, d);
        }
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
