
// Source Routine

int locate_node(int coord);
void source_routine()
{
 int i,j;
 FILE *in;
 char  string[50];


   psource=v_alloc1d(Max_Time); 
   //psource1=v_alloc1d(Max_Time);

   sprintf( string,"%s",input2);
   if(( in= fopen(string,"r")) ==NULL)
   {
      printf("Error opening file %s \n", string);
      MPI_Finalize();
      fclose(in);
      exit(1);
   }
  for(i=0; i<Max_Time; i++)
  {
    fscanf(in,"%lf \n",&psource[i]);
    //fscanf(in,"%lf %lf\n",&psource[i],&psource1[i]);
  }
  fclose(in);


   // Read in the x and y positions of sources:
   sprintf( string,"%s",input1);
   if(( in= fopen(string,"r")) ==NULL)
   {
      printf("Error opening file %s \n", string);
      MPI_Finalize();
      fclose(in);
      exit(1);
   }
   for (i = 0; i < NumSource; i++)
   {
      source[0][i]=source[1][i]=0;
      fscanf( in,"%d %d\n", &source[0][i], &source[1][i]);
   }
   fclose(in);


}

void force_source()
{
  int i,j;

  i=source[1][0];
  j=source[0][0]%Nx;
  
  if(i==Ny) { i=0;  }
  if(i==-1) { i=Ny-1; }
   
  if(locate_node(source[0][0])==my_rank)
  {
    force[i][j][sdir] = force[i][j][sdir] + sscale*psource[run_time];
  }
   

}


void vol_source()
{
  int i,j,jj;

   i=source[1][0];
   j=source[0][0]%Nx;
   jj=(source[0][0]+1)%Nx;
  

   if(i==Ny) { i=0;  }
   if(i==-1) { i=Ny-1; }
   
   if(locate_node(source[0][0])==my_rank)
   {
          force[i][j][0] = force[i][j][0] - sscale*psource[run_time];
          force[i][j][1] = force[i][j][1] - sscale*psource[run_time];
          
          force[i+1][j][0] = force[i+1][j][0] - sscale*psource[run_time];
          force[i+1][j][1] = force[i+1][j][1] + sscale*psource[run_time];
   }
   if(locate_node(source[0][0]+1)==my_rank)
   {
          force[i][jj][0] = force[i][jj][0] + sscale*psource[run_time];
          force[i][jj][1] = force[i][jj][1] - sscale*psource[run_time];

          force[i+1][jj][0] = force[i+1][jj][0] + sscale*psource[run_time];
          force[i+1][jj][1] = force[i+1][jj][1] + sscale*psource[run_time];
   }

}


void stress_source()
{
  int i,j,jj,jm,n;
  double pscale;

  pscale=0.5*dx*sscale;

  i=source[1][0];
  j=source[0][0]%Nx;
  jj=(source[0][0]+1)%Nx;
  jm=(source[0][0]-1)%Nx;

   if(i==Ny) { i=0;  }
   if(i==-1) { i=Ny-1; }

  /* if(locate_node(source[0][0])==my_rank)
   {
     force[i+1][j][1] = force[i+1][j][1] + pscale*psource[run_time]*(mzz-mxz);
     force[i-1][j][1] = force[i-1][j][1] - pscale*psource[run_time]*(mzz-mxz);
   }
   if(locate_node(source[0][0]+1)==my_rank)
   {
     force[i][jj][0] = force[i][jj][0] + pscale*psource[run_time]*(mxx-mxz);
   }
   if(locate_node(source[0][0]-1)==my_rank)
   {
     force[i][jm][0] = force[i][jm][0] - pscale*psource[run_time]*(mxx-mxz);
   }*/

  /* if(locate_node(source[0][0])==my_rank)
   {
          force[i][j][0] = force[i][j][0] - pscale*psource[run_time]*(mxx-mxz);
          force[i][j][1] = force[i][j][1] - pscale*psource[run_time]*(mzz-mxz);

          force[i+1][j][0] = force[i+1][j][0] - pscale*psource[run_time]*(mxx-mxz) ;
          force[i+1][j][1] = force[i+1][j][1] + pscale*psource[run_time]*(mzz-mxz);
   }
   if(locate_node(source[0][0]+1)==my_rank)
   {
          force[i][jj][0] = force[i][jj][0] + pscale*psource[run_time]*(mxx+mxz);
          force[i][jj][1] = force[i][jj][1] - pscale*psource[run_time]*(mzz+mxz);

          force[i+1][jj][0] = force[i+1][jj][0] + pscale*psource[run_time]*(mxx+mxz);
          force[i+1][jj][1] = force[i+1][jj][1] + pscale*psource[run_time]*(mzz+mxz);
   } */

   if(locate_node(source[0][0])==my_rank)
   {
          force[i-1][j][1] = force[i-1][j][1] - pscale*psource[run_time]*mzz;
          force[i+1][j][1] = force[i+1][j][1] + pscale*psource[run_time]*mzz;

          force[i-1][j][0] = force[i-1][j][0] + pscale*psource[run_time]*mxz;
          force[i+1][j][0] = force[i+1][j][0] - pscale*psource[run_time]*mxz;

   }
   if(locate_node(source[0][0]+1)==my_rank)
   {
          force[i][jj][0] = force[i][jj][0] - pscale*psource[run_time]*mxx;

          force[i][jj][1] = force[i][jj][1] - pscale*psource[run_time]*mxz;
   }
   if(locate_node(source[0][0]-1)==my_rank)
   {
          force[i][jm][0] = force[i][jm][0] + pscale*psource[run_time]*mxx;

          force[i][jm][1] = force[i][jm][1] + pscale*psource[run_time]*mxz;
   }



}

double ranf()
{
const int ia=16807,ic=2147483647,iq=127773,ir=2836;
int il,ih,it;
double rc;
int t1,t2,t3,t4,t5,t6;
time_t ts,tp;
struct tm t;
int iseed;

/* Initial seed from the system time and and forced to be odd */

ts = time(&tp);
t  = *gmtime(&tp);
t1 = t.tm_sec+2*my_rank;
t2 = t.tm_min+3*my_rank;
t3 = t.tm_hour;
t4 = t.tm_mday;
t5 = t.tm_mon;
t6 = t.tm_year;
iseed = t6+70*(t5+2*my_rank+12*(t4+31*(t3+23*(t2+59*t1))));
iseed=iseed*drand48();
ih = iseed/iq;
il = iseed%iq;
it = ia*il-ir*ih;
if (it > 0)
  {
  iseed = it;
  }
else
  {
iseed = ic+it;
  }
rc = ic;
return iseed/rc;
}

void noise_source()
{
 int i,j,jj;
 double pscale;

 pscale=0.5*dx*sscale;

 j=75;
 if(locate_node(j)==my_rank)
 {
  jj=j%Nx;
  for(i=100; i<Ny; i++)
  {
    if(vp[i][jj]!=-1974)
    {
    force[i][jj][0] = force[i][jj][0] + sscale*(-1.0+2.0*ranf());
    force[i][jj][1] = force[i][jj][1] + sscale*(-1.0+2.0*ranf());
    }
  }
 }
 j=437;
 if(locate_node(j)==my_rank)
 {
  jj=j%Nx;
  for(i=100; i<Ny; i++)
  {
    if(vp[i][jj]!=-1974)
    {
    force[i][jj][0] = force[i][jj][0] + sscale*(-1.0+2.0*ranf());
    force[i][jj][1] = force[i][jj][1] + sscale*(-1.0+2.0*ranf());
    }
  }
 }
 
 for(j=75; j<437; j++)
 {
 if(locate_node(j)==my_rank)
 {
    i=75; jj=j%Nx;
    if(vp[i][jj]!=-1974)
    { 
    force[i][jj][0] = force[i][jj][0] + sscale*(-1.0+2.0*ranf());
    force[i][jj][1] = force[i][jj][1] + sscale*(-1.0+2.0*ranf());
    }
 }
 }
 
}
