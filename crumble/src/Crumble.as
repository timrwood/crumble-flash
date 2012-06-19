package  
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2DebugDraw;
	import Box2D.Dynamics.b2World;
	import com.timwoodcreates.crumble.actors.Actor;
	import com.timwoodcreates.crumble.env.CrumbleScene;
	import com.timwoodcreates.crumble.env.Universe;
	import com.timwoodcreates.crumble.levels.Level1;
	import com.timwoodcreates.crumble.levels.Level4;
	import com.timwoodcreates.crumble.levels.Level5;
	import com.timwoodcreates.crumble.levels.Level6;
	import com.timwoodcreates.crumble.utils.Architect;
	import com.timwoodcreates.crumble.utils.CrumbleContactListener;
	import com.timwoodcreates.crumble.utils.Effects;
	import com.timwoodcreates.crumble.utils.fpsTest;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	/**
	 * ...
	 * @author ...
	 */
	public class Crumble extends Sprite
	{
		private var actors:Array = [];
		private var m_sprite:Sprite = new Sprite();
		private var slowmotion:Boolean = false;
		private var noGravity:Boolean = false;
		private var fps:fpsTest = new fpsTest()
		
		public function Crumble() 
		{
			//setup physics world
			setupPhysicalWorld();
			
			//setup 3d world
			setupVisualWorld();
			
			//setup actors
			setupActors();
			
			//setup debugger and fps counter
			setupDebug();
			
			//event listeners
			// event listener on every frame (update physics world, etc)
			addEventListener(Event.ENTER_FRAME, newFrameListener);		
			// event listener on key press	
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyPressed);
			// event listener on key release	
			stage.addEventListener(KeyboardEvent.KEY_UP, keyReleased);
			// event listener on mouse down
			stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			// event listener on mouse up	
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
			// event listener on mouse up	
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
			// event listener on mouse leave stage 
			stage.addEventListener(Event.MOUSE_LEAVE, mouseOut);
		}
		
		private function mouseMove(e:MouseEvent):void 
		{
			Universe.effects.mouseMove(mouseX, mouseY);
			Universe.hero.setMouseTarget(mouseX - stage.stageWidth / 2, mouseY - stage.stageHeight / 2);
		}
		
		private function mouseUp(e:Event):void 
		{
			// set the slowmotion var to false
			// 100830:tim moved slowmotion to ctrl
			//Universe.isSlowmotion = false;
			Universe.hero.mouseUp();
		}
		
		private function mouseDown(e:Event):void 
		{
			// set the slowmotion var to true
			// 100830:tim moved slowmotion to ctrl
			//Universe.isSlowmotion = true;
			Universe.hero.mouseDown();
		}
		
		private function mouseOut(e:Event):void 
		{
			// set the slowmotion var to true
			// 100830:tim moved slowmotion to ctrl
			//Universe.isSlowmotion = false;
		}
		
		private function keyReleased(e:KeyboardEvent):void 
		{
			// pass the keyboard event to the hero
			Universe.hero.keyRelease(e);
			
			// 100830:tim toggle slowmotion for the universe if pressed control
			if (e.keyCode == Keyboard.CONTROL) {
				Universe.isSlowmotion = !Universe.isSlowmotion;
			}
			/*if (!Universe.isSlowmotion) {
				Universe.msPerFrame = 40;
			} else {
				Universe.msPerFrame = 4;
			}*/
		}
		
		private function keyPressed(e:KeyboardEvent):void 
		{
			// pass the keyboard event to the hero
			Universe.hero.keyPress(e);
			if (e.keyCode == Keyboard.SPACE) {
				noGravity = !noGravity;
			}
			if (e.keyCode == Keyboard.SHIFT) {
				Universe.scene.toggleDebug();
			}
			/*if (noGravity) {
				Universe.world.SetGravity(new b2Vec2(0, 0));
			} else {
				Universe.world.SetGravity(new b2Vec2(0, 50));
			}*/
		}
		
		private function newFrameListener(e:Event):void 
		{
			if (Universe.isSlowmotion) {
				if (Universe.msPerFrame > 4) {
					Universe.msPerFrame--;
				}
			} else {
				if (Universe.msPerFrame < 40) {
					Universe.msPerFrame++;
				}
			}
			var cacheMs:int = Universe.msPerFrame;
			Universe.timeElapsed += cacheMs;
			
			fps.startFrame();
			fps.startCounting('world step');
			// step the world one frame
			Universe.world.Step( cacheMs / 1000, 10, 10);
			
			// don't know why this is required. its part of the update to 2.1
			//Universe.world.ClearForces();
			fps.stopCounting('world step');
			
			fps.startCounting('actor update');
			/* 
			 * loop through all the actors and update them. 
			 * Doesn't really do much now, as we are using the debugdraw.
			 * Later though, this will update the sprites to the position 
			 * and location of their correlating physics objects.
			 * This is where the Hero does his movements.
			 */
			for each (var actor:Actor in Universe.actors) {
				actor.updateNow(cacheMs);
			}
			fps.stopCounting('actor update');
			
			fps.startCounting('draw debug');
			// debug draw
			Universe.world.DrawDebugData();
			fps.stopCounting('draw debug');
			
			fps.startCounting('effects');
			// update effects
			Universe.effects.update();
			fps.stopCounting('effects');
			
			fps.startCounting('remove actors');
			reallyRemoveActors();
			fps.stopCounting('remove actors');
			
			fps.stopFrame();
		}
		
		// remove all actors that are marked for deletion
		private function reallyRemoveActors():void
		{
			for each(var removeMe:Actor in Universe.actorsToRemove) {
				// destroy actor
				removeMe.destroy();
				
				// remove it from the main list of actors
				var actorIndex:int = Universe.actors.indexOf(removeMe);
				if (actorIndex > -1) {
					Universe.actors.splice(actorIndex, 1);
				}
			}
			
			Universe.actorsToRemove = [];
		}
		
		private function setupVisualWorld():void {
			// TODO: Setup Visual World
			Universe.camera = new Sprite();
			Universe.scene = new CrumbleScene();
			Universe.camera.addChild(Universe.scene);
			Universe.film = new Bitmap(new BitmapData(stage.stageWidth, stage.stageHeight, true, 0));
			// uncomment to toggle effects
			addChild(Universe.film);
			//addChild(Universe.camera);
		}
		
		private function setupDebug():void
		{
			/*
			 * set up debug draw stuff.
			 * it's just copy/paste from somewhere, so I don't have 
			 * detailed comments and I don't completely understand the 
			 * debugdraw class. It's only temporary, so its not that important
			 */
			var dbgDraw:b2DebugDraw = new b2DebugDraw();
			dbgDraw.SetSprite(Universe.scene.debugDraw);
			dbgDraw.SetDrawScale(Universe.RATIO);
			dbgDraw.SetFillAlpha(.5);
			dbgDraw.SetLineThickness(1);
			dbgDraw.SetFlags(b2DebugDraw.e_shapeBit|b2DebugDraw.e_centerOfMassBit|b2DebugDraw.e_jointBit|b2DebugDraw.e_pairBit|b2DebugDraw.e_controllerBit);
			
			Universe.world.SetDebugDraw(dbgDraw);
			
			addChild(fps.wrapper);
			fps.addKey('actor update');
			fps.addKey('draw debug');
			fps.addKey('effects');
			fps.addKey('world step');
			fps.addKey('remove actors');
		}
		
		private function setupPhysicalWorld():void
		{
			// create gravity
			var gravity:b2Vec2 = new b2Vec2(0, 9.8)
			// allow bodies to sleep
			var allowSleep:Boolean = true;
			/*
			 * instatiate the physics world.
			 * todo: we can get rid of the gravity and allowSleep vars
			 * and just set them using 
			 * Universe.world = new b2World(new b2Vec2(0, 20), true);
			 */
			Universe.world = new b2World(gravity, allowSleep);
			/*
			 * create the contact listener.
			 * the contact listener is what we use to perform 
			 * calculations on the collisions
			 * see 
			 * com.timwoodcreates.crumble.utils.CrumbleContactListener
			 * for more details
			 */
			Universe.world.SetContactListener(new CrumbleContactListener());
			// instantiate the effects class
			Universe.effects = new Effects(stage);
			Universe.architect = new Architect();
		}
		
		private function setupActors():void {
			//var level:StairTestLevel = new StairTestLevel();
			var level:Level5 = new Level5();
			level.build();
		}
		
	}

}