package com.noonat.queens
{
	import com.adamatomic.flixel.FlxArray;
	import com.adamatomic.flixel.FlxEmitter;
	import com.adamatomic.flixel.FlxG;
	import com.adamatomic.flixel.FlxSprite;

	public class Queen extends FlxSprite
	{
		[Embed(source="../../../data/queens/queen.png")] private var ImgQueen:Class;
		
		private var _doubleJumped:Boolean = false;
		private var _intro:Boolean = true;
		private var _standingUp:Boolean = false;
		private var _jumpVelocity:int = 180;
		private var _runVelocity:int = 70;
		private var _restartTimer:Number = 0;
		
		public function Queen(X:int,Y:int)
		{
			super(ImgQueen, X, Y, true, true);
			
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
			addAnimation("run", [1, 2, 3, 0], 10);
			addAnimation("jump", [2]);
			addAnimation("standUp", [4, 5, 6], 2, false);
		}
		
		override public function update():void
		{
			//FlxG.log(Math.floor(x).toString());
			
			if (!dead && y > 240) {
				kill();
			}
			
			// game restart timer
			if (dead) {
				FlxG.log(_restartTimer.toString());
				_restartTimer += FlxG.elapsed;
				if (_restartTimer > 3) {
					FlxG.switchState(PlayState);
				}
				return;
			}
			
			if (_standingUp) {
				if (finished) {
					_standingUp = false;
				}
				else {
					super.update();
					return;
				}
			}
			
			// movement
			acceleration.x = 0;
			if (_intro) {
				if (y < 16) {
					acceleration.x -= drag.x * 0.1;
				}
			}
			else {
				if (FlxG.kLeft) {
					facing(false);
					acceleration.x -= drag.x;
				}
				else if (FlxG.kRight) {
					facing(true);
					acceleration.x += drag.x;
				}
				if (FlxG.justPressed(FlxG.A)) {
					if (!velocity.y) {
						velocity.y = -_jumpVelocity;
					}
					else if (!_doubleJumped) {
						velocity.y = -_jumpVelocity;
						_doubleJumped = true;
					}
				}
			}
			
			// animation
			if (velocity.y != 0) {
				play("jump");
			}
			else if (velocity.x != 0) {
				play("run");
			}
			else {
				play("idle");
			}
				
			// update position and animation
			super.update();
		}
		
		override public function hitFloor():Boolean
		{
			if (y > 64 && _intro) {
				_intro = false;
				FlxG.quake(0.005, 0.2);
				play("standUp");
				_standingUp = true;
			}
			_doubleJumped = false;
			return super.hitFloor();
		}
		
		override public function hurt(Damage:Number):void
		{
			Damage = 0;
			if (flickering()) {
				return;
			}
			flicker(1.3);
			super.hurt(Damage);
		}
		
		override public function kill():void
		{
			if (dead) {
				return;
			}
			super.kill();
			flicker(-1);
			exists = true;
			visible = false;
			FlxG.quake(0.005,0.35);
			FlxG.flash(0xffd8eba2,0.2);
			FlxG.fade(0xff000000,2);
		}
	}
}