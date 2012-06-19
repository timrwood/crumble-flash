package  com.timwoodcreates.crumble.actors
{
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.Joints.b2PrismaticJointDef;
	import Box2D.Dynamics.Joints.b2RevoluteJointDef;
	import com.timwoodcreates.crumble.env.Universe;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Tim Wood
	 */
	public class Door extends Actor
	{
		private static const DOOR_HEIGHT:Number = 2;
		private static const DOOR_WIDTH:Number = .2;
		
		private var body:b2Body;
		
		public function Door(size:b2Vec2, position:b2Vec2, locked:Boolean = false) 
		{
			// define body
			var bodyDef:b2BodyDef = new b2BodyDef();
			bodyDef.position.Set(position.x, position.y + (size.y - DOOR_HEIGHT) - .1);
			bodyDef.type = b2Body.b2_dynamicBody;
			
			// define shape
			var shapeDef:b2PolygonShape = new b2PolygonShape();
			shapeDef.SetAsBox(DOOR_WIDTH, DOOR_HEIGHT - .1);
			
			// define fixture
			var fixtureDef:b2FixtureDef = new b2FixtureDef();
			fixtureDef.density = 2;
			fixtureDef.friction = .2;
			fixtureDef.restitution = 0;
			fixtureDef.shape = shapeDef;
			
			// create body
			body = Universe.world.CreateBody(bodyDef);
			
			// attach fixture to body
			body.CreateFixture(fixtureDef);
			
			// create costume
			var costume:Sprite = new Sprite();
			
			// call actor class
			super(body, costume);
			
			buildFrame(size, position);
			
		}
		
		private function buildFrame(size:b2Vec2, position:b2Vec2):void
		{
			var newSize:b2Vec2 = new b2Vec2(size.x, size.y - DOOR_HEIGHT);
			var newPosition:b2Vec2 = new b2Vec2(position.x, position.y - DOOR_HEIGHT);
			
			var frame:FixedWall = new FixedWall(newSize, newPosition);
			Universe.actors.push(frame);
			/*
			 * define a joint to connect the frame to the door.
			 * the joint revolves around a point
			 */
			var jointDef:b2RevoluteJointDef = new b2RevoluteJointDef();
			jointDef.Initialize(body, frame._body, new b2Vec2(position.x, position.y + (size.y - DOOR_HEIGHT * 2)));
			jointDef.upperAngle = Math.PI * .7;
			jointDef.lowerAngle = - Math.PI * .7;
			jointDef.enableLimit = true;
			// add the joint to the world
			Universe.world.CreateJoint(jointDef);		
		}
	}

}