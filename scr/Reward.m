% Function to convert state matrix and action to reward matrix
% Define 1 as change light, 0 as keep the same
function [reward]=Reward(state, state_matrix)
    index_vert_pos=2;
    index_horiz_pos=3;
    green_index = 4;
    reward=0;
    %Checks to see if red road has stopped car
    if (state_matrix(state,index_vert_pos)==1 & state_matrix(state,green_index)==2)|...
        (state_matrix(state,index_horiz_pos)==1 & state_matrix(state,green_index)==1)
        reward=reward-1;
    end
    
    % Checks to see if green road has a car that will be passed
    if (state_matrix(state,index_vert_pos)==1 & state_matrix(state,green_index)==1)|...
        (state_matrix(state,index_horiz_pos)==1 & state_matrix(state,green_index)==2)
        reward=reward+0.01;
    end
end

