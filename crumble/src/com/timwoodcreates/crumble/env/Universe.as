package com.timwoodcreates.crumble.env
{
	import Box2D.Dynamics.b2World;
	import com.timwoodcreates.crumble.actors.Hero;
	import com.timwoodcreates.crumble.utils.Architect;
	import com.timwoodcreates.crumble.utils.Effects;
	import com.timwoodcreates.crumble.utils.GameLogic;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author ...
	 * This class is for singleton variables.
	 * logic - the game logic
	 * world - the box2d world
	 * scene - the flash sprite that holds all the other sprites
	 * hero - the hero actor
	 * RATIO - the ratio of meters to pixels
	 */
	public class Universe
	{
		public static const RATIO:Number = 50;
		
		public static var world:b2World;
		public static var scene:CrumbleScene;
		public static var camera:Sprite;
		public static var film:Bitmap;
		public static var logic:GameLogic;
		public static var hero:Hero;
		public static var architect:Architect;
		public static var actors:Array = [];
		public static var actorsToRemove:Array = [];
		public static var effects:Effects;
		public static var isSlowmotion:Boolean = false;
		// depreciated - use msPerFrame instead public static var framesPerSecond:int = 30;
		public static var msPerFrame:int = 33;
		public static var timeElapsed:int = 0;
		
	}

}