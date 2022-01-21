#include <math.h>
#include <stdio.h>
__global__
void frobenius_kernel(double ***u, double ***u_old, int N,double sum){
    int i, j, k;
    double dist;
    for (i = 1; i < N+1; i++) 
	{
		for (j = 1; j < N+1; j++)   
		{
			for (k = 1; k < N+1; k++) 
			{   
                dist = u[i][j][k] - u_old[i][j][k];
                sum += dist*dist;
            }
        }
    }
}

double frobenius(double ***u, double ***u_old, int N){
    int i, j, k;
    double dist;
    double sum = 0.0;
    for (i = 1; i < N+1; i++) 
	{
		for (j = 1; j < N+1; j++)   
		{
			for (k = 1; k < N+1; k++) 
			{   
                dist = u[i][j][k] - u_old[i][j][k];
                sum += dist*dist;
            }
        }
    }
    return sqrt(sum);
}
