#Traffic light reinforcement project
Date: 27/5/17
Author: Johnny Wong
Software: Matlab R2016b

##INTRODUCTION
These files contain code to learn a traffic light system under different scenarios
The file 'Traffic_light.m' is the control centre for the project
Other files are functions used throughout the simulations.

##INSTRUCTIONS
1. Make sure all files are in the same folder
2. Open 'Traffic_light.m'
3. It is recommended you run each section one at a time
	Section A will define some constants used in following sections
	Section B will create matrices based on parameters
	Section C will generate a Q-matrix by simulating different 
	 states and randomly picking actions
	Section D will animate a simulation of traffic and the decisions made by the traffic light
	 when following the Q-matrix generated in section C. This can be terminated by clicking
	 on the command window and pressing ctrl+c. Animation speed can be changed in Section A
	Section E will animate a simulation of traffic based on a fixed time traffic light change.
	 The fixed time parameter is set as variable 'fixed_time_light_change'
4. Play around with the parameters as you wish!
5. If you aren't interested in looking at the animation, 
	a. Set seconds_pause=0 in Section A
	b. Comment out the animation subsection in Sections D and E; this will speed the simulations significantly

##DETAILS ON OTHER FILES
Reward.m
	Takes in the state matrix, returns a reward for being in that state

pos_2_state.m
	Takes in a position matrix, returns the equivalent state

next_position.m
	Takes in a position matrix, the action taken and returns the resulting position matrix

intersection_animation_setup.m
	Takes in animation parameters and draws the intersection used in the animation

initialise_1.m
	Initialises some various matrices such as position and state based on scenario parameters

find_position_between.m
	Takes in two consecutive position matrices and creates a position matrix representing the
	middle of the two. Used to smooth the animation when moving between time steps

find_next_optimal.m
	Takes in the current position matrix, a Q-matrix and returns the current state, the action taken,
	the resulting position and state. The action can be either randomly chosen or based on the Q-matrix
	depending on the optimal_toggle (1=based on Q, 0=random)

find_car_positions.m
	Takes in a position matrix and find the points at which there are cars. Used for animation purposes

animate_pos.m
	Takes in the outputs from find_car_positions and puts them into the animation.
	Animates the cars and traffic lights.

	





