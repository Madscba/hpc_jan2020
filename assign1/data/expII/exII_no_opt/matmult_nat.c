

/*int main()
{
	
}

double ** dmalloc_2d(int m, int n) {
    if (m <= 0 || n <= 0) return NULL;
    double **A = malloc(m * sizeof(double *));
    if (A == NULL) return NULL;
    A[0] = malloc(m*n*sizeof(double));
    if (A[0] == NULL) {
        free(A); 
        return NULL; 
    }
    for (int i = 1; i < m; i++)
        A[i] = A[0] + i * n;
    return A;
}*/




void matmult_nat(int m,int n,int k,double **A,double **B,double **C){
	
	//initialization of C
	for(int i = 0; i< m; i++)
	{
		for(int j = 0; j < n; j++)
		{
			C[i][j] = 0;
		}
	}
	
	for(int i = 0; i< m; i++)
	{
		for(int j = 0; j < n; j++)
		{
			for(int l = 0; l < k; l++){
				C[i][j] += A[i][l] * B[l][j];
			}
		}
	}
	
}


void matmult_mnk(int m,int n,int k,double **A,double **B,double **C)
{
	//Same as native matmult func
	//initialization of C
	for(int i = 0; i< m; i++)
	{
		for(int j = 0; j < n; j++)
		{
			C[i][j] = 0;
		}
	}
	
	
	for(int i = 0; i< m; i++)
	{
		for(int j = 0; j < n; j++)
		{
			C[i][j] = 0;
			for(int l = 0; l < k; l++){
				C[i][j] += A[i][l] * B[l][j];
			}
			
		}
	}
}

void matmult_mkn(int m,int n,int k,double **A,double **B,double **C)
{
	//initialization of C
	for(int i = 0; i< m; i++)
	{
		for(int j = 0; j < n; j++)
		{
			C[i][j] = 0;
		}
	}
	for(int i = 0; i< m; i++)
	{	
		for(int l = 0; l < k; l++)
		{
			for(int j = 0; j < n; j++)
			{
				C[i][j] += A[i][l] * B[l][j];
			}
			
		}
	}
}
void matmult_nmk(int m,int n,int k,double **A,double **B,double **C)
{
	//initialization of C
	for(int i = 0; i< m; i++)
	{
		for(int j = 0; j < n; j++)
		{
			C[i][j] = 0;
		}
	}
	
	for(int j = 0; j < n; j++)
	{	
		for(int i = 0; i< m; i++)
		{
			for(int l = 0; l < k; l++)
			{
				C[i][j] += A[i][l] * B[l][j];
			}
		}
	}
	
}
void matmult_nkm(int m,int n,int k,double **A,double **B,double **C)
{
	//initialization of C
	for(int i = 0; i< m; i++)
	{
		for(int j = 0; j < n; j++)
		{
			C[i][j] = 0;
		}
	}
	for(int j = 0; j < n; j++)
	{	
		for(int l = 0; l < k; l++)
		{
			for(int i = 0; i< m; i++)
			{
				C[i][j] += A[i][l] * B[l][j];
			}
			
		}
	}
	
}
void matmult_kmn(int m,int n,int k,double **A,double **B,double **C)
{
	//initialization of C
	for(int i = 0; i< m; i++)
	{
		for(int j = 0; j < n; j++)
		{
			C[i][j] = 0;
		}
	}
	for(int l = 0; l < k; l++)
	{	
		for(int i = 0; i< m; i++)
		{
			for(int j = 0; j < n; j++)
			{
				C[i][j] += A[i][l] * B[l][j];
			}
			
		}
	}
}
void matmult_knm(int m,int n,int k,double **A,double **B,double **C)
{
	//initialization of C
	for(int i = 0; i< m; i++)
	{
		for(int j = 0; j < n; j++)
		{
			C[i][j] = 0;
		}
	}
	for(int l = 0; l < k; l++)
	{	
		for(int j = 0; j < n; j++)
		{
			for(int i = 0; i< m; i++)
			{
				C[i][j] += A[i][l] * B[l][j];
			}
			
		}
	}
}

/*void matmult_blk(int m,int n,int k,double **A,double **B,double **C, int bs){
	
	
}*/
