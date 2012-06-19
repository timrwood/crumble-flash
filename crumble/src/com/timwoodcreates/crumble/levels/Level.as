package com.timwoodcreates.crumble.levels 
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Joints.b2PrismaticJointDef;
	import com.timwoodcreates.crumble.actors.Hero;
	import com.timwoodcreates.crumble.env.Universe;
	/**
	 * ...
	 * @author Tim Wood
	 */
	public class Level
	{
		
		public function Level() 
		{
			
		}
		
		public function build():void
		{
			heroBuilding();
			childSpecificBuilding();
		}
		
		private function heroBuilding():void
		{
			// instantiate the hero
			Universe.hero = new Hero(new b2Vec2(0,-2));
			// add him to our actors array to be updated during newFrameListener()
			Universe.actors.push(Universe.hero);
		}
		
		protected function childSpecificBuilding():void
		{
			//This function does nothing
			//To be used by children
		}
	}

}