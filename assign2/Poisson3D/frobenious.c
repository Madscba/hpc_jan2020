#include <math.h>
double frobenius(double ***u, double ***u_old, int N){
    int i, j, k;
    double sum=0.0;
    for (i = 1; i < N+1; i++) 
	{
		for (j = 1; j < N+1; j++)   
		{
			for (k = 1; k < N+1; k++) 
			{
                sum += pow(u[i][j][k] - u_old[i][j][k],2);
            }
        }
    }
    return sqrt(sum);

}