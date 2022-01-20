#ifndef _FROBENIUS
#define _FROBENIUS

__global__
void frobenius_kernel(double ***u, double ***u_old, int N, double sum);
double frobenius(double ***u, double ***u_old, int N);
#endif
