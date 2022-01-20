/* jacobi.h - Poisson problem 
 *
 * $Id: jacobi.h,v 1.1 2006/09/28 10:12:58 bd Exp bd $
 */

#ifndef _JACOBI_H
#define _JACOBI_H
__global__
void jacobi_kernel(double ***u, double ***u_old, double ***f, int N, double delta);
int jacobi(double ***u, double ***u_old, double ***f, int N, double delta, int iter_max, int NUM_BLOCKS, int THREADS_PER_BLOCK);

#endif