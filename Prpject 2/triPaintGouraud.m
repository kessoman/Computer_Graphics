
% All credits go to:                  
% Author:Ioannis Kessopoulos          
% Date Project Started: 09/03/2020    
% Filling Triangles               

function Y = triPaintGouraud(X, V, C)
    
    % Saving information on a struct for each side of the triangle
	%Also creating a struck ,empty at first for the active list of points and sides
    
	first = 'yMax';
    second = 'yMin';
    third = 'x';
    fourth = 'sign';
    fifth = 'dX';
    sixth = 'dY';
    seventh = 'sum';
    eighth = 'normColor';
    ninth = 'totLength';
    tenth = 'startingColor';
    eleventh = 'xOfymin';

    Y = X;

    base_struct = struct(first, {}, second, {}, third, {}, fourth, {}, fifth, {}, sixth, {}, seventh, {}, eighth, {}, ninth, {}, tenth, {}, eleventh, {});

    a_List = struct(first, {}, second, {}, third, {}, fourth, {}, fifth, {}, sixth, {}, seventh, {}, eighth, {}, ninth, {}, tenth, {}, eleventh, {});

    V(4, :) = V(1, :);
    C(4, :) = C(1, :);
    
    %Rule :In a polygon the last side is equal to the first

    for k = 1 : 3
        % Seting yMax and yMin in the bucket by comparing the edges between
        % them
        y_max = max(V(k, 2), V(k + 1, 2));
        base_struct(k).yMax = y_max;

        [y_min, y_min_index] = min([V(k, 2), V(k + 1, 2)]);
        base_struct(k).yMin = y_min;
        
        
        % Set the dX and dY values, the difference of the coordinates
        base_struct(k).dX = V(k, 1) - V(k + 1, 1);
        base_struct(k).dY = V(k, 2) - V(k + 1, 2);

        %  a = dY/dX Slope
        
        a = base_struct(k).dY / base_struct(k).dX;
        if (base_struct(k).dY == 0 || base_struct(k).dX == 0)
            base_struct(k).sign = 0;
        else
            base_struct(k).sign = sign(a);
        end
        
        base_struct(k).dX = abs(base_struct(k).dX);
        base_struct(k).dY = abs(base_struct(k).dY);

        % Euklidean distance between the two vertices
        base_struct(k).totLength = sqrt((base_struct(k).dX) ^ 2 + (base_struct(k).dY) ^ 2);

        base_struct(k).sum = 0;

        % Characteristics of the lowest vertex
        if y_min_index == 1
            base_struct(k).x = V(k, 1);
            base_struct(k).xOfymin = V(k, 1);
            base_struct(k).startingColor = C(k, :);
            base_struct(k).normColor = (C(k + 1, :) - C(k, :)) / base_struct(k).totLength;
        else
            base_struct(k).x = V(k + 1, 1);
            base_struct(k).xOfymin = V(k + 1, 1);
            base_struct(k).startingColor = C(k + 1, :);
            base_struct(k).normColor = (C(k, :) - C(k + 1, :)) / base_struct(k).totLength;
        end

    end
    
    %Calculated necssary data fot th structs
    
    [~, temp] = sortrows({base_struct.yMin}');
    base_struct = base_struct(temp);
    
    % x_min = min(V(1,:));
    % x_max = max(V(1,:));

    % Scanline Interval
    y_min = min([base_struct.yMin]);
    y_max = max([base_struct.yMax]);

    for y = y_min : 1 : y_max

        % Crossing scan lines anf then removing sidees if their ymax isnt
        % bigger than scanline's
        if (~ isempty(a_List))
            for i = 1 : length(a_List) 
              
                if (i > length(a_List))
                    continue;
                end

                if (a_List(i).yMax <= y)
                    a_List(i) = []; % Remove the edge from active list
                end
            end
        end

        %or if ymin is equal to scanline's y wee add the side to the a_List
        for i = 1 : length(base_struct)
            if (base_struct(i).yMin == y)
                a_List(length(a_List) + 1) = base_struct(i);
            end
        end

        
        [~, temp] = sortrows({a_List.sign}');
        a_List = a_List(temp);

        [~, temp] = sortrows({a_List.x}');
        a_List = a_List(temp);
        
        %Sortd the variables from low to high according to their angl and x
        %position

        %Case1:
        if (isempty(a_List))
            continue; % continue to next iteration
        end
        
        %Case2:
        if length(a_List) < 2
            continue; 
        end

        % Case3: Horizontal line 
        if (size(a_List) == 3)
            a_List(2).x = a_List(3).x;
        end
        
        %Thesee weree special occasions we need to avoid

        %Gouraud method uses Linear interpolation in order to find the
        %appropriate colour in the activelist limits

        a = a_List(1).x;
        b = a_List(2).x;
        
        distance_atm1 = pdist([a_List(1).xOfymin, a_List(1).yMin; a, y], 'euclidean');%atm=at the moment
        distance_atm2 = pdist([a_List(2).xOfymin, a_List(2).yMin; b, y], 'euclidean');
        
        A = a_List(1).startingColor + (distance_atm1 * a_List(1).normColor);
        B = a_List(2).startingColor + (distance_atm2 * a_List(2).normColor);

        for x = a : 1 : b
            Y(y, x, :) = colorInterp(A, B, a, b, x); %Start colouring
        end

        for j = 1 : length(a_List)
            if a_List(j).sign == 0
                continue;
            end

            if a_List(j).dX ~= 0
                a_List(j).sum = a_List(j).sum + a_List(j).dX;
                while (a_List(j).sum >= a_List(j).dY)
                    % Alter value of x - depending on slope
                    a_List(j).x = a_List(j).x + a_List(j).sign; 
                    a_List(j).sum = a_List(j).sum - a_List(j).dY;
                    					  %We changed value of x according to slopes	

                end
            end
        end
    end
end