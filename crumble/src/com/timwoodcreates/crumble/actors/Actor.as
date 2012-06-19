package com.timwoodcreates.crumble.actors
{
	import Box2D.Dynamics.b2Body;
	import com.timwoodcreates.crumble.env.Universe;
	import flash.display.DisplayObject;
	import flash.events.EventDispatcher;
	/**
	 * ...
	 * @author ...
	 */
	public class Actor extends EventDispatcher
	{
		
		public var _body:b2Body;
		public var _costume:DisplayObject;
				
		public function Actor(myBody:b2Body, myCostume:DisplayObject) 
		{
			_body = myBody;
			_body.SetUserData(this);
			_costume = myCostume;
			
			updateMyLook();
		}
		
		public function updateNow(ms:int):void
		{
			updateMyLook();
			childSpecificUpdating(ms);
		}
		
		protected function childSpecificUpdating(ms:int):void
		{
			//This function does nothing
			//To be used by children
		}
		
		public function destroy():void
		{
			// Remove event listeners, misc cleanup
			cleanUpBeforeRemoving();
			
			// Remove costume sprite from display
			// TODO: When we add the costume parents
			if (_costume.parent is DisplayObject) {
				_costume.parent.removeChild(_costume);
			}
			
			// Destroy the body
			Universe.world.DestroyBody(_body);
			
		}
		
		// Mark an actor to be removed
		public function flagForRemoval():void {
			if (Universe.actorsToRemove.indexOf(this) < 0) {
				Universe.actorsToRemove.push(this);
			}
		}
		
		protected function cleanUpBeforeRemoving():void
		{
			//This function does nothing
			//To be used by children
		}
		
		private function updateMyLook():void
		{
			_costume.x = _body.GetPosition().x * Universe.RATIO;
			_costume.y = _body.GetPosition().y * Universe.RATIO;
			_costume.rotation = _body.GetAngle() * 180 / Math.PI;
		}
		
	}

}