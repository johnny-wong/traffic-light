function [current_state, best_action, resulting_position, next_state, number_stuck]=...
    find_next_optimal(position_matrix, Q_matrix,State_Matrix, ...
    CARS_BEFORE, car_probabilities, ...
    CHANGE_LIGHT_BUFFER, optimal_toggle)

% Optimal toggle = 
% 0 if best_action is random
% 1 if best_action is based on maximising Q
% percentage representing the probability of not choosing the 
%     optimal action for exploration purposes

    current_state=pos_2_state(position_matrix, State_Matrix, CARS_BEFORE);
    immediate_reward = Reward(current_state,State_Matrix);
    
    % Randomly generate new cars
    new_cars = [binornd(1, car_probabilities(1)), binornd(1, car_probabilities(2))];

    % Find possible states
    % Find new state if no action is taken
    [no_action_position, ~]= next_position(position_matrix,0,new_cars,...
        CARS_BEFORE,CHANGE_LIGHT_BUFFER);
    no_action_state = pos_2_state(no_action_position,State_Matrix,...
        CARS_BEFORE);
        
    % Find new state if action is taken, if action can't be taken, return
    % no_action_state
    if State_Matrix(current_state, 5)<CHANGE_LIGHT_BUFFER
        can_take_action = 0;
    else
        [action_position, ~] = next_position(position_matrix,1,new_cars,...
        CARS_BEFORE,CHANGE_LIGHT_BUFFER);
        action_state = pos_2_state(action_position,State_Matrix,...
        CARS_BEFORE);
        can_take_action = 1;
    end
    
    % choose action to take
    if can_take_action == 0
        best_action = 0;
    else
        if optimal_toggle==0 % If not choosing based on Q matrix, randomly pick action
            best_action = binornd(1,0.5);
        else
            Q_no_action = Q_matrix(current_state, no_action_state);
            Q_action = Q_matrix(current_state, action_state);
            best_action = find(max([Q_no_action, Q_action])==...
                [Q_no_action, Q_action])-1;
        end
    end

    if optimal_toggle > 0 & optimal_toggle < 1
        choose_best = binornd(1,optimal_toggle);
        best_action=choose_best*best_action + (1-choose_best)*(1-best_action);
    end
    
    [resulting_position, number_stuck]=next_position(position_matrix,best_action,new_cars,...
        CARS_BEFORE, CHANGE_LIGHT_BUFFER);
    next_state = pos_2_state(resulting_position,State_Matrix,CARS_BEFORE);
end

