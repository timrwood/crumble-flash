package com.timwoodcreates.crumble.levels 
{
	import Box2D.Common.Math.b2Vec2;
	import com.timwoodcreates.crumble.actors.BreakableWall;
	import com.timwoodcreates.crumble.actors.Floor;
	import com.timwoodcreates.crumble.actors.MovableWall;
	import com.timwoodcreates.crumble.actors.Stair;
	import com.timwoodcreates.crumble.actors.Wall;
	import com.timwoodcreates.crumble.env.Universe;
	/**
	 * ...
	 * @author Tim Wood
	 */
	public class Level2 extends Level
	{
		private var i:int;
		private var j:int;
		
		public function Level2() 
		{
			super();
		}
		
		override protected function childSpecificBuilding():void
		{
			/*
			var walls:Array = [
				[.5,2.5,-2.5,-3],
				[.5,2.5,-8.5,-3],
				[.5,2.5,-16.5,-3]
			];
			for (i = 0; i < walls.length; i++) {
				Universe.actors.push(new BreakableWall(new b2Vec2(walls[i][0], walls[i][1]), new b2Vec2(walls[i][2], walls[i][3] - j*10)));
			}
			*/
			var wallsSolid:Array = [
				[10,1,10,-7],
				[6,1,34,-7],
				[16,1,24,-15],
				[16,1,16,-23],
				[16,1,24,-31],
				[.5,12,.5,-20],
				[.5,12,39.5,-20]
			];
			for (i = 0; i < wallsSolid.length; i++) {
				Universe.actors.push(new Floor(new b2Vec2(wallsSolid[i][0], wallsSolid[i][1]), new b2Vec2(wallsSolid[i][2], wallsSolid[i][3] - j*10)));
			}
			var stairs:Array = [
				[4, 24, -4],
				[4, 4, -12],
				[4, 36, -20],
				[4, 4, -28]
			];
			for (i = 0; i < stairs.length; i++) {
				Universe.actors.push(new Stair(stairs[i][0], new b2Vec2(stairs[i][1], stairs[i][2])));
			}
			
			Universe.actors.push(new Floor(new b2Vec2(60, 1), new b2Vec2(30, 1)));
			Universe.actors.push(new Floor(new b2Vec2(60, 1), new b2Vec2(30, -58)));
			Universe.actors.push(new Floor(new b2Vec2(2, 60), new b2Vec2(-30, -58)));
			Universe.actors.push(new Floor(new b2Vec2(2, 60), new b2Vec2(90, -58)));
		}
		
	}

}