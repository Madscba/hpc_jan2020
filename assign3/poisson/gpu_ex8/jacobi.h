/* jacobi.h - Poisson problem 
 *
 * $Id: jacobi.h,v 1.1 2006/09/28 10:12:58 bd Exp bd $
 */
__global__ 
void
jacobi_reduction_baseline(double ***u, double ***u_old, double ***f, int N, double delta, double *d);
__inline__ __device__ 
double blockReduceSum(double*** value);
__inline__ __device__ 
double warpReduceSum(double value);
__global__ 
void jacobi_reduction_warp(double ***u, double ***u_old, double ***f, int N, double delta, double *d);
__global__ 
void jacobi_reduction_presum(double ***u, double ***u_old, double ***f, int N, double delta, double *d) 
__global__
void jacobi_kernel(double ***u, double ***u_old, double ***f, int N, double delta);
int jacobi(double ***u_d, double ***u_old_d, double ***f_d, double ***u_h, double ***u_old_h, double ***f_h, int N, double delta, int iter_max, int NUM_BLOCKS, int THREADS_PER_BLOCK);
