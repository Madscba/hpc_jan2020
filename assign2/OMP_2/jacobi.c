/* jacobi.c - Poisson problem in 3d
 * 
 */
#include <math.h>
#include <float.h>
#include <stdio.h>

double
jacobi(double ***u, double ***u_old, double ***f, int N, double delta) {
    int i, j, k;
	double tmpi, tmpj, tmpk, dist;
	double d = 0.0;
	printf("kernel1 %f \n",u[1][2][2]); 
	printf("kernel2 %f \n",u_old[1][2][2]);
	#pragma omp parallel for shared(u, u_old, f, delta) private(i,j,k,tmpi,tmpj,tmpk, dist) reduction(+:d)
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
				dist = u[i][j][k] - u_old[i][j][k];
				d += dist*dist;
				if (f[i][j][k]>0){
				printf("F %i %i %i %f \n",i,j,k,f[i][j][k]);
				}
			}
		}
	}
	printf("kernel3 %f \n",u[1][2][2]); 
	printf("kernel4 %f \n",u_old[1][2][2]);
	return sqrt(d);
}
