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
	public class Limb extends Actor
	{
		public static const TYPE_TORSO:int = 1;
		public static const TYPE_HEAD:int = 2;
		public static const TYPE_LEG:int = 3;
		public static const TYPE_ARM:int = 4;
		
		private static const RATIO:Number = Universe.RATIO;
		private static const CURVE:Number = (Math.abs(Math.cos(Math.PI / 4)) * 2) - .5;
		
		private static const HEAD_DIAMETER:Number = .125;
		private static const HEAD_Y:Number = -1 + HEAD_DIAMETER;
		
		private static const ARMS_WIDTH:Array = [.07, .07];
		private static const ARMS_TOP:Array = [ ARMS_WIDTH[0], ARMS_WIDTH[1]];
		private static const ARMS_BOTTOM:Array = [ .45, .35];
		private static const ARMS_Y:Array = [ -.7 + ARMS_WIDTH[0], -.25];
		
		private static const LEGS_WIDTH:Array = [.08, .08];
		private static const LEGS_TOP:Array = [ LEGS_WIDTH[0], LEGS_WIDTH[1]];
		private static const LEGS_BOTTOM:Array = [ .5 + LEGS_WIDTH[0], .46];
		private static const LEGS_Y:Array = [ 0, .5];
		
		private static const TORSO_WIDTH:Number = .11
		private static const TORSO_HEIGHT:Number = .7;
		private static const TORSO_Y:Number = -.35 + TORSO_WIDTH / 2;
		
		private static const SKIN_COLOR:int = 0xB28B57;
		private static const SUIT_COLOR:int = 0x222222;
		private static const BACK_SUIT_COLOR:int = 0x000000;
		private static const HAIR_COLOR:int = 0x332516;
		private static const SHIRT_COLOR:int = 0xdddddd;
		private static const SUIT_HILITE_COLOR:int = 0x333333;
		
		private var parent:Person;
		private var limbType:int;
		private var isFirstLevel:Boolean;
		private var isBack:Boolean;
		private var isLeft:Boolean = false;
		private var costume:Sprite = new Sprite();
		
		
		public function Limb(bodyCenter:b2Vec2, _limbType:int, _isFirstLevel:Boolean, _parent:Person, _isBack:Boolean = false) 
		{
			// set the parent and cache variables
			parent = _parent;
			limbType = _limbType;
			isFirstLevel = _isFirstLevel;
			isBack = _isBack;
			
			// make a copy of the body center
			var bodyCenterCopy:b2Vec2 = bodyCenter.Copy();
			
			// define body
			var bodyDef:b2BodyDef = new b2BodyDef();
			bodyDef.type = b2Body.b2_dynamicBody;
			bodyDef.angularDamping = .1;
			
			// define fixture mask bits
			var maskBits:uint = CMasks.VILLAIN_BULLET | CMasks.STATIC_BUILDING | CMasks.DYNAMIC_BUILDING;
			var categoryBits:uint = CMasks.HERO;
			if (!parent.isHero) {
				maskBits = CMasks.HERO_BULLET | CMasks.STATIC_BUILDING | CMasks.DYNAMIC_BUILDING;
				categoryBits = CMasks.VILLAIN;
			}
			
			// define shapes
			var headShapeDef:b2CircleShape = new b2CircleShape(.15);
			var limbShapeDef:b2PolygonShape = new b2PolygonShape();
			
			// setup some variables for size of limb
			var top:Number = 0;
			var width:Number = 0;
			var bottom:Number = 0;
			
			// toggle the first level of the limb (thigh or bicep)
			var i:int = 0;
			if (!isFirstLevel) {
				i = 1;
			}
			
			// set the size and position of the limb based on if its an arm or not
			if (limbType == TYPE_ARM) {
				top = ARMS_TOP[i];
				width = ARMS_WIDTH[i];
				bottom = ARMS_BOTTOM[i];
				bodyCenterCopy.y += ARMS_Y[i];
			} else if (limbType == TYPE_LEG) {
				top = LEGS_TOP[i];
				width = LEGS_WIDTH[i];
				bottom = LEGS_BOTTOM[i];
				bodyCenterCopy.y += LEGS_Y[i];
			} else if (limbType == TYPE_TORSO) {
				top = TORSO_HEIGHT;
				width = TORSO_WIDTH;
				bottom = TORSO_WIDTH;
			}
			
			// set the limb position. if a head, use different positioning than the limbs.
			if (limbType == TYPE_HEAD) {
				bodyDef.position.Set(bodyCenter.x, bodyCenter.y + HEAD_Y)
			} else {
				bodyDef.position = bodyCenterCopy;
				limbShapeDef.SetAsArray([
					new b2Vec2( -width, -top),
					new b2Vec2( width, -top),
					new b2Vec2( width, bottom),
					new b2Vec2( -width, bottom)], 4);
			}
			
			// define fixture
			var fixtureDef:b2FixtureDef = new b2FixtureDef();
			fixtureDef.density = 0;
			fixtureDef.friction = .2;
			fixtureDef.restitution = .3;
			fixtureDef.filter.categoryBits = categoryBits;
			fixtureDef.filter.maskBits = maskBits;
			if (limbType == TYPE_HEAD || limbType == TYPE_TORSO) {
				fixtureDef.density = .5;
			}
			// set the shape to either the head or the limb
			if (limbType == TYPE_HEAD) {
				fixtureDef.shape = headShapeDef;
			} else {
				fixtureDef.shape = limbShapeDef;
			}
			fixtureDef.filter.groupIndex = -Person.groupIndex;
			
			// create body
			var body:b2Body = Universe.world.CreateBody(bodyDef);
			
			// attach fixture to body
			body.CreateFixture(fixtureDef);
			
			// create costume
			if (limbType == TYPE_HEAD) {
				drawHead(top, width, bottom);
			} else if (limbType == TYPE_TORSO) {
				drawTorso(top, width, bottom);
			} else if (limbType == TYPE_LEG) {
				if (isFirstLevel){
					drawLeg1(top, width, bottom);
				} else {
					drawLeg2(top, width, bottom);
				}
			} else if (limbType == TYPE_ARM) {
				if (isFirstLevel){
					drawArm1(top, width, bottom);
				} else {
					drawArm2(top, width, bottom);
				}
			}
			Universe.scene.realDraw.addChild(costume);
			
			// call actor class
			super(body, costume);
		}
		
		private function drawLeg1(top:Number, width:Number, bottom:Number):void
		{
			if (isBack) {
				costume.graphics.beginGradientFill(GradientType.RADIAL, [BACK_SUIT_COLOR, SUIT_COLOR], [1, 1], [0, bottom * RATIO * 2]);
			} else {
				costume.graphics.beginFill(SUIT_COLOR, 1);
			}
			costume.graphics.moveTo( -TORSO_WIDTH * RATIO, 0);
			costume.graphics.lineTo( TORSO_WIDTH * RATIO, 0);
			//costume.graphics.curveTo( -TORSO_WIDTH * RATIO * CURVE, -TORSO_WIDTH * RATIO * CURVE, 0, -TORSO_WIDTH * RATIO);
			//costume.graphics.curveTo( TORSO_WIDTH * RATIO * CURVE, -TORSO_WIDTH * RATIO * CURVE, TORSO_WIDTH * RATIO, 0);
			costume.graphics.lineTo( width * RATIO, (bottom - width) * RATIO );
			costume.graphics.lineTo( -width * RATIO, (bottom - width) * RATIO );
			costume.graphics.lineTo( -TORSO_WIDTH * RATIO, 0);
		}
		
		private function drawLeg2(top:Number, width:Number, bottom:Number):void
		{
			costume.graphics.beginFill(SUIT_COLOR, 1);
			costume.graphics.drawCircle(0, (bottom - width) * RATIO, width * RATIO);
			costume.graphics.beginFill(SUIT_COLOR, 1);
			costume.graphics.moveTo( -width * RATIO, 0);
			costume.graphics.curveTo( -width * RATIO * CURVE, -width * RATIO * CURVE, 0, -width * RATIO);
			costume.graphics.curveTo( width * RATIO * CURVE, -width * RATIO * CURVE, width * RATIO, 0);
			costume.graphics.lineTo( width * 1.2 * RATIO, (bottom - width) * RATIO );
			costume.graphics.lineTo( -width * 1.2 * RATIO, (bottom - width + .04) * RATIO );
			costume.graphics.lineTo( -width * RATIO, 0);
			// draw shoe
			var costume2:Sprite = new Sprite();
			costume.addChild(costume2);
			costume2.y = (bottom - width) * RATIO
			costume2.graphics.beginFill(BACK_SUIT_COLOR, 1);
			costume2.graphics.moveTo( -width * RATIO, 0);
			costume2.graphics.lineTo( width * RATIO, 0);
			costume2.graphics.lineTo( width * 2 * RATIO, width * .5 * RATIO);
			costume2.graphics.lineTo( width * 2 * RATIO, width * RATIO);
			costume2.graphics.lineTo( -width * RATIO, width * RATIO);
			costume2.graphics.lineTo( -width * RATIO, 0);
		}
		
		private function drawArm1(top:Number, width:Number, bottom:Number):void
		{
			if (isBack) {
				costume.graphics.beginGradientFill(GradientType.RADIAL, [BACK_SUIT_COLOR, SUIT_COLOR], [1, 1], [0, bottom * RATIO * 2]);
			} else {
				costume.graphics.beginFill(SUIT_COLOR, 1);
			}
			costume.graphics.drawRoundRect( -width * RATIO, -top * RATIO, width * RATIO * 2, (top + bottom) * RATIO, width * RATIO * 2, width * RATIO * 2);
			/*costume.graphics.lineStyle(.01 * RATIO, SUIT_HILITE_COLOR, 1);
			costume.graphics.moveTo((width - .005) * RATIO, 0);
			costume.graphics.lineTo((width - .005) * RATIO, (bottom - width) * RATIO);*/
		}
		
		private function drawArm2(top:Number, width:Number, bottom:Number):void
		{
			costume.graphics.beginFill(SKIN_COLOR, 1);
			costume.graphics.drawCircle(0, (bottom - width) * RATIO, width * RATIO);
			costume.graphics.beginFill(SUIT_COLOR, 1);
			costume.graphics.moveTo( -width * RATIO, 0);
			costume.graphics.curveTo( -width * RATIO * CURVE, -width * RATIO * CURVE, 0, -width * RATIO);
			costume.graphics.curveTo( width * RATIO * CURVE, -width * RATIO * CURVE, width * RATIO, 0);
			costume.graphics.lineTo( width * 1.2 * RATIO, (bottom - width - .08) * RATIO );
			costume.graphics.lineTo( -width * 1.2 * RATIO, (bottom - width - .08) * RATIO );
			costume.graphics.lineTo( -width * RATIO, 0);
			costume.graphics.beginFill(SHIRT_COLOR, 1);
			costume.graphics.moveTo( -width * RATIO, (bottom - width - .08) * RATIO );
			costume.graphics.lineTo( width * RATIO, (bottom - width - .08) * RATIO );
			costume.graphics.lineTo( width * RATIO, (bottom - width - .03) * RATIO );
			costume.graphics.lineTo( -width * RATIO, (bottom - width - .03) * RATIO );
			costume.graphics.lineTo( -width * RATIO, (bottom - width - .08) * RATIO );
			/*costume.graphics.lineStyle(.01 * RATIO, SUIT_HILITE_COLOR, 1);
			costume.graphics.moveTo((width - .005) * RATIO, 0);
			costume.graphics.lineTo((width - .005) * RATIO, (bottom - width - .08) * RATIO);*/
			//costume.graphics.beginFill(SUIT_COLOR, 1);
			//costume.graphics.drawRoundRect( -width * RATIO, -top * RATIO, width * RATIO * 2, (top + bottom) * RATIO, width * RATIO * 2, width * RATIO * 2);
		}
		
		private function drawHead(top:Number, width:Number, bottom:Number):void
		{
			costume.graphics.beginFill(SKIN_COLOR, 1);
			costume.graphics.moveTo( .125 * RATIO, -.05 * RATIO );
			costume.graphics.lineTo( .125 * RATIO, .125 * RATIO );
			costume.graphics.lineTo( -.05 * RATIO, .125 * RATIO );
			costume.graphics.lineTo( -.05 * RATIO, -.05 * RATIO );
			costume.graphics.beginFill(HAIR_COLOR, 1);
			costume.graphics.moveTo( 0, -.025 * RATIO );
			costume.graphics.lineTo( 0, .05 * RATIO );
			costume.graphics.lineTo( -.05 * RATIO, .05 * RATIO );
			costume.graphics.lineTo( -.05 * RATIO, .125 * RATIO );
			costume.graphics.lineTo( -.1 * RATIO, .1 * RATIO );
			costume.graphics.lineTo( -.125 * RATIO, .075 * RATIO );
			costume.graphics.lineTo( -.15 * RATIO, 0 );
			costume.graphics.curveTo( -.15 * RATIO * CURVE, -.15 * RATIO * CURVE, 0, -.15 * RATIO);
			costume.graphics.curveTo( .15 * RATIO * CURVE, -.15 * RATIO * CURVE, .15 * RATIO, 0);
			costume.graphics.lineTo( 0, -.025 * RATIO );
		}
		
		private function drawTorso(top:Number, width:Number, bottom:Number):void
		{
			costume.graphics.beginGradientFill(GradientType.RADIAL, [SUIT_COLOR, BACK_SUIT_COLOR], [1, 1], [top * RATIO / 2, top * RATIO * 2]);
			costume.graphics.drawRoundRect( -width * RATIO, -top * RATIO, width * RATIO * 2, (top + bottom) * RATIO, width * RATIO * 2, width * RATIO * 2);
		}
		
		public function faceLeft(_isLeft:Boolean):void
		{
			isLeft = _isLeft;
			if (isLeft) {
				costume.scaleX = -1;
			} else {
				costume.scaleX = 1;
			}
		}
		
		public function hitByBullet(actor:Actor):void
		{
			parent.hitByBullet(actor);
		}
		
	}

}