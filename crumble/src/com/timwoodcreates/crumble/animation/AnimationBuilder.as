package com.timwoodcreates.crumble.animation 
{
	import Box2D.Common.Math.b2Vec2;
	/**
	 * ...
	 * @author Tim Wood
	 */
	public class AnimationBuilder
	{
		private static const PI:Number = Math.PI;
		private static const halfPI:Number = PI/2;
		
		
		public function AnimationBuilder() 
		{
			
		}
		
		public static function makeLegRun(isLeft:Boolean = false):Animation
		{
			var t:int = 100;
			var times:Array = [t, t, t, t, t, t];
			var points:Array = [
				[halfPI * .45, 1],// front foot land
				[0, .7],// start moving back
				[- halfPI * .45, 1],// back foot stretched out
				[- halfPI, .5],// back foot swinging up
				[0, .5],// back foot and center
				[halfPI * .6, .8]// front foot before being set down
			];
			
			var offset:Number = t * 3;
			
			if (isLeft) {
				return new Animation(times, points, 1, offset);
			} else {
				return new Animation(times, points);
			}
		}
		
		public static function makeLegJump(isLeft:Boolean = false):Animation
		{
			var t:int = 400;
			var times:Array = [t, t];
			var points:Array = [
				[- halfPI * .1, .8],
				[halfPI * .5, .8]
			];
			
			if (isLeft) {
				points = [
					[-halfPI * .1, .8],
					[-halfPI * .7, .8]
				];
			}
			
			return new Animation(times, points);
		}
		
		public static function makeLegStand(isLeft:Boolean = false):Animation
		{
			var times:Array = [0];
			var points:Array = [[0, 1]];
			
			return new Animation(times, points);
		}
		
		
		
		public static function makeArmRun(isLeft:Boolean = false):Animation
		{
			var t:int = 150;
			var times:Array = [t, t, t, t];
			var points:Array = [
				[halfPI, .5],
				[0, .5],
				[- halfPI * .4, .5],
				[0, .5]
			];
			
			var offset:Number = t * 2;
			
			if (isLeft) {
				return new Animation(times, points, 1, offset);
			} else {
				return new Animation(times, points);
			}
		}
		
		public static function makeArmJump(isLeft:Boolean = false):Animation
		{
			var t:int = 200;
			var times:Array = [t, t];
			var points:Array = [
				[halfPI * .7, .8],
				[halfPI * .3, .8]
			];
			
			if (isLeft) {
				points = [
					[-halfPI * .5, .8],
					[-halfPI * .1, .8]
				];
			}
			
			return new Animation(times, points);
		}
		
		public static function makeArmStand(isLeft:Boolean = false):Animation
		{
			var times:Array = [0];
			var points:Array = [
				[halfPI * .05, .95]
			];
			if (isLeft) {
				points = [[halfPI * .1, .9]];
			}
			return new Animation(times, points);
		}
	}

}