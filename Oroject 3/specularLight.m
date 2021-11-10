
% All credits go to:                  
% Author:Ioannis Kessopoulos          
% Date Project Started: 28/05/2020    
% View      

function I = specularLight(P, N, C, ks, ncoeff, S, I0)

    I = zeros(3,1);
    n = size(S,2);
   
    for i = 1:n
        L = S(:,i)-P;
        distance = norm(L);
        L = L/distance;
        
        V = C-P;
        V = V/norm(V);
        
        cossp = dot( 2*N*dot(N,L) - L, V );
        
        if ( cossp <= 0 )
            continue
        end
    
        %Ypologizei to fwtismo shmeioy P logo katwptrikhs anaklashs kai mas dinei thn entash ths trixrwmikhs poy anaklatai apo to shmeio    
        
        I=I + (I0(:,i).*ks )*(cossp^ncoeff);
    end
        
   for i = 1:3
        if ( I(i) > 1 )
            I(i) = 1;
        elseif ( I(i) < 0 )
            I(i) = 0;
        end
    end

end