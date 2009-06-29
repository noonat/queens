package com.adamatomic.flixel.data
{
	import com.adamatomic.flixel.FlxG;
	import com.adamatomic.flixel.FlxBlock;
	import flash.geom.Point;
	
	//@desc		This is the base class for most of the display objects (FlxSprite, FlxText, etc).  It includes some very simple basic attributes about game objects.
	public class FlxCore
	{
		//@desc	Kind of a global on/off switch for any objects descended from FlxCore
		public var exists:Boolean;
		//@desc	If an object is not alive, the game loop will not automatically call update() on it
		public var active:Boolean;
		//@desc	If an object is not visible, the game loop will not automatically call render() on it
		public var visible:Boolean;
		//@desc	If an object is dead, the functions that automate collisions will skip it (see overlapArrays in FlxSprite and collideArrays in FlxBlock)
		public var dead:Boolean;
		
		//Basic attributes variables
		public var x:Number;
		public var y:Number;
		public var width:uint;
		public var height:uint;
		
		//@desc	A point that can store numbers from 0 to 1 (for X and Y independently) that governs how much this object is affected by the camera subsystem.  0 means it never moves, like a HUD element or far background graphic.  1 means it scrolls along a tthe same speed as the foreground layer.
		public var scrollFactor:Point;
		private var _flicker:Boolean;
		private var _flickerTimer:Number;
		private var _shake:Boolean=false;
		protected var _shakeX:Number=0;
		protected var _shakeY:Number=0;
		private var _shakeAmount:Number=1;
		private var _shakeTimer:Number=0;
		
		//@desc		Constructor
		public function FlxCore()
		{
			exists = true;
			active = true;
			visible = true;
			dead = false;
			
			x = 0;
			y = 0;
			width = 0;
			height = 0;
			
			scrollFactor = new Point(1,1);
			_flicker = false;
			_flickerTimer = -1;
		}
		
		//@desc		Just updates the flickering.  FlxSprite and other subclasses override this to do more complicated behavior.
		virtual public function update():void
		{
			if(flickering())
			{
				if(_flickerTimer > 0) _flickerTimer -= FlxG.elapsed;
				if(_flickerTimer < 0) flicker(-1);
				else
				{
					_flicker = !_flicker;
					visible = !_flicker;
				}
			}
			if (_shake) {
				_shakeTimer -= FlxG.elapsed;
				if (_shakeTimer <= 0) {
					shake(-1);
				}
				else {
					_shakeX = (Math.random()*_shakeAmount*2)-_shakeAmount;
					_shakeY = (Math.random()*_shakeAmount*2)-_shakeAmount;
				}
			}
		}
		
		//@desc		FlxSprite and other subclasses override this to render their materials to the screen
		virtual public function render():void {}
		
		//@desc		Checks to see if some FlxCore object overlaps this FlxCore object
		//@param	Core	The object being tested
		//@return	Whether or not the two objects overlap
		virtual public function overlaps(Core:FlxCore):Boolean
		{
			if((Core.x <= x-Core.width) || (Core.x >= x+width) || (Core.y <= y-Core.height) || (Core.y >= y+height))
				return false;
			return true;
		}
		
		//@desc		Checks to see if a point in 2D space overlaps this FlxCore object
		//@param	X			The X coordinate of the point
		//@param	Y			The Y coordinate of the point
		//@param	PerPixel	Whether or not to use per pixel collision checking (only available in FlxSprite subclass, included here because of Flash's F'd up lack of polymorphism)
		//@return	Whether or not the point overlaps this object
		virtual public function overlapsPoint(X:Number,Y:Number,PerPixel:Boolean = false):Boolean
		{
			if((X <= x) || (X >= x+width) || (Y <= y) || (Y >= y+height))
				return false;
			return true;
		}
		
		//@desc		Called when this object collides with a FlxBlock on one of its sides
		//@return	Whether you wish the FlxBlock to collide with it or not
		virtual public function hitWall(block:FlxBlock):Boolean { return true; }
		
		//@desc		Called when this object collides with the top of a FlxBlock
		//@return	Whether you wish the FlxBlock to collide with it or not
		virtual public function hitFloor(block:FlxBlock):Boolean { return true; }
		
		//@desc		Called when this object collides with the bottom of a FlxBlock
		//@return	Whether you wish the FlxBlock to collide with it or not
		virtual public function hitCeiling(block:FlxBlock):Boolean { return true; }
		
		//@desc		Call this function to "kill" a sprite so that it no longer 'exists'
		virtual public function kill():void
		{
			exists = false;
			dead = true;
		}
		
		//@desc		Tells this object to flicker for the number of seconds requested (0 = infinite, negative number tells it to stop)
		public function flicker(Duration:Number=1):void { _flickerTimer = Duration; if(_flickerTimer < 0) { _flicker = false; visible = true; } }
		
		//@desc		Called when this object collides with the bottom of a FlxBlock
		//@return	Whether the object is flickering or not
		public function flickering():Boolean { return _flickerTimer >= 0; }
		
		public function shake(Duration:Number=1, Amount:Number=1):void {
			_shakeTimer = Duration;
			if (_shakeTimer < 0) {
				_shake = false;
				_shakeX = _shakeY = 0;
			}
			else {
				_shake = true;
				_shakeAmount=Amount;
			}
		}
		
		public function shaking():Boolean {
			return _shake;
		}
		
		//@desc		Call this to check and see if this object is currently on screen
		//@return	Whether the object is on screen or not
		public function onScreen():Boolean
		{
			var p:Point = new Point();
			getScreenXY(p);
			if((p.x + width < 0) || (p.x > FlxG.width) || (p.y + height < 0) || (p.y > FlxG.height))
				return false;
			return true;
		}
		
		//@desc		Call this function to figure out the post-scrolling "screen" position of the object
		//@param	p	Takes a Flash Point object and assigns the post-scrolled X and Y values of this object to it
		virtual protected function getScreenXY(p:Point):void
		{
			p.x = Math.floor(x)+_shakeX+Math.floor(FlxG.scroll.x*scrollFactor.x);
			p.y = Math.floor(y)+_shakeY+Math.floor(FlxG.scroll.y*scrollFactor.y);
		}
	}
}