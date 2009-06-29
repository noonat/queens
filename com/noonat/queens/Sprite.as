package com.noonat.queens
{
	import com.adamatomic.flixel.FlxG;
	import com.adamatomic.flixel.FlxSprite;
	
	public class Sprite extends FlxSprite
	{
		public function Sprite($graphic:Class=null, $x:int=0, $y:int=0, $animated:Boolean=false, $reverse:Boolean=false, $width:uint=0, $height:uint=0, $color:uint=0)
		{
			super($graphic, $x, $y, $animated, $reverse, $width, $height, $color);
		}
		
		public function inFollowBounds():Boolean
		{
			if (x+width < -FlxG.followMin.x || x > -FlxG.followMin.x+480 ||
				y+height < -240 || y > 240) {
				return false;
			}
			else {
				return true;
			}
		}
	}
}