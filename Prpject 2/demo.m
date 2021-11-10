% All credits go to:                  
% Author:Ioannis Kessopoulos          
% Date Project Started: 01/05/2020  

clc
clear

% loading required data 

load('hw2.mat');


P_2d = zeros(8758,2);
D = zeros(8758,1);

fprintf('\n Initial Position \n');

% Creating,painting and saving the image of the initial position 


for i = 1:8758
    [p, d] = photographObject(V(i,:), M, N, H, W, w, cv, ck, cu);
    P_2d(i,:) = p;
    D(i) = d;
end

I0 = paintObject(P_2d, F, C, D, 'Gouraud');
KO=figure;
imshow(I0);
imsave(KO);

fprintf('\n  Translating by t1  \n');

%Applying translation, Photographing object, painting it andc then saving the image.

R = eye(3);
for j = 1:8758
    a = affinetrans(V(j,:)',R,t1);
    V(j,:) = a;
end

for i = 1:8758
    [p, d] = photographObject(V(i,:), M, N, H, W, w, cv, ck, cu);
    P_2d(i,:) = p;
    D(i) = d;
end

I1 = paintObject(P_2d, F, C, D, 'Gouraud');
K1=figure;
imshow(I1);
imsave(K1);


fprintf('\n  Rotating by theta and giving axis \n');

% Applying rotation, painting object and saving the result

R = rotationMatrix(theta,g);
t = [0;0;0];
for j = 1:8758
    a = affinetrans(V(j,:)',R,t);
    V(j,:) = a;
end

for i = 1:8758
    [p, d] = photographObject(V(i,:), M, N, H, W, w, cv, ck, cu);
    P_2d(i,:) = p;
    D(i) = d;
end

I2 = paintObject(P_2d, F, C, D, 'Gouraud');
K2 = figure;
imshow(I2);
imsave(K2);

fprintf('\n Translating by t2 \n');

% Applying trnslation, photographing object ,painting it and saving the result

R = eye(3);
for j = 1:8758
    a = affinetrans(V(j,:)',R,t2);
    V(j,:) = a;
end

for i = 1:8758
    [p, d] = photographObject(V(i,:), M, N, H, W, w, cv, ck, cu);
    P_2d(i,:) = p;
    D(i) = d;
end

I3 = paintObject(P_2d, F, C, D, 'Gouraud');
K3=figure;
imshow(I3);
imsave(K3);
