package com.timwoodcreates.crumble.actors 
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
	public class BreakableWall extends Actor
	{
		private var _size:b2Vec2;
		private var _position:b2Vec2;
		private var _actor:Actor;
		
		public function BreakableWall(size:b2Vec2, position:b2Vec2) 
		{
			// save variables for destroy block creation
			_size = size.Copy();
			_position = position.Copy();
			
			// define body
			var bodyDef:b2BodyDef = new b2BodyDef();
			bodyDef.position.Set(position.x, position.y);
			bodyDef.type = b2Body.b2_staticBody;
			
			// define shape
			var shapeDef:b2PolygonShape = new b2PolygonShape();
			shapeDef.SetAsBox(size.x, size.y);
			
			// define fixture
			var fixtureDef:b2FixtureDef = new b2FixtureDef();
			fixtureDef.density = 1;
			fixtureDef.shape = shapeDef;
			fixtureDef.filter.categoryBits = CMasks.STATIC_BUILDING;
			
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
		
		public function breakApart(actor:Actor):Boolean
		{
			var velocity:Number = actor._body.GetLinearVelocity().Copy().x;
			var mass:Number = actor._body.GetMass();
			
			if (Math.abs(mass * velocity) > 1){
				_actor = actor;
				this.flagForRemoval();
				return true;
			}
			return false;
		}
		
		override protected function cleanUpBeforeRemoving():void
		{
			Universe.effects.shake = 200;
			
			// get the hero position
			var heroPosition:b2Vec2 = Universe.hero._body.GetWorldCenter().Copy();
			
			// set some helper variables of the size of the box
			var sizeX:Number = -_size.x;
			var sizeY:Number = _size.y;
			
			// if hero is to the right of the box, invert the size
			if ( heroPosition.x > _position.x ) {
				sizeX = -sizeX;
			}
			
			// set the break point of the wall as a percentage of the way between center and edge
			// should output a number roughly between 1 and -1
			var breakPoint:Number = (heroPosition.y - _position.y) / _size.y;
			
			// set the max and min of the breakpoint to .9 and -.9
			breakPoint = Math.max( -.9, Math.min(.9, breakPoint));
			
			// create an array of points to split the wall these are the points closest to the hero
			var pointsClose:Array = [
				1, 
				findPercent(breakPoint, 1, .4),
				breakPoint, 
				findPercent(breakPoint, -1, .4), 
				-1 
			];
			
			// create an array of points on the opposite side of the wall from the hero
			var pointsFar:Array = [
				1, 
				findPercent(breakPoint, 1, .55),
				breakPoint, 
				findPercent(breakPoint, -1, .55), 
				-1 
			];
			
			// create an array of points for the center of the wall chunks
			var pointsCenter:Array = [
				average([pointsFar[0],pointsFar[1],pointsClose[0],pointsClose[1]]),
				average([pointsFar[1],pointsFar[2],pointsClose[1],pointsClose[2]]),
				average([pointsFar[2],pointsFar[3],pointsClose[2],pointsClose[3]]),
				average([pointsFar[3],pointsFar[4],pointsClose[3],pointsClose[4]])
			];
			
			// create new BreakableWallChunks
			for (var i:int = 0; i < 4; i++) {
				var chunkPoints:Array = [
					new b2Vec2(sizeX, (-pointsCenter[i] + pointsClose[i]) * sizeY),
					new b2Vec2(-sizeX, (-pointsCenter[i] + pointsFar[i]) * sizeY),
					new b2Vec2(-sizeX, (-pointsCenter[i] + pointsFar[i + 1]) * sizeY),
					new b2Vec2(sizeX, (-pointsCenter[i] + pointsClose[i + 1]) * sizeY)
				];
				Universe.actors.push(new BreakableWallChunk(chunkPoints, new b2Vec2(_position.x, _position.y + pointsCenter[i] * sizeY)));
			}
		}
		
		private function average(numbers:Array):Number
		{
			var output:Number = 0;
			for (var i:int = 0; i < numbers.length; i++) {
				output += numbers[i];
			}
			output = output / numbers.length;
			return output;
		}
		
		private function findPercent(start:Number, end:Number, ratio:Number):Number
		{
			return start + (end - start) * ratio;
		}
	}

}