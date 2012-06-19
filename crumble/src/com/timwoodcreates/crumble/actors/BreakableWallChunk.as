package com.timwoodcreates.crumble.actors 
{
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FilterData;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2FixtureDef;
	import com.timwoodcreates.crumble.env.Universe;
	import com.timwoodcreates.crumble.utils.CMasks;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Tim Wood
	 */
	public class BreakableWallChunk extends Actor
	{
		private static const MAX_HITS:int = 20;
		
		private var hitCount:int = 0;
		private var canChange:int = 0;
		private var body:b2Body;
		private var costume:Sprite;
		private var fadeout:Boolean = false;
		private var fadeoutCount:int = 10;
		private var fixture:b2Fixture;
		private var fixtureDef:b2FixtureDef;
		
		public function BreakableWallChunk(points:Array, position:b2Vec2) 
		{
			// define body
			var bodyDef:b2BodyDef = new b2BodyDef();
			bodyDef.position.Set(position.x, position.y);
			bodyDef.type = b2Body.b2_dynamicBody;
			
			// define shape
			var shapeDef:b2PolygonShape = new b2PolygonShape();
			points.sort(sortPoints);
			shapeDef.SetAsArray(points, 4);
			
			// define fixture
			fixtureDef = new b2FixtureDef();
			fixtureDef.restitution = .2;
			fixtureDef.density = 1;
			fixtureDef.shape = shapeDef;
			fixtureDef.filter.maskBits = CMasks.STATIC_BUILDING | CMasks.DYNAMIC_BUILDING | CMasks.BROKEN_BUILDING | CMasks.HERO;
			fixtureDef.filter.categoryBits = CMasks.BROKEN_BUILDING;
			
			// create body
			body = Universe.world.CreateBody(bodyDef);
			
			// attach fixture to body
			fixture = body.CreateFixture(fixtureDef);
			
			// create costume
			costume = Universe.architect.buildWallChunk(points);
			Universe.scene.realDraw.addChild(costume);
			
			// call actor class
			super(body, costume);
		}
		
		private function sortPoints(a:b2Vec2, b:b2Vec2):int
		{
			var aatan:Number = Math.atan2(a.y, a.x);
			var batan:Number = Math.atan2(b.y, b.x);
			if (aatan < batan) {
				return -1;
			} else if (aatan > batan) {
				return 1;
			} else {
				return 0;
			}
		}
		
		public function addHit():void
		{
			hitCount++
			if (hitCount > MAX_HITS) {
				fadeout = true;
			}
		}
		
		override protected function childSpecificUpdating(ms:int):void {
			if (canChange < 2){
				canChange ++;
				if (canChange == 1) {
					var filterData:b2FilterData = body.GetFixtureList().GetFilterData();
					filterData.maskBits = CMasks.STATIC_BUILDING | CMasks.DYNAMIC_BUILDING;
					body.GetFixtureList().SetFilterData(filterData);
				}
			}
			if (!body.IsAwake()) {
				fadeout = true;
			}
			if (fadeout) {
				fadeoutCount--;
				costume.alpha = fadeoutCount / 10;
				if (fadeoutCount < 1) {
					this.flagForRemoval();
				}
			}
		}
		
	}

}