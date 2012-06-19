package com.timwoodcreates.crumble.utils 
{
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.system.System;
	import flash.text.*;
	import flash.utils.*;

	public class fpsTest {
		
		//[Embed(source = '../assets/visitor.ttf', fontFamily='visitor', mimeType='application/x-font-truetype', embedAsCFF="false")]
		//private var visitorFontClass:Class;
		
		private static const GRAPH_HEIGHT:int = 100;
		private static const GRAPH_WIDTH:int = 400;
		
		private var fps:TextField;
		private var output:TextField;
		private var currentTime:int;
		private var previousTime:int;
		
		private var timerName:Array = [];
		private var maxNameLength:int = 0;
		private var startTime:Array = [];
		private var totalTime:Array = [];
		private var graphColors:Array = [];
		private var timerCount:int = 0;
		
		private var colorPresets:Array = [ 0xff4533, 0x0c8558, 0xffd96a, 0x204709, 0x4e352f, 0xfc7c17 ];
		private var colorsUsed:int = 0;
		private var drawLine:Sprite = new Sprite();
		private var graphBitmap:Bitmap;
		private var countersMultiply:Number;
		public var wrapper:Sprite = new Sprite();
		
		private var maxFPS:int;
		private var m:Matrix;
		private var tmp:BitmapData;
		private var shown:Boolean = true;
		
		public function fpsTest(currentFPS:Number = 30) {
			//Font.registerFont(visitorFontClass);
			var textFormat:TextFormat = new TextFormat('Courier New', 12, 0xffffff, false);
			
			graphBitmap = new Bitmap(new BitmapData(GRAPH_WIDTH, GRAPH_HEIGHT, true, 0));
			wrapper.addChild(graphBitmap);
			
			fps = new TextField();
			fps.defaultTextFormat = textFormat;
			//fps.embedFonts = true;
			fps.antiAliasType = AntiAliasType.ADVANCED;
			fps.autoSize = TextFieldAutoSize.LEFT;
			//fps.sharpness = 400;
			wrapper.addChild(fps);	
			
			output = new TextField();
			output.defaultTextFormat = textFormat;
			//output.embedFonts = true;
			output.antiAliasType = AntiAliasType.ADVANCED;
			output.autoSize = TextFieldAutoSize.LEFT;
			//output.sharpness = 400;
			output.x = 40;
			output.y = GRAPH_HEIGHT + 20;
			wrapper.addChild(output);
			
			maxFPS = currentFPS;
			//graphBitmap.y = 10;
			wrapper.graphics.lineStyle(1, 0xffffff, .5);
			wrapper.graphics.moveTo(0, 10 + (GRAPH_HEIGHT * .3 / 1.3));
			wrapper.graphics.lineTo(GRAPH_WIDTH, 10 + (GRAPH_HEIGHT * .3 / 1.3));
			
			countersMultiply = GRAPH_HEIGHT / (1000 / maxFPS * 1.3);
			
			m = new Matrix();
			m.tx = -1;
			tmp = new BitmapData(GRAPH_WIDTH, GRAPH_HEIGHT, true, 0);
		}
		
		public function addKey(name:String):void
		{
			if (timerName.indexOf(name) == -1) {
				timerName[timerCount] = name;
				totalTime[timerCount] = 0;
				startTime[timerCount] = 0;
				graphColors[timerCount] = colorPresets[colorsUsed];
				colorsUsed = (colorsUsed + 1) % colorPresets.length;
				addGraphKey(timerCount);
				timerCount++;
				maxNameLength = Math.max(maxNameLength, name.length);
			}
		}
		
		public function startCounting(name:String):void
		{
			// if the counter doesn't exist, create it.
			addKey(name);
			// set the start point to the current time
			startTime[timerName.indexOf(name)] = getTimer();
		}
		
		private function addGraphKey(value:int):void
		{
			wrapper.graphics.lineStyle(0, 0, 0);
			wrapper.graphics.beginFill(graphColors[value]);
			wrapper.graphics.drawRect(5, 24 + GRAPH_HEIGHT + 15 * value, 30, 13);
		}
		
		public function stopCounting(name:String):void {
			// set the number of frames for this item
			totalTime[timerName.indexOf(name)] = getTimer() - startTime[timerName.indexOf(name)];
		}
		
		public function startFrame():void
		{
			previousTime = getTimer();
		}
		
		public function stopFrame():void
		{
			// get current time
			currentTime = getTimer();
			// find milliseconds passed
			var passedTime:int = currentTime - previousTime;
			// find frames per second
			var framesPerSecond:Number = Math.min(1000 / passedTime, maxFPS);
			// find system memory used
			var systemMemory:Number = System.totalMemory / 1024;
			fps.text = "NOW FPS " + zeroFill(framesPerSecond, 2) + '  ' + zeroFill(passedTime, 4) + ' MS  ' + zeroFill(systemMemory, 4) + ' KB';
			
			tmp.fillRect(tmp.rect,0);
			tmp.draw(graphBitmap.bitmapData,m);
			graphBitmap.bitmapData.copyPixels(tmp, tmp.rect, new Point());
			
			previousTime = currentTime;
			
			// write out the text for each of the timers.
			compareTimes();
		}
		
		private function compareTimes():void
		{
			var i:int = 0;
			
			output.text = "";
			
			drawLine.graphics.clear();
			var frameCounter:int = 0;
			for (i = 0; i < timerCount; i++) {
				output.appendText(appendSpaces(timerName[i], maxNameLength + 1) + totalTime[i] + "MS\n");
				// draw a segment of the line
				drawLine.graphics.lineStyle(1, graphColors[i]);
				drawLine.graphics.moveTo(GRAPH_WIDTH - 1, GRAPH_HEIGHT - frameCounter * countersMultiply);
				drawLine.graphics.lineTo(GRAPH_WIDTH - 1, GRAPH_HEIGHT - (frameCounter + totalTime[i]) * countersMultiply);
				frameCounter += totalTime[i];
			}
			graphBitmap.bitmapData.draw(drawLine);
		}
		
		private function zeroFill(input:Number, wholeNumbers:int):String
		{
			var wholeString:String = '' + int(input);
			var decimalString:String = '' + int((input * 10) % 10);
			while (wholeString.length < wholeNumbers) {
				wholeString = '0' + wholeString;
			}
			return wholeString + '.' + decimalString;
		}
		
		private function appendSpaces(input:String, spaces:int):String
		{
			var wholeString:String = input;
			while (wholeString.length < spaces) {
				wholeString += ' ';
			}
			return wholeString;
		}
	}
}