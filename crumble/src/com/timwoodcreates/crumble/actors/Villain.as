package com.timwoodcreates.crumble.actors 
{
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2Fixture;
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
	public class Villain extends Person
	{
		
		private var body:b2Body;
		
		private var targetJumpTo:b2Vec2 = new b2Vec2();
		private var myPos:b2Vec2 = new b2Vec2();
		private var heroPos:b2Vec2 = new b2Vec2();
		
		public function Villain(position:b2Vec2) 
		{
			super(position, false);
			body = this._body;
		}
		
		override protected function childSpecificUpdating(ms:int):void {
			var canSeeHero:Boolean = checkCanSeeHero();
			myPos = body.GetPosition().Copy();
			heroPos = Universe.hero._body.GetPosition().Copy();
			if (canSeeHero) {
				this.setAimAngle(Math.atan2(myPos.x - heroPos.x, heroPos.y - myPos.y));
				var length:Number = Math.sqrt(Math.pow(myPos.x - heroPos.x, 2) + Math.pow(myPos.y - heroPos.y, 2));
				//trace(length);
				if (length < 10){
					this.shoot();
					this.stand();
				} else {
					//trace('i want to run');
					var isLeft:Boolean = (heroPos.x < myPos.x);
					this.run(isLeft);
				}
			} else {
				this.stand();
			}
			// update the animation
			this.animateBody(ms);
		}
		
		private function checkCanSeeHero():Boolean
		{
			var fixture:b2Fixture = Universe.world.RayCastOne(body.GetPosition(), Universe.hero._body.GetPosition());
			if (fixture != null) {
				if (fixture.GetBody() != null) {
					if (fixture.GetBody().GetUserData() != null) {
						if (fixture.GetBody().GetUserData() is Hero) {
							return true;
						}
					}
				}
			}
			return false;
		}
		
	}

}