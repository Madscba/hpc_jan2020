#include <stdio.h>
 __global__
void m_overwrite(int N, double ***u, double ***u_old)
{
	//overwrite values of matrix u into u_old indentically square matrices
	printf("I'm here! \n");
	int i, j, k;
    for (i = 1; i < N+1; i++) 
	{
		for (j = 1; j < N+1; j++)   
		{
			for (k = 1; k < N+1; k++) 
			{	
				u_old[i][j][k] = u[i][j][k];
			}
		}
	}
}
