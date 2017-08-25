%modified version of https://www.mathworks.com/matlabcentral/fileexchange/45302-serialport-quaternion-data-visualize

fclose(instrfind);
%Creat Port
s = serial('COM29')
%Set Baudrate
set(s, 'Baudrate', 115200);
%Open Port 
fopen(s);
%Read First Data for Calibration 
a(1,:) = fscanf(s, '%f, %f, %f, %f');

%drift vector
e = zeros(1,4);

%start time
t0 = clock;

[yaw_c, pitch_c, roll_c]=quat2angle(a);

while 1
    %Read Data;
    flushinput(s);
    a(1,:)=fscanf(s,'%f, %f, %f, %f');
    %Convert Quaternion to Roll Pitch Yaw
    [yaw, pitch, roll] = quat2angle(a);
    [x,y,z] = sphere;
    h = surf(x,y,z);axis('square'); 
    xlabel('x'); ylabel('y'); zlabel('z');
    %Rotate Object
    rotate(h,[1,0,0],(roll-roll_c)*180/pi);
    rotate(h,[0,1,0],(pitch-pitch_c)*180/pi);
    rotate(h,[0,0,1],(yaw-yaw_c)*180/pi+90);
    view(0,0);
    drawnow;
    e = [(roll-roll_c)*180/pi, (pitch-pitch_c)*180/pi,(yaw-yaw_c)*180/pi+90, etime(clock, t0)]; 
end
fclose(s);