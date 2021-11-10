% All credits go to:                  
% Author:Ioannis Kessopoulos          
% Date Project Started: 01/05/2020  

function dp=systemTransformation(cp,b1,b2,b3,co)

  [~,n2]=size(cp);
  dp=zeros(3,n2);

  rotation_transformation=[b1,b2,b3];
  rotation_transformation=rotation_transformation./norm(rotation_transformation);

  a= (cp-repmat(co',size(cp,1),1))';
  dp=rotation_transformation \ a; % new coordinates

end