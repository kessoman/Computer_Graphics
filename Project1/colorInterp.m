
% All credits go to:                  
% Author:Ioannis Kessopoulos          
% Date Project Started: 09/03/2020    
% Filling Triangles               


function color = colorInterp(A, B, a, b, x)

    total_length = (b - a); 
    length_atm = (x - a); %atm=at the moment

    % Compute Color
    
    if a ~= b
        
        color = (((B - A) / total_length ) * length_atm) + A;
        
    else 
        
        color = (A + B) / 2;
        
        %Thats because if a=b the colour that occurs is black and we need
        %to computeee thee mean value
        
    end
end