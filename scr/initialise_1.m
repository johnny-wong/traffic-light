function [Pos_Matrix, State_Matrix, light_Matrix, Q_Matrix]=...
    initialise_1(CARS_BEFORE, CARS_AFTER,...
    CHANGE_LIGHT_BUFFER)
    Pos_Matrix = zeros(CARS_BEFORE+...
        CARS_AFTER+1+1,2);
     % Initialise vertical road green, light is free to change immediately
    Pos_Matrix(end,:) = [1,CHANGE_LIGHT_BUFFER];

    % State matrix id, pos_vert, pos_horiz, green_vert, light_change_buffer
    %position of closest car before intersection (1 means just before, highest number means no cars
    Position_vert = 1:CARS_BEFORE+1; 
    Position_horiz = 1:CARS_BEFORE+1;

    % Create matrix with all possible combinations of columns:
    % id, pos_vert, pos_horiz, green_vert, light_change_buffer
    State_Matrix=combvec(Position_vert,...
        Position_horiz,...
        [1:2],...
        [0:CHANGE_LIGHT_BUFFER])';

    State_Matrix = [[1:size(State_Matrix,1)]', State_Matrix];

    % traffic_lights = [1 if green in vertical direction 2 otherwise, number of time units]
    % since last change
    light_Matrix = [1,CHANGE_LIGHT_BUFFER];

    %Initialise Q-matrix
    Q_Matrix = zeros(size(State_Matrix,1));
end
