clear all
close all
clc

[NxStatus Nx] = system('grep \ Nx example/input/PARAMETERS.h | cut -d "(" -f2 | cut -d ")" -f1');
Nx_mpi = str2num(Nx);
nproc=3;
Nx = Nx_mpi*nproc;

x= transpose([0:Nx-1]);
x_min = min(x);
x_max = max(x);
x_middle = (x_min + x_max)/2;


%topo = ones(size(x))*(Nx-100);
topoHight=200;
topo = Nx-100 -topoHight + round(gausswin(Nx)*topoHight);

fileID = fopen(['example/input/topo'],'w');

for i = [1:Nx]
  fprintf(fileID, '%i %i\n', x(i), topo(i));
end

fclose(fileID);

[NyStatus Ny] = system('grep \ Ny example/input/PARAMETERS.h | cut -d "(" -f2 | cut -d ")" -f1');
Ny = str2num(Ny);

y= transpose([0:Ny-1]);

[velpStatus velp] = system('grep \ velp example/input/PARAMETERS.h | cut -d "(" -f2 | cut -d ")" -f1');
velp = str2num(velp);

fileID = fopen(['example/input/vp'],'w');
for i = [0:Nx-1]
for j = [0:Ny-1]
  if topo(i+1) >= j
    vp = velp + (topo(i+1) - j)*5.0;
  else 
    vp = velp;
  end
  fprintf(fileID, '%i %i %f\n', i, j, vp);
end
end
fclose(fileID);
