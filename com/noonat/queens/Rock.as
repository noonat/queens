package com.noonat.queens
{
	import com.adamatomic.flixel.FlxBlock;
	
	public class Rock extends Sprite
	{
		[Embed(source="../../../data/queens/rock.png")] private var ImgRock:Class;
		
		public var block:RockBlock;
		
		private var _frozen:Boolean=false;
		private var _frozenY:Number;
		
		public function Rock($x:Number, $y:Number):void
		{
			super(ImgRock, $x, $y, false, false);
			block = new RockBlock(this, x, y, width, height, null);
			acceleration.y = 840;
			maxVelocity.x = 20;
			freeze();
		}
		
		public function freeze():void
		{
			_frozen = true;
			_frozenY = y;
		}
		
		override public function hitFloor(block:FlxBlock):Boolean
		{
			acceleration.x = 0;
			velocity.x = 0;
			velocity.y = 0;
			return super.hitFloor(block);
		}
		
		override public function update():void
		{
			acceleration.x = 0;
			if (velocity.y > 40) {
				acceleration.x = 1000;
			}
			super.update();
			block.x = x;
			block.y = y;
		}
	}
}
