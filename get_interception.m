function interception = get_interception(Line1,Line2)
    % Extract coords
    x11 = Line1.point1(1);
    y11 = Line1.point1(2);
    x12 = Line1.point2(1);
    y12 = Line1.point2(2);
    x21 = Line2.point1(1);
    y21 = Line2.point1(2);
    x22 = Line2.point2(1);
    y22 = Line2.point2(2);
    
    % Iniciate both line as not vertical and not horizontal.
    line1_vert = false;
    line1_horz = false;
    line2_vert = false;
    line2_horz = false;
    
    % Check if the line 1 is vertical or horizontal
    if x11 == x12
        x_int = x11;
        line1_vert = true;
    elseif y11 == y12
        y_int = y11;
        line1_horz = true;
    end
    
    % Check if the line 2 is vertical or horizontal
    if x21 == x22
        x_int = x21;
        line2_vert = true;
    elseif y21 == y22
        y_int = y21;
        line2_horz = true;
    end
    
    if ~line1_vert && ~line1_horz && ~line2_vert && ~line2_horz
        % Get both lines equations if none is vertical or horizontal
        [m1,b1] = line_parameters(x11,x12,y11,y12);
        [m2,b2] = line_parameters(x21,x22,y21,y22);
        
        % Intercetion coords (m1 =/= m2 since the lines are perpendicular
        x_int = (b2 - b1) / (m1 - m2);
        y_int = m1 * x_int + b1;    % Same as y_int = m2 * x_int + b2;
        
    elseif line1_vert && ~line2_horz    % Line 1 vertical and line 2 not horizontal
        % Get line 2 parameters
        [m2,b2] = line_parameters(x21,x22,y21,y22);
        % Calculate interception in y
        y_int = m2 * x_int + b2;
        
    elseif line2_vert && ~line1_horz    % Line 2 vertical and line 1 not horizontal   
        % Get line 1 parameters
        [m1,b1] = line_parameters(x11,x12,y11,y12);
        % Calculate interception in y
        y_int = m1 * x_int + b1;
        
    elseif line1_horz && ~line2_vert    % Line 1 horizontal and line 2 not vertical
        % Get line 2 parameters
        [m2,b2] = line_parameters(x21,x22,y21,y22);
        % Calculate interception in x
        x_int = y_int / m2 - b2;
        
    elseif line2_horz && ~line1_vert    % Line 2 horizontal and line 1 not vertical
        % Get line 1 parameters
        [m1,b1] = line_parameters(x11,x12,y11,y12);
        % Calculate interception in x
        x_int = y_int / m1 - b1;
        
        % If both are vertical or horizontal the x_int and y_int already
        % are defined
    end
    
    interception = [x_int,y_int];
end

