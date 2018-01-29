%% Create functions
% function to convert position and light matrix to state matrix
function [state]=pos_2_state(position_matrix, state_matrix, ...
    CARS_BEFORE)
    % Find closest point to intersection on vertical and horizontal road (1 means just before)
    index_vert_pos=1;
    index_horiz_pos=2;

    if sum(position_matrix(1:CARS_BEFORE,index_vert_pos))==0
        vert_pos=CARS_BEFORE+1;
    else
        vert_pos = CARS_BEFORE+1-...
        max(find(position_matrix(1:CARS_BEFORE,index_vert_pos)));
    end

    if sum(position_matrix(1:CARS_BEFORE,index_horiz_pos))==0
        horiz_pos=CARS_BEFORE+1;
    else
        horiz_pos = CARS_BEFORE+1-...
        max(find(position_matrix(1:CARS_BEFORE,index_horiz_pos)));
    end
    state=state_matrix(ismember(state_matrix(:,2:end),[vert_pos, horiz_pos, ...
        position_matrix(end,:)],'rows'),1);
end





