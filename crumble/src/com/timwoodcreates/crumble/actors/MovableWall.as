package  com.timwoodcreates.crumble.actors
{
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2FixtureDef;
	import com.timwoodcreates.crumble.env.Universe;
	import com.timwoodcreates.crumble.utils.CMasks;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Tim Wood
	 */
	public class MovableWall extends Actor
	{
		
		public function MovableWall(size:b2Vec2, position:b2Vec2) 
		{
			// define body
			var bodyDef:b2BodyDef = new b2BodyDef();
			bodyDef.position.Set(position.x, position.y);
			bodyDef.type = b2Body.b2_dynamicBody;
			
			// define shape
			var shapeDef:b2PolygonShape = new b2PolygonShape();
			shapeDef.SetAsBox(size.x, size.y);
			
			// define fixture
			var fixtureDef:b2FixtureDef = new b2FixtureDef();
			fixtureDef.density = 1;
			fixtureDef.friction = .4;
			fixtureDef.restitution = 0;
			fixtureDef.filter.categoryBits = CMasks.DYNAMIC_BUILDING;
			fixtureDef.shape = shapeDef;
			
			// create body
			var body:b2Body = Universe.world.CreateBody(bodyDef);
			
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