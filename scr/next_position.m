function [end_Matrix, number_stuck] = next_position(initial_matrix, action, ...
    new_cars, CARS_BEFORE,CHANGE_LIGHT_BUFFER)
    % Action = 1 if light change
    % split initial matrix into car positions and light information
    initial_pos_matrix = initial_matrix(1:end-1,:);
    initial_light_vector = initial_matrix(end,:);
    % Initialise sizes
    end_pos_Matrix = zeros(size(initial_pos_matrix));
    end_light_vector = zeros(size(initial_light_vector));
    
    % Determine direction that is currently green light 1=vertical 2=horiz
    green_direction = initial_light_vector(1);
    red_direction = abs(green_direction-3);
    
    % Advance all vehicles in green direction
    end_pos_Matrix(2:end,green_direction)=initial_pos_matrix(1:end-1,green_direction);
    % randomly generate a car
    end_pos_Matrix(1,green_direction)=new_cars(green_direction);

    
    % Advance everything past intersection in red direction
    end_pos_Matrix(CARS_BEFORE+2:end, red_direction)=...
        initial_pos_matrix(CARS_BEFORE+1:end-1, red_direction);
    % no cars in intersection from red road
    end_pos_Matrix(CARS_BEFORE+1,red_direction)=0;
    % Advance cars before intersection if possible
    index=CARS_BEFORE;
    cars_immobile = 1;
    while cars_immobile == 1 && index>=2
        if initial_pos_matrix(index, red_direction)==0
            cars_immobile=0;
        else index=index-1;
        end
    end
    
    % if no cars can advance
    if index==1
        end_pos_Matrix(1:CARS_BEFORE,red_direction)=...
            initial_pos_matrix(1:CARS_BEFORE,red_direction);
        number_stuck = CARS_BEFORE;
    else
        number_stuck = CARS_BEFORE-index;
    end

    % if some cars can advance
    if cars_immobile==0
        end_pos_Matrix(2:index,red_direction)=initial_pos_matrix(1:index-1,red_direction);
        end_pos_Matrix(index+1:CARS_BEFORE,red_direction)=...
            initial_pos_matrix(index+1:CARS_BEFORE,red_direction);
        end_pos_Matrix(1,red_direction)=new_cars(red_direction);
    end
   
    % Change lights if necessary
    if action==1
        end_light_vector(1)=red_direction;
    else
        end_light_vector(1)=green_direction;
        end_light_vector(2)= min(initial_light_vector(2)+1,CHANGE_LIGHT_BUFFER);
    end
    end_Matrix = [end_pos_Matrix; end_light_vector];
end