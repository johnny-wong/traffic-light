% Set up roads and traffic light
function [lights, stopped_cars_counter, time, cars_passed_label] = ...
    intersection_animation_setup(animation_name)
    close all
    global ROAD_WIDTH CAR_WIDTH_BUFFER CAR_LENGTH_BUFFER ...
        AXIS_X_LOWER AXIS_X_UPPER AXIS_Y_LOWER AXIS_Y_UPPER...
        CAR_SPACE_LENGTH CAR_WIDTH CAR_LENGTH CARS_BEFORE CARS_AFTER
    CAR_SPACE_WIDTH = CAR_SPACE_LENGTH;
    ROAD_WIDTH = CAR_SPACE_WIDTH;
    CAR_WIDTH_BUFFER = (CAR_SPACE_WIDTH-CAR_WIDTH)/2;
    CAR_LENGTH_BUFFER = (CAR_SPACE_LENGTH - CAR_LENGTH)/2;

    figure
    AXIS_X_LOWER = -CARS_BEFORE*CAR_SPACE_LENGTH-ROAD_WIDTH/2; 
    AXIS_X_UPPER = CARS_AFTER*CAR_SPACE_LENGTH+ROAD_WIDTH/2;
    AXIS_Y_LOWER = -CARS_AFTER*CAR_SPACE_LENGTH-ROAD_WIDTH/2;
    AXIS_Y_UPPER = CARS_BEFORE*CAR_SPACE_LENGTH+ROAD_WIDTH/2;

    axis([AXIS_X_LOWER AXIS_X_UPPER AXIS_Y_LOWER AXIS_Y_UPPER])
    axis square
    set(gca, 'XTick',[],'YTick',[]);
    whitebg([0,0.4,0])
    
    % Put label
    text(AXIS_X_LOWER+ROAD_WIDTH/2, AXIS_Y_UPPER-ROAD_WIDTH/3,animation_name)
    
    % Create vertical grey road
    vertical_road = rectangle('Position',[-ROAD_WIDTH/2,AXIS_Y_LOWER,ROAD_WIDTH,AXIS_Y_UPPER-AXIS_Y_LOWER],...
        'facecolor', [0.5,0.5,0.5], 'edgecolor', 'none');
    set(vertical_road, 'HandleVisibility','off');
    % Create horizontal grey road
    rectangle('Position',[AXIS_X_LOWER,-ROAD_WIDTH/2,AXIS_Y_UPPER-AXIS_Y_LOWER,ROAD_WIDTH],...
        'facecolor', [0.5,0.5,0.5], 'edgecolor', 'none')
    
    % Traffic light shape paremeters
    TRAFFIC_LIGHT_LENGTH = CAR_SPACE_LENGTH*2;
    TRAFFIC_LIGHT_WIDTH = CAR_SPACE_WIDTH;
    CIRCLE_DIAMETER = TRAFFIC_LIGHT_WIDTH;
    % Create vertical traffic light
    rectangle('Position', [ROAD_WIDTH,ROAD_WIDTH,TRAFFIC_LIGHT_WIDTH,TRAFFIC_LIGHT_LENGTH],...
        'facecolor','black', 'curvature',[0.5,0.5]);
    % Create horizontal traffic light
    rectangle('Position', [-ROAD_WIDTH-TRAFFIC_LIGHT_LENGTH,-ROAD_WIDTH-TRAFFIC_LIGHT_WIDTH,...
        TRAFFIC_LIGHT_LENGTH,TRAFFIC_LIGHT_WIDTH],...
        'facecolor','black', 'curvature',[0.5,0.5]);

    % Create handles for vertical green and red light
    lights = gobjects(4,1);
    lights(1) = rectangle('position',[ROAD_WIDTH,ROAD_WIDTH,CIRCLE_DIAMETER,CIRCLE_DIAMETER],...
        'curvature',[1,1]);
    lights(2) = rectangle('position',[ROAD_WIDTH,ROAD_WIDTH+CIRCLE_DIAMETER,...
        CIRCLE_DIAMETER,CIRCLE_DIAMETER],'curvature',[1,1]);
    % Create handles for horizontal green and red light
    lights(3) = rectangle('position',[-ROAD_WIDTH-TRAFFIC_LIGHT_LENGTH+CIRCLE_DIAMETER,...
        -ROAD_WIDTH-TRAFFIC_LIGHT_WIDTH,CIRCLE_DIAMETER, CIRCLE_DIAMETER], 'curvature',[1,1]);
    lights(4) = rectangle('position',[-ROAD_WIDTH-TRAFFIC_LIGHT_LENGTH,...
        -ROAD_WIDTH-TRAFFIC_LIGHT_WIDTH,CIRCLE_DIAMETER, CIRCLE_DIAMETER], 'curvature',[1,1]);

    %create handle for vehicles stopped count
    stopped_cars_counter = text(AXIS_X_LOWER/2,AXIS_Y_UPPER/2,'');
    %create handle for time counter
    time=text(AXIS_X_LOWER+ROAD_WIDTH/2, AXIS_Y_UPPER-ROAD_WIDTH,'');
    cars_passed_label = text(AXIS_X_LOWER/2,AXIS_Y_UPPER/2-ROAD_WIDTH/2,'');
end