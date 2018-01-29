%% Animate cars
function picture=animate_pos(vert_car_positions, horiz_car_positions, ...
    light_vector, light_g, seconds_pause)
    global ROAD_WIDTH CAR_WIDTH_BUFFER AXIS_Y_UPPER CAR_SPACE_LENGTH...
        CAR_LENGTH_BUFFER CAR_WIDTH CAR_LENGTH AXIS_X_LOWER CAR_SPACE_WIDTH
    
    
    %draw vertical cars
    if numel(vert_car_positions) >0
        vert_cars_g = gobjects(numel(vert_car_positions),1);
        for car = 1:numel(vert_car_positions)
            vert_cars_g(car)=rectangle('Position',[-ROAD_WIDTH/2+CAR_WIDTH_BUFFER,...
                AXIS_Y_UPPER-vert_car_positions(car)*CAR_SPACE_LENGTH + CAR_LENGTH_BUFFER,...
                CAR_WIDTH, CAR_LENGTH], 'facecolor','b');
        end
    else
        vert_cars_g=[];
    end
    %draw horizontal cars
    if numel(horiz_car_positions)>0
        horiz_cars_g = gobjects(numel(horiz_car_positions),1);
        for car = 1:numel(horiz_car_positions)
            horiz_cars_g(car)=rectangle('Position',[AXIS_X_LOWER+...
                (horiz_car_positions(car)-1)*CAR_SPACE_LENGTH+CAR_LENGTH_BUFFER,...
                -ROAD_WIDTH/2+CAR_WIDTH_BUFFER,...
                CAR_LENGTH,CAR_WIDTH],'facecolor','b');
        end
    else
        horiz_cars_g=[];
    end

    if light_vector(1)==1
        set(light_g(1),'facecolor','g')
        set(light_g(2),'facecolor','none')
        set(light_g(3), 'facecolor','none')
        set(light_g(4),'facecolor','r')
    else
        set(light_g(1),'facecolor','none')
        set(light_g(2),'facecolor','r')
        set(light_g(3), 'facecolor','g')
        set(light_g(4),'facecolor','none')
    end
    pause(seconds_pause);
    % Delete car positions so next cars can be animated
    if numel(vert_cars_g)>0
        for car = 1:numel(vert_cars_g)
            delete(vert_cars_g(car))
        end
    end
    if numel(horiz_cars_g)>0
        for car = 1:numel(horiz_cars_g)
            delete(horiz_cars_g(car))
        end
    end    
end