% All credits go to:                  
% Author:Ioannis Kessopoulos          
% Date Project Started: 01/05/2020  

function [P_2d, D] = photographObject(p, M, N, H, W, w, cv, ck, cu)
    
    [P, D] = projectCameraKu(w, cv, ck, cu, p);
    P_Rasterize = rasterize(P, M, N, H, W);
    P_2d = P_Rasterize;
    
end