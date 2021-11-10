% All credits go to:                  
% Author:Ioannis Kessopoulos          
% Date Project Started: 01/05/2020  

function [P,D]=projectCameraKu(w,cv,ck,cu,p)

  camera_z= (ck-cv)./norm(ck-cv);
  t=cu-dot(cu,camera_z)*camera_z;
  camera_y=t ./norm(t);
  camera_x=cross(camera_y,camera_z);
  
  [P,D]=projectCamera(w,cv,camera_x,camera_y,p);

end