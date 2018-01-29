%% Section A-set parameters

global CARS_BEFORE CARS_AFTER ...
    CHANGE_LIGHT_BUFFER CAR_SPACE_LENGTH CAR_LENGTH CAR_WIDTH
% Scenario parameters
CARS_BEFORE = 9;
CARS_AFTER = 2;
CHANGE_LIGHT_BUFFER = 3;
    
car_probabilities = [0.2,0.2];

% Animation parameters
CAR_SPACE_LENGTH = 24;
CAR_LENGTH = 20;
CAR_WIDTH = 14;
seconds_pause = 0.05; %0.2 works well
SIMULATION_TIME = 300;

close all;
% Q learning parameters
GAMMA = 0.9; % discount rate
ALPHA = 0.9; % learning rate
NUM_ITERATIONS_Q=10000;

    %% Section B-Initialise matrices
    [Pos_Matrix, State_Matrix, light_Matrix, Q_Matrix]=...
        initialise_1(CARS_BEFORE, CARS_AFTER,...
        CHANGE_LIGHT_BUFFER);

    %% Section C-Run simulation to update Q matrix
    %Run algorithm
    M_current_position = Pos_Matrix;

    % Matrix to capture mean squared difference between old Q matrix and new
    SSD = zeros(1, NUM_ITERATIONS_Q);
    h=waitbar(0,'Generating Q matrix');
    for i=1:NUM_ITERATIONS_Q
        % Randomly choose action and observe resulting states
        [current_state, best_action, M_next_position, next_state,~] = ...
            find_next_optimal(M_current_position,Q_Matrix,State_Matrix,...
            CARS_BEFORE,car_probabilities,CHANGE_LIGHT_BUFFER,0);

        % Update Q matrix
        Q_previous = Q_Matrix;
        Q_Matrix(current_state, next_state) = (1-ALPHA)*Q_Matrix(current_state, next_state)...
            +ALPHA*(Reward(current_state,State_Matrix) + GAMMA*max(Q_Matrix(next_state,:)));

        % Update state and position
        current_state = next_state;
        M_current_position = M_next_position;
        waitbar(i/NUM_ITERATIONS_Q)

        % Find Q Sum Squared Difference
        SSD(i)= sum(sum((Q_Matrix - Q_previous).^2));
    end
    close(h);
    iteration_to_plot = 10000;
    movAverage_k = 500;
    close all
    figure
    axis square
    plot(1:iteration_to_plot,movmean(SSD(1:iteration_to_plot),movAverage_k))
    title(['Convergence of Q-Matrix, learning rate ', num2str(ALPHA)])
    xlabel('Iterations')
    ylabel('Sum of squared difference')
    legend([num2str(movAverage_k), ' point moving average']);
    %% Section D-Animate simulation with generated Q-matrix
    [lights, stopped_cars_counter, time, cars_passed_label]=...
        intersection_animation_setup('Q-learned system');
    %Run algorithm
    M_current_position = Pos_Matrix;
    vehicles_stopped=0;
    cars_passed=0;
    h=waitbar(0,'Running simulation');
    for i=1:SIMULATION_TIME
        % Choose Q-optimal action and observe resulting states
        [~, best_action, M_next_position, next_state, num_stuck] = ...
            find_next_optimal(M_current_position,Q_Matrix,State_Matrix,...
            CARS_BEFORE,car_probabilities,CHANGE_LIGHT_BUFFER,1);
        vehicles_stopped = vehicles_stopped+num_stuck;

        % Animate sequence ---------------------------------------------------
            % Update counters - time, vehicles stopped, vehicles passed
            set(time,'string',['Time: ',num2str(i), ' of ', num2str(SIMULATION_TIME)])
            set(stopped_cars_counter, 'string',[num2str(vehicles_stopped),' stoppages']);
            set(cars_passed_label, 'string', [num2str(cars_passed),' passed']);
            
            % Animate tween frame
            [middle_vert_car_pos, middle_horiz_car_pos, middle_light_vector] = ...
              find_position_between(M_current_position, M_next_position, ...
              CARS_BEFORE);
            animate_pos(middle_vert_car_pos, middle_horiz_car_pos, ...
               middle_light_vector, lights, seconds_pause)
            % animate final frame
            [final_vert_car_positions, final_horiz_car_positions, final_light_matrix] = ...
            find_car_positions(M_next_position);
            animate_pos(final_vert_car_positions, final_horiz_car_positions, ...
            final_light_matrix, lights, seconds_pause);
        %---------------------------------------------------------------------

        % Update state and position
        current_state = next_state;
        M_current_position = M_next_position;
        cars_passed = cars_passed + sum(M_current_position(end-1,:));
        waitbar(i/SIMULATION_TIME)
    end
    close(h)

    %Record results
%     results = readtable('results.txt');
%     Use_Q_Matrix = 1;
%     Fixed_time_light_change = 0;
%     new_results = {car_probabilities(1), car_probabilities(2), ALPHA, ...
%         GAMMA, Use_Q_Matrix, Fixed_time_light_change, SIMULATION_TIME,...
%         vehicles_stopped, cars_passed};
%     results = [results; new_results];
%     writetable(results);
    %% Section E-Animate simulation with fixed time light changes

    %Run algorithm
    M_current_position = Pos_Matrix;
    vehicles_stopped=0;
    cars_passed=0;
    %%%%%%%%%%%%%%%%%
    fixed_time_light_change = 3;
    %%%%%%%%%%%%%%%%%
    [lights, stopped_cars_counter, time, cars_passed_label]=...
        intersection_animation_setup(['Fixed ',num2str(fixed_time_light_change),...
        ' time change']);

    h=waitbar(0,'Running simulation');
    for i=1:SIMULATION_TIME
        % Choose action
        action=mod(i, fixed_time_light_change)==0;
        new_cars = [binornd(1,car_probabilities(1)), binornd(1,car_probabilities(2))];
        
        % Resulting states
        M_next_position = next_position(M_current_position, action, new_cars,...
            CARS_BEFORE,0);
        next_state = pos_2_state(M_next_position, State_Matrix, CARS_BEFORE);
        red_direction = abs(M_current_position(end,1)-3);
        
        %find number stuck
        index=CARS_BEFORE;
        cars_immobile = 1;
        while cars_immobile == 1 & index>=2
            if M_current_position(index, red_direction)==0
                cars_immobile=0;
            else index=index-1;
            end
        end
        if index==1
            num_stuck = CARS_BEFORE;
        else
            num_stuck = CARS_BEFORE-index;
        end
        vehicles_stopped = vehicles_stopped + num_stuck;
        
        % Animate sequence-----------------------------------------------------
            %Update counters - time, vehicles stopped, vehicles passed
            set(time,'string',['Time: ',num2str(i), ' of ', num2str(SIMULATION_TIME)])
            set(stopped_cars_counter, 'string',[num2str(vehicles_stopped),' stoppages']);
            set(cars_passed_label, 'string', [num2str(cars_passed),' passed']);
            
            
            % Animate tween frame
            [middle_vert_car_pos, middle_horiz_car_pos, middle_light_vector] = ...
               find_position_between(M_current_position, M_next_position, CARS_BEFORE);
            animate_pos(middle_vert_car_pos, middle_horiz_car_pos, ...
                middle_light_vector, lights, seconds_pause)
            % animate final frame
            [final_vert_car_positions, final_horiz_car_positions, final_light_matrix] = ...
            find_car_positions(M_next_position);
            animate_pos(final_vert_car_positions, final_horiz_car_positions, ...
            final_light_matrix, lights, seconds_pause);
        %----------------------------------------------------------------------
        
        % Update state and position
        current_state = next_state;
        M_current_position = M_next_position;
        cars_passed = cars_passed + sum(M_current_position(end-1,:));
        
        waitbar(i/SIMULATION_TIME)
    end
    close(h)
    
    % % Record results
%     results = readtable('results.txt');
%     Use_Q_Matrix = 0;
%     Fixed_time_light_change = fixed_time_light_change;
%     new_results = {car_probabilities(1), car_probabilities(2), ALPHA, ...
%         GAMMA, Use_Q_Matrix, Fixed_time_light_change, SIMULATION_TIME,...
%         vehicles_stopped, cars_passed};
%     results = [results; new_results];
%     writetable(results);
