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
			if (x+width < -FlxG.followMin.x || x > -FlxG.followMax.x+FlxG.width ||
				y+height < -FlxG.followMin.y || y > -FlxG.followMax.y+FlxG.height) {
				return false;
			}
			else {
				return true;
			}
		}
	}
}