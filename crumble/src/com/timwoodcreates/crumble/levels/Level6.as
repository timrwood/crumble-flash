package com.timwoodcreates.crumble.levels 
{
	import Box2D.Common.Math.b2Vec2;
	import com.timwoodcreates.crumble.actors.BreakableWall;
	import com.timwoodcreates.crumble.actors.FixedWall;
	import com.timwoodcreates.crumble.actors.Floor;
	import com.timwoodcreates.crumble.actors.MovableWall;
	import com.timwoodcreates.crumble.actors.Person;
	import com.timwoodcreates.crumble.actors.Stair;
	import com.timwoodcreates.crumble.env.Universe;
	/**
	 * ...
	 * @author Tim Wood
	 */
	public class Level6 extends Level
	{
		private var i:int;
		private var j:int;
		
		public function Level6() 
		{
			super();
		}
		
		override protected function childSpecificBuilding():void
		{
			// floor 1
			var b1:Array = [
				[0, 50]
			];
			var w1:Array = [
				[0, 1, 'fixed'],
				[10-.2, .4, 'breakable'],
				[20-.2, .4, 'breakable'],
				[30-.2, .4, 'breakable'],
				[40-.2, .4, 'breakable'],
				[50, 1, 'fixed']
			];
			var f1:Array = [
				[0, 10, 'trap'],
				[10, 10, 'trap'],
				[20, 10, 'trap'],
				[30, 10, 'trap'],
				[40, 10, 'trap']
			];
			var w2:Array = [
				[0, 1, 'fixed'],
				[5-.2, .4, 'breakable'],
				[15-.2, .4, 'breakable'],
				[25-.2, .4, 'breakable'],
				[35-.2, .4, 'breakable'],
				[45-.2, .4, 'breakable'],
				[50, 1, 'fixed']
			];
			var f2:Array = [
				[0, 5, 'trap'],
				[5, 10, 'trap'],
				[15, 10, 'trap'],
				[25, 10, 'trap'],
				[35, 10, 'trap'],
				[45, 5, 'trap']
			];
			
			var building:SubLevel = new SubLevel();
			building.x = -10;
			
			building.buildWalls(-3, 3, w1);
			building.buildFloors(-3.25, .25, f1);
			
			building.buildWalls(-6.25, 3, w2);
			building.buildFloors(-6.5, .25, f2);
			
			building.buildWalls(-9.5, 3, w1);
			building.buildFloors(-9.75, .25, f1);
			
			building.buildWalls(-12.75, 3, w2);
			building.buildFloors(-13, .25, f2);
			
			building.buildWalls(-16, 3, w1);
			building.buildFloors(-16.25, .25, f1);
			
			building.buildWalls(-19.25, 3, w2);
			building.buildFloors(-19.5, .25, f2);
			
			building.buildWalls(-22.5, 3, w1);
			building.buildFloors(-22.75, .25, f1);
			
			//Universe.actors.push(new Person(new b2Vec2(3, -1)));
			//Universe.actors.push(new Person(new b2Vec2(5, -1)));
			//Universe.actors.push(new Person(new b2Vec2(7, -1)));
			
			Universe.actors.push(new Floor(new b2Vec2(150, 1), new b2Vec2(100, 2)));
		}
		
	}

}