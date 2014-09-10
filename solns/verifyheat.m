function [avTerr,maxTerr] = verifyheat(J,L)
% VERIFYHEAT uses the Green's function of the D=1 heat equation, namely
% T_t = T_xx, at t=0.1 as initial condition.  It runs HEATADAPT forward for
% duration 1.0 to get the numerical solution.  Then it compares the numerical
% solution to the exact solution, which is the Green's function at t=1.1.
% Example demonstrating convergence; takes a few seconds:
%   >> for J=[20,40,80,160,320], verifyheat(J); end

if nargin<1, J=40; end;
if nargin<2, L=20; end;

dx = 2 * L / J;  [x,y] = ndgrid(-L:dx:L, -L:dx:L);

Texact = @(t,x,y) (4 * pi * t)^(-1) * exp(- (x.^2 + y.^2) / (4*t));
Tinitial = Texact(0.1,x,y);

Tfinalapprox = heatadapt(1.0,L,J,J,0.9,Tinitial);
Tfinalexact  = Texact(1.0,x,y);

err = Tfinalapprox - Tfinalexact;
fprintf('errors for %d x %d grid:\n',J,J)
avTerr = sum(sum(abs(err)))/(J+1)^2;
fprintf('  average T error  = %.3e\n',avTerr)
maxTerr = max(max(abs(err)));
fprintf('  maximum T error  = %.3e\n',maxTerr)

figure(2),   surf(x,y,err)
shading('flat'),   axis square,   view(2),   colorbar,  title('T error')

