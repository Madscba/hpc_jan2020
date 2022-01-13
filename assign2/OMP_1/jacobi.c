/* jacobi.c - Poisson problem in 3d
 * 
 */
#include <math.h>
#include <float.h>

void
jacobi(double ***u, double ***u_old, double ***f, int N, double delta) {
    int i, j, k;
	#pragma omp parallel shared(u,u_old) private(i,j,k)
	{
	#pragma omp for
    for (i = 1; i < N+1; i++) 
	{
		for (j = 1; j < N+1; j++)   
		{
			for (k = 1; k < N+1; k++) 
			{	
				double tmpX = (u_old[i-1][j][k] + u_old[i+1][j][k]);
				double tmpY = (u_old[i][j-1][k] + u_old[i][j+1][k]);
				double tmpZ = (u_old[i][j][k-1] + u_old[i][j][k+1]);
				u[i][j][k] = (tmpX + tmpY + tmpZ + delta*f[i][j][k]) / 6.0;
			}
		}
	}
	}
    


    // fill in your code here
}
