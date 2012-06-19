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
	public class Floor extends Actor
	{
		public var _movable:Boolean = false;
		private var body:b2Body;
		
		public function Floor(size:b2Vec2, position:b2Vec2, movable:Boolean = false) 
		{
			// cache variables
			_movable = movable
			
			// define body
			var bodyDef:b2BodyDef = new b2BodyDef();
			bodyDef.position.Set(position.x, position.y);
			// set as static - body will not move, but other bodies can bounce off it
			bodyDef.type = b2Body.b2_staticBody;
			if (movable) {
				bodyDef.type = b2Body.b2_dynamicBody;
			}
			
			// define shape
			// set shape as polygon - only other option is circle
			var shapeDef:b2PolygonShape = new b2PolygonShape();
			// shortcut to make a box
			shapeDef.SetAsBox(size.x, size.y);
			
			// define fixture
			// i'm not exactly sure what fixturedefs are for, i'll have to read up on them more
			var fixtureDef:b2FixtureDef = new b2FixtureDef();
			// set density to 1 kilogram/cubic meter - i'm not exactly sure about this ratio, I'll have to check into it more.
			fixtureDef.density = 1.0;
			// set friction to 1 - should be a value between 0 and 1
			fixtureDef.friction = .2;
			// set the rectangle shape we defined above to the fixturedef shape
			fixtureDef.shape = shapeDef;
			fixtureDef.filter.categoryBits = CMasks.STATIC_BUILDING;
			if (movable) {
				fixtureDef.filter.categoryBits = CMasks.DYNAMIC_BUILDING;
			}
			// create body
			// add the body to the world
			body = Universe.world.CreateBody(bodyDef);
			
			// attach fixture to body
			// add the fixture to the body
			body.CreateFixture(fixtureDef);
			
			// create costume
			// TODO: create the costume for the wall
			var costume:Sprite = Universe.architect.buildFloor(size);
			Universe.scene.realDraw.addChild(costume);
			
			// call actor class
			super(body, costume);
		}
		
		public function checkUnderFloor(actor:Actor):Boolean
		{
			if (actor is Floor || !_movable || actor is BreakableWall || actor is FixedWall || actor is MovableWall) {
				return false;
			}
			var myAngle:Number = body.GetAngle();
			var myPos:b2Vec2 = actor._body.GetPosition().Copy();
			myPos.Subtract(body.GetPosition());
			trace(myPos.x + ' : ' + myPos.y);
			var angleToHero:Number = Math.atan2(myPos.x, -myPos.y);
			trace(myAngle * 180 / Math.PI + ' - ' + angleToHero * 180 / Math.PI);
			trace(Math.abs(angleToHero - myAngle) * 180 / Math.PI + ' should be ' + (Math.abs(angleToHero - myAngle) > Math.PI / 2?'true':'false'));
			if (Math.abs(angleToHero - myAngle) > Math.PI / 2) {
				return true;
			}
			return false;
		}
		
	}

}