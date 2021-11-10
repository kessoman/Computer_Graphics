
% All credits go to:                  
% Author:Ioannis Kessopoulos          
% Date Project Started: 28/05/2020    
% View      

function I = diffuseLight(P, N, kd, S, I0)
   
     I = zeros(3,1);
    
    for i = 1:size(S,2)
        L = S(:,i)-P;
        distance = norm(L);
        L = L/distance;       
        cos = dot(N,L);
        
        if (cos <= 0)
            continue;
        end
       
       %Ypologizeei to fwtismo shmeioy P logo diaxyths anaklashs kai mas dinei thn entash ths trixrwmikhs poy anaklatai apo to shmeio 
        
        I = I + ( I0(:,i).*kd )*cos;
    
    for i = 1:3
        if ( I(i) > 1 )            
            I(i) = 1;
        elseif ( I(i) < 0 )
            I(i) = 0;
        end
    end    
end