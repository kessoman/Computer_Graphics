
% All credits go to:                  
% Author:Ioannis Kessopoulos          
% Date Project Started: 28/05/2020    
% View      

function Y = shadeGouraud(p, Vn, Pc, C, S, ka, kd, ks, ncoeff, Ia, I0, X)

    total_illumination = zeros(3,3);
    for i = 1:3
        total_illumination(:,i) = total_illumination(:,i) + ambientLight(ka(:,i),Ia); 
        
        total_illumination(:,i) = total_illumination(:,i) + diffuseLight(Pc, Vn(:,i), kd(:,i), S, I0);
        
        total_illumination(:,i) = total_illumination(:,i) + specularLight(Pc, Vn(:,i), C, ks(:,i), ncoeff, S, I0);
    end
 
%Ypologizei to xrwma stis koryfes toy trigwnoy poy dinetai kai to xrwmatizei me th mthodo Gouraud    
    
    Y = triPaintGouraud(X, p', total_illumination');

end