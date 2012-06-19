package  com.timwoodcreates.crumble.actors
{
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.Joints.b2RevoluteJointDef;
	import com.timwoodcreates.crumble.env.Universe;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Tim Wood
	 */
	public class Tie extends Actor
	{
		private static const TIE_LENGTH:Number = .07;
		private static const TIE_Y:Number = .65;
		
		public function Tie(position:b2Vec2, i:int) 
		{
			
			// define body
			var bodyDef:b2BodyDef = new b2BodyDef();
			bodyDef.type = b2Body.b2_dynamicBody;
			bodyDef.angularDamping = .9;
			var shapeDef:b2PolygonShape = new b2PolygonShape();
			if (i == 0) {
				shapeDef.SetAsBox(.04, .04);
				bodyDef.position.Set(position.x + .1, position.y - TIE_Y);
			} else {
				shapeDef.SetAsBox(.03, TIE_LENGTH);
				bodyDef.position.Set(position.x + .1, position.y - TIE_Y - .07 + (i * .14));
			}
			
			// define fixture
			var fixtureDef:b2FixtureDef = new b2FixtureDef();
			fixtureDef.density = .3;
			if (i == 0) {
				fixtureDef.density = 1;
			}
			fixtureDef.shape = shapeDef;
			fixtureDef.filter.groupIndex = -Person.groupIndex;
			fixtureDef.isSensor = true;
			
			// create body
			var body:b2Body = Universe.world.CreateBody(bodyDef);
			
			// attach fixture to body
			body.CreateFixture(fixtureDef);
			
			// create costume
			var costume:Sprite = new Sprite();
			if (i != 0) {
				costume.graphics.lineStyle(.06 * Universe.RATIO, 0xff0000);
				costume.graphics.moveTo(0, - TIE_LENGTH * Universe.RATIO);
				costume.graphics.lineTo(0, TIE_LENGTH * Universe.RATIO);
			} else {
				costume.graphics.beginFill(0xff0000);
				costume.graphics.drawCircle(0, 0, .04 * Universe.RATIO);
			}
			
			Universe.scene.realDraw.addChild(costume);
			
			// call actor class
			super(body, costume);
		}
	}

}