function c = bisect(a,b,f,N)
% BISECT  Initial implementation of bisection.  Example:
%   >> f = @(x) x^4 - 3*x + 1
%   >> bisect(0,1,f,10)
% Possible improvements:
%   * store current f(a), f(b) values as fa and fb, and make sure there is
%     only one new function evaluation per step  (Epperson Alg. 3.2)
%   * use tolerance not number of steps as input  (Epperson Alg. 3.2)
%   * use  "c = a + 0.5*(b-a)"  (if you believe Epperson Alg. 3.2)
%   * make "disp" statements optional so this can be put inside other codes

if f(a) * f(b) > 0, error('[a,b] is not an initial bracket'), end

for k=1:N
  disp([a b]);            % show current bracket
  c = (a+b)/2;            % get its midpoint
  if f(c) == 0.0          % stop if exactly done (rare)
    break;
  elseif f(a) * f(c) < 0  % decide if [a c] or [c b] is new bracket
    b = c;
  else
    a = c;
  end
end
disp([a b]);              % show last bracket
end

