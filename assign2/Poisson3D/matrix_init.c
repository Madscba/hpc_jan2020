


void init_inner(int outer_size,double T_start, double ***matrix){
	
	int loop_size = size-1; //Should only init from 1-N+1
	for(int i = 1; i < loop_size; i++)
	{	
		for(int j = 1; j < loop_size; j++)
		{
			for(int k = 1; k < loop_size; k++)
			{

				matrix[i][j][k] = T_start;
			}
			
		}
	}
}

void init_bounds(int outer_size,double mw_T, double sw_T, double ***matrix){
	//sw_T = single wall temperature
	//mw_T = multiple wall temperature
	int loop_size = size-1; 


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
		for(int i = 0; i < outer_size; k++)
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


void init_f()
{

}

void init_mat(int grid_size,double T_start, double ***f, double ***u){

	int outer_size = grid_size + 2;
	/*m, matricen
	en væg 0 grader.
	(x,y,z) (k,j,i)*/

	//initialization of the grid of u and f
	init_inner(outer_size, 0, f)
	init_inner(outer_size,T_start,u)
	


	//initialization of boundaries
		/*arguments: 
			outer_size
			temperature for 5 walls
			temperature for wall in x-z plane with y=-1,
			matrix you would like to define boundaries for */
	init_bounds(outer_size,20, 0, double u)
	init_bounds(outer_size,0, 0, double f)

	


	init_f()


}
