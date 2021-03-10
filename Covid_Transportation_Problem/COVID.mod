
set B;  #Additional buses
set N;  #Nodes in the graph: s,t, and all trips from 1 to n;
set C;  #Critical trips

param I{N};   #Operative parameter used to detect Node "s"
param F{N};   #Operative parameter used to detect Node "t"
param p{N};   #Number of extra passengers for each trip;


param u{N,N} ; #capacities of arcs

var  x {N,N} >= 0;   #Flow assigned to each arc, non-negative

maximize ServedPassengers :
sum  {i in N} sum {j in N} x[i,j]*p[i];

subject to CapacityConstraint {i in N, j in N} :
x[i,j] <= u[i,j];

subject to EnteringBusMustLeave {i in C} : 
sum  {j in N} x[j,i]  = sum  {k in N} x[i,k] ;

subject to AllUsedBusesMustReturn {i in N, j in N}:  
if I[i] = 1 and F[j] = 1 then sum  {k in N} x[i,k] - sum  {m in N} x[m,j] = 0;

subject to MaxUsableBuses {i in N}: 
  if I[i] = 1 then sum  {j in N} x[i,j] <= sum {k in B} 1;

subject to EachTripDoneAtMostOnce {i in C} :
 sum {j in N} x[j,i] <= 1;
