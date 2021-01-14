function [next_v, next_P] = ellipsoid_fit_step(x,y,z,v,P,R)

H = [x^2, y^2, z^2, 2*x*y, 2*x*z, 2*y*z, 2*x, 2*y, 2*z];

Y = 1 - H*v;
% S(k) = H(k)*P(k|k-1)*H(k)' + R(k)
S = H*P*H' + R;
% K(k) = P(k|k-1)*H(k)'*S(k)^-1
K = P*H'/S; 
% X(k|k) = X(k|k-1) + K(k)*Y(k)
v = v + K*Y;
% P(k|k) = P(k|k-1) - K(k)*H(k)*P(k|k-1);
P = P - K*H*P;
%     P = (eye(9)-K*H)*P*(eye(9)-K*H)'+K*R*K';

next_v = v;
next_P = P;

end

