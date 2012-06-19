package com.timwoodcreates.crumble.animation 
{
	import Box2D.Common.Math.b2Vec2;
	/**
	 * ...
	 * @author Tim Wood
	 */
	public class AnimationMixer
	{
		private static const PI:Number = Math.PI;
		private static const halfPI:Number = PI / 2;
		
		private var runAnim:Animation;
		private var standAnim:Animation;
		private var jumpAnim:Animation;
		
		private var animations:Array = [];
		private var maxLength:Number = 0;
		private var facingLeft:Boolean = false;
		private var helperAngleA:Number = 0;
		private var helperAngleB:Number = 0;
		
		private var targetDistance:Number = 0;
		private var targetAngle:Number = 0;
		private var totalOpacity:Number = 1;
		
		public var pointBY:Number = 0;
		public var pointBX:Number = 0;
		//public var pointA:b2Vec2 = new b2Vec2();
		//public var pointDiffA:b2Vec2 = new b2Vec2();
		public var angleA:Number = 0;
		public var angleB:Number = 0;
		
		
		public function AnimationMixer(_maxLength:int, isLegs:Boolean, isLeft:Boolean) 
		{
			maxLength = _maxLength;
			
			if (isLegs) {
				runAnim = AnimationBuilder.makeLegRun(isLeft);
				standAnim = AnimationBuilder.makeLegStand(isLeft);
				jumpAnim = AnimationBuilder.makeLegJump(isLeft);
			} else {
				runAnim = AnimationBuilder.makeArmRun(isLeft);
				standAnim = AnimationBuilder.makeArmStand(isLeft);
				jumpAnim = AnimationBuilder.makeArmJump(isLeft);
			}
			addAnimation(runAnim);
			addAnimation(standAnim);
			addAnimation(jumpAnim);
		}
		
		public function step(ms:int):void
		{
			// set the initial point
			//pointDiffA = pointA.Copy();
			
			// reset the target values
			targetDistance = 0;
			targetAngle = 0;
			totalOpacity = 0;
			
			//trace('angle = ' + targetAngle);
			// add the values of each active animation
			for each(var anim:Animation in animations) {
				if (anim.enabled){
					anim.step(ms);
					//trace('anim.angle = ' + anim.angle + ' anim.opacity = ' + anim.opacity + ' anim.distance = ' + anim.distance);
					//trace('angle = ' + targetDistance);
					targetAngle += anim.angle * anim.opacity;
					targetDistance += anim.distance * anim.opacity;
					//trace('angle = ' + targetDistance);
					totalOpacity += anim.opacity;
				}
			}
			// if the opacity is less than one, fill with zero angle
			if (totalOpacity < 1) {
				targetDistance += (1 - totalOpacity);
				totalOpacity = 1;
			}
			//trace('angle = ' + targetAngle);
			
			// set the total opacity of the point
			targetAngle = targetAngle / totalOpacity;
			targetDistance = targetDistance / totalOpacity;
			//trace('final angle = ' + targetDistance);
			
			// make sure the distance is not greater than the maximum distance
			targetDistance = Math.min(targetDistance, maxLength);
			
			// set the helper angles
			pointBX = targetDistance * Math.cos(targetAngle + halfPI);
			pointBY = targetDistance * Math.sin(targetAngle + halfPI);
			//trace('pointBY = ' + pointBY);
			//trace('pointBX = ' + pointBX);
			
			// set the helper angles
			helperAngleA = Math.atan2(pointBX, pointBY);
			helperAngleB = Math.acos(targetDistance);
			
			// change the helper angles if facing left
			if (facingLeft) {
				helperAngleA = Math.atan2( -pointBX, pointBY);
				helperAngleB = -helperAngleB;
			}
			
			// set the angles
			angleA = helperAngleA - helperAngleB;
			angleB = helperAngleA + helperAngleB;
			
			// set point a
			//pointA.x = maxLength / 2 * Math.cos(angleA);
			//pointA.y = maxLength / 2 * Math.sin(angleA);
			
			// sebtract the new points from the speeds
			//pointDiffA.Subtract(pointA.Copy());
		}
		
		public function addAnimation(anim:Animation):void
		{
			animations.push(anim);
		}
		
		public function switchDirection(_facingLeft:Boolean):void
		{
			facingLeft = _facingLeft;
		}
		
		// should only be called once, not every frame
		public function run():void {
			runAnim.fadeTo(1, 100);
			standAnim.fadeTo(0, 0);
			jumpAnim.fadeTo(0, 0);
		}
		
		// should only be called once, not every frame
		public function stand():void {
			runAnim.fadeTo(0, 100);
			standAnim.fadeTo(1, 100);
			jumpAnim.fadeTo(0, 100);
		}
		
		// should only be called once, not every frame
		public function jump():void {
			runAnim.fadeTo(0, 100);
			standAnim.fadeTo(0, 100);
			jumpAnim.fadeTo(1, 100);
		}
		
	}

}