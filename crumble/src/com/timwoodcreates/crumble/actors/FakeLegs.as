package com.timwoodcreates.crumble.actors 
{
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	import com.timwoodcreates.crumble.env.Universe;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Tim Wood
	 */
	public class FakeLegs extends Actor
	{
		private static const TORSO_WIDTH:Number = .1
		private static const TORSO_HEIGHT:Number = .7;
		private static const TORSO_Y:Number = -.35 + TORSO_WIDTH / 2;
		
		public function FakeLegs(position:b2Vec2) 
		{
			// define body
			var bodyDef:b2BodyDef = new b2BodyDef();
			bodyDef.position.Set(position.x, position.y);
			bodyDef.type = b2Body.b2_dynamicBody;
			//bodyDef.type = b2Body.b2_kinematicBody;
			
			// define shape
			var shapeDef:b2PolygonShape = new b2PolygonShape();
			shapeDef.SetAsArray([
				new b2Vec2( -TORSO_WIDTH, -TORSO_HEIGHT),
				new b2Vec2( TORSO_WIDTH, -TORSO_HEIGHT),
				new b2Vec2( TORSO_WIDTH, TORSO_WIDTH),
				new b2Vec2( -TORSO_WIDTH, TORSO_WIDTH)], 4);
			
			// define fixture
			var fixtureDef:b2FixtureDef = new b2FixtureDef();
			fixtureDef.density = 1;
			fixtureDef.shape = shapeDef;
			fixtureDef.filter.groupIndex = -groupIndex;
			
			// create body
			body = Universe.world.CreateBody(bodyDef);
			
			// attach fixture to body
			body.CreateFixture(fixtureDef);
			
			// create costume
			var costume:Sprite = new Sprite();
			
			// call actor class
			super(body, costume);
		}
		
	}

}