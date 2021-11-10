
% All credits go to:                  
% Author:Ioannis Kessopoulos          
% Date Project Started: 28/05/2020    
% View      

function Normals = findVertNormals(R,F)
%R pinakas me syntetagmenes koryfwn trigwnwn
%F pinakas me plhrofories trigwnwn, opoy h kathe stili exei tis koryfes twn
%ekastote trigwnwn
    Normals = zeros(3,8758);
    
    for i = 1:17504     
        first_vertex = R(:,F(1,i));
        second_vertex = R(:,F(2,i));
        third_vertex = R(:,F(3,i));     
        V = second_vertex - first_vertex;
        W = third_vertex - second_vertex;  
        N = cross(V,W);
        A = N ./ norm(N);        
        Normals(:,F(1,i)) = Normals(:,F(1,i)) + A;
        Normals(:,F(2,i)) = Normals(:,F(2,i)) + A;
        Normals(:,F(3,i)) = Normals(:,F(3,i)) + A;        
    end
    
    for i = 1:8758
        
%Ypologizei ton 3xr Normals pinaka me syntetagmenes ta normalveectors gia kathe koryfi toy 3d object        
        
        Normals(:,i) = Normals(:,i) ./ norm(Normals(:,i));
        
    end

end