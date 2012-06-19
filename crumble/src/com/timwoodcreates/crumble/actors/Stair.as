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
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Tim Wood
	 */
	public class Stair extends Actor
	{
		private var fixtureDef:b2FixtureDef;
		private var baseLeft:Boolean = false;
		private var body:b2Body;
		
		public function Stair(height:Number, position:b2Vec2, baseLeftInit:Boolean = false ) 
		{
			// define body
			var bodyDef:b2BodyDef = new b2BodyDef();
			bodyDef.position.Set(position.x, position.y);
			bodyDef.type = b2Body.b2_staticBody;
			
			// set direction of the stair
			baseLeft = baseLeftInit;
			
			// define shape
			var shapeDef:b2PolygonShape = new b2PolygonShape();
			var vertices:Array = [
				new b2Vec2(height, height),
				new b2Vec2(-height, height),
				new b2Vec2(height, -height)
			];
			if (!baseLeft) {
				vertices = [
				new b2Vec2(height, height),
				new b2Vec2(-height, height),
				new b2Vec2(-height, -height)
			];
			}
			shapeDef.SetAsArray(vertices, 3);
			
			// define fixture
			fixtureDef = new b2FixtureDef();
			fixtureDef.density = 1;
			fixtureDef.friction = .3;
			fixtureDef.shape = shapeDef;
			
			// create body
			body = Universe.world.CreateBody(bodyDef);
			
			// attach fixture to body
			body.CreateFixture(fixtureDef);
			
			// create costume
			var costume:Sprite = new Sprite();
			
			// call actor class and set the type to stair
			super(body, costume);
		}
		
		public function checkHeroIgnoreStair( hero:Hero ):Boolean
		{
			var ignoreCollision:Boolean = true;
			
			// htos = hero to stair position
			var htos:b2Vec2 = hero._body.GetWorldCenter().Copy();
			// we subtract the stair position from the hero position
			htos.Subtract(body.GetWorldCenter());
			if ( baseLeft ) {
				// top left
				if (htos.x < 0 && htos.y < 0) {
					ignoreCollision = false;
				}
				// bottom left
				if (htos.x < 0 && htos.y > 0) {
					if (-htos.x > htos.y){
						ignoreCollision = false;
					}
				}
				// top right
				if (htos.x > 0 && htos.y < 0) {
					if (htos.x < -htos.y){
						ignoreCollision = false;
					}
				}
			} else {
				// top right
				if (htos.x > 0 && htos.y < 0) {
					ignoreCollision = false;
				}
				// top left
				if (htos.x < 0 && htos.y < 0) {
					if (-htos.x < -htos.y){
						ignoreCollision = false;
					}
				}
				// bottom right
				if (htos.x > 0 && htos.y > 0) {
					if (htos.x > htos.y){
						ignoreCollision = false;
					}
				}
			}
			
			if (ignoreCollision /*|| hero.ignoreStairs*/) {
				return true;
			} else {
				return false;
			}
			
		}
	}

}