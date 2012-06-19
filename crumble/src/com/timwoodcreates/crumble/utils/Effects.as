package com.timwoodcreates.crumble.utils {
	
	import Box2D.Common.Math.b2Vec2;
	import com.timwoodcreates.crumble.env.Universe;
	import flash.display.Bitmap;
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.DisplacementMapFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;

	/**
	 * ...
	 * @author Tim Wood
	 */
	public class Effects {
		[Embed(source='../assets/map.jpg')]
		public static const mapC:Class;
		private var map:Bitmap = new mapC;
		
		[Embed(source='../assets/clouds.jpg')]
		public static const cloudsC:Class;
		private var clouds:Bitmap = new cloudsC;
		private var cloudsX:Number = 0;
		
		[Embed(source='../assets/city1.png')]
		public static const city1C:Class;
		private var city1:Bitmap = new city1C;
		private var city1X:Number = 0;
		
		[Embed(source='../assets/city2.png')]
		public static const city2C:Class;
		private var city2:Bitmap = new city2C;
		private var city2X:Number = 0;

		private static const STAGE_WIDTH:int = 800;
		private static const STAGE_HEIGHT:int = 600;

		public var shake:Number = 50;

		private var rect:Rectangle = new Rectangle(0, 0, STAGE_WIDTH, STAGE_HEIGHT);
		private var rate:Number = .95;
		private var shakePos:b2Vec2 = new b2Vec2();
		private var fadeoutMatrix:ColorMatrixFilter;
		private var displaceMap:DisplacementMapFilter = new DisplacementMapFilter(map.bitmapData, null, 1, 2, 30, 30, 'wrap', 0, 0);
		private var positionHero:Matrix = new Matrix(1, 0, 0, 1, STAGE_WIDTH / 2, STAGE_HEIGHT / 2);
		private var targetX:Number = STAGE_WIDTH / 2;
		private var targetY:Number = STAGE_HEIGHT / 2;
		
		private var showRealEffects:Boolean = true;

		public function Effects(stage:Stage){
			//stage.addChildAt(clouds, 0);
			//stage.addChildAt(city2, 1);
			//stage.addChildAt(city1, 2);
		}

		public function update():void {
			// move clouds each frame
			//cloudsX = (cloudsX + 1) % 1677;
			//clouds.x = -cloudsX;
			
			// update debug draw to center on the hero
			var heroPos:b2Vec2 = Universe.hero._body.GetPosition();
			Universe.scene.x = -heroPos.x * Universe.RATIO;
			Universe.scene.y = -heroPos.y * Universe.RATIO;
			
			// add shake to the camera
			shakePos.x = Math.max(-shake, Math.min(shake, shakePos.x - shake * .25 + Math.random() * shake * .5));
			shakePos.y = Math.max(-shake, Math.min(shake, shakePos.y - shake * .25 + Math.random() * shake * .5));
			Universe.scene.x += shakePos.x;
			Universe.scene.y += shakePos.y;
			shake = Math.max(0, shake * .9 - 1);

			smoothToTargets();

			//city1X = -(Universe.scene.x + positionHero.tx) / 2
			//city2X = -(Universe.scene.x + positionHero.tx) / 8
			
			//city1X = (city1X % 1600 + 1600) % 1600;
			//city2X = (city2X % 1000 + 1000) % 1000;
			
			//city1.x = -city1X;
			//city2.x = -city2X;
			
			drawCamera();
		}

		private function smoothToTargets():void {
			if (Math.abs(positionHero.tx - targetX) > .2){
				positionHero.tx = positionHero.tx + (targetX - positionHero.tx) * .2;
			} else {
				positionHero.tx = targetX;
			}
			if (Math.abs(positionHero.ty - targetY) > .2){
				positionHero.ty = positionHero.ty + (targetY - positionHero.ty) * .2;
			} else {
				positionHero.ty = targetY;
			}
		}

		private function drawCamera():void {
			rate = Math.min(.8, shake / 50);
			//rate = 0;
			fadeoutMatrix = new ColorMatrixFilter([rate, 0, 0, 0, 0, 0, rate, 0, 0, 0, 0, 0, rate, 0, 0, 0, 0, 0, rate, 0]);
			Universe.film.bitmapData.applyFilter(Universe.film.bitmapData, rect, new Point(), fadeoutMatrix);
			Universe.film.bitmapData.draw(Universe.camera, positionHero);
			if (Universe.isSlowmotion){
				//Universe.film.bitmapData.applyFilter(Universe.film.bitmapData, rect, new Point(), displaceMap);
			}
		}

		public function mouseMove(mouseX:Number, mouseY:Number):void {
			// get center of screen
			var center:b2Vec2 = new b2Vec2(STAGE_WIDTH / 2, STAGE_HEIGHT / 2);
			// subtract mouse position
			center.Subtract(new b2Vec2(mouseX, mouseY));
			// divide by 2
			center.Multiply(.8);
			// add center of screen back in
			center.Add(new b2Vec2(STAGE_WIDTH / 2, STAGE_HEIGHT / 2));
			// apply the target x and y values
			targetX = center.x;
			targetY = center.y;
		}


	}

}