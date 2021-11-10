
% All credits go to:                  
% Author:Ioannis Kessopoulos          
% Date Project Started: 09/03/2020    
% Filling Triangles               

function Y = triPaintFlat(X, V, C)

    % Saving information on a struct for each side of the triangle
	%Also creating a struck ,empty at first for the active list of points and sides
    
	first= 'ymaximum';
    second = 'yminimum';
    third = 'x';
    fourth = 'sign';
    fifth = 'dX';
    sixth = 'dY';
    seventh = 'sum';

    Y = X;

    base_struct = struct(first, {}, second, {}, third, {}, fourth, {}, fifth, {}, sixth, {}, seventh, {});

    
    a_List = struct(first, {}, second, {}, third, {}, fourth, {}, fifth, {}, sixth, {}, seventh, {});

    
   
    V(4, :) = V(1, :); %the last top of the triangle will be equal to the first one
    
    for k = 1 : 3
     % ymaximum & yminimum  
        y_max = max(V(k, 2), V(k + 1, 2));
        base_struct(k).ymaximum = y_max;
        y_min = min(V(k, 2), V(k + 1, 2));      
        base_struct(k).yminimum = y_min;
        
        if (V(k, 2) < V(k + 1, 2))
            base_struct(k).x = V(k, 1);
        else
            base_struct(k).x = V(k + 1, 1);
        end
        %Here we susposed that x will be in the begining ath the same point with yminimum
				       
        base_struct(k).dX = V(k, 1) - V(k + 1, 1);
        base_struct(k).dY = V(k, 2) - V(k + 1, 2);

        % Set the slope. a = dY/dX        
        a = base_struct(k).dY / base_struct(k).dX;
        if (base_struct(k).dY == 0 || base_struct(k).dX == 0)
            base_struct(k).sign = 0;
        else
            base_struct(k).sign = sign(a);
        end
        
        base_struct(k).dX = abs(base_struct(k).dX);
        base_struct(k).dY = abs(base_struct(k).dY);

        base_struct(k).sum = 0;      
              
    end
	
	%Calculating basic elements to fill the struct: Complete!
	%Now we are gonna sort yminimum from low to high cause sides are maintained that way

    [~, temp] = sortrows({base_struct.yminimum}');
    base_struct = base_struct(temp);

    % Distance of scanlines
    y_min = min([base_struct.yminimum]);
    y_max = max([base_struct.ymaximum]);

    color = mean(C); %Colour?

    % Crossing scanlines
    for y = y_min : 1 : y_max

        
        if (~ isempty(a_List))
            for i = 1 : length(a_List) %checking every edge in the a_list struct
                
                if (i > length(a_List))
                    continue;
                end

                if (a_List(i).ymaximum <= y)
                    a_List(i) = []; 
                end
            end
        end
		
		%Here we crossed all the scan lines and removed them from the a_List struct
		%if they fulfilled the following equation:ymax <= current scanline
		
        for i = 1 : length(base_struct)
            if (base_struct(i).yminimum == y)                
                a_List(length(a_List) + 1) = base_struct(i);
            end
        end
		
		%Here we added sides to the a_Liststruct if they fulfilled this equation:y=ymin
        %Then we added base struct to the end of the a_List
		

        [~, temp] = sortrows({a_List.sign}');
        a_List = a_List(temp);
        [~, temp] = sortrows({a_List.x}');
        a_List = a_List(temp);
		
		%Sorted sides according to slope and x-axis position from low to high

        %Case:1
        if (isempty(a_List))
            continue; 
        end

        %Case:2  
        if length(a_List) < 2
            continue; 
        end
        
		%Case:3 Horizondal 
        if (size(a_List) == 3)
            a_List(2).x = a_List(3).x;
        end

        %Declared some special occasions needed to be left out

        for x = a_List(1).x : 1 : a_List(2).x          
            Y(y, x, :) = color;
        end

        %Started colouring the pixels
        %Also changed the (x,y) system to (y,x)because imshow(K)gave us a turned image	

        for j = 1 : length(a_List)
            if (a_List(j).sign == 0) %slope is vertical
                continue;
            end
            if a_List(j).dX ~= 0
                a_List(j).sum = a_List(j).sum + a_List(j).dX;
                while (a_List(j).sum >= a_List(j).dY)
                    if a_List(j).dY ~= 0
						a_List(j).x = a_List(j).x + a_List(j).sign; 
                        a_List(j).sum = a_List(j).sum - a_List(j).dY;
					  %We changed value of x according to slopes	
                    end
                end 
            end
        end
    end
end