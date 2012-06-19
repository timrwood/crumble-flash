package com.timwoodcreates.crumble.levels 
{
	import Box2D.Common.Math.b2Vec2;
	import com.timwoodcreates.crumble.actors.BreakableWall;
	import com.timwoodcreates.crumble.actors.FixedWall;
	import com.timwoodcreates.crumble.actors.Floor;
	import com.timwoodcreates.crumble.actors.MovableWall;
	import com.timwoodcreates.crumble.actors.Stair;
	import com.timwoodcreates.crumble.actors.Wall;
	import com.timwoodcreates.crumble.env.Universe;
	/**
	 * ...
	 * @author Tim Wood
	 */
	public class ClimbingLevel extends Level
	{
		private var i:int;
		private var j:int;
		
		public function ClimbingLevel() 
		{
			super();
		}
		
		override protected function childSpecificBuilding():void
		{
			// floor 1
			
			var w1:Array = [
				[0, 1, 'fixed'],
				[20, 1, 'fixed']
			];
			var reference:Array = [
				[-1, 1, 'fixed'],
				[21, 1, 'fixed']
			];
			
			var building:SubLevel = new SubLevel();
			building.x = -10;
			
			//building.buildWalls(-100, 100, w1);
			building.buildWalls(-10, 1, reference);
			building.buildWalls(-20, 1, reference);
			building.buildWalls(-30, 1, reference);
			building.buildWalls(-40, 1, reference);
			building.buildWalls(-50, 1, reference);
			building.buildWalls(-60, 1, reference);
			building.buildWalls(-70, 1, reference);
			building.buildWalls(-80, 1, reference);
			building.buildWalls(-90, 1, reference);
			building.buildWalls(-100, 1, reference);
			
			Universe.actors.push(new Floor(new b2Vec2(150, 1), new b2Vec2(100, 1)));
		}
		
	}

}