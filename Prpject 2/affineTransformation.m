% All credits go to:                  
% Author:Ioannis Kessopoulos          
% Date Project Started: 01/05/2020  

function cq=affineTransformation(cp,R,ct)

  cp_r=R*cp;  %cp rot   1`ated

  cq=cp_r+ct;

end