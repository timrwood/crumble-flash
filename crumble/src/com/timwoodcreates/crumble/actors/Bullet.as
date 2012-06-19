package  com.timwoodcreates.crumble.actors
{
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	import com.timwoodcreates.crumble.env.Universe;
	import com.timwoodcreates.crumble.utils.CMasks;
	import flash.display.GradientType;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Tim Wood
	 */
	public class Bullet extends Actor
	{
		private static const MAX_TIME_ALIVE:int = 5000;
		
		private var timeAlive:int = 0;
		private var angle:Number = 0;
		private var speed:Number = 0;
		private var isHero:Boolean = false;
		private var body:b2Body;
		
		public function Bullet(position:b2Vec2, _angle:Number, _speed:Number, _isHero:Boolean = false) 
		{
			angle = _angle;
			speed = _speed;
			isHero = _isHero;
			
			// define body
			var bodyDef:b2BodyDef = new b2BodyDef();
			bodyDef.position = position;
			bodyDef.type = b2Body.b2_dynamicBody;
			bodyDef.angle = angle;
			bodyDef.bullet = true;
			
			// define fixture mask bits
			var maskBits:uint = CMasks.HERO | CMasks.STATIC_BUILDING | CMasks.DYNAMIC_BUILDING;
			var categoryBits:uint = CMasks.VILLAIN_BULLET;
			if (isHero) {
				maskBits = CMasks.VILLAIN | CMasks.STATIC_BUILDING | CMasks.DYNAMIC_BUILDING;
				categoryBits = CMasks.HERO_BULLET;
			}
			
			// define shapes
			var shapeDef:b2PolygonShape = new b2PolygonShape();
			shapeDef.SetAsBox(.05, .1);
			
			// define fixture
			var fixtureDef:b2FixtureDef = new b2FixtureDef();
			fixtureDef.filter.categoryBits = categoryBits;
			fixtureDef.filter.maskBits = maskBits;
			fixtureDef.shape = shapeDef;
			
			// create body
			body = Universe.world.CreateBody(bodyDef);
			
			// attach fixture to body
			body.CreateFixture(fixtureDef);
			
			var costume:Sprite = new Sprite();
			costume.graphics.beginFill(0, 1);
			costume.graphics.drawRect( -.05 * Universe.RATIO, -.1 * Universe.RATIO, .1 * Universe.RATIO, .2 * Universe.RATIO);
			Universe.scene.realDraw.addChild(costume);
			
			// call actor class
			super(body, costume);
		}
		
		override protected function childSpecificUpdating(ms:int):void
		{
			// set bullet speed
			body.SetLinearVelocity(new b2Vec2(-Math.sin(angle) * speed, Math.cos(angle) * speed));
			timeAlive += ms;
			if (timeAlive > MAX_TIME_ALIVE) {
				this.flagForRemoval();
			}
		}
		
		public function hitSomething():void
		{
			trace('ouch charlie');
			this.flagForRemoval();
		}
		
	}

}