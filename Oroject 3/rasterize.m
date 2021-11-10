% All credits go to:                  
% Author:Ioannis Kessopoulos          
% Date Project Started: 01/05/2020  

function PRast=rasterize(P,M,N,H,W)
  
  P_x=(P(1,1) + (W/2))/W;
  P_y=(P(2,1) + (H/2))/H;

  P_x_rasterized=P_x*M;
  P_y_rasterized=P_y*N;

  PRast(1,1)=floor(P_x_rasterized);
  PRast(2,1)=floor(P_y_rasterized);

end