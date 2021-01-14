
%% visualize fitting result
figure,
subplot(1,2,1);
% display original data
plot3( x, y, z, '.r' );
hold on;

% display fit ellipsoid
mind = min( [ x y z ] );
maxd = max( [ x y z ] );
nsteps = 50;
step = ( maxd - mind ) / nsteps;
[ X, Y, Z ] = meshgrid( linspace( mind(1) - step(1), maxd(1) + step(1), nsteps ), linspace( mind(2) - step(2), maxd(2) + step(2), nsteps ), linspace( mind(3) - step(3), maxd(3) + step(3), nsteps ) );

Ellipsoid = u(1) *X.*X +   u(2) * Y.*Y + u(3) * Z.*Z + ...
          2*u(4) *X.*Y + 2*u(5)*X.*Z + 2*u(6) * Y.*Z + ...
          2*u(7) *X    + 2*u(8)*Y    + 2*u(9) * Z;
      
fit_val = u(1) *x.*x +   u(2) * y.*y + u(3) * z.*z + ...
          2*u(4) *x.*y + 2*u(5)*x.*z + 2*u(6) * y.*z + ...
          2*u(7) *x    + 2*u(8)*y    + 2*u(9) * z;
isovalue = mean(fit_val);
p = patch( isosurface( X, Y, Z, Ellipsoid, isovalue ) );
hold off;
set( p, 'FaceColor', 'g', 'EdgeColor', 'none' );
view( -70, 40 );
axis equal;
camlight;
lighting phong;
xlabel('X'); ylabel('Y');zlabel('Z'); grid on;

xlim = get(gca,'Xlim');
ylim = get(gca,'Ylim');
zlim = get(gca,'Xlim');

% display calibrated data
XC=x-bias(1); YC=y-bias(2); ZC=z-bias(3); % translate to (0,0,0)
XYZC=rotM*[XC,YC,ZC]';
XC=XYZC(1,:);
YC=XYZC(2,:);
ZC=XYZC(3,:);
fitting_radius = sqrt(XC.*XC + YC.*YC + ZC.*ZC);
refr = mean(fitting_radius);

% display calibrated data points
subplot(1,2,2);
plot3(XC,YC,ZC,'r.');

% display reference sphere
[X, Y, Z] = sphere();
surface(refr*X, refr*Y, refr*Z, 'FaceColor', 'none');
xlabel('X'); ylabel('Y');zlabel('Z'); axis equal; grid on;

%% print fiting variables
fprintf( 'Ellipsoid bias: %.5g %.5g %.5g\n', bias );
fprintf( 'Rotation matrix:\n' );
fprintf( '%.5g %8.5g %8.5g\n%.5g %8.5g %8.5g\n%.5g %8.5g %8.5g\n', ...
    rotM(1), rotM(4), rotM(7), rotM(2), rotM(5), rotM(8), rotM(3), rotM(6), rotM(9) );
fprintf( 'Ellipsoid radius: %.5g %.5g %.5g\n', radii );
fprintf( 'Sphere radius: %.5g\n', refr );
fprintf( 'Algebraic form:\n' );
fprintf( '%.5g ', u );
fprintf( '\n' );