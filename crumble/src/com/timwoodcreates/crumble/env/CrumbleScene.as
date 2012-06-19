package com.timwoodcreates.crumble.env 
{
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Tim Wood
	 */
	public class CrumbleScene extends Sprite
	{
		public var debugDraw:Sprite;
		public var realDraw:Sprite;
		
		private var isDebug:Boolean = true;
		
		public function CrumbleScene() 
		{
			debugDraw = new Sprite();
			realDraw = new Sprite();
			addChild(debugDraw);
			addChild(realDraw);
			setDebug();
			toggleDebug();
		}
		
		private function setDebug():void
		{
			debugDraw.visible = isDebug;
			realDraw.visible = !isDebug;
		}
		
		public function toggleDebug():void
		{
			isDebug = !isDebug;
			setDebug();
		}
		
	}

}