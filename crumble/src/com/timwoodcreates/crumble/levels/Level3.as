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
	public class Level3 extends Level
	{
		private var i:int;
		private var j:int;
		
		public function Level3() 
		{
			super();
		}
		
		override protected function childSpecificBuilding():void
		{
			// define breakable walls
			var actors:Array = [
				[1,4,-5,-4],
				[1,4,5,-4]
			];
			for (i = 0; i < actors.length; i++) {
				Universe.actors.push(new BreakableWall(new b2Vec2(actors[i][0], actors[i][1]), new b2Vec2(actors[i][2], actors[i][3])));
			}
			
			// define solid walls
			actors = [
				[1,4,15,-4],
				[1,4,-15,-4],
				[1,4,15,-14],
				[1,4,-15,-14],
				[1,4,15,-24],
				[1,4,-15,-24],
				[1,4,15,-34],
				[1,4,-15,-34],
				[1,4,15,-44],
				[1,4,-15,-44],
				[1,4,15,-54],
				[1,4,-15,-54]
			];
			for (i = 0; i < actors.length; i++) {
				Universe.actors.push(new FixedWall(new b2Vec2(actors[i][0], actors[i][1]), new b2Vec2(actors[i][2], actors[i][3])));
			}
			
			// define movable walls
			actors = [
				[1,4,-5,-14],
				[1,4,5,-14],
				[5,1,10,-9],
				[5,1,0,-9],
				[5,1,-10,-9],
				[1,4,-5,-24],
				[1,4,5,-24],
				[5,1,10,-19],
				[5,1,0,-19],
				[5,1,-10,-19],
				[1,4,-5,-34],
				[1,4,5,-34],
				[5,1,10,-29],
				[5,1,0,-29],
				[5,1,-10,-29],
				[1,4,-5,-44],
				[1,4,5,-44],
				[5,1,10,-39],
				[5,1,0,-39],
				[5,1,-10,-39],
				[1,4,-5,-54],
				[1,4,5,-54],
				[5,1,10,-49],
				[5,1,0,-49],
				[5,1,-10,-49],
				[5,1,10,-59],
				[5,1,0,-59],
				[5,1,-10,-59]
			];
			for (i = 0; i < actors.length; i++) {
				Universe.actors.push(new MovableWall(new b2Vec2(actors[i][0], actors[i][1]), new b2Vec2(actors[i][2], actors[i][3])));
			}
			
			Universe.actors.push(new Floor(new b2Vec2(60, 1), new b2Vec2(30, 1)));
			Universe.actors.push(new Floor(new b2Vec2(60, 1), new b2Vec2(30, -208)));
			Universe.actors.push(new Floor(new b2Vec2(2, 60), new b2Vec2(-30, -58)));
			Universe.actors.push(new Floor(new b2Vec2(2, 60), new b2Vec2(90, -58)));
		}
		
	}

}