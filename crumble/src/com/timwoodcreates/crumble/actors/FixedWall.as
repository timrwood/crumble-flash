package com.timwoodcreates.crumble.actors 
{
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.Joints.b2PrismaticJointDef;
	import Box2D.Dynamics.Joints.b2RevoluteJoint;
	import Box2D.Dynamics.Joints.b2RevoluteJointDef;
	import com.timwoodcreates.crumble.env.Universe;
	import com.timwoodcreates.crumble.utils.CMasks;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Tim Wood
	 */
	public class FixedWall extends Actor
	{
		private var body:b2Body;
		private var stuckToMe:Boolean = false;
		private var addedJointDef:Boolean = false;
		private var stickPosition:b2Vec2;
		private var jointDef:b2RevoluteJointDef;
		
		public function FixedWall(size:b2Vec2, position:b2Vec2) 
		{
			// define body
			var bodyDef:b2BodyDef = new b2BodyDef();
			bodyDef.position.Set(position.x, position.y);
			bodyDef.type = b2Body.b2_staticBody;
			
			// define shape
			var shapeDef:b2PolygonShape = new b2PolygonShape();
			shapeDef.SetAsBox(size.x, size.y);
			
			// define fixture
			var fixtureDef:b2FixtureDef = new b2FixtureDef();
			fixtureDef.friction = 0.3;
			fixtureDef.filter.categoryBits = CMasks.STATIC_BUILDING;
			fixtureDef.shape = shapeDef;
			
			// create body
			body = Universe.world.CreateBody(bodyDef);
			
			// attach fixture to body
			body.CreateFixture(fixtureDef);
			
			// create costume
			var costume:Sprite = Universe.architect.buildWall(size);
			Universe.scene.realDraw.addChild(costume);
			
			// call actor class
			super(body, costume);
		}
		
	}

}