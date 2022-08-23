function [Lines_final] = Select_8lines(Lines)
    %% Select 8 lines
    n_lines = length(Lines);

    min_x = min([Lines(1).point1(1),Lines(2).point1(1)]);
    max_x = max([Lines(1).point1(1),Lines(2).point1(1)]);

    min_y = min([Lines(1).point1(2), Lines(2).point1(2)]);
    max_y = max([Lines(1).point1(2), Lines(2).point1(2)]);

    for ind = 1:n_lines
        % Create vector
        Lines(ind).vector = Lines(ind).point2 - Lines(ind).point1;
        Lines(ind).size = norm(Lines(ind).vector);

        % Find min and max for X and Y
        % point 1
        if Lines(ind).point1(1) < min_x
            min_x = Lines(ind).point1(1);
        end
        if Lines(ind).point1(1) > max_x
            max_x = Lines(ind).point1(1);
        end
        if Lines(ind).point1(2) < min_y
            min_y = Lines(ind).point1(2);
        end
        if Lines(ind).point1(2) > max_y
            max_y = Lines(ind).point1(2);
        end
        % point 2
        if Lines(ind).point2(1) < min_x
            min_x = Lines(ind).point2(1);
        end
        if Lines(ind).point2(1) > max_x
            max_x = Lines(ind).point2(1);
        end
        if Lines(ind).point2(2) < min_y
            min_y = Lines(ind).point2(2);
        end
        if Lines(ind).point2(2) > max_y
            max_y = Lines(ind).point2(2);
        end
    end

    % Create 4 groups
    ind_1 = 1; ind_2 = 1; ind_3 = 1; ind_4 = 1;
    for ind = 1:n_lines
        % Closer to min_x
        closer_min_x = abs(Lines(ind).point1(1) - min_x) < abs(Lines(ind).point1(1) - max_x);
        % Closer to min_y
        closer_min_y = abs(Lines(ind).point1(2) - min_y) < abs(Lines(ind).point1(2) - max_y);

        %   1---2   Numeration used to group the lines   
        %   |   |   
        %   3---4   
        if closer_min_x && closer_min_y
            Lines(ind).group = 1;
            Lines_1(ind_1) = Lines(ind);
            ind_1 = ind_1 + 1;
        elseif ~closer_min_x && closer_min_y
            Lines(ind).group = 2;
            Lines_2(ind_2) = Lines(ind);
            ind_2 = ind_2 + 1;
        elseif closer_min_x && ~closer_min_y
            Lines(ind).group = 3;
            Lines_3(ind_3) = Lines(ind);
            ind_3 = ind_3 + 1;
        else
            Lines(ind).group = 4;
            Lines_4(ind_4) = Lines(ind);
            ind_4 = ind_4 + 1;
        end
    end

    % Select the 2 lines with the lowest cosine Similarity (more perpendicular)
    n_lines_1 = length(Lines_1);
    n_lines_2 = length(Lines_2);
    n_lines_3 = length(Lines_3);
    n_lines_4 = length(Lines_4);

    cosine_lines_1 = ones(n_lines_1^2,1);
    cosine_lines_2 = ones(n_lines_2^2,1);
    cosine_lines_3 = ones(n_lines_3^2,1);
    cosine_lines_4 = ones(n_lines_4^2,1);

    % Get absolute of cosine Similarity for group 1
    for ind_1 = 1:n_lines_1
        for ind_2 = 1:n_lines_1
            cosine_lines_1( (ind_1 - 1)*n_lines_1 + ind_2) = ...
                abs(cosineSimilarity(Lines_1(ind_1).vector,Lines_1(ind_2).vector));
        end
    end

    % Get absolute of cosine Similarity for group 2
    for ind_1 = 1:n_lines_2
        for ind_2 = 1:n_lines_2
            cosine_lines_2( (ind_1 - 1)*n_lines_2 + ind_2) = ...
                abs(cosineSimilarity(Lines_2(ind_1).vector,Lines_2(ind_2).vector));
        end
    end

    % Get absolute of cosine Similarity for group 3
    for ind_1 = 1:n_lines_3
        for ind_2 = 1:n_lines_3
            cosine_lines_3( (ind_1 - 1)*n_lines_3 + ind_2) = ...
                abs(cosineSimilarity(Lines_3(ind_1).vector,Lines_3(ind_2).vector));
        end
    end

    % Get absolute of cosine Similarity for group 4
    for ind_1 = 1:n_lines_4
        for ind_2 = 1:n_lines_4
            cosine_lines_4( (ind_1 - 1)*n_lines_4 + ind_2) = ...
                abs(cosineSimilarity(Lines_4(ind_1).vector,Lines_4(ind_2).vector));
        end
    end

    % Get min for each group
    [~,I_1] = min(cosine_lines_1);
    [~,I_2] = min(cosine_lines_2);
    [~,I_3] = min(cosine_lines_3);
    [~,I_4] = min(cosine_lines_4);

    % Create final struct
    Lines_final(1) = Lines_1(floor((I_1-1)/n_lines_1)+1);
    ind_2 = mod(I_1,n_lines_1);
    if ind_2 == 0
        ind_2 = n_lines_1;
    end
    Lines_final(2) = Lines_1(ind_2);

    Lines_final(3) = Lines_2(floor((I_2-1)/n_lines_2)+1);
    ind_2 = mod(I_2,n_lines_2);
    if ind_2 == 0
        ind_2 = n_lines_2;
    end
    Lines_final(4) = Lines_2(ind_2);

    Lines_final(5) = Lines_3(floor((I_3-1)/n_lines_3)+1);
    ind_2 = mod(I_3,n_lines_3);
    if ind_2 == 0
        ind_2 = n_lines_3;
    end
    Lines_final(6) = Lines_3(ind_2);

    Lines_final(7) = Lines_4(floor((I_4-1)/n_lines_4)+1);
    ind_2 = mod(I_4,n_lines_4);
    if ind_2 == 0
        ind_2 = n_lines_4;
    end
    Lines_final(8) = Lines_4(ind_2);
end
