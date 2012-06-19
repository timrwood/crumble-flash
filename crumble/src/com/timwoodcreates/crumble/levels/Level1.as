package com.timwoodcreates.crumble.levels 
{
	import Box2D.Common.Math.b2Vec2;
	import com.timwoodcreates.crumble.actors.Floor;
	import com.timwoodcreates.crumble.actors.Stair;
	import com.timwoodcreates.crumble.env.Universe;
	/**
	 * ...
	 * @author Tim Wood
	 */
	public class Level1 extends Level
	{
		private var i:int;
		private var j:int;
		
		public function Level1() 
		{
			super();
		}
		
		override protected function childSpecificBuilding():void
		{
			
			// add the bounding walls, ceiling, and floor
			Universe.actors.push(new Floor(new b2Vec2(60, 2), new b2Vec2(30, 2)));
			Universe.actors.push(new Floor(new b2Vec2(60, 2), new b2Vec2(30, -58)));
			Universe.actors.push(new Floor(new b2Vec2(2, 60), new b2Vec2(-30, -58)));
			Universe.actors.push(new Floor(new b2Vec2(2, 60), new b2Vec2(90, -58)));
		}
		
	}

}