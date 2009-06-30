package com.noonat.queens
{
	import com.adamatomic.flixel.FlxArray;
	import com.adamatomic.flixel.FlxG;
	
	public class ArrowShooter extends Sprite
	{
		[Embed(source="../../../data/queens/arrow_shooter.png")] private var ImgArrowShooter:Class;
		[Embed(source="../../../data/queens/arrow.mp3")] private var SndArrow:Class;
		
		public var screen:int;
		private var _arrow:int = 0;
		private var _arrows:FlxArray;
		private var _queen:Queen;
		private var _timer:Number = 2.0;
		
		public function ArrowShooter($x:Number, $y:Number, $arrows:FlxArray, $queen:Queen, $timer:Number=-1):void
		{
			super(ImgArrowShooter, $x, $y, false, false);
			_arrows = $arrows;
			_queen = $queen;
			if ($timer >= 0) {
				_timer = $timer;
			}
		}
		
		public function fire():void
		{
			FlxG.play(SndArrow);
			_arrows.add(FlxG.state.add(new Arrow(x, y + (_arrow * 16) + 4, -1)));
			_arrows.add(FlxG.state.add(new Arrow(x, y + (_arrow * 16) + 11, -1)));
			_arrows.add(FlxG.state.add(new Arrow(x + width - 8, y + (_arrow * 16) + 4, 1)));
			_arrows.add(FlxG.state.add(new Arrow(x + width - 8, y + (_arrow * 16) + 11, 1)));
			_arrow++;
			if (_arrow == 2) {
				_arrow = 0;
			}
			_timer += 1;
		}
		
		override public function update():void
		{
			if (!onScreen()) {
				return;
			}
			_timer -= FlxG.elapsed;
			if (_timer < 0) {
				fire();
			}
			super.update();
		}
	}
}
