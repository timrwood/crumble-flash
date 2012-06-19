package com.timwoodcreates.crumble.animation 
{
	/**
	 * ...
	 * @author Tim Wood
	 */
	public class Animation
	{
		private var currentTime:int = 0;
		private var animationTime:int = 0
		
		private var times:Array = [];
		private var points:Array = [];
		
		private var originalOpacity:Number = 0;
		private var targetOpacity:Number = 0;
		private var fadeTime:int = 0;
		private var timeToFade:int = 0;
		
		public var opacity:Number = 0;
		public var angle:Number = 0;
		public var distance:Number = 0;
		public var enabled:Boolean = true;
		
		public function Animation(inputTimes:Array, inputPoints:Array, inputOpacity:Number = 1, inputOffset:Number = 0) 
		{
			// set the default opacity and target opacity to the initial opacity
			opacity = inputOpacity;
			targetOpacity = opacity;
			
			// for each keyframe
			for (var i:int = 0; i < inputTimes.length; i++) {
				// set the target time to the total animation time
				times[i] = animationTime;
				// increase the animation time
				animationTime += inputTimes[i];
				// set the points item to the input points item
				points[i] = inputPoints[i];
			}
			
			// set duplicate the first item to the end of the list for wraparound.
			times[times.length] = animationTime;
			points[points.length] = points[0];
			
			// set the offset of the timer
			currentTime = inputOffset % animationTime;			
		}
		
		public function step(ms:int):void
		{
			// do nothing if only one frame of the animation
			if (times.length == 1) {
				return;
			}
			// check if it needs to be faded
			if (opacity != targetOpacity) {
				fade(ms);
			}
			// check if it needs to be disabled
			if (opacity == 0) {
				enabled = false;
			}
			// add ms to the current time
			currentTime = (currentTime + ms) % animationTime;
			// check where the animation should be
			for (var i:int = 0; i < times.length; i++) {
				if (currentTime == times[i]) {
					// if its exactly on one of the keyframes, use that keyframe
					angle = points[i][0];
					distance = points[i][1];
				} else if (currentTime > times[i] && times[i + 1] != undefined && currentTime < times[i + 1]) {
					// if it's between two keyframes, calculate where in between
					averagePoints(i, i + 1);
				}
			}
		}
		
		private function fade(ms:int):void
		{
			// add to the fade time
			fadeTime += ms;
			// get the percentage of fade completion
			var fadePercent:Number = fadeTime / timeToFade;
			if (fadePercent < 1) {
				// if it's not completely faded, fade it some more.
				opacity = originalOpacity + (targetOpacity - originalOpacity) * fadePercent
			} else {
				//otherwise, set it to the completed opacity.
				opacity = targetOpacity;
			}
			
		}
		
		/*
		 * This function takes two indexes and averages the b2vec2's from the 
		 * points array, using the times array and the currentTime to find the 
		 * weighted average.
		 */
		private function averagePoints(a:int, b:int):void
		{
			// get the percentage of the way between the two points
			var percent:Number = (currentTime - times[a]) / (times[b] - times[a]);
			
			// get the angle
			angle = points[a][0] * (1 - percent) + points[b][0] * percent;
			
			// get the distance
			distance = points[a][1] * (1 - percent) + points[b][1] * percent;
		}
		
		public function fadeTo(targetOpacity:Number, timeToFade:int):void
		{
			// set the animation as emabled
			enabled = true;
			
			// reset the time spent fading
			fadeTime = 0;
			
			// reset the initial opacity to the currrent opacity
			originalOpacity = opacity;
			
			// set the target opacity
			this.targetOpacity = targetOpacity;
			
			// set the duration
			this.timeToFade = timeToFade;
		}
		
	}

}