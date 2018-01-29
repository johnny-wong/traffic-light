function [vert_car_positions horiz_car_positions light_matrix] = ...
    find_car_positions(position_matrix)
    vert_car_positions = find(position_matrix(1:end-1,1));
    horiz_car_positions = find(position_matrix(1:end-1,2));
    light_matrix = position_matrix(end,:);
end