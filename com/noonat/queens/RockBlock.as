package com.noonat.queens
{
	import com.adamatomic.flixel.FlxBlock;
	
	public class RockBlock extends FlxBlock
	{
		public var rock:Rock;
		
		public function RockBlock($rock:Rock, X:int,Y:int,Width:uint,Height:uint,TileGraphic:Class,Empties:uint=0):void
		{
			rock = $rock;
			super(X, Y, Width, Height, TileGraphic, Empties);
		}
	}
}
