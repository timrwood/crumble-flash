package com.timwoodcreates.crumble.actors 
{
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.Joints.b2DistanceJoint;
	import Box2D.Dynamics.Joints.b2DistanceJointDef;
	import Box2D.Dynamics.Joints.b2Joint;
	import Box2D.Dynamics.Joints.b2JointDef;
	import Box2D.Dynamics.Joints.b2PrismaticJoint;
	import Box2D.Dynamics.Joints.b2PrismaticJointDef;
	import Box2D.Dynamics.Joints.b2RevoluteJointDef;
	import com.timwoodcreates.crumble.env.Universe;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.utils.getTimer;
	/**
	 * ...
	 * @author Tim Wood
	 */
	public class Hero extends Person
	{
		private static const MAX_SPEED:int = 1 / .2 ;
		private static const RUN_SPEED:int = 2;
		private static const JUMP_SPEED:int = 5;
		private static const STOMP_SPEED:int = 12;
		private static const MAX_JUMP:int = 12;
		private static const DOUBLE_TAP:int = 400;
		private static const MAX_SECONDS_AT_MAX_SPEED:Number = .12;
		private static const MOUSE_DISTANCE_TO_DASH:int = 20;
		private static const MOUSE_DISTANCE_TIMEOUT:int = 1000
		private static const VERTICAL_SPEED:int = -25;
		
		private var body:b2Body;
		private var costume:Sprite = new Sprite();
		private var pressLeft:Boolean = false;
		private var pressRight:Boolean = false;
		private var pressUp:Boolean = false;
		private var pressDown:Boolean = false;
		private var pressingShoot:Boolean = false;
		private var lastLeft:Number = 0;
		private var lastRight:Number = 0;
		private var pressSpace:Boolean = false;
		private var enableSpace:Boolean = true;
		private var secondsAtMaxSpeed:Number = 0;
		
		private var targetJumpTo:b2Vec2 = new b2Vec2();
		
		public function Hero(position:b2Vec2) 
		{
			super(position, true);
			body = this._body;
		}
		
		// the keypresses sent from the crumble class
		public function keyPress(e:KeyboardEvent):void {
			body.SetAwake(true);
			switch (e.keyCode) {
				case Keyboard.RIGHT:
					pressRight = true;
					checkDoubleTap(false);
					break;
				case Keyboard.LEFT:
					pressLeft = true;
					checkDoubleTap(true);
					break;
				case Keyboard.UP:
					pressUp = true;
					break;
				case Keyboard.DOWN:
					pressDown = true;
					break;
				case Keyboard.DELETE:
					pressingShoot = true;
					break;
				case Keyboard.CONTROL:
					pressSpace = true;
					break;
				case Keyboard.SPACE:
					tract('should kill');
					this.kill();
					break;
			}
		}
		
		public function keyRelease(e:KeyboardEvent):void {
			switch (e.keyCode) {
				case Keyboard.RIGHT:
					pressRight = false;
					// check if double tapped - pass false for right, true for left
					setDoubleTap(false);
					break;
				case Keyboard.LEFT:
					pressLeft = false;
					setDoubleTap(true);
					break;
				case Keyboard.UP:
					pressUp = false;
					break;
				case Keyboard.DOWN:
					pressDown = false;
					break;
				case Keyboard.CONTROL:
					pressSpace = false;
					enableSpace = true;
					break;
				case Keyboard.DELETE:
					pressingShoot = false;
					break;
			}
		}
		
		public function mouseUp():void
		{
			
		}
		
		public function mouseDown():void
		{
			jumpToMousePosition();
		}
		
		private function jumpToMousePosition():void
		{
			// add a shake effect
			Universe.effects.shake = 200;
			  
			// apply an impulse in that direction
			body.ApplyImpulse(targetJumpTo, body.GetWorldCenter());
		}

		
		public function setMouseTarget(mouseX:Number, mouseY:Number):void
		{
			//trace('set target : ' + mouseX + ', ' + mouseY);
			targetJumpTo.x = mouseX;
			targetJumpTo.y = mouseY;
			targetJumpTo.Normalize();
			targetJumpTo.Multiply(100);
			this.setAimAngle(Math.atan2( -mouseX, mouseY));
		}
		
		private function setDoubleTap(isleft:Boolean):void
		{
			var time:Number = new Date().getTime();
			if (isleft) {
				lastLeft = time;
			} else {
				lastRight = time;
			}
		}
		
		private function checkDoubleTap(isleft:Boolean):void
		{
			/* 
			 * this can be cleaned up, but not until we figure out what kind of mechanics work best for the game
			 * time is the number of milliseconds since midnight January 1, 1970
			 * see http://www.adobe.com/livedocs/flash/9.0/ActionScriptLangRefV3/Date.html#getTime()
			 */
			var time:Number = new Date().getTime();
			// switch left or right keys
			if (isleft) {
				// if time since last left key release is less than the DOUBLE_TAP constant defined above...
				if (time - lastLeft < DOUBLE_TAP) {
					// apply an impulse to hero body
					//body.ApplyImpulse(new b2Vec2(-400, 0), body.GetWorldCenter());
				}
				// set the last left key release to now (so this function can use this value next time it is called)
				//lastLeft = time;
			} else {
				// do the same for the right key only with an impulse in the opposite direction
				if (time - lastRight < DOUBLE_TAP) {
					//body.ApplyImpulse(new b2Vec2(400, 0), body.GetWorldCenter());
				}
				//lastRight = time;
			}
		}
		
		override protected function childSpecificUpdating(ms:int):void {
			 
			// check if the hero is running
			if ( pressRight ) {
				this.run(false);
			}
			if ( pressLeft ) {
				this.run(true);
			}
			
			// if not running, stand still
			if ( !pressLeft && !pressRight ) {
				this.stand();
			}
			
			// check if the hero is jumping or stomping
			if (pressUp) {
				this.jump();
			}
			
			// shoot
			if (pressingShoot) {
				this.shoot();
			}
			
			// update the animation
			this.animateBody(ms);
		}
		
	}

}