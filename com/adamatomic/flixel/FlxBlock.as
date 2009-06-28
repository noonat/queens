package com.adamatomic.flixel
{
	import com.adamatomic.flixel.data.FlxCore;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	//@desc		This is the basic "environment object" class, used to create walls and floors
	public class FlxBlock extends FlxCore
	{
		private var _pixels:BitmapData;
		private var _rects:FlxArray;
		private var _tileSize:uint;
		private var _p:Point;
		
		//@desc		Constructor
		//@param	X			The X position of the block
		//@param	Y			The Y position of the block
		//@param	Width		The width of the block
		//@param	Height		The height of the block
		//@param	TileGraphic The graphic class that contains the tiles that should fill this block
		//@param	Empties		The number of "empty" tiles to add to the auto-fill algorithm (e.g. 8 tiles + 4 empties = 1/3 of block will be open holes)
		public function FlxBlock(X:int,Y:int,Width:uint,Height:uint,TileGraphic:Class,Empties:uint=0)
		{
			super();
			x = X;
			y = Y;
			width = Width;
			height = Height;
			if(TileGraphic == null)
				return;

			_pixels = FlxG.addBitmap(TileGraphic);
			_rects = new FlxArray();
			_p = new Point();
			_tileSize = _pixels.height;
			var widthInTiles:uint = Math.ceil(width/_tileSize);
			var heightInTiles:uint = Math.ceil(height/_tileSize);
			width = widthInTiles*_tileSize;
			height = heightInTiles*_tileSize;
			var numTiles:uint = widthInTiles*heightInTiles;
			var numGraphics:uint = _pixels.width/_tileSize;
			for(var i:uint = 0; i < numTiles; i++)
			{
				if(Math.random()*(numGraphics+Empties) > Empties)
					_rects.push(new Rectangle(_tileSize*Math.floor(Math.random()*numGraphics),0,_tileSize,_tileSize));
				else
					_rects.push(null);
			}
		}
		
		//@desc		Draws this block
		override public function render():void
		{
			if(!visible)
				return;
			getScreenXY(_p);
			var opx:int = _p.x;
			for(var i:uint = 0; i < _rects.length; i++)
			{
				if(_rects[i] != null) FlxG.buffer.copyPixels(_pixels,_rects[i],_p,null,null,true);
				_p.x += _tileSize;
				if(_p.x >= opx + width)
				{
					_p.x = opx;
					_p.y += _tileSize;
				}
			}
		}
		
		//@desc		Collides a FlxSprite against this block
		//@param	Spr		The FlxSprite you want to check
		public function collide(Spr:FlxSprite):void
		{
			if((Math.abs(Spr.x + (Spr.width>>1) - x - (width>>1)) > (width>>1) + (Spr.width>>1)) && (Math.abs(Spr.y + (Spr.height>>1) - y - (height>>1)) > (height>>1) + (Spr.height>>1)))
				return;
			
			var yFirst:Boolean = true;
			if((Math.abs(Spr.velocity.x) > Math.abs(Spr.velocity.y)))
				yFirst = false;
			
			var checkForMoreX:Boolean = false;
			var checkForMoreY:Boolean = false;
			if(yFirst)
			{
				if(Spr.velocity.y > 0)
				{
					if(overlapsPoint(Spr.x + (Spr.width>>1),Spr.y + Spr.height))
					{
						if(Spr.hitFloor())
							Spr.y = y - Spr.height;
					}
					else
						checkForMoreY = true;
				}
				else if(Spr.velocity.y < 0)
				{
					if(overlapsPoint(Spr.x + (Spr.width>>1),Spr.y))
					{
						if(Spr.hitCeiling())
							Spr.y = y + height;
					}
					else
						checkForMoreY = true;
				}

				if(Spr.velocity.x < 0)
				{
					if(overlapsPoint(Spr.x,Spr.y + (Spr.height>>1)))
					{
						if(Spr.hitWall())
							Spr.x = x + width;
					}
					else
						checkForMoreX = true;
				}
				else if(Spr.velocity.x > 0)
				{
					if(overlapsPoint(Spr.x + Spr.width,Spr.y + (Spr.height>>1)))
					{
						if(Spr.hitWall())
							Spr.x = x - Spr.width;
					}
					else
						checkForMoreX = true;
				}
			}
			else
			{
				if(Spr.velocity.x < 0)
				{
					if(overlapsPoint(Spr.x,Spr.y + (Spr.height>>1)))
					{
						if(Spr.hitWall())
							Spr.x = x + width;
					}
					else
						checkForMoreX = true;
				}
				else if(Spr.velocity.x > 0)
				{
					if(overlapsPoint(Spr.x + Spr.width,Spr.y + (Spr.height>>1)))
					{
						if(Spr.hitWall())
							Spr.x = x - Spr.width;
					}
					else
						checkForMoreX = true;
				}
				
				if(Spr.velocity.y > 0)
				{
					if(overlapsPoint(Spr.x + (Spr.width>>1),Spr.y + Spr.height))
					{
						if(Spr.hitFloor())
							Spr.y = y - Spr.height;
					}
					else
						checkForMoreY = true;
				}
				else if(Spr.velocity.y < 0)
				{
					if(overlapsPoint(Spr.x + (Spr.width>>1),Spr.y))
					{
						if(Spr.hitCeiling())
							Spr.y = y + height;
					}
					else
						checkForMoreY = true;
				}
			}
			
			if(!checkForMoreY && !checkForMoreX)
				return;
			var bias:int = Spr.width>>3;
			if(bias < 1)
				bias = 1;
			if(checkForMoreY && checkForMoreX)
			{				
				if(yFirst)
				{
					if(checkForMoreY)
					{
						if((Spr.x + Spr.width - bias > x) && (Spr.x + bias < x + width))
						{
							if((Spr.velocity.y > 0) && (Spr.y + Spr.height > y) && (Spr.y + Spr.height < y + height) && Spr.hitFloor())
								Spr.y = y - Spr.height;
							else if((Spr.velocity.y < 0) && (Spr.y > y) && (Spr.y < y + height) && Spr.hitCeiling())
								Spr.y = y + height;
						}
					}
					if(checkForMoreX)
					{
						if((Spr.y + Spr.height - bias > y) && (Spr.y + bias < y + height))
						{
							if((Spr.velocity.x > 0) && (Spr.x + Spr.width > x) && (Spr.x + Spr.width < x + width) && Spr.hitWall())
								Spr.x = x - Spr.width;
							else if((Spr.velocity.x < 0) && (Spr.x > x) && (Spr.x < x + width) && Spr.hitWall())
								Spr.x = x + width;
						}
					}
				}
				else
				{
					if(checkForMoreX)
					{
						if((Spr.y + Spr.height - bias > y) && (Spr.y + bias < y + height))
						{
							if((Spr.velocity.x > 0) && (Spr.x + Spr.width > x) && (Spr.x + Spr.width < x + width) && Spr.hitWall())
								Spr.x = x - Spr.width;
							else if((Spr.velocity.x < 0) && (Spr.x > x) && (Spr.x < x + width) && Spr.hitWall())
								Spr.x = x + width;
						}
					}
					if(checkForMoreY)
					{
						if((Spr.x + Spr.width - bias > x) && (Spr.x + bias < x + width))
						{
							if((Spr.velocity.y > 0) && (Spr.y + Spr.height > y) && (Spr.y + Spr.height < y + height) && Spr.hitFloor())
								Spr.y = y - Spr.height;
							else if((Spr.velocity.y < 0) && (Spr.y > y) && (Spr.y < y + height) && Spr.hitCeiling())
								Spr.y = y + height;
						}
					}
				}
			}
			else if(checkForMoreY)
			{
				if((Spr.x + Spr.width - bias > x) && (Spr.x + bias < x + width))
				{
					if((Spr.velocity.y > 0) && (Spr.y + Spr.height > y) && (Spr.y + Spr.height < y + height) && Spr.hitFloor())
						Spr.y = y - Spr.height;
					else if((Spr.velocity.y < 0) && (Spr.y > y) && (Spr.y < y + height) && Spr.hitCeiling())
						Spr.y = y + height;
				}
			}
			else if(checkForMoreX)
			{
				if((Spr.y + Spr.height - bias > y) && (Spr.y + bias < y + height))
				{
					if((Spr.velocity.x > 0) && (Spr.x + Spr.width > x) && (Spr.x + Spr.width < x + width) && Spr.hitWall())
						Spr.x = x - Spr.width;
					else if((Spr.velocity.x < 0) && (Spr.x > x) && (Spr.x < x + width) && Spr.hitWall())
						Spr.x = x + width;
				}
			}
		}
		
		//@desc		Collides a FlxSprite against an array of FlxBlock objects
		//@param	Blocks		A FlxArray of FlxBlock objects
		//@param	Sprite		The FlxSprite object you want to check
		static public function collideArray(Blocks:FlxArray,Sprite:FlxSprite):void
		{
			if(!Sprite.exists || Sprite.dead) return;
			for(var i:uint = 0; i < Blocks.length; i++)
				Blocks[i].collide(Sprite);
		}
		
		//@desc		Collides an array of FlxSprites against an array of FlxBlock objects
		//@param	Blocks		A FlxArray of FlxBlock objects
		//@param	Sprites		A FlxArray of FlxSprite objects
		static public function collideArrays(Blocks:FlxArray,Sprites:FlxArray):void
		{
			for(var i:uint = 0; i < Blocks.length; i++)
				for(var j:uint = 0; j < Sprites.length; j++)
				{
					if(!Sprites[j].exists || Sprites[j].dead) continue;
					Blocks[i].collide(Sprites[j]);
				}
		}
	}
}