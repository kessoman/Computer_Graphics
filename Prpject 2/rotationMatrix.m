% All credits go to:                  
% Author:Ioannis Kessopoulos          
% Date Project Started: 01/05/2020  

function R = rotationMatrix(theta, u)

    R = zeros(3,3); % Initialization - R is a 3x3 rotation matrix
    
    % Rodrigues Formula
    
    y = 1 - cos(theta);
    x = cos(theta);
    z = sin(theta);
    
    R(1,1) = y * (u(1))^2 + x;
    R(1,2) = y * u(1) * u(2) - z * u(3);
    R(1,3) = y * u(1) * u(3) + z * u(2);
    R(2,1) = y * u(2) * u(1) + z * u(3);
    R(2,2) = y * (u(2))^2 + x;
    R(2,3) = y * u(2) * u(3) - z * u(1);
    R(3,1) = y * u(3) * u(1) - z * u(2);
    R(3,2) = y * u(3) * u(2) + z * u(1);
    R(3,3) = y * (u(3))^2 + x;

end