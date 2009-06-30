package com.noonat.queens
{
	import com.adamatomic.flixel.FlxBlock;
	import com.adamatomic.flixel.FlxG;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	
	public class Platform extends FlxBlock
	{
		[Embed(source="../../../data/queens/platform.png")] private var ImgPlatform:Class;
		[Embed(source="../../../data/queens/crusher.mp3")] private var SndCrusher:Class;
		
		public static var AXIS_X:int = 0;
		public static var AXIS_Y:int = 1;
		
		public var moved:Number = 0;
		
		private var _axis:int;
		private var _direction:int;
		private var _min:Number;
		private var _max:Number;
		private var _r:Rectangle;
		private var _p:Point;
		private var _pixels:BitmapData;
		private var _speedNeg:Number;
		private var _speedPos:Number;
		private var _wait:Number;
		private var _waiting:Number=0;
		
		public function Platform($x:Number, $y:Number, $w:Number, $h:Number,
			$axis:int, $direction:int, $min:Number, $max:Number, $speed:*, $wait:Number,
			$graphic:Class=null)
		{
			super($x, $y, $w, $h, null);
			_p = new Point();
			_r = new Rectangle(0, 0, width, height);
			_pixels = FlxG.addBitmap($graphic ? $graphic : ImgPlatform);
			_axis = $axis;
			_direction = $direction;
			_min = $min;
			_max = $max;
			_speedNeg = $speed is Number ? $speed : $speed[0];
			_speedPos = $speed is Number ? $speed : $speed[1];
			_wait = $wait;
		}
		
		override public function render():void
		{
			if (!visible) {
				return;
			}
			getScreenXY(_p);
			FlxG.buffer.copyPixels(_pixels, _r, _p, null, null, true);
		}
		
		override public function update():void
		{
			if (FlxG.state is PlayState && (FlxG.state as PlayState).broken) {
				return;
			}
			moved = 0;
			if (x+width < -FlxG.followMin.x || x > -FlxG.followMax.x+FlxG.width ||
				y+height < -FlxG.followMin.y || y > -FlxG.followMax.y+FlxG.height) {
				return;
			}
			var elapsed:Number = FlxG.elapsed;
			if (_waiting > 0) {
				_waiting -= elapsed;
				elapsed = Math.abs(_waiting);
			}
			if (_waiting <= 0) {
				var value:Number = _axis === AXIS_X ? x : y;
				moved = _direction * (_direction < 0 ? _speedNeg : _speedPos) * elapsed
				value += moved;
				if (_direction < 0) {
					if (value < _min) {
						//moved += (_min - value);
						//value = _min;
						_direction = 1;
						if (_wait) {
							_waiting = _wait;
						}
					}
				}
				else {
					if (value > _max) {
						if (height === 64) {
							FlxG.quake(0.0025, 0.2);
							FlxG.play(SndCrusher);
						}
						moved -= (value - _max);
						value = _max;
						_direction = -1;
						if (_wait) {
							_waiting = _wait;
						}
					}
				}
				this[_axis === AXIS_X ? 'x' : 'y'] = value;
			}
			super.update();
		}
	}
}