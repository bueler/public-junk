function gencount = mcmc(samples,red)
% MCMC  try out Markov Chain Monte Carlo, i.e. the Metropolis algorithm

if (nargin < 1) | (nargin > 2)
    error(strcat('usage:   gencount = mcmc(samples,red)',
                 '     or  gencount = mcmc(samples)'))
elseif nargin < 2
    red = 0;
end

f = @(x) (5*x(1).^2 + 1) * exp(- x'*x);                      % f>0 and unnormalized
%f = @(x) x(1).^2 * exp(- x'*x) .* (all(abs(x)<3));

subplot(4,1,1:3)
plot(-3:.1:3)
view(2)
hold on

X = [2.9 2.9]';
fX = f(X);
XX = zeros(2,samples);
XX(:,1) = X;
sigma = 0.5;
marker = 'r*';
gencount = 0;
k = 1;
while k < samples
    Xp = X + sigma * randn(2,1);      % proposed
    fXp = f(Xp);
    gencount = gencount+1;
    if fXp > 0                        % avoid  div 0  error in future
        ar = fXp / fX;                % acceptance ratio
        if (ar > 1) | (ar > rand(1))
            X = Xp;
            fX = fXp;
            if k > red
                marker = 'ko';
            end
            plot3(X(1),X(2),f(X)+.01,marker)
            k = k + 1;
            XX(:,k) = X;
        end
    end
end
hold off
axis([-3 3 -3 3])

subplot(4,1,4)
hist(XX(1,red+1:end),-3+.1:.2:3-.1)

    function plot(a)
        [xx,yy] = meshgrid(a,a);
        zz = zeros(size(xx));
        for j = 1:length(a)
          for k = 1:length(a)
            zz(j,k) = f([xx(j,k) yy(j,k)]');
          end
        end
        %h = surf(xx,yy,zz);
        %set(h,'edgecolor','none')
        contour(xx,yy,zz,30);
        %clabel(h)
    end
end

