package com.noonat.queens
{
	import com.adamatomic.flixel.data.FlxCore;
	import com.adamatomic.flixel.FlxBlock;
	import com.adamatomic.flixel.FlxEmitter;
	import com.adamatomic.flixel.FlxG;
	
	public class RoofSpike extends Sprite
	{
		[Embed(source="../../../data/queens/roof_spike.png")] private var ImgRoofSpike:Class;
		[Embed(source="../../../data/gibs.png")] private var ImgDirtGibs:Class;
		[Embed(source="../../../data/queens/spike.mp3")] private var SndSpike:Class;
		[Embed(source="../../../data/queens/spike_rumble.mp3")] private var SndSpikeRumble:Class;
		
		private var _falling:Boolean = false;
		private var _gibs:FlxEmitter;
		private var _queen:Queen;
		private var _shakeTime:Number;
		private var _triggerDistance:int;
		
		public function RoofSpike($queen:Queen, $x:int, $y:int, $shakeTime:Number=0.2, $triggerDistance:int=4):void
		{
			super(ImgRoofSpike, $x, $y, false, false);
			width = 12;
			height = 20;
			offset.x = 2;
			
			_queen = $queen;
			_triggerDistance = $triggerDistance;
			_shakeTime = $shakeTime;
			_gibs = FlxG.state.add(new FlxEmitter(
				0, 0, width, height, // x, y, w, h
				null, // sprites
				-1.5, // lifespan
				-50, 50, // minVelocityX, maxVelocityX
				-100, 0, // minVelocityY, maxVelocityY
				-720, 720, // minRotation, maxRotation
				400, 0, // gravity, drag
				ImgDirtGibs, // graphics
				15, // quantity
				true // true if graphics is a sprite sheet
			)) as FlxEmitter;
		}
		
		public function fall():void
		{
			FlxG.play(SndSpikeRumble, 0.1);
			_falling = true;
			shake(_shakeTime);
		}
		
		public function falling():Boolean
		{
			return _falling;
		}
		
		override public function hitFloor(block:FlxBlock):Boolean
		{
			FlxG.play(SndSpike, 0.3);
			_gibs.x = x;
			_gibs.y = y-8;
			_gibs.reset();
			kill();
			return super.hitFloor(block);
		}
		
		override public function update():void
		{
			if (!inFollowBounds()) {
				return;
			}
			if (!_falling && !(x-_triggerDistance > _queen.x+_queen.width || x+width+_triggerDistance < _queen.x)) {
				fall();
			}
			if (_falling && !shaking()) {
				acceleration.y = 1000;
				maxVelocity.y = 1000;
			}
			super.update();
		}
	}
}
