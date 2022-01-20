/* jacobi.c - Poisson problem in 3d
 * 
 */
#include <math.h>
#include <float.h>
#include <stdio.h>
#include <helper_cuda.h>
#include "transfer3d_gpu.h"
#include "frobenius.h"
#include "alloc3d_gpu.h"


__global__
void
jacobi_kernel(double ***u, double ***u_old, double ***f, int N, double delta) {
    int i, j, k;
	double tmpi, tmpj, tmpk;
	printf("kernel %f \n",u[2][2][2]); 
	printf("kernel %f \n",u_old[2][2][2]);
    for (i = 1; i < N+1; i++) 
	{
		for (j = 1; j < N+1; j++)   
		{
			for (k = 1; k < N+1; k++) 
			{	
				tmpi = (u_old[i-1][j][k] + u_old[i+1][j][k]);
				tmpj = (u_old[i][j-1][k] + u_old[i][j+1][k]);
				tmpk = (u_old[i][j][k-1] + u_old[i][j][k+1]);
				u[i][j][k] = (tmpi + tmpj + tmpk + delta*f[i][j][k]) / 6.0;
			}
		}
	}
}

int
jacobi(double ***u_d, double ***u_old_d, double ***f_d, double ***u_h, double ***u_old_h, double ***f_h, int N, double delta, int iter_max) {
	double*** temp;
	int k = 0;
    double d = 0.0;

	while(k<iter_max)
    {
        // Execute kernel function
        jacobi_kernel<<<1,1>>>(u_d,u_old_d,f_d,N,delta);
        checkCudaErrors(cudaDeviceSynchronize());
		//  #Comment out when benchmarking!!#
        if ((k % 100) == 0)
		{   
			transfer_3d(u_h,u_d,N+2,N+2,N+2,cudaMemcpyDeviceToHost);
			transfer_3d(u_old_h,u_old_d,N+2,N+2,N+2,cudaMemcpyDeviceToHost);
			printf("%f \n",u_h[2][2][2]); 
			printf("%f \n",u_old_h[2][2][2]);
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
