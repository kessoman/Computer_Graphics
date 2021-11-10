% All credits go to:          
% Author:Ioannis Kessopoulos  
% Date Started: 09/03/2020    
% Filling Triangles           

load duck_hw1.mat % importing the given data

I = paintObject(V_2d, F, C, D, "Flat"); % specificating the type of painting we need

K = figure;
imshow(I)
[filename, user_canceled] = imsave(K);