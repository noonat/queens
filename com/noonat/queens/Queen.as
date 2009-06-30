package com.noonat.queens
{
	import com.adamatomic.flixel.FlxArray;
	import com.adamatomic.flixel.FlxBlock;
	import com.adamatomic.flixel.FlxEmitter;
	import com.adamatomic.flixel.FlxG;
	import com.adamatomic.flixel.FlxSprite;

	public class Queen extends FlxSprite
	{
		[Embed(source="../../../data/queens/queen.png")] private var ImgQueen:Class;
		[Embed(source="../../../data/queens/queen2.png")] private var ImgQueen2:Class;
		[Embed(source="../../../data/queens/queen3.png")] private var ImgQueen3:Class;
		[Embed(source="../../../data/queens/footstep.mp3")] private var SndFootstep:Class;
		[Embed(source="../../../data/queens/hurt.mp3")] private var SndHurt:Class;
		
		private static var _lastQueen:Class=null;
		private var _jumped:Boolean = false;
		private var _intro:Boolean = true;
		private var _standingUp:Boolean = false;
		private var _jumpVelocity:int = 180;
		private var _runVelocity:int = 70;
		private var _restartTimer:Number = 0;
		private var _lastSoundFrame:int=0;
		
		public function Queen(X:int,Y:int)
		{
			//screen 3
			//X = 1280;
			//Y = -112;
			//screen 4
			//X = 1440;
			//Y = 160-32;
			//X = 1464;
			//Y = 242;
			//_intro = false;
			do {
				var s:Class;
				var r:Number = Math.random();
				if (r < 0.33) {
					s = ImgQueen;
				}
				else if (r < 0.66) {
					s = ImgQueen2;
				}
				else {
					s = ImgQueen3;
				}
			} while (s === _lastQueen);
			_lastQueen = s;
			super(s, X, Y, true, true);
			
			// bounding box tweaks
			offset.x = 5;
			offset.y = 2;
			width = 6;
			height = 14;
			
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
			addAnimation("dead", [4], 1, false);
		}
		
		override public function update():void
		{
			//FlxG.logObject({x: Math.floor(x).toString(), y: Math.floor(y).toString()});
			if (!dead && y > 320) {
				kill();
			}
			
			// game restart timer
			acceleration.x = 0;
			if (dead) {
				_restartTimer += FlxG.elapsed;
				if (_restartTimer > 3) {
					FlxG.switchState(PlayState);
				}
			}
			else {
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
					if (FlxG.justPressed(FlxG.A) && !_jumped && velocity.y < 30) {
						_jumped = true;
						velocity.y = -_jumpVelocity;
					}
					if (FlxG.justPressed(FlxG.B)) {
						FlxG.play(SndFootstep);
					}
				}
			
				// animation
				if (velocity.y != 0) {
					_lastSoundFrame = 0;
					play("jump");
				}
				else if (velocity.x != 0) {
					play("run");
					if ((_curFrame == 1 || _curFrame == 3) && _lastSoundFrame != _curFrame) {
						_lastSoundFrame = _curFrame;
						FlxG.play(SndFootstep, 0.8);
					}
				}
				else {
					_lastSoundFrame = 0;
					play("idle");
				}
			}
				
			// update position and animation
			super.update();
		}
		
		override public function hitFloor(block:FlxBlock):Boolean
		{
			if (y > 64 && _intro) {
				_intro = false;
				FlxG.quake(0.005, 0.2);
				FlxG.play(SndHurt, 0.5);
				play("standUp");
				_standingUp = true;
			}
			else if (velocity.y > 50) {
				FlxG.play(SndFootstep, 0.8);
			}
			_jumped = false;
			if (block is Platform) {
				x += (block as Platform).moved;
			}
			return super.hitFloor(block);
		}
		
		override public function hitWall(block:FlxBlock):Boolean
		{
			if (block is RockBlock) {
				(block as RockBlock).rock.x += 0.2;
				return true;
			}  
			else {
				return super.hitWall(block);
			}
		}
		
		override public function kill():void
		{
			if (dead) {
				return;
			}
			FlxG.play(SndHurt, 0.5);
			play('dead');
			super.kill();
			exists = true;
			FlxG.quake(0.005,0.35);
			FlxG.flash(0xffd8eba2,0.2);
			FlxG.fade(0xff000000,2);
		}
	}
}