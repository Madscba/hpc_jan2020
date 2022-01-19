extern "C" {
#include <cblas.h>


void matmult_lib(int m,int n,int k,double *A,double *B,double *C){
	/* Level 3 BLAS: cblas_interface.pdf, page 191 line 5
	 * performed operation: C <- alpha * AB + beta*C */
	int alpha = 1;
	int beta = 0;
	//int CblasNoTrans = 111;
	int lda = k;
	int ldb = n;
	int ldc = n;
	//DGEMM(TRANSA, TRANSB, m, n, k, ALPHA, A, LDA, B, LDB, BETA, C, LDC);
	cblas_dgemm(CblasRowMajor, CblasNoTrans, CblasNoTrans, m,n,k, alpha, A, lda, B, ldb, beta, C, ldc);
	
}
}
