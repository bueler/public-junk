function T = heatwithloops(D,J,K,dt,N)

dx = 2 / J;    dy = 2 / K;
[x,y] = meshgrid(-1:dx:1, -1:dy:1);
T = exp(-30*(x.*x + y.*y));

mu_x = dt * D / (dx*dx);
mu_y = dt * D / (dy*dy);
Tnew = T;  % allocate space for new values by copying T
for n=1:N
   for j=2:J
     for k=2:K
       Tnew(j,k) = T(j,k) + ...
                   mu_x * ( T(j+1,k) - 2 * T(j,k) + T(j-1,k) ) + ...
                   mu_y * ( T(j,k+1) - 2 * T(j,k) + T(j,k-1) );
     end
   end
   T = Tnew;  % overwrite old values (update to next time)
end

surf(x,y,T),  shading('interp'),  xlabel x,  ylabel y
