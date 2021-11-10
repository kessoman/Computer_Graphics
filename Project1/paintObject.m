% All credits go to:                  
% Author:Ioannis Kessopoulos          
% Date Project Started: 09/03/2020    
% Filling Triangles                   

function I = paintObject(V, F, C, D, painter)
    
    M=1200;
    N=1200;	
    I = ones(M,N,3);
    triangles_depth = zeros(length(F(:,1)),2);

    % Calculating the depth of each triangle
    for j=1:length(F(:,1)) 
        triangle_tops = F(j,:); % the tops of triagnle j
        first_top_depth = D(triangle_tops(1));
        second_top_depth = D(triangle_tops(2));
        third_top_depth = D(triangle_tops(3));
         triangle_depth = (first_top_depth + second_top_depth + third_top_depth) / 3;   
         triangles_depth(j,:) = [j triangle_depth];   
    end

    triangles_depth = sortrows(triangles_depth,2); % sorting triangles according to their depth from low to high
    
     % Cross matrix from end to fill the  triangles that have the lowest time of "filling" first
    for i = length(triangles_depth(:,1)):-1:1
        triangle_tops = F(triangles_depth(i,1),:);
        triangle_coordinates = [ V(triangle_tops(1),:) ; V(triangle_tops(2),:) ; V(triangle_tops(3),:)];
        triangle_tops_rgb = [ C(triangle_tops(1),:) ; C(triangle_tops(2),:) ; C(triangle_tops(3),:) ];
        if strcmp(painter, "Flat") == 1 %strcmp() is a built-in function i use so i am able to check the type of the painter   
            I = triPaintFlat(I, triangle_coordinates, triangle_tops_rgb);
           elseif strcmp(painter, "Gouraud") == 1
            I = triPaintGouraud(I, triangle_coordinates, triangle_tops_rgb);
           else
           fprintf('There is no such painter.');
            return;    
        end
    end
end