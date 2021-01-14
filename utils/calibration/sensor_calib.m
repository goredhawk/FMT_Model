
%% read sensor data
[file,path] = uigetfile('*.*');
fprintf("sensor data file:%s\n", fullfile(path,file));
fid = fopen(fullfile(path,file));

Data = fscanf(fid, '%f %f %f', [3 inf]);
Data = Data';
fclose(fid);
x = Data(:,1);
y = Data(:,2);
z = Data(:,3);

%% choose sensor type
options = {'Accelerometer','Magnetometer','Gyroscope'};
[idx, value_selected] = listdlg('Name','Select Sensor Type','ListString',options);
if value_selected == 0
    error('Sensor not selected');
end
sensor = options{idx};
%% Calculate Calibration Parameters
if strcmp(sensor,'Gyroscope')
    gyro_bias = mean([x y z]);
    disp('gyro_bias = ');
    disp(gyro_bias);
    return;
elseif strcmp(sensor,'Accelerometer')
    est_off_diagonal_parameters = 0;
else strcmp(sensor,'Magnetometer')
    est_off_diagonal_parameters = 1;
end

if est_off_diagonal_parameters
    P = diag([10,10,10,1,1,1,1,1,1]);
else
    P = diag([10,10,10,0,0,0,1,1,1]);
end

v = zeros(9,1);

R = 0.001;

for i = 1:length(x)
    [v, P] = ellipsoid_fit_step(x(i),y(i),z(i),v,P,R);
end

[rotM, bias, u, radii] = ellipsoid_fit_solve(v);

plot_result;