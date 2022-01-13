/* gauss_seidel.c - Poisson problem in 3d
 *
 */
#include <math.h>

void
gauss_seidel(double ***u, double ***f, int N, double delta) 
{
	// This is a implementation of the wavefront parallelization scheme with doacross loops
    int i, j, k;
	#pragma omp parallel for schedule(static,1) ordered(2) private(i,j,k)
    for (i = 1; i < N+1; ++i) 
	{
		for (j = 1; j < N+1; ++j)   
		{
			#pragma omp ordered depend(sink: i-1,j) depend(sink: i,j-1)
			for (k = 1; k < N+1; ++k) 
			{	
				double tmpX = (u[i-1][j][k] + u[i+1][j][k]);
				double tmpY = (u[i][j-1][k] + u[i][j+1][k]);
				double tmpZ = (u[i][j][k-1] + u[i][j][k+1]);
				u[i][j][k] = (tmpX + tmpY + tmpZ + delta*f[i][j][k]) / 6.0;
			}
			#pragma omp ordered depend(source)
		}
	}
}

