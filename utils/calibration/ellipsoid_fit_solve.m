function [mat, bias, u, radii] = ellipsoid_fit_solve(v)

A = [ v(1) v(4) v(5) v(7); v(4) v(2) v(6) v(8); v(5) v(6) v(3) v(9); v(7) v(8) v(9) -1 ];
ofs=-A(1:3,1:3)\[v(7);v(8);v(9)]; % offset is center of ellipsoid
Tmtx=eye(4); Tmtx(4,1:3)=ofs'; AT=Tmtx*A*Tmtx'; % ellipsoid translated to (0,0,0)
[evecs ev]=eig(AT(1:3,1:3)/-AT(4,4)); % eigenvectors (rotation) and eigenvalues (gain)
gain=sqrt(1./diag(ev)); % gain is radius of the ellipsoid

g_mat = diag(1./gain);
% g_mat = diag(sqrt(diag(ev)));
% g_mat will rotate axis, so we need rotate axis back
trans_mat = evecs*g_mat*pinv(evecs);
% maintain the norm of input data
trans_mat = trans_mat'/norm(trans_mat);

bias = ofs;
mat = trans_mat;
u = v;
radii = gain;

end

