package com.timwoodcreates.crumble.actors 
{
	import Box2D.Common.Math.b2Vec2;
	import com.timwoodcreates.crumble.env.Universe;
	
	/**
	 * ...
	 * @author Tim Wood
	 */
	public class Gun
	{
		private var maxCooldown:int = 100;
		
		public var angle:Number = 0;
		private var isHero:Boolean = false;
		private var coolDown:int = 0;
		
		public function Gun(_isHero:Boolean) 
		{
			isHero = _isHero;
			if (isHero) {
				maxCooldown = 20;
			}
		}
		
		public function shoot(position:b2Vec2):void
		{
			if (coolDown == 0) {
				coolDown = maxCooldown;
				Universe.actors.push(new Bullet(position, angle, 10, isHero));
			}
		}
		
		public function update(ms:int):void
		{
			if (coolDown != 0) {
				coolDown = Math.max(0, coolDown - ms);
			}
		}
		
	}

}