/* gauss_seidel.c - Poisson problem in 3d
 *
 */
#include <math.h>

void
gauss_seidel(double ***u, double ***f, int N, double delta) 
{
    int i, j, k;
	double tmpX, tmpY, tmpZ;
    for (i = 1; i < N+1; ++i) 
	{
		for (j = 1; j < N+1; ++j)   
		{
			for (k = 1; k < N+1; ++k) 
			{	
				tmpX = (u[i-1][j][k] + u[i+1][j][k]);
				tmpY = (u[i][j-1][k] + u[i][j+1][k]);
				tmpZ = (u[i][j][k-1] + u[i][j][k+1]);
				u[i][j][k] = (tmpX + tmpY + tmpZ + delta*f[i][j][k]) / 6.0;
			}
		}
	}
}

