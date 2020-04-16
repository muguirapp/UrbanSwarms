/***
* Name: TangibleIntersection
* Author: mugui
* Description: 
* Tags: Tag1, Tag2, TagN
***/

model Intersection

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


species toio skills:[moving]{
	point target;
	init{
		speed <- 0.01;
	}
	
	
	aspect body{
		draw square(3#cm) color: #blue;
	}
	
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
}

species food{
	bool eaten <- false;
	
	reflex disappear{
		if eaten{
			do die;
		}
	}
	
	aspect{
		draw circle(1#cm) color: #red;
	}
}


experiment simple_movement type:gui{
	float minimum_cycle_duration <- 0.05;
	output{
		display view{
			species toio aspect: body;
			species food aspect: default;
		}
	}
}
