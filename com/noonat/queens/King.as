package com.noonat.queens
{
	import com.adamatomic.flixel.FlxArray;
	import com.adamatomic.flixel.FlxEmitter;
	import com.adamatomic.flixel.FlxG;
	import com.adamatomic.flixel.FlxSprite;

	public class King extends FlxSprite
	{
		[Embed(source="../../../data/queens/king.png")] private var ImgKing:Class;
		
		private var _intro:Boolean = true;
		private var _jumpVelocity:int = 180;
		private var _runVelocity:int = 20;
		
		public function King(X:int,Y:int)
		{
			super(ImgKing, X, Y, true, true);
			
			// bounding box tweaks
			width = 8;
			height = 14;
			offset.x = 4;
			offset.y = 2;
			
			// basic player physics
			maxVelocity.x = _runVelocity;
			maxVelocity.y = _jumpVelocity * 2;
			acceleration.y = 420;
			drag.x = maxVelocity.x * 8;
			
			// animations
			addAnimation("idle", [1]);
			addAnimation("run", [1, 2, 3, 0], 5);
			play("idle");
		}
		
		override public function update():void
		{
			if (_intro) {
 				if (x > 72) {
					acceleration.x -= drag.x;
				}
				else {
					_intro = false;
					acceleration.x = 0;
				}
			}
			else {
				// movement
				/*
				acceleration.x = 0;
				if (FlxG.kLeft) {
					facing(false);
					acceleration.x -= drag.x;
				}
				else if (FlxG.kRight) {
					facing(true);
					acceleration.x += drag.x;
				}
				*/
				//acceleration.x += drag.x;
			}
			
			if (velocity.x != 0) {
				play("run");
			}
			else {
				play("idle");
			}
				
			// update position and animation
			super.update();
		}
	}
}