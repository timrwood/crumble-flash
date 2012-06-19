package com.timwoodcreates.crumble.utils 
{
	import Box2D.Collision.b2Manifold;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2ContactListener;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.Contacts.b2Contact;
	import com.timwoodcreates.crumble.actors.Actor;
	import com.timwoodcreates.crumble.actors.BreakableWall;
	import com.timwoodcreates.crumble.actors.BreakableWallChunk;
	import com.timwoodcreates.crumble.actors.Bullet;
	import com.timwoodcreates.crumble.actors.FixedWall;
	import com.timwoodcreates.crumble.actors.Floor;
	import com.timwoodcreates.crumble.actors.Hero;
	import com.timwoodcreates.crumble.actors.Limb;
	import com.timwoodcreates.crumble.actors.Person;
	import com.timwoodcreates.crumble.actors.Stair;
	import com.timwoodcreates.crumble.actors.TrapFloor;
	import com.timwoodcreates.crumble.env.Universe;
	/**
	 * ...
	 * @author Tim Wood
	 */
	public class CrumbleContactListener extends b2ContactListener
	{
		
		public function CrumbleContactListener() 
		{
			
		}
		
		/* ------------------- PRESOLVE ------------------------- */
		
		/* function called right before a collision */
		override public function PreSolve(contact:b2Contact, oldManifold:b2Manifold):void {
			super.PreSolve(contact, oldManifold);
		}
		
		/* parent function for all presolve functions */
		private function allPreSolve(actorA:Actor, actorB:Actor, contact:b2Contact):void
		{
			
		}
		
		/* ------------------- BEGIN CONTACT ------------------------- */
		
		// this is called when two objects first come into contact.
		override public function BeginContact(contact:b2Contact):void {
			// same way of treating contacts as presolve()
			allBeginContact(contact.GetFixtureA().GetBody().GetUserData(), contact.GetFixtureB().GetBody().GetUserData(), contact);
			allBeginContact(contact.GetFixtureB().GetBody().GetUserData(), contact.GetFixtureA().GetBody().GetUserData(), contact);
			
			super.BeginContact(contact);
		}
		
		private function allBeginContact(actorA:Actor, actorB:Actor, contact:b2Contact):void
		{
			// break breakable walls
			if (actorB is BreakableWall) {
				if (BreakableWall(actorB).breakApart(actorA)) {
					contact.SetSensor(true);
				}
			}
			
			// trigger trap floors
			if (actorB is TrapFloor && (actorA is Limb || actorA is Hero || actorA is BreakableWallChunk)) {
				if (TrapFloor(actorB).breakApart(actorA)) {
					contact.SetSensor(true);
				}
			}
			
			// increment breakable wall chunk hit count
			if (actorB is BreakableWallChunk) {
				BreakableWallChunk(actorB).addHit();
				if (!actorB._body.IsAwake()) {
					contact.SetSensor(true);
				}
			}
			
			if (actorA is Floor) {
				if (Floor(actorA).checkUnderFloor(actorB)) {
					contact.SetSensor(true);
				}
			}
			
			/* stick hero to walls
			if (actorA is Hero && actorB is FixedWall) {
				Hero(actorA).stickToWall(actorB);
			}*/
			
			/* one way platform for stairs
			if (actorA is Stair && actorB is Hero) {
				if (Stair(actorA).checkHeroIgnoreStair(Hero(actorB))) {
					contact.SetSensor(true);
				}
			}*/
				
			// person hit count increments
			if (actorA is Person) {
				Person(actorA).addFootHit(actorB, true);
			}
			
			if (actorA is Bullet) {
				Bullet(actorA).hitSomething();
				if (actorB is Person) {
					Person(actorB).hitByBullet(actorA);
				}
				if (actorB is Limb) {
					Limb(actorB).hitByBullet(actorA);
				}
			}
			
		}
		
		
		/* ------------------- END CONTACT ------------------------- */
		
		// this is called when two objects stop contacting each other.
		override public function EndContact(contact:b2Contact):void {	
			// same way of treating contacts as presolve()
			allEndContact(contact.GetFixtureA().GetBody().GetUserData(), contact.GetFixtureB().GetBody().GetUserData(), contact);
			allEndContact(contact.GetFixtureB().GetBody().GetUserData(), contact.GetFixtureA().GetBody().GetUserData(), contact);
			
			super.EndContact(contact);
		}
		
		private function allEndContact(actorA:Actor, actorB:Actor, contact:b2Contact):void
		{
			// person hit count increments
			if (actorA is Person) {
				Person(actorA).addFootHit(actorB, false);
			}
		}
		
	}

}