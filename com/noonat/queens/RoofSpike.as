package com.noonat.queens
{
	import com.adamatomic.flixel.data.FlxCore;
	import com.adamatomic.flixel.FlxEmitter;
	import com.adamatomic.flixel.FlxG;
	import com.adamatomic.flixel.FlxSprite;
	
	public class RoofSpike extends FlxSprite
	{
		[Embed(source="../../../data/queens/roof_spike.png")] private var ImgRoofSpike:Class;
		[Embed(source="../../../data/gibs.png")] private var ImgDirtGibs:Class;
		
		private var _fallDistance:int;
		private var _falling:Boolean = false;
		private var _gibs:FlxEmitter;
		private var _shakeTime:Number;
		
		public function RoofSpike(X:int, Y:int, ShakeTime:Number=0.2, FallDistance:int=4):void
		{
			super(ImgRoofSpike, X, Y, false, false);
			width = 12;
			height = 20;
			offset.x = 2;
			_fallDistance = FallDistance;
			_shakeTime = ShakeTime;
			_gibs = FlxG.state.add(new FlxEmitter(
				0, 0, width, height, // x, y, w, h
				null, // sprites
				-1.5, // lifespan
				-50, 50, // minVelocityX, maxVelocityX
				-100, 0, // minVelocityY, maxVelocityY
				-720, 720, // minRotation, maxRotatoin
				400, 0, // gravity, drag
				ImgDirtGibs, // graphics
				15, // quantity
				true // true if graphics is a sprite sheet
			)) as FlxEmitter;
		}
		
		public function fall():void
		{
			_falling = true;
			shake(_shakeTime);
		}
		
		public function falling():Boolean
		{
			return _falling;
		}
		
		override public function hitFloor():Boolean
		{
			_gibs.x = x;
			_gibs.y = y-8;
			_gibs.reset();
			kill();
			return super.hitFloor();
		}
		
		public function shouldFall(other:FlxCore):Boolean
		{
			if (_falling || x-_fallDistance > other.x+other.width || x+width+_fallDistance < other.x) {
				return false;
			}
			else {
				return true;
			}
		}
		
		override public function update():void
		{
			if (_falling && !shaking()) {
				acceleration.y = 1000;
				maxVelocity.y = 1000;
			}
			super.update();
		}
	}
}
