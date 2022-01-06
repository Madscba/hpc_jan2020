#ifndef __MATMULT_NAT_H
#define __MATMULT_NAT_H

void matmult_blk(int m, int n, int k, double **A, double **B, double **C, int bs);
#endif