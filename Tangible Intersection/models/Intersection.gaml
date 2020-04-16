/***
* Name: TangibleIntersection
* Author: mugui
* Description: 
* Tags: Tag1, Tag2, TagN
***/

model Intersection


/**
 * Basic environment representing a real size pad.
 */
global{
	geometry shape <- square(56#cm);
	
	point center <- shape.centroid;
	init{
		create toio number: 1{
			location <- center;
		}
		create food number:1{
			location <- any_location_in(shape);
		}	
	}
}




/**
 * Toio robot that moves in the pad. Real sized
 */
species toio skills:[moving]{
	
	//Food it wants to eat
	
	point target;
	init{
		speed <- 0.01;
	}
	
	

	//Moves in the direction of the target food
	reflex move{
		if (target = nil){
			ask food{
				myself.target <- self.location;
			}
		}
		else{
			do goto target:target;
		}
	}
	
	
	//Eats the food once both agents are in the same position
	reflex eat{
		ask food{
			if (myself.location = self.location){
				self.eaten <- true;
				myself.target <- nil;
				create food number: 1{
					location <- any_location_in(shape);
				}
			}
		}
	}
	
	//Regular square with triangle representing the direction at which it is facing
	aspect body{
		draw square(3#cm) color: #blue rotate: heading;
		draw triangle(1#cm) rotate:90 + heading color: #red;
	}
}

//Food that serves as a target for the tooit to move to its location
species food{
	bool eaten <- false;
	
	reflex disappear{
		if eaten{
			do die;
		}
	}
	
	aspect{
		draw circle(0.5#cm) color: #red;
	}
}


experiment simple_movement type:gui{
	float minimum_cycle_duration <- 0.05;
	output{
		display view type:opengl{
			species toio aspect: body;
			species food aspect: default;
		}
	}
}
