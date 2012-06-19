package com.timwoodcreates.crumble.levels 
{
	import Box2D.Common.Math.b2Vec2;
	import com.timwoodcreates.crumble.actors.BreakableWall;
	import com.timwoodcreates.crumble.actors.FixedWall;
	import com.timwoodcreates.crumble.actors.Floor;
	import com.timwoodcreates.crumble.actors.MovableWall;
	import com.timwoodcreates.crumble.actors.Person;
	import com.timwoodcreates.crumble.actors.Stair;
	import com.timwoodcreates.crumble.actors.Villain;
	import com.timwoodcreates.crumble.env.Universe;
	/**
	 * ...
	 * @author Tim Wood
	 */
	public class Level5 extends Level
	{
		private var i:int;
		private var j:int;
		
		public function Level5() 
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
				[20.8, .4, 'breakable'],
				[24.8, .4, 'fixed'],
				[41.8, .4, 'breakable'],
				[50, 1, 'fixed']
			];
			var f1:Array = [
				[0, 13, 'fixed'],
				[13, 8, 'movable', true],
				[21, 6, 'fixed'],
				[27, 6, 'trap'],
				[33, 8, 'fixed', true],
				[41, 8, 'movable'],
				[49, 2, 'fixed', true]
			];
			var w2:Array = [
				[0, 1, 'fixed'],
				[34, .4, 'fixed'],
				[41.8, .4],
				[50, 1, 'fixed']
			];
			var f2:Array = [
				[0, 35, 'fixed'],
				[35, 8, 'movable', true],
				[43, 8, 'fixed']
			];
			var w3:Array = [
				[0, 1, 'fixed'],
				[22.8, .4, 'breakable'],
				[34, .4, 'fixed'],
				[41.8, .4],
				[50, 1, 'fixed']
			];
			var f3:Array = [
				[0, 1, 'fixed'],
				[1, 9, 'trap'],
				[10, 5, 'fixed'],
				[15, 8, 'movable', true],
				[23, 18, 'fixed'],
				[41, 8, 'movable'],
				[49, 2, 'fixed', true]
			];
			var w4:Array = [
				[0, 1, 'fixed'],
				[10, .4, 'fixed'],
				[23, .4, 'breakable'],
				[34, .4, 'fixed'],
				[41.8, .4],
				[50, 1, 'fixed']
			];
			var f4:Array = [
				[0, 1, 'fixed'],
				[1, 9, 'trap'],
				[10, 12, 'fixed'],
				[22, 8, 'movable'],
				[30, 5, 'fixed', true],
				[35, 8, 'movable', true],
				[43, 8, 'fixed']
			];
			var w5:Array = [
				[0, 1, 'fixed'],
				[10, .4, 'fixed'],
				[22, .4, 'breakable'],
				[34, .4, 'fixed'],
				[41.8, .4],
				[50, 1, 'fixed']
			];
			var f5:Array = [
				[0, 1, 'fixed'],
				[1, 9, 'trap'],
				[10, 8, 'fixed'],
				[18, 8, 'movable'],
				[26, 15, 'fixed', true],
				[41, 8, 'movable'],
				[49, 2, 'fixed', true]
			];
			var w6:Array = [
				[0, 1, 'fixed'],
				[10, .4, 'fixed'],
				[19, .4, 'breakable'],
				[34, .4, 'fixed'],
				[41.8, .4],
				[50, 1, 'fixed']
			];
			var f6:Array = [
				[0, 1, 'fixed'],
				[1, 9, 'trap'],
				[10, 2, 'fixed'],
				[12, 8, 'movable', true],
				[20, 5, 'fixed'],
				[25, 8, 'trap'],
				[33, 2, 'fixed'],
				[35, 8, 'movable', true],
				[43, 8, 'fixed']
			];
			var w7:Array = [
				[0, 1, 'fixed'],
				[6, .4, 'breakable'],
				[11.6, .4, 'breakable'],
				[22, .4, 'fixed'],
				[50, 1, 'fixed']
			];
			var f7:Array = [
				[0, 2, 'fixed'],
				[2, 11, 'movable', true],
				[13, 37, 'fixed']
			];
			
			var building:SubLevel = new SubLevel();
			building.x = -10;
			
			building.buildWalls(-3, 3, w1);
			building.buildFloors(-3.5, .5, f1);
			
			building.buildWalls(-6.5, 3, w2);
			building.buildFloors(-7, .5, f2);
			
			building.buildWalls(-10, 3, w3);
			building.buildFloors(-10.5, .5, f3);
			
			building.buildWalls(-13.5, 3, w4);
			building.buildFloors(-14, .5, f4);
			
			building.buildWalls(-17, 3, w5);
			building.buildFloors(-17.5, .5, f5);
			
			building.buildWalls(-20.5, 3, w6);
			building.buildFloors(-21, .5, f6);
			
			building.buildWalls(-24, 3, w7);
			building.buildFloors(-24.5, .5, f7);
			
			Universe.actors.push(new Villain(new b2Vec2(0, -5)));
			Universe.actors.push(new Villain(new b2Vec2(20, -1)));
			
			Universe.actors.push(new Floor(new b2Vec2(150, 1), new b2Vec2(100, 1)));
		}
		
	}

}