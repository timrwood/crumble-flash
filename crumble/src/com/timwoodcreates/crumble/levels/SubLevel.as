package com.timwoodcreates.crumble.levels 
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Joints.b2RevoluteJointDef;
	import com.timwoodcreates.crumble.actors.Actor;
	import com.timwoodcreates.crumble.actors.BreakableWall;
	import com.timwoodcreates.crumble.actors.Door;
	import com.timwoodcreates.crumble.actors.FixedWall;
	import com.timwoodcreates.crumble.actors.Floor;
	import com.timwoodcreates.crumble.actors.MovableWall;
	import com.timwoodcreates.crumble.actors.Stair;
	import com.timwoodcreates.crumble.actors.TrapFloor;
	import com.timwoodcreates.crumble.env.Universe;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Tim Wood
	 */
	public class SubLevel
	{
		private static const WALL_WIDTH:Number = 1;
		private static const WALL_TYPE:String = 'movable';
		private static const FLOOR_HEIGHT:Number = 2;
		private static const FLOOR_TYPE:String = 'movable';
		
		public var x:Number = 0;
		public var y:Number = 0;
		
		public function SubLevel() 
		{
			
			
			
			// loop through floors
			/**/
			
		}
		
		public function buildWalls(wallY:Number, wallHeight:Number, walls:Array):void
		{
			var i:int;
			var position:b2Vec2;
			var size:b2Vec2;
			
			for (i = 0; i < walls.length; i++) {
				var wallX:Number = walls[i][0];
				var wallWidth:Number = (walls[i][1] != undefined) ? walls[i][1] : WALL_WIDTH;
				var wallType:String = (walls[i][2] != undefined) ? walls[i][2] : WALL_TYPE;
				
				position = new b2Vec2(x + wallX + wallWidth / 2, y + wallY + wallHeight / 2);
				size = new b2Vec2(wallWidth / 2, wallHeight / 2);
				
				switch (wallType) {
					case 'movable':
						Universe.actors.push(new MovableWall(size, position));
						break;
					case 'fixed':
						Universe.actors.push(new FixedWall(size, position));
						break;
					case 'breakable':
						Universe.actors.push(new BreakableWall(size, position));
						break;
				}
			}
		}
		
		public function buildDoors(doorY:Number, doorHeight:Number, doors:Array):void
		{
			var i:int;
			var position:b2Vec2;
			var size:b2Vec2;
			
			for (i = 0; i < doors.length; i++) {
				var doorX:Number = doors[i][0];
				var doorWidth:Number = doors[i][1];
				var doorLocked:Boolean = (doors[i][2] != undefined) ? doors[i][2] : false;
				
				position = new b2Vec2(x + doorX + doorWidth / 2, y + doorY + doorHeight / 2);
				size = new b2Vec2(doorWidth / 2, doorHeight / 2);
				
				Universe.actors.push(new Door(size, position, doorLocked));
			}
		}
		
		public function buildBackgrounds(floorY:Number, floorHeight:Number, floors:Array):void
		{
			var i:int;
			var position:b2Vec2;
			var size:b2Vec2;

			for (i = 0; i < floors.length; i++) {
				var floorX:Number = floors[i][0];
				var floorWidth:Number = floors[i][1];
				
				position = new b2Vec2(x + floorX + floorWidth / 2, y + floorY + floorHeight / 2);
				size = new b2Vec2(floorWidth / 2, floorHeight / 2);
				
				var background:Sprite = Universe.architect.buildBackground(size);
				background.x = position.x * Universe.RATIO;
				background.y = position.y * Universe.RATIO;
				
				Universe.scene.realDraw.addChildAt(background, 0);
			}
		}
		
		public function buildFloors(floorY:Number, floorHeight:Number, floors:Array):void
		{
			var i:int;
			var position:b2Vec2;
			var size:b2Vec2;
			var lastActor:Actor;

			for (i = 0; i < floors.length; i++) {
				var floorX:Number = floors[i][0];
				var floorWidth:Number = floors[i][1];
				var floorType:String = (floors[i][2] != undefined) ? floors[i][2] : FLOOR_TYPE;
				var makeConnection:Boolean = (floors[i][3] != undefined) ? floors[i][3] : false;
				var thisActor:Actor;
				
				position = new b2Vec2(x + floorX + floorWidth / 2, y + floorY + floorHeight / 2);
				size = new b2Vec2(floorWidth / 2, floorHeight / 2);
				
				switch (floorType) {
					case 'movable':
						size.x -= .02;
						thisActor = new Floor(size, position, true);
						break;
					case 'fixed':
						thisActor = new Floor(size, position);
						break;
					case 'trap':
						thisActor = new TrapFloor(size, position);
						break;
				}
				Universe.actors.push(thisActor);
				if (makeConnection && lastActor is Floor) {
					var jointDef:b2RevoluteJointDef = new b2RevoluteJointDef();
					jointDef.Initialize(thisActor._body, lastActor._body, new b2Vec2(position.x - size.x, position.y - size.y));
					jointDef.upperAngle = 0;
					jointDef.lowerAngle = - Math.PI * .5;
					jointDef.enableLimit = true;
					Universe.world.CreateJoint(jointDef);	
				}
				lastActor = thisActor;
			}
		}
		
		public function buildStairs(stairY:Number, stairHeight:Number, stairs:Array):void
		{
			var i:int;
			var position:b2Vec2;
			var size:b2Vec2;
			
			for (i = 0; i < stairs.length; i++) {
				var stairX:Number = stairs[i][0];
				var stairWidth:Number = stairHeight;
				var baseLeft:Boolean = (stairs[i][1] != undefined) ? stairs[i][1] : false;
				
				position = new b2Vec2(x + stairX + stairWidth / 2, y + stairY + stairHeight / 2);
				
				Universe.actors.push(new Stair(stairWidth / 2, position, baseLeft));
			}
		}
		
		public function buildBoxes(boxSize:Number, boxes:Array):void
		{
			var i:int;
			var position:b2Vec2;
			var size:b2Vec2;
			
			for (i = 0; i < boxes.length; i++) {
				var boxX:Number = boxes[i][0];
				var boxY:Number = boxes[i][1];
				
				position = new b2Vec2(x + boxX + boxSize / 2, y + boxY + boxSize / 2);
				size = new b2Vec2(boxSize / 2, boxSize / 2);
				
				Universe.actors.push(new MovableWall(size, position));
			}
		}
		
	}

}