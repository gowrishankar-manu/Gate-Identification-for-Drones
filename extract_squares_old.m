function [possible_combination,number_combinations] = ...
    extract_squares(interception_points,distance_tolerance)
% Use distance between each point to find squares with a given tolerance

n_interceptions = size(interception_points,1);
interception_distances = zeros(n_interceptions,n_interceptions);

% Compute the distance between each point
for ind_1 = 1:n_interceptions
    for ind_2 = 1:n_interceptions
        interception_distances(ind_1,ind_2) = distance(interception_points(ind_1,:),...
            interception_points(ind_2,:));
    end
end

% Check distance between each points from each other perspective
proximity = false(n_interceptions,n_interceptions,n_interceptions);
for ind_1 = 1:n_interceptions
    for ind_2 = 1:n_interceptions
        for ind_3 = 1:n_interceptions
            if ind_1 ~= ind_2 && ind_1 ~= ind_3 && ind_2 ~= ind_3
                proximity(ind_1,ind_2,ind_3) = abs(interception_distances(ind_1,ind_2)...
                    - interception_distances(ind_1,ind_3)) < distance_tolerance;
            end
        end
    end
end

% Extract points that have 4 different points equidistant
possible_combination = cell(0);
number_combinations = 0;
for ind_1 = 1:n_interceptions
    % Need to find at least 2 points equidistant and the matrix is symmetric
    if length(find(proximity(ind_1,:,:),4)) == 4
        % Find 2 points equidistant to point number 1 (points 2 and 3)
        for ind_2 = 1:n_interceptions
            if ind_2 ~= ind_1
                vector_test_1 = reshape(proximity(ind_1,ind_2,:),[n_interceptions,1]);
                vector_values_1 = find(vector_test_1);
                vector_size_1 = length(vector_values_1);
                if vector_size_1 >= 1   % Check if we have at least 2 points
                    
                    % Find 1 point equidistant to point 1 relative to point 3 (point 4)
                    for ind_vector = 1:vector_size_1
                        ind_3 = vector_values_1(ind_vector);
                        if ind_3 ~= ind_1 && ind_3 ~= ind_2
                            vector_test_2 = reshape(proximity(ind_3,ind_1,:),[n_interceptions,1]);
                            vector_values_2 = find(vector_test_2);
                            vector_size_2 = length(vector_values_2);
                            if vector_size_2 >= 1   % Check if we have at least 1 point
                                
                                % Check if from point 4 point 2 is equidistant to point 3
                                for ind_vector_2 = 1:vector_size_2
                                    ind_4 = vector_values_2(ind_vector_2);
                                    if ind_4 ~= ind_1 && ind_4 ~= ind_2 && ind_4 ~= ind_3
                                        vector_test_3 = reshape(proximity(ind_4,ind_3,:),[n_interceptions,1]);
                                        vector_values_3 = find(vector_test_3);
                                        if sum(vector_values_3 == ind_2)
                                            unique_comb = true;
                                            possible_square = [ind_1, ind_2, ind_3, ind_4, ind_1];

                                            % Check if the square already exist in another order
                                            for ind_comb = 1:number_combinations
                                                if length(intersect(possible_square,possible_combination{ind_comb})) == 4
                                                    unique_comb = false;
                                                end
                                            end

                                            if unique_comb
                                                number_combinations = number_combinations + 1;
                                                possible_combination{number_combinations} = possible_square;
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end
end
