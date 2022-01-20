/* jacobi.c - Poisson problem in 3d
 * 
 */
#include <math.h>
#include <float.h>
#include <stdio.h>

void
jacobi(double ***u, double ***u_old, double ***f, int N, double delta) {
    int i, j, k;
	double tmpi, tmpj, tmpk;	
	printf("kernel1 %f \n",u[2][2][2]); 
	printf("kernel2 %f \n",u_old[2][2][2]);
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
	printf("kernel3 %f \n",u[2][2][2]); 
	printf("kernel4 %f \n",u_old[2][2][2]);
	printf("F %f \n",f[2][2][2]);
    // fill in your code here
}
