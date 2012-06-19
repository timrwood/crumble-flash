package com.timwoodcreates.crumble.utils 
{
	import Box2D.Common.Math.b2Vec2;
	import com.timwoodcreates.crumble.env.Universe;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Tim Wood
	 */
	public class Architect
	{
		[Embed(source='../assets/wall.png')]
		public static const wallC:Class;
		private var wall:Bitmap = new wallC;
		
		private static const SCALE:int = Universe.RATIO;
		
		public static const TYPE_MODERN:int = 0;
		
		public static const COLOR_WHITE:uint = 0xffffff;
		public static const COLOR_DK_WHITE:uint = 0xdddddd;
		public static const COLOR_LT_GREY:uint = 0xbbbbbb;
		public static const COLOR_MD_GREY:uint = 0x999999;
		public static const COLOR_DK_GREY:uint = 0x666666;
		public static const COLOR_LT_BLACK:uint = 0x333333;
		public static const COLOR_BLACK:uint = 0x000000;
		
		public var buildingType:int = 0;
		
		public function Architect() 
		{
			
		}
		
		public function buildWall(sizeInit:b2Vec2):Sprite
		{
			var size:b2Vec2 = sizeInit.Copy();
			size.Multiply(SCALE);
			var output:Sprite = new Sprite();
			output.graphics.beginFill(COLOR_BLACK, 1);
			output.graphics.drawRect( -size.x, -size.y, size.x * 2, size.y * 2);
			return output;
		}
		
		public function buildFloor(sizeInit:b2Vec2):Sprite
		{
			var size:b2Vec2 = sizeInit.Copy();
			size.Multiply(SCALE);
			var output:Sprite = new Sprite();
			output.graphics.beginFill(COLOR_BLACK, 1);
			output.graphics.drawRect( -size.x, -size.y, size.x * 2, size.y * 2);
			return output;
		}
		
		public function buildBackground(sizeInit:b2Vec2):Sprite
		{
			var size:b2Vec2 = sizeInit.Copy();
			size.Multiply(SCALE);
			var output:Sprite = new Sprite();
			var matrix:Matrix = new Matrix(1, 0, 0, 1, 0, size.y);
			output.graphics.beginBitmapFill(wall.bitmapData, matrix);
			output.graphics.drawRect( -size.x, -size.y, size.x * 2, size.y * 2);
			return output;
		}
		
		public function buildWallChunk(points:Array):Sprite
		{
			var output:Sprite = new Sprite();
			
			output.graphics.beginFill(COLOR_BLACK, 1);
			output.graphics.moveTo(points[points.length - 1].x * SCALE, points[points.length - 1].y * SCALE);
			for (var i:int = 0; i < points.length; i++) {
				output.graphics.lineTo(points[i].x * SCALE, points[i].y * SCALE);
			}
			/*
			var right:Number = -points[0].x * SCALE;
			var left:Number = points[0].x * SCALE;
			var rightTop:Number = points[1].y * SCALE;
			var rightBottom:Number = points[2].y * SCALE;
			var leftTop:Number = points[0].y * SCALE;
			var leftBottom:Number = points[3].y * SCALE;
			var topCenter:Number = (rightTop + leftTop) / 2;
			var bottomCenter:Number = (rightBottom + leftBottom) / 2;
			
			
			output.graphics.beginFill(COLOR_DK_WHITE, 1);
			output.graphics.moveTo(left, leftTop);
			output.graphics.lineTo(left + 2, leftTop);
			output.graphics.lineTo(left + 2, leftBottom);
			output.graphics.lineTo(left, leftBottom);
			output.graphics.lineTo(left, leftTop);
			
			output.graphics.beginFill(COLOR_MD_GREY, 1);
			output.graphics.moveTo(right, rightTop);
			output.graphics.lineTo(right, rightBottom);
			output.graphics.lineTo(right * .3, bottomCenter);
			output.graphics.lineTo(left * .3, bottomCenter);
			output.graphics.lineTo(left + 2, leftBottom);
			output.graphics.lineTo(left + 2, leftTop);
			output.graphics.lineTo(left * .3, topCenter);
			output.graphics.lineTo(right * .3, topCenter);
			output.graphics.lineTo(right, rightTop);
			*/
			return output;
		}
	}

}