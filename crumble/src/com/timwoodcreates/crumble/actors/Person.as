package com.timwoodcreates.crumble.actors 
{
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.Joints.b2RevoluteJoint;
	import Box2D.Dynamics.Joints.b2RevoluteJointDef;
	import com.timwoodcreates.crumble.env.Universe;
	import com.timwoodcreates.crumble.utils.CMasks;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Tim Wood
	 */
	public class Person extends Actor
	{
		private static const PI:Number = Math.PI;
		private static const DEG_TO_RAD:Number = PI / 180;
		private static const RAD_TO_DEG:Number = 180 / PI;
		private static const TIME_BETWEEN_FOOT_HIT:int = 100;
		
		private static const ARMS_WIDTH:Array = [.05, .05];
		private static const ARM_JOINTS:Array = [ -.7 + ARMS_WIDTH[0], -.25, .15];
		private static const LEGS_WIDTH:Array = [.08, .08];
		private static const LEG_JOINTS:Array = [0, .5, 1 - LEGS_WIDTH[1]];
		private static const HEAD_JOINT:Number = -.7;
		private static const TIE_Y:Number = .65;
		
		private static const MAX_SPEED:int = 20;
		private static const RUN_SPEED:int = 2;
		
		public static var groupIndex:int = 0;
		
		private var body:b2Body;
		private var costume:Sprite = new Sprite();
		
		private var gun:Gun;
		private var gunJoint:b2RevoluteJoint;
		private var torso:Limb;
		private var torsoJoint:b2RevoluteJoint;
		
		private var isFacingLeft:Boolean = false;
		private var isRunning:Boolean = false;
		private var isJumping:Boolean = false;
		private var isInMidair:Boolean = false;
		public var isAlive:Boolean = true;
		public var isHero:Boolean = false;
		public var isPunching:Boolean = false;
		
		private var footHitCount:int = 0;
		private var personHitCount:int = 0;
		private var lastFootHit:int = 0;
		
		private var timeToDie:int = 0;
		private var fadeOutDie:Number = 1;
		
		private var hp:Number = 100;
		
		public var gunAimAngle:Number = 0;
		
		private var hpBar:Sprite = new Sprite();
		
		public function Person(position:b2Vec2, _isHero:Boolean = false) 
		{
			isHero = _isHero;
			
			// increment the groupIndex
			groupIndex ++;
			
			// define body
			var bodyDef:b2BodyDef = new b2BodyDef();
			bodyDef.position.Set(position.x, position.y);
			bodyDef.type = b2Body.b2_dynamicBody;
			
			// create body
			body = Universe.world.CreateBody(bodyDef);
			
			// define fixture mask bits
			var maskBits:uint = CMasks.VILLAIN_BULLET | CMasks.STATIC_BUILDING | CMasks.DYNAMIC_BUILDING;
			var categoryBits:uint = CMasks.HERO;
			if (!isHero) {
				maskBits = CMasks.HERO_BULLET | CMasks.STATIC_BUILDING | CMasks.DYNAMIC_BUILDING;
				categoryBits = CMasks.VILLAIN;
			}
			
			// define shapes for box
			var boxShapeDef:b2PolygonShape = new b2PolygonShape();
			//boxShapeDef.SetAsBox(.2, .8);
			boxShapeDef.SetAsOrientedBox(.2, .8, new b2Vec2(0, 0), 0);
			var boxFixtureDef:b2FixtureDef = new b2FixtureDef();
			boxFixtureDef.shape = boxShapeDef;
			boxFixtureDef.density = 1;
			boxFixtureDef.filter.groupIndex = -Person.groupIndex;
			boxFixtureDef.filter.categoryBits = categoryBits;
			boxFixtureDef.filter.maskBits = maskBits;
			body.CreateFixture(boxFixtureDef);
			
			// define round edges of top and bottom
			for (var i:int = 0; i < 2; i++) {
				var circleShapeDef:b2CircleShape = new b2CircleShape(.2);
				circleShapeDef.SetLocalPosition(new b2Vec2(0, (i == 0? .8 : -.8)));
				var circleFixtureDef:b2FixtureDef = new b2FixtureDef();
				circleFixtureDef.shape = circleShapeDef;
				circleFixtureDef.density = 1;
				circleFixtureDef.filter.groupIndex = -Person.groupIndex;
				circleFixtureDef.filter.categoryBits = categoryBits;
				circleFixtureDef.filter.maskBits = maskBits;
				body.CreateFixture(circleFixtureDef);
			}
			
			// create costume
			Universe.scene.realDraw.addChild(costume);
			
			costume.graphics.beginFill(0, 1);
			costume.graphics.drawRect( -.2 * Universe.RATIO, -1 * Universe.RATIO, .4 * Universe.RATIO, 2 * Universe.RATIO);
			
			costume.addChild(hpBar);
			hpBar.graphics.beginFill(0, 1);
			hpBar.graphics.drawRect( -.5 * Universe.RATIO, -1 * Universe.RATIO, Universe.RATIO, .2 * Universe.RATIO);
			
			// call actor class
			super(body, costume);
			
			// add limbs and joints
			buildBody(position);
		}
		
		
		/* ----------    CREATING    -------------- */
		
		
		private function buildBody(position:b2Vec2):void
		{
			// make torso
			/*torso = new Limb(position, Limb.TYPE_TORSO, false, this);
			Universe.actors.push(torso);
			var torsoJointDef:b2RevoluteJointDef = new b2RevoluteJointDef();
			torsoJointDef.Initialize(body, torso._body, position);
			torsoJointDef.upperAngle = .5;
			torsoJointDef.lowerAngle = -.5;
			torsoJointDef.enableLimit = true;
			torsoJoint = b2RevoluteJoint(Universe.world.CreateJoint(torsoJointDef));*/
			
			// make gun
			gun = new Gun(isHero);
			
		}
		
		
		
		/* ----------    UPDATING    -------------- */
		
		
		
		override protected function childSpecificUpdating(ms:int):void {
			stand();
			animateBody(ms);
		}
		
		/*
		 * function to animate the body based on the animations currently in use.
		 * should be called by children on each childSpecificUpdating
		 */
		public function animateBody(ms:int):void
		{
			if (isHero && hp < 100) {
				hp += .4;
				hpBar.graphics.clear();
				hpBar.graphics.beginFill(0, 1);
				hpBar.graphics.drawRect( -.5 * Universe.RATIO, -1 * Universe.RATIO, Universe.RATIO * Math.max(0, hp / 100), .2 * Universe.RATIO);
			}
			
			gun.update(ms);
			
			var targetAngle:Number = 0;
			
			// set a slight forward angle while running
			if (isRunning) {
				targetAngle = .4;
			}
			
			// reverse it if you're facing left
			if (isFacingLeft) {
				targetAngle = -targetAngle;
			}
			
			if (isAlive){
				// set the torso to lean forward
				//torso._body.SetAngularVelocity( (targetAngle -torso._body.GetAngle()) * 1000 / ms);
				
				// set the body to stand straight
				body.SetAngularVelocity( -body.GetAngle() * 1000 / ms );
				
				// match linear velocity for torso and gun
				//torso._body.SetLinearVelocity(body.GetLinearVelocity());
			}
			
			
			// set the person as not in midair if they start to fall
			//if (!isInMidair && ((body.GetLinearVelocity().y > .2 && personHitCount == 0) || personHitCount < 1)){
				//setMidair();
			//}
			
		}
		
		private function switchDirection(faceLeft:Boolean):void
		{
			isFacingLeft = faceLeft;
		}
		
		private function setMidair():void
		{
			isInMidair = true;
			isRunning = false;
		}
		
		// function for the person to count the number of hits
		public function addFootHit(actor:Actor, add:Boolean):void
		{
			if (add) {
				isInMidair = false;
				isJumping = false;
				personHitCount ++;
			} else {
				personHitCount --;
			} 
		}
		
		
		
		/* ----------    EXTERNAL METHODS    -------------- */
		
		
		public function run(isLeft:Boolean):void
		{
			if (!body.IsAwake()) {
				body.SetAwake(true);
			}
			if (!isInMidair && !isRunning) {
				isRunning = true;
			}
			if (isFacingLeft != isLeft) {
				switchDirection(isLeft);				
			}
			
			body.SetLinearVelocity(new b2Vec2(7 * (isLeft? -1:1), body.GetLinearVelocity().y));
			
			
		}
		
		public function stand():void
		{
			isRunning = false;
			if (!isInMidair) {
				body.SetLinearVelocity(new b2Vec2(body.GetLinearVelocity().x * .8, body.GetLinearVelocity().y));
			}
		}
		
		public function jump():void
		{
			if (!isJumping){
				isJumping = true;
				body.SetLinearVelocity(new b2Vec2(body.GetLinearVelocity().x, -8));
				setMidair();
			}
		}
		
		public function kill():void
		{
			if (!isHero){
				isAlive = false;
			}
			//Universe.world.DestroyJoint(torsoJoint);
		}
		
		public function punch():void
		{
			shoot()
			isPunching = true;
		}
		
		public function shoot():void
		{
			if (isAlive){
				var position:b2Vec2 = body.GetPosition().Copy();
				//var angle:Number = torso._body.GetAngle();
				//position.Add(new b2Vec2(Math.sin(angle) * .7, -Math.cos(angle) * .7));
				position.Add(new b2Vec2(-Math.sin(gun.angle) * .7, Math.cos(gun.angle) * .7));
				gun.shoot(position);
			}
		}
		
		public function setAimAngle(angle:Number):void
		{
			gun.angle = angle;
		}
		
		public function hitByBullet(actor:Actor):void
		{
			hp -= 10;
			hpBar.graphics.clear();
			hpBar.graphics.beginFill(0, 1);
			hpBar.graphics.drawRect( -.5 * Universe.RATIO, -1 * Universe.RATIO, Universe.RATIO * Math.max(0, hp / 100), .2 * Universe.RATIO);
			trace('im hit!');
			if (hp < 0) {
				trace('im dead!');
				kill();
			}
		}
		
	}

}