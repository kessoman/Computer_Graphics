function color = colorInterp(A, B, a, b, x)

    total_length = (b - a); 
    current_length = (x - a);

    % Compute Color    
    if a ~= b        
        color = (((B - A) / total_length ) * current_length) + A;        
    else 
        color = (A + B) / 2;        
    end
end
