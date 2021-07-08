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
	
	bool NeedMaxPower(RocketData data)
	{
		while (data.vSpeed >= landing_speed)
		{
			data = OneSecondSimulation(data, 4);
		}
		bool hasCrashed = data.vDistance < 0;

		return hasCrashed;
	}

	
	// returns thrust value. Between 0 and 4
	public int Update(double rocketSpeed, double distanceToPad)
	{
		RocketData data;
		data.vSpeed = rocketSpeed;
		data.vDistance = distanceToPad;
		
		return NeedMaxPower(data) ? 4 : 0;
	}
}
