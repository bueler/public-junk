function gencount = mcmc(samples,red)
% MCMC  try out Markov Chain Monte Carlo, i.e. the Metropolis algorithm.
% Example:
%    >> mcmc(500,20)

if (nargin < 1) | (nargin > 2)
    error(strcat('usage:   gencount = mcmc(samples,red)',
                 '     or  gencount = mcmc(samples)'))
elseif nargin < 2
    red = 0;
end

f = @(x) (5*x(1).^2 + 1) * exp(- x'*x);   % f>0 and unnormalized
L = 3;

subplot(4,1,1:3)
plot(-L:.1:L)
view(2)
hold on

X = [2.9 2.9]';
fX = f(X);
XX = zeros(2,samples);
XX(:,1) = X;
sigma = 0.5;
gencount = 0;
k = 1;
showit(X,fX,k)
while k < samples
    Xp = X + sigma * randn(2,1);      % proposed
    fXp = f(Xp);
    gencount = gencount+1;
    if fXp > 0                        % avoid  div 0  error in future
        ar = fXp / fX;                % acceptance ratio
        if (ar > 1) | (ar > rand(1))
            X = Xp;
            fX = fXp;
            showit(X,fX,k)
            k = k + 1;
            XX(:,k) = X;
        else
            showreject(X,Xp)
        end
    end
end
hold off
axis([-L L -L L])

subplot(4,1,4)
hist(XX(1,red+1:end),-L+.1:.2:L-.1)

    function showit(X,fX,k)
        if k <= red
            marker = 'r*';
        else
            marker = 'ko';
        end
        plot3(X(1),X(2),fX+0.1,marker)
    end

    function showreject(X,Xp)
        plot3([X(1) Xp(1)],[X(2) Xp(2)],[10 10],'color',[0 0 0]+.7,'linewidth',0.6)
    end

    function plot(a)
        [xx,yy] = meshgrid(a,a);
        zz = zeros(size(xx));
        for j = 1:length(a)
          for k = 1:length(a)
            zz(j,k) = f([xx(j,k) yy(j,k)]');
          end
        end
        contour(xx,yy,zz,30);
    end
end

