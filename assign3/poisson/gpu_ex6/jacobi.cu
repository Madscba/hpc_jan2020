/* jacobi.c - Poisson problem in 3d
 * 
 */
#include <math.h>
#include <float.h>

__global__
void
jacobi(double ***u, double ***u_old, double ***f, int N, double delta) {
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
