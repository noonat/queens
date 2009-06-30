package com.noonat.queens
{
	import com.adamatomic.flixel.FlxArray;
	import com.adamatomic.flixel.FlxEmitter;
	import com.adamatomic.flixel.FlxG;

	public class King extends Sprite
	{
		[Embed(source="../../../data/queens/king.png")] private var ImgKing:Class;
		
		private var _intro:Boolean = true;
		private var _jumpVelocity:int = 180;
		private var _runVelocity:int = 20;
		private var _queen:Queen;
		
		public function King($queen:Queen, $x:int,$y:int)
		{
			super(ImgKing, $x, $y, true, true);
			_queen = $queen;
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
			addAnimation("dead", [4]);
			play("idle");
		}
		
		override public function kill():void
		{
			if (dead) {
				return;
			}
			play('dead');
			super.kill();
			exists = true;
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
					drag.x /= 2;
					maxVelocity.x /= 2;
				}
			}
			else {
				if (_queen.x > 180) {
					if (x < 440) {
						facing(true);
						acceleration.x += drag.x;
					}
					else {
						facing(false);
						acceleration.x = 0;
					}
				}
				if (_queen.x > 480) {
					if (x < 480-16) {
						x = 480-16;
					}
					if (x < 480*2) {
						facing(true);
						acceleration.x += drag.x
					}
					else {
						facing(false);
						acceleration.x = 0;
					}
				}
				if (_queen.x > 1200 && x < 1200) {
					x = 1612;
					y = 50;
				}
			}
			
			if (!dead) {
				if (velocity.x != 0) {
					play("run");
				}
				else {
					play("idle");
				}
			}
			else {
				acceleration.y = 0;
			}
				
			// update position and animation
			super.update();
		}
	}
}