package com.timwoodcreates.crumble.actors 
{
	import Box2D.Collision.b2AABB;
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Collision.Shapes.b2MassData;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.Joints.b2PrismaticJoint;
	import Box2D.Dynamics.Joints.b2PrismaticJointDef;
	import Box2D.Dynamics.Joints.b2RevoluteJoint;
	import Box2D.Dynamics.Joints.b2RevoluteJointDef;
	import com.timwoodcreates.crumble.animation.Animation;
	import com.timwoodcreates.crumble.animation.AnimationBuilder;
	import com.timwoodcreates.crumble.animation.AnimationMixer;
	import com.timwoodcreates.crumble.env.Universe;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Tim Wood
	 */
	public class RagDollPerson extends Actor
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
		
		private var arms:Array = [];
		private var legs:Array = [];
		private var armJoints:Array = [];
		private var legJoints:Array = [];
		private var head:Limb;
		private var headJoint:b2RevoluteJoint;
		private var torso:Limb;
		private var torsoJoint:b2PrismaticJoint;
		private var ties:Array = [];
		private var tieJoint:b2RevoluteJoint;
		
		private var leg1Mixer:AnimationMixer;
		private var leg2Mixer:AnimationMixer;
		private var arm1Mixer:AnimationMixer;
		private var arm2Mixer:AnimationMixer;
		private var legMixers:Array = [];
		private var armMixers:Array = [];
		private var allMixers:Array = [];
		
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
		
		//private var kineTargetY:Number = 0;
		
		public function RagDollPerson(position:b2Vec2, _isHero:Boolean = false) 
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
			
			// define shapes for box
			var boxShapeDef:b2PolygonShape = new b2PolygonShape();
			//boxShapeDef.SetAsBox(.2, .8);
			boxShapeDef.SetAsOrientedBox(.2, .4, new b2Vec2(0, .4), 0);
			var boxFixtureDef:b2FixtureDef = new b2FixtureDef();
			boxFixtureDef.shape = boxShapeDef;
			boxFixtureDef.filter.groupIndex = -Person.groupIndex;
			body.CreateFixture(boxFixtureDef);
			
			// define round edges of top and bottom
			for (var i:int = 0; i < 2; i++) {
				var circleShapeDef:b2CircleShape = new b2CircleShape(.2);
				circleShapeDef.SetLocalPosition(new b2Vec2(0, (i == 0? .8 : 0)));
				
				var circleFixtureDef:b2FixtureDef = new b2FixtureDef();
				circleFixtureDef.shape = circleShapeDef;
				circleFixtureDef.filter.groupIndex = -Person.groupIndex;
				body.CreateFixture(circleFixtureDef);
			}
			
			// create costume
			//Universe.scene.realDraw.addChild(costume);
			
			// call actor class
			super(body, costume);
			
			// add limbs and joints
			buildBody(position);
			
			// create all the animations
			buildAnimations();
		}
		
		
		
		/* ----------    CREATING    -------------- */
		
		
		
		private function buildAnimations():void
		{
			leg1Mixer = new AnimationMixer(1, true, true);
			leg2Mixer = new AnimationMixer(1, true, false);
			arm1Mixer = new AnimationMixer(1, false, true);
			arm2Mixer = new AnimationMixer(1, false, false);
			legMixers = [leg1Mixer, leg2Mixer];
			armMixers = [arm1Mixer, arm2Mixer];
			allMixers = [leg1Mixer, leg2Mixer, arm1Mixer, arm2Mixer];
			stand();
		}
		
		private function buildBody(position:b2Vec2):void
		{
			// make back arms and legs
			makeLimbs(0, position);
			
			// make torso
			torso = new Limb(position, Limb.TYPE_TORSO, false, this);
			Universe.actors.push(torso);
			/*
			var torsoJointDef:b2RevoluteJointDef = new b2RevoluteJointDef();
			torsoJointDef.Initialize(body, torso._body, position);
			torsoJoint = b2RevoluteJoint(Universe.world.CreateJoint(torsoJointDef));*/
			var torsoJointDef:b2PrismaticJointDef = new b2PrismaticJointDef();
			torsoJointDef.Initialize(body, torso._body, position, new b2Vec2(0, 1));
			torsoJointDef.upperTranslation = .2;
			torsoJointDef.lowerTranslation = 0;
			torsoJointDef.enableLimit = true;
			torsoJoint = b2PrismaticJoint(Universe.world.CreateJoint(torsoJointDef));
			
			// make head
			head = new Limb(position, Limb.TYPE_HEAD, false, this);
			Universe.actors.push(head);
			var headJointDef:b2RevoluteJointDef = new b2RevoluteJointDef();
			headJointDef.Initialize(torso._body, head._body, new b2Vec2(position.x, position.y + HEAD_JOINT));
			headJointDef.lowerAngle = 0;
			headJointDef.upperAngle = 0;
			headJointDef.enableLimit = true;
			headJoint = b2RevoluteJoint(Universe.world.CreateJoint(headJointDef));
			
			// make front arms and legs
			makeLimbs(1, position);
			
			// create all the arm and leg joints
			for (var i:int = 0; i < 2; i++) {
				// Shoulder joints
				armJoints[i][0] = pinTogether(arms[i][0], torso, new b2Vec2(position.x, position.y + ARM_JOINTS[0]), 1, -1);
				// Elbow joints
				armJoints[i][1] = pinTogether(arms[i][1], arms[i][0], new b2Vec2(position.x, position.y + ARM_JOINTS[1]), .9, 0);
				// Hip joints
				legJoints[i][0] = pinTogether(legs[i][0], torso, new b2Vec2(position.x, position.y + LEG_JOINTS[0]), .9, -.5);
				// Knee joints
				legJoints[i][1] = pinTogether(legs[i][1], legs[i][0], new b2Vec2(position.x, position.y + LEG_JOINTS[1]), 0, -.9);
			}
			
			// make tie if a hero
			if (isHero) {
				makeTie(position);
			}
			
		}
		
		private function makeLimbs(i:int, position:b2Vec2):void
		{
			arms[i] = [];
			legs[i] = [];
			armJoints[i] = [];
			legJoints[i] = [];
			for (var j:int = 0; j < 2; j++) {
				var isFirstLevel:Boolean = (j == 0);
				arms[i][j] = new Limb(position, Limb.TYPE_ARM, isFirstLevel, this, (i==0));
				legs[i][j] = new Limb(position, Limb.TYPE_LEG, isFirstLevel, this, (i==0));
				Universe.actors.push(arms[i][j]);
				Universe.actors.push(legs[i][j]);
			}
		}
		
		private function makeTie(position:b2Vec2):void
		{
			for (var i:int = 0; i < 4; i++) {
				ties[i] = new Tie(position, i);
				Universe.actors.push(ties[i]);
				var jointDef:b2RevoluteJointDef = new b2RevoluteJointDef();
				if (i == 0) {
					jointDef.Initialize(Tie(ties[i])._body, torso._body, new b2Vec2(position.x + .1, position.y - TIE_Y));
					tieJoint = b2RevoluteJoint(Universe.world.CreateJoint(jointDef));
				} else {
					jointDef.Initialize(Tie(ties[i])._body, Tie(ties[i - 1])._body, new b2Vec2(position.x + .1, position.y - TIE_Y + ((i - 1) * .14)));
					jointDef.lowerAngle = -Math.PI * .2;
					jointDef.upperAngle = Math.PI * .2;
					jointDef.enableLimit = true;
					Universe.world.CreateJoint(jointDef);
				}
				
			}
		}
		
		
		
		/* ----------    UPDATING    -------------- */
		
		
		
		override protected function childSpecificUpdating(ms:int):void {
			stand();
			animateBody(ms);
		}
		
		private function pinTogether(actorA:Actor, actorB:Actor, pinPoint:b2Vec2, upperAngle:Number = 1, lowerAngle:Number = 1):b2RevoluteJoint
		{
			var jointDef:b2RevoluteJointDef = new b2RevoluteJointDef();
			jointDef.Initialize(actorA._body, actorB._body, pinPoint);
			jointDef.upperAngle = PI * upperAngle;
			jointDef.lowerAngle = PI * lowerAngle;
			jointDef.enableLimit = true;
			var joint:b2RevoluteJoint = b2RevoluteJoint(Universe.world.CreateJoint(jointDef));
			return joint;
		}
		
		/*
		 * function to animate the body based on the animations currently in use.
		 * should be called by children on each childSpecificUpdating
		 */
		public function animateBody(ms:int):void
		{
			// only animate the hero if he is alive
			if (isAlive) {
				var targetAngle:Number = 0;
				// set a slight forward angle while running
				if (isRunning) {
					targetAngle = .2;
				}
				// reverse it if you're facing left
				if (isFacingLeft) {
					targetAngle = -targetAngle;
				}
				//fakeLegs._body.SetAngle(0);
				/*torso._body.SetAngularVelocity( (targetAngle -torso._body.GetAngle()) * 1000 / ms);*/
				body.SetAngularVelocity( -body.GetAngle() * 1000 / ms);
				
				// match linear velocity
				torso._body.SetLinearVelocity(body.GetLinearVelocity());
				head._body.SetLinearVelocity(body.GetLinearVelocity());
				if (isHero){
					Tie(ties[0])._body.SetLinearVelocity(body.GetLinearVelocity());
				}
				
				var maxPosition:Number = .7;
				
				for (var i:int = 0; i < 2; i++) {
					var armAnim:AnimationMixer = armMixers[i];
					var legAnim:AnimationMixer = legMixers[i];
					
					armAnim.step(ms);
					legAnim.step(ms);
					
					var multiplier:int = 250;
					if (ms > 10) {
						multiplier = 40;
					}
					
					maxPosition = Math.max( legAnim.pointBY, maxPosition);
					// position legs
					rotateLimb(Actor(legs[i][0])._body, legAnim.angleA, multiplier);
					rotateLimb(Actor(legs[i][1])._body, legAnim.angleB, multiplier);
					
					// position arms
					rotateLimb(Actor(arms[i][0])._body, armAnim.angleB, multiplier);
					rotateLimb(Actor(arms[i][1])._body, armAnim.angleA, multiplier);
					
				}
				
				if (maxPosition > .7) {
					var targetDistance:Number = 1 - maxPosition;
					var currentDistance:Number = torso._body.GetPosition().y - body.GetPosition().y;
					torso._body.SetLinearVelocity(new b2Vec2(torso._body.GetLinearVelocity().x, (targetDistance - currentDistance) * 1000 / ms));
				}
			
			} else {
				timeToDie += ms;
				if (timeToDie > 1000) {
					fadeOutItems(ms);
				}
			}
			
			// set the person as not in midair if they start to fall
			if (!isInMidair && ((body.GetLinearVelocity().y > .2 && personHitCount == 0) || personHitCount < 1)){
				setMidair();
			}
			
		}
		
		private function fadeOutItems(ms:int):void
		{
			var j:int;
			var i:int;
			fadeOutDie -= ms / 500;
			for (j = 0; j < 2; j++) {
				for (i = 0; i < 2; i++) {
					Limb(arms[i][j])._costume.alpha = fadeOutDie;
					Limb(legs[i][j])._costume.alpha = fadeOutDie;
				}
			}
			head._costume.alpha = fadeOutDie;
			torso._costume.alpha = fadeOutDie;
			if (fadeOutDie < 0) {
				for (j = 0; j < 2; j++) {
					for (i = 0; i < 2; i++) {
						Limb(arms[j][i]).flagForRemoval();
						Limb(legs[j][i]).flagForRemoval();
					}
				}
				head.flagForRemoval();
				torso.flagForRemoval();
				this.flagForRemoval();
			}
		}
		
		private function rotateLimb(limbBody:b2Body, targetAngle:Number, multiplier:int):void
		{
			limbBody.SetAngularVelocity( (targetAngle - limbBody.GetAngle()) * multiplier);
			limbBody.SetLinearVelocity(body.GetLinearVelocity().Copy());
		}
		
		private function switchDirection(faceLeft:Boolean):void
		{
			isFacingLeft = faceLeft;
			for (var j:int = 0; j < 2; j++) {
				AnimationMixer(armMixers[j]).switchDirection(faceLeft);
				AnimationMixer(legMixers[j]).switchDirection(faceLeft);
				for (var i:int = 0; i < 2; i++) {
					var legJoint:b2RevoluteJoint = legJoints[i][j];
					var armJoint:b2RevoluteJoint = armJoints[i][j];
					legJoint.SetLimits( -legJoint.GetUpperLimit(), -legJoint.GetLowerLimit());
					armJoint.SetLimits( -armJoint.GetUpperLimit(), -armJoint.GetLowerLimit());
					Limb(arms[i][j]).faceLeft(faceLeft);
					Limb(legs[i][j]).faceLeft(faceLeft);
				}
			}
			head.faceLeft(faceLeft);
			torso.faceLeft(faceLeft);
			
		}
		
		private function setMidair():void
		{
			isInMidair = true;
			isRunning = false;
			for (var i:int = 0; i < 4; i++) {
				AnimationMixer(allMixers[i]).jump();
			}
		}
		
		// function for the person to count the number of hits
		public function addFootHit(add:Boolean, isPerson:Boolean = false):void
		{
			if (isPerson) {
				if (add) {
					isInMidair = false;
					personHitCount ++;
				} else {
					personHitCount --;
				}
			} else {
				if (add) {
					footHitCount ++;
					lastFootHit = Universe.timeElapsed;
					isInMidair = false;
					isJumping = false;
				} else {
					footHitCount --;
				}
			}
		}
		
		
		
		/* ----------    EXTERNAL METHODS    -------------- */
		
		
		
		public function run(isLeft:Boolean):void
		{
			if (!isInMidair && !isRunning) {
				isRunning = true;
				for (var i:int = 0; i < 4; i++) {
					AnimationMixer(allMixers[i]).run();
				}
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
				for (var i:int = 0; i < 4; i++) {
					AnimationMixer(allMixers[i]).stand();
				}
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
			if (!(this is Hero)){
				isAlive = false;
				/*for (var i:int = 0; i < 2; i++) {
					Universe.world.DestroyJoint(armJoints[i][0]);
					Universe.world.DestroyJoint(legJoints[i][0]);
				}*/
				Universe.world.DestroyJoint(torsoJoint);
				Universe.world.DestroyJoint(headJoint);
			}
		}
		
		public function punch():void
		{
			isPunching = true;
		}
		
	}

}