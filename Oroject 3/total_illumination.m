
% All credits go to:                  
% Author:Ioannis Kessopoulos          
% Date Project Started: 28/05/2020    
% View 

function light = total_illumination(ka, ks, kd, normal_vector, S, C, Pc, Ia, I0, ncoeff)

%Calculates total light of a point considering all of possible
%options(ambiest,diffyse,specular)
%P.s. this is an extra function.

    light = zeros(3,1);   
    light = light + ambientLight(ka, Ia);   
    light = light + diffuseLight(Pc, normal_vector, kd, S, I0);   
    light = light + specularLight(Pc, normal_vector, C, ks, ncoeff, S, I0);

%Output is the total Light    
    
end