function [interception_points,cosine_lines,angles,max_len] = ...
    extract_interception_points(image_size,Lines,angle_tolerance)

% Check if angle_tolerance is valid
if angle_tolerance < 0 && angle_tolerance > 90
    error("Angle tolerance not valid!")
end

n_lines = length(Lines);
cosine_lines = ones(n_lines,n_lines);

max_len = 0;
for ind_1 = 1:n_lines
    % Create vector
    Lines(ind_1).vector = Lines(ind_1).point2 - Lines(ind_1).point1;
    Lines(ind_1).size = norm(Lines(ind_1).vector);
    
    if Lines(ind_1).size > max_len
        max_len = Lines(ind_1).size;
    end
end

% Get absolute of cosine Similarity for group 4
for ind_1 = 1:n_lines
    for ind_2 = 1:n_lines
        cosine_lines(ind_1,ind_2) = ...
            abs(cosineSimilarity(Lines(ind_1).vector,Lines(ind_2).vector));
    end
end

angles = acos(cosine_lines);
angles = real(angles .* 180 ./ pi);

perpendicular_lines = angles > (90 - angle_tolerance);

% To avoid repetition (diagonal always zero)
upper_triu_perp_lines = triu(perpendicular_lines,1);

% Create empty cell
interception = cell(n_lines);
interception_points = [];

for ind_1 = 1:n_lines
    for ind_2 = 1:n_lines
        if upper_triu_perp_lines(ind_1,ind_2) == 1
            xy_int = get_interception(Lines(ind_1),Lines(ind_2));
            if xy_int(1) >= 0 && xy_int(2) >= 0 && ...
                    xy_int(1) <= image_size(2) && xy_int(2) <= image_size(1)
                interception{ind_1,ind_2} = xy_int;
                interception_points = [interception_points; interception{ind_1,ind_2}];
            end
        end
    end
end

% Delete equal points
n_interceptions = size(interception_points,1);
unique_points = true(n_interceptions,1);

for ind = 1:n_interceptions
    if unique_points(ind)
        rep_points = interception_points == interception_points(ind,:);
        rep_points_vector = rep_points(:,1) + rep_points(:,2);

        rep_points_ind = find(rep_points_vector == 2);
        n_rep = length(rep_points_ind);
        for ind_2 = 2:n_rep
            unique_points(rep_points_ind(ind_2)) = false;
        end
    end
end

interception_points = interception_points(unique_points,:);

end

