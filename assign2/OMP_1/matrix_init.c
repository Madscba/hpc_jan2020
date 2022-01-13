#include <math.h>
#include <stdio.h>

void init_inner(int outer_size,double start_T, double ***matrix)
{
	
	int loop_size = outer_size-1; //Should only init from 1-N+1
	for(int i = 1; i < loop_size; i++)
	{	
		for(int j = 1; j < loop_size; j++)
		{
			for(int k = 1; k < loop_size; k++)
			{

				matrix[i][j][k] = start_T;
			}
			
		}
	}
}

void init_bounds(int outer_size,double mw_T, double sw_T, double ***matrix)
{
	//sw_T = single wall temperature
	//mw_T = multiple wall temperature
	int loop_size = outer_size-1; 


	//x-z plane with y=1  (start phys (x,y,z)=(-1,1,-1), start idx (z,y,x)=(i,j,k)=(0->N+2 , 0 , 0->N+2)
	for(int j = 0; j < outer_size; j++)
	{
		for(int k = 0; k < outer_size; k++)
		{
			//     (z,y,x) (i,j,k)
			matrix[j][0][k] = mw_T;
		}
	
	}

	//x-z plane with y=-1  (start phys (x,y,z)=(-1, -1,-1), start idx (z,y,x)=(i,j,k)=(0->N+2 , N+2  , 0->N+2)
	for(int j = 0; j < outer_size; j++)
	{
		for(int k = 0; k < outer_size; k++)
		{
			//     (z,y,x) (i,j,k)
			matrix[j][loop_size][k] = sw_T;
		}
	
	}

	//x-y plane with z=1  (start phys (x,y,z)=(-1,1,1), start idx (z,y,x)=(i,j,k)=(N+2 , 0->N+2, 0->N+2 )
	for(int i = 0; i < outer_size; i++)
	{
		for(int k = 0; k < outer_size; k++)
		{
			//     (z,y,x) (i,j,k)
			matrix[loop_size][i][k] = mw_T;
		}
	
	}

	//x-y plane with z=-1  (start phys (x,y,z)=(-1,1,-1), start idx (z,y,x)=(i,j,k)=(0 , 0->N+2, 0->N+2 )
	for(int i = 0; i < outer_size; i++)
	{
		for(int k = 0; k < outer_size; k++)
		{
			//     (z,y,x) (i,j,k)
			matrix[0][i][k] = mw_T;
		}
	
	}


	//y-z plane with x=1  (start phys (x,y,z)=(1,1,1), start idx (z,y,x)=(i,j,k)=(0->N+2 , 0->N+2, N+2 )
	for(int j = 0; j < outer_size; j++)
	{
		for(int i = 0; i < outer_size; i++)
		{
			//     (z,y,x) (i,j,k)
			matrix[j][i][loop_size] = mw_T;
		}
	
	}

	//y-z plane with x=-1  (start phys (x,y,z)=(-1,1,-1), start idx (z,y,x)=(i,j,k)=(0-N+2 , 0->N+2, 0 )
	for(int j = 0; j < outer_size; j++)
	{
		for(int i = 0; i < outer_size; i++)
		{
			//     (z,y,x) (i,j,k)
			matrix[j][i][0] = mw_T;
		}
	
	}

	
	

	
	

}

void init_f(int outer_size,  double ***f)
{	
	int x_bound, y_bound, z_bound_start, z_bound_stop, i, j, k;
	int loop_size = outer_size-1; 

	// BE AWARE:
		//bounds have been given +1 or -1 since we use <=
		// Either "<" or ">" is used depending on which way we iterate
	x_bound = loop_size * (5.0/16.0) + 1.0;  	//outer_size/2 * (5/8) + 1
	y_bound = loop_size * (3.0/4.0) - 1.0; 	//outer_size/2 * (3/2) - 1
	z_bound_start = loop_size * (1.0/6.0) - 1.0; 	//outer_size/2 * (1/3)  
	z_bound_stop = loop_size/2.0 + 1.0; 
	

	for(i = z_bound_start; i < z_bound_stop; i++)
	{
		for(j = loop_size; j > y_bound; j--)
		{
			for(k = 0; k < x_bound; k++)
			{
				f[i][j][k] = 200.0;
			}
		}
		
	}
}


double f_analytical(double x, double y, double z)
{
	
	return 3.0*M_PI*M_PI*sin(M_PI*x)*sin(M_PI*y)*sin(M_PI*z);
}

void init_f_analytical(int outer_size,  double ***f)
{	
	int i, j, k;
	double delta = (double) 2.0/outer_size; 
	double x,y,z;
	for(i = 0; i < outer_size; i++)
	{
		for(j = 0; j < outer_size; j++)
		{
			for(k = 0; k < outer_size; k++)
			{
				x = (double) -1.0+k*delta;
				y = (double) 1.0-j*delta;
				z = (double) -1.0+i*delta;
				f[i][j][k] = f_analytical(x, y, z);
			}
		}
		
	}
}
double u_analytical(double x, double y, double z)
{
	
	return sin(M_PI*x)*sin(M_PI*y)*sin(M_PI*z);
}

void u_true_analytical(int outer_size,  double ***u)
{	
	int i,j,k;
	double delta = (double) 2.0/outer_size; 
	double x,y,z;
	for(i = 0; i < outer_size; i++)
	{
		for(j = 0; j < outer_size; j++)
		{
			for(k = 0; k < outer_size; k++)
			{
				x = (double) -1+k*delta;
				y = (double) 1-j*delta;
				z = (double) -1+i*delta;
				u[i][j][k] = u_analytical(x, y, z);
			}
		}
		
	}
}

void init_mat(int N,double start_T, int analytical, double ***f, double ***u){
	int outer_size = N + 2;
	
	/*m, matricen
	en væg 0 grader.
	(x,y,z) (k,j,i)*/


	if(analytical)
	{
		//initialization of the grid of u - initial guess
		init_inner(outer_size,start_T,u);	
		
		//initialization of boundaries
			/*arguments: 
				outer_size
				temperature for 5 walls
				temperature for wall in x-z plane with y=-1,
				matrix you would like to define boundaries for */
		init_bounds(outer_size,0, 0, u);
		
		//initialization of f radiator
		init_f_analytical(outer_size,f);

	}
	else
	{
		//initialization of the grid of u and f

		init_inner(outer_size, 0, f);
		
		init_inner(outer_size,start_T,u);
		
		//initialization of boundaries
			/*arguments: 
				outer_size
				temperature for 5 walls
				temperature for wall in x-z plane with y=-1,
				matrix you would like to define boundaries for */
		init_bounds(outer_size,20, 0, u);
		init_bounds(outer_size,0, 0, f);
		
		//initialization of f radiator
		init_f(outer_size,f);
	}
	



}
