
% All credits go to:                  
% Author:Ioannis Kessopoulos          
% Date Project Started: 28/05/2020    
% View    

function Y = shadePhong(p, Vn, Pc, C, S, ka, kd, ks, ncoeff, Ia, I0, X)

%Calculates the colour for each point of the triangle using linear
%interpolation in normal vectors as well as in ka,kd,ks.

    Y = X;

    p = p';

    p(4,:) = p(1,:);
    ka(:,4) = ka(:,1);
    ks(:,4) = ks(:,1);
    kd(:,4) = kd(:,1);
    Vn(:,4) = Vn(:,1); 
    Pc(:,4) = Pc(:,1);
    
%Now we compute the characteristic values of each edge of the triangle and also we define and save the initial values of ka,ks,kd,Vn,Pc
%Also we include some required matrices for the function to wrok

    active_edges = zeros(3,12);
    zero = zeros(1,12);
    coordinate = zeros(1,3);
    
    x_y = zeros(1,3);
    
    y_maximum = zeros(3,1);
    y_minimum = zeros(3,1);
    x_maximum = zeros(3,1);
    x_minimum = zeros(3,1);
    
    slope = zeros(3,1);
    dx = zeros(3,1);
    dy = zeros(3,1);
    sign_of_slope = zeros(3,1);
    
    distance = zeros(3,1);
    dist = zeros(3,1);
    
    normalized_vector_pts = zeros(3,3);
    normalized_ks = zeros(3,3);
    normalized_ka = zeros(3,3);
    normalized_kd = zeros(3,3);
    
    starting_value_of_kd = zeros(3,3);
    starting_value_of_ks = zeros(3,3);
    starting_value_of_ka = zeros(3,3);
    starting_value_of_vn = zeros(3,3);
    starting_value_of_pc = zeros(3,3);
    
    normalized_pc = zeros(3,3);
    
    for i = 1:3
       
        y_maximum(i) = max(p(i,2),p(i+1,2));
        [y_minimum(i), idx] = min([p(i,2),p(i+1,2)]);
        x_maximum(i) = max(p(i,1),p(i+1,1));
        x_minimum(i) = min(p(i,1),p(i+1,1));
        
        dx(i) = p(i+1,1) - p(i,1);
        dy(i) = p(i+1,2) - p(i,2);
        
        slope(i) = dy(i) / dx(i);
        
        if dx(i) == 0 || dy(i) == 0
            sign_of_slope(i) = 0;
        else
            sign_of_slope(i) = sign(slope(i));
        end
        
        dx(i) = abs(dx(i));
        dy(i) = abs(dy(i));
        
        distance(i) = sqrt( dx(i)^2 + dy(i)^2 );
        
        if idx == 1
            
            coordinate(i) = p(i,1);
            x_y(i) = p(i,1);
            
            %Defining the starting values of the variables on whick we are
            %gonna wrok
            
            starting_value_of_ks(:,i) = ks(:,i);
            starting_value_of_kd(:,i) = kd(:,i);
            starting_value_of_ka(:,i) = ka(:,i);
            starting_value_of_vn(:,i) = Vn(:,i);
            starting_value_of_pc(:,i) = Pc(:,i);
            
            %Defining the normalized values of the pre-referred variables
            
            normalized_pc(:,i) = ( Pc(:,i+1) - Pc(:,i) ) ./ distance(i);
            normalized_vector_pts(:,i) = ( Vn(:,i+1) - Vn(:,i) ) ./ distance(i);
            normalized_kd(:,i) = ( kd(:,i+1) - kd(:,i) ) ./ distance(i);
            normalized_ka(:,i) = ( ka(:,i+1) - ka(:,i) ) ./ distance(i);
            normalized_ks(:,i) = ( ks(:,i+1) - ks(:,i) ) ./ distance(i);

            
        else
            
            coordinate(i) = p(i+1,1);
            x_y(i) = p(i+1,1);
            
            starting_value_of_ks(:,i) = ks(:,i+1);
            starting_value_of_kd(:,i) = kd(:,i+1);
            starting_value_of_ka(:,i) = ka(:,i+1);
            starting_value_of_vn(:,i) = Vn(:,i+1);
            starting_value_of_pc(:,i) = Pc(:,i+1);
            
            normalized_pc(:,i) = ( Pc(:,i) - Pc(:,i+1) ) ./ distance(i);            
            normalized_vector_pts(:,i) = ( Vn(:,i) - Vn(:,i+1) ) ./ distance(i);
            normalized_kd(:,i) = ( kd(:,i) - kd(:,i+1) ) ./ distance(i);
            normalized_ka(:,i) = ( ka(:,i) - ka(:,i+1) ) ./ distance(i);
            normalized_ks(:,i) = ( ks(:,i) - ks(:,i+1) ) ./ distance(i);
            
        end        
                            
    end                 
                   
%Updating variables according to index
            
    [z, index] = sort(y_minimum);
    
    y_minimum = z;
    y_maximum = y_maximum(index);
    x_maximum = x_maximum(index);
    x_minimum = x_minimum(index);
    slope = slope(index);
    
    dx = dx(index);
    dy = dy(index);
    sign_of_slope = sign_of_slope(index);
    
    distance = distance(index);
    
    normalized_ks = normalized_ks(:,index);
    normalized_ka = normalized_ka(:,index);
    normalized_kd = normalized_kd(:,index);
    normalized_vector_pts = normalized_vector_pts(:,index);
    
    ka = ka(:,index);
    ks = ks(:,index);
    kd = kd(:,index);
    starting_value_of_ka = starting_value_of_ka(:,index);
    starting_value_of_vn = starting_value_of_vn(:,index);
    
    coordinate = coordinate(index);
    x_y = x_y(index);
    Pc = Pc(:,index);
    normalized_pc = normalized_pc(:,index);
    
%For y_minimum to y_maximum we find the active lines and the active points

    minimum = min(y_minimum);
    maximum = max(y_maximum);  

    for y = minimum:maximum

        if ( ~isequal(active_edges(1,1:7), zeros(1,7)) && ~isequal(active_edges(1,9:12), zeros(1,4)) ) || ...
                ( ~isequal(active_edges(2,1:7), zeros(1,7)) && ~isequal(active_edges(2,9:12), zeros(1,4)) ) 
                        
             for i = 1:3       
               
                if active_edges(i,2) <= y
                    
                    active_edges(i,:) = 0;                    
                    
                end
                
            end
            
        end
        
        for i = 1:3 
            if y == y_minimum(i)
                
                if (isequal(active_edges(1,1:7),zeros(1,7)))
                    
                    active_edges(1,:) = [y_minimum(i) y_maximum(i) coordinate(i) dx(i) dy(i) distance(i) sign_of_slope(i) 0 i x_y(i) x_minimum(i) x_maximum(i)];
                    
                elseif (isequal(active_edges(2,1:7),zeros(1,7)))
                    
                    active_edges(2,:) = [y_minimum(i) y_maximum(i) coordinate(i) dx(i) dy(i) distance(i) sign_of_slope(i) 0 i x_y(i) x_minimum(i) x_maximum(i)];
                    
                elseif (isequal(active_edges(3,1:7),zeros(1,7)))
                    
                    active_edges(3,:) = [y_minimum(i) y_maximum(i) coordinate(i) dx(i) dy(i) distance(i) sign_of_slope(i) 0 i x_y(i) x_minimum(i) x_maximum(i)];
                    
                end                   
            end
        end
                    
        if active_edges(3,:) == 0
            
            active_edges(1:2,:) = sortrows(active_edges(1:2,:),7,'ascend');
            active_edges(1:2,:) = sortrows(active_edges(1:2,:),3,'ascend');
            
        elseif active_edges(1,:) == 0
            
            active_edges(1:2,:) = sortrows(active_edges(2:3,:),7,'ascend');
            active_edges(3,:) = 0;
            active_edges(1:2,:) = sortrows(active_edges(1:2,:),3,'ascend');        
        
        elseif active_edges(2,:) == 0
            
            active_edges(2,:) = active_edges(1,:);
            active_edges(1,:) = 0;            
            active_edges(1:2,:) = sortrows(active_edges(2:3,:),7,'ascend');
            active_edges(3,:) = 0;
            active_edges(1:2,:) = sortrows(active_edges(1:2,:),3,'ascend');        
        
        else         
            active_edges(1:3,:) = sortrows(active_edges(1:3,:),7,'ascend');
            active_edges(1:3,:) = sortrows(active_edges(1:3,:),3,'ascend');

        end
        
        if active_edges(1,3) > active_edges(2,3)
            
            disp("INSIDE")
            disp(active_edges)
            disp("WHY")
        end
        if (isequal(active_edges(2,:),zero) && isequal(active_edges(3,:),zero)) || ...
                ( isequal(active_edges(1,:),zero) && isequal(active_edges(3,:),zero))  || ...
                ( isequal(active_edges(2,:),zero) && isequal(active_edges(1,:),zero))        
            continue;
       end
        
        if (isequal(active_edges(:,:),zeros(3,12)))           
            continue;
        end
        
    %For x_left to x_right we perform linear interpolation for
    %ka,ks,kd,Vn,Pc and paint eachpixel of the filling interval
        
        x_left = active_edges(1,3);
        x_right = active_edges(2,3);

        if x_left > x_right
            disp("INSIDE")
            temp = x_left;
            x_left = x_right;
            x_right = temp;
            
            temporary_vec = active_edges(1,:);
            active_edges(1,:) = active_edges(2,:);
            active_edges(2,:) = temporary_vec;
            
        end        
        
        current_dist_first = pdist( [ active_edges(1,10), active_edges(1,1); x_left, y ],'euclidean' );
        current_dist_second = pdist( [ active_edges(2,10), active_edges(2,1); x_right, y ],'euclidean' );
        
       %Distances between vertexes thar define the active edges

        dist_first = sqrt( ( active_edges(1,11) - active_edges(1,12) )^2 + ( active_edges(1,1) - active_edges(1,2) )^2 );
        dist_second = sqrt( ( active_edges(2,11) - active_edges(2,12) )^2 + ( active_edges(2,1) - active_edges(2,2) )^2 );
       
        normal_vector_first = starting_value_of_vn(:,active_edges(1,9)) + ((current_dist_first * normalized_vector_pts(:,active_edges(1,9))));
        normal_vector_second = starting_value_of_vn(:,active_edges(2,9)) + ((current_dist_second * normalized_vector_pts(:,active_edges(2,9))));
        
        normal_vector_first = normal_vector_first ./norm(normal_vector_first);
        normal_vector_second = normal_vector_second ./ norm(normal_vector_second);
        
        ka_first = starting_value_of_ka(:,active_edges(1,9)) + (current_dist_first * normalized_ka(:,active_edges(1,9)));
        ka_second = starting_value_of_ka(:,active_edges(2,9)) + (current_dist_second * normalized_ka(:,active_edges(2,9)));
        
        ks_first = starting_value_of_ks(:,active_edges(1,9)) + (current_dist_first * normalized_ks(:,active_edges(1,9)));
        ks_second = starting_value_of_ks(:,active_edges(2,9)) + (current_dist_second * normalized_ks(:,active_edges(2,9)));
        
        kd_first = starting_value_of_kd(:,active_edges(1,9)) + ((current_dist_first * normalized_kd(:,active_edges(1,9))));
        kd_second = starting_value_of_kd(:,active_edges(2,9)) + ((current_dist_second * normalized_kd(:,active_edges(2,9))));
        
        pc_first = starting_value_of_pc(:,active_edges(1,9)) + ((current_dist_first * normalized_pc(:,active_edges(1,9))));
        pc_second = starting_value_of_pc(:,active_edges(2,9)) + ((current_dist_second * normalized_pc(:,active_edges(2,9))));        
        
        for x = x_left:x_right            
            
           normal_vector_interpolated= colorInterp(normal_vector_first, normal_vector_second, x_left, x_right, x);
           
           if x_left ~= x_right
               normal_vector_interpolated = normal_vector_interpolated / norm(normal_vector_interpolated);
           end
           
           %Defining the final values of the interoplated values of
           %ka.ks.kd.pc
           
           ka_interpolated = colorInterp(ka_first, ka_second, x_left, x_right, x);
            
           ks_interpolated = colorInterp(ks_first, ks_second, x_left, x_right, x);
            
           kd_interpolated = colorInterp(kd_first, kd_second, x_left, x_right, x);
           
           pc_interpolated = colorInterp(pc_first, pc_second, x_left, x_right, x);
            
           Y(y,x,:) = total_illumination(ka_interpolated, ks_interpolated, kd_interpolated, normal_vector_interpolated, S, C, pc_interpolated, Ia, I0, ncoeff);
            
        end
        
    %Finally, we update active edges    
    
    for j = 1:3
           
            if active_edges(j,7) == 0
                continue;
            end
            
            if active_edges(j,4) ~= 0 
                
                active_edges(j,8) = active_edges(j,8) + active_edges(j,4);
                
                while (active_edges(j,8) >= active_edges(j,5))
                    
                    active_edges(j,3) = active_edges(j,3) + active_edges(j,7);
                    active_edges(j,8) = active_edges(j,8) - active_edges(j,5);
                    
                end
            end
        end
       
    end
    
end