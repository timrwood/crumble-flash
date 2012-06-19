package com.timwoodcreates.crumble.levels 
{
	import Box2D.Common.Math.b2Vec2;
	import com.timwoodcreates.crumble.actors.BreakableWall;
	import com.timwoodcreates.crumble.actors.FixedWall;
	import com.timwoodcreates.crumble.actors.Floor;
	import com.timwoodcreates.crumble.actors.MovableWall;
	import com.timwoodcreates.crumble.actors.Stair;
	import com.timwoodcreates.crumble.env.Universe;
	/**
	 * ...
	 * @author Tim Wood
	 */
	public class Level4 extends Level
	{
		private var i:int;
		private var j:int;
		
		public function Level4() 
		{
			super();
		}
		
		override protected function childSpecificBuilding():void
		{
			// floor 1
			var b1:Array = [
				/*[20, -2],
				[22, -2], 
				[21, -4], 
				[40, -2],
				[40, -4], 
				[40, -6], 
				[40, -8], 
				[60, -2],
				[62, -2],
				[62, -4],
				[64, -2],
				[64, -4], 
				[64, -6],
				[66, -2],
				[66, -4], 
				[66, -6], 
				[66, -8]*/
			];
			var w1:Array = [
				[0, 1, 'fixed'],
				[20, 1, 'breakable'],
				[25, 1, 'breakable'],
				[30, 1, 'breakable'],
				[35, 1, 'breakable'],
				[40, 1, 'breakable'],
				[45, 1, 'breakable'],
				[50, 1, 'breakable'],
				[60, 1, 'breakable'],
				[99, 1, 'fixed']
			];
			var d1:Array = [
				[20, 1],
				[30, 1],
				[40, 1, true]
			];
			var s1:Array = [
				[89, true]
			];
			var f1:Array = [
				[0, 94, 'fixed'],
				[99, 1, 'fixed']
			];
			
			// floor 2
			var w2:Array = [
				[0, 1, 'fixed'],
				[60, 1, 'fixed'],  
				[99, 1, 'fixed']
			];
			var s2:Array = [
				[60],
				[10]
			];
			var f2:Array = [
				[0, 10, 'fixed'],
				[20, 20, 'fixed'],
				[50, 11, 'fixed'],
				[70, 30, 'fixed']
			];
			
			// floor 3
			var w3:Array = [
				[0, 1, 'fixed'],
				[20, 1, 'fixed'],  
				[99, 1, 'fixed']
			];
			var s3:Array = [
				[10, true]
			];
			var f3:Array = [
				[0, 10, 'fixed'],
				[20, 80, 'fixed']
			];
			
			// floor 4
			var w4:Array = [
				[30, 1, 'breakable'],
				[35, 1, 'breakable'],
				[40, 1, 'breakable'],
				[45, 1, 'breakable'],
				[50, 1, 'breakable'],
				[60, 1, 'breakable'],
			];
			
			var building:SubLevel = new SubLevel();
			building.x = -10;
			
			building.buildWalls(-8, 8, w1);
			building.buildFloors(-10, 2, f1);
			building.buildStairs(-10, 10, s1);
			//building.buildDoors(-8, 8, d1);
			building.buildBoxes(2, b1);
			building.buildWalls(-18, 8, w2);
			building.buildFloors(-20, 2, f2);
			building.buildStairs(-20, 10, s2);
			building.buildWalls(-28, 8, w3);
			building.buildFloors(-30, 2, f3);
			building.buildStairs(-30, 10, s3);
			building.buildWalls(-38, 8, w4);
			
			Universe.actors.push(new Floor(new b2Vec2(150, 1), new b2Vec2(100, 1)));
		}
		
	}

}