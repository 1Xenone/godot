using Godot;
using System;


public class UserScript : Node
{
	const double landing_speed = 5; // spacecraft will crash if the speed is higher
	const double mars_gravity = 3.2;
	
	public struct RocketData
	{
		public double vSpeed;
		public double vDistance;
	};
	
	RocketData OneSecondSimulation(RocketData data, int thrust)
	{
		data.vSpeed += mars_gravity - thrust;
		data.vDistance -= data.vSpeed;
		return data;
	}	

	// returns thrust value. Between 0 and 4
	public int Update(double rocketSpeed, double distanceToPad)
	{
		if(distanceToPad < 280){
			return 4;
		}
		return 0;
	}
}
