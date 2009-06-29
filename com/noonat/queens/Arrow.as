package com.noonat.queens
{
	import com.adamatomic.flixel.FlxG;
	
	public class Arrow extends Sprite
	{
		[Embed(source="../../../data/queens/arrow.png")] private var ImgArrow:Class;
		
		private var _direction:Number;
		
		public function Arrow($x:Number, $y:Number, $direction:Number):void
		{
			super(ImgArrow, $x, $y, false, true);
			this.acceleration.x = $direction * 1000;
			this.maxVelocity.x = 500;
			_direction = $direction;
		}
		
		override public function update():void
		{
			if (!exists) {
				return;
			}
			if (!inFollowBounds()) {
				kill();
				return;
			}
			//facing(_direction < 0);
			super.update();
		}
	}
}