function [vert_car_positions, horiz_car_positions, light_vector] = ...
    find_position_between(M_position_1, M_position_2, CARS_BEFORE)
    
    % find car positions
    [init_vert_car_pos, init_horiz_car_pos, init_light] = find_car_positions(M_position_1);
    [end_vert_car_pos, end_horiz_car_pos, end_light] = find_car_positions(M_position_2);  
    
    % Information about light
    init_green_direction = init_light(1);
    % specify which green and red car positions
    if init_green_direction == 1
        green_car_pos = init_vert_car_pos;
        if numel(end_vert_car_pos)==0
            new_car_green=0;
        else
            new_car_green=end_vert_car_pos(1)==1;
        end
        red_car_pos = init_horiz_car_pos;
        new_car_red = sum(init_horiz_car_pos<=CARS_BEFORE)<...
            sum(end_horiz_car_pos<=CARS_BEFORE);
    else
        green_car_pos = init_horiz_car_pos;
        if numel(end_horiz_car_pos)==0
            new_car_green=0;
        else
            new_car_green = end_horiz_car_pos(1)==1;
        end
        red_car_pos = init_vert_car_pos;
        new_car_red = sum(init_vert_car_pos<=CARS_BEFORE)<...
            sum(end_vert_car_pos<=CARS_BEFORE);
    end
    
    % Advance all cars in green direction half a length
    if green_car_pos ~=0
        green_car_pos = green_car_pos + 1/2;
    end
    % If a new car is introduced, add it in
    if new_car_green==1
        green_car_pos = [1/2; green_car_pos];
    end

    % Advance all cars in red direction past intersection half a length
    red_car_pos = red_car_pos + (red_car_pos>CARS_BEFORE)*1/2;
    
    % Find which positions cars are stuck
    gap_found=0;
    no_car = CARS_BEFORE;
    while gap_found==0
        if sum(red_car_pos==no_car)==1
            no_car=no_car-1;
        else
            gap_found=1;
        end
    end
    % Advance cars that aren't stuck half a length
    if no_car>0
        red_car_pos=red_car_pos+1/2*(red_car_pos<no_car);
        if new_car_red == 1
            red_car_pos = [1/2; red_car_pos];
        end
    
    end
    
    % Convert back to vertical and horizontal
    if init_green_direction == 1
        vert_car_positions = green_car_pos;
        horiz_car_positions = red_car_pos;
    else
        vert_car_positions = red_car_pos;
        horiz_car_positions = green_car_pos;
    end    
    
    light_vector = end_light;
    
    
end