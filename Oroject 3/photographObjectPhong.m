
% All credits go to:                  
% Author:Ioannis Kessopoulos          
% Date Project Started: 28/05/2020    
% View      

function Im = photographObjectPhong(shader,f, C, K, u, bC, M, N, H, W, R, F, S, ka, kd, ks, ncoeff, Ia, I0)
%Etoimazei ta aparaithta orismata gia tis shade synarthseis
%Creating a canvas which also contains a background

Im = ones(M, N, 3);
   
for i = 1:3
        Im(:,:,i) = bC(i);
end
    
 number_of_triangles = length(F);
 triangles_depth = zeros(number_of_triangles, 1);
 
 %For rach triangle's vertice we calculate it's normal veectors
 
 Normals = findVertNormals(R, F);
 
 %Now we fubd each triangle's vertices and we transfer them into the
 %rasterize zone
 
  P = zeros(2,8758);
    D = zeros(8758,1);
    for i = 1:8758
        [point, d] = projectCameraKu(f, C, K, u, R(:,i)');
        P(:,i) = point;
        D(i) = d;
    end
    
  PRast = zeros(2,length(P));  
  
      for i = 1:length(P)
        PRast(:,i) = rasterize(P(:,i),M,N,H,W);
      end
 
     for i = 1:number_of_triangles
        
       triangles_depth(i) = ( D(F(1,i)) + D(F(2,i)) + D(F(3,i)) ) / 3;
       
    end
    
    [~,index] = sort(triangles_depth, 'descend');
    F = F(:,index);     
    
    for i = 1:number_of_triangles
      %setting triangle's vertexes
        
        first_vertex = F(1,i);
        second_vertex = F(2,i);
        third_vertex = F(3,i); 
       
      %Setting the coordinates for each triangle's vertex
      
        first_vertex_coordinates = R(:,first_vertex);
        second_vertex_coordinates = R(:,second_vertex);
        third_vertex_coordinates = R(:,third_vertex);
        
       %Setting the factor of mirroring reflection
       
        ks_current(:,1) = ks(:,first_vertex);
        ks_current(:,2) = ks(:,second_vertex);
        ks_current(:,3) = ks(:,third_vertex);

       %Setting the factor of diffusible reflection
       
        kd_current(:,1) = kd(:,first_vertex);
        kd_current(:,2) = kd(:,second_vertex);
        kd_current(:,3) = kd(:,third_vertex);
        
       %Setting the factor of diffuslible light from enviroment  reflection
       
        ka_current(:,1) = ka(:,first_vertex);
        ka_current(:,2) = ka(:,second_vertex);
        ka_current(:,3) = ka(:,third_vertex);    
        
       %Calcualting center of gravity of the triangle
       
       Pc(1,1) = ( first_vertex_coordinates(1,1) + second_vertex_coordinates(1,1) + third_vertex_coordinates(1,1) ) / 3 ;
       Pc(2,1) = ( first_vertex_coordinates(2,1) + second_vertex_coordinates(2,1) + third_vertex_coordinates(2,1) ) / 3 ;
       Pc(3,1) = ( first_vertex_coordinates(3,1) + second_vertex_coordinates(3,1) + third_vertex_coordinates(3,1) ) / 3 ;
       
       %Coordinatees of the triangle's vertexes on the curtain of the
       %camera
       
        p(:,1) = PRast(:,first_vertex);
        p(:,2) = PRast(:,second_vertex);
        p(:,3) = PRast(:,third_vertex);
        
        %sSetting the matrix that will contain the normal vectors of the
        %vertexes of the triang;e
        
        Vn(:,1) = Normals(:,first_vertex);
        Vn(:,2) = Normals(:,second_vertex);
        Vn(:,3) = Normals(:,third_vertex);
 
        %Choosing which shade we will use (Gouraud or Phong)
        
        if shader == 1
            
            %Output is the colourized, with Gouraud shade, photo
            
            Im = shadeGouraud(p, Vn, Pc, C, S, ka_current, kd_current, ks_current, ncoeff, Ia, I0, Im);                      
        else    
            Pc(:,1) = R(:,first_vertex);
            Pc(:,2) = R(:,second_vertex);
            Pc(:,3) = R(:,third_vertex);
            
             %Output is the colourized, with Phong shade, photo
            
            Im = shadePhong(p, Vn, Pc, C, S, ka_current, kd_current, ks_current, ncoeff, Ia, I0, Im);
        end
        
    end

end