/* jacobi.h - Poisson problem 
 *
 * $Id: jacobi.h,v 1.1 2006/09/28 10:12:58 bd Exp bd $
 */

#ifndef _JACOBI_H
#define _JACOBI_H

__global__
void jacobi(double ***u, double ***u_old, double ***f, int N, double delta);
int jacobi(double ***u_d0, double ***u_old_d0, double ***f_d0,double ***u_d1, double ***u_old_d1, double ***f_d1, double ***u_h, double ***u_old_h, double ***f_h, int N, double delta, int iter_max);
#endif
