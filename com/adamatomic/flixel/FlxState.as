package com.adamatomic.flixel
{
	import com.adamatomic.flixel.data.FlxCore;
	import flash.display.Sprite;

	//@desc		This is the basic game "state" object - e.g. in a simple game you might have a menu state and a play state
	public class FlxState extends Sprite
	{
		private var _children:FlxArray;

		//@desc		Constructor		
		virtual public function FlxState()
		{
			FlxG.state = this;
			_children = new FlxArray();
		}
		
		//@desc		Adds a new FlxCore subclass (FlxSprite, FlxBlock, etc) to the game loop
		//@param	Core	The object you want to add to the game loop
		virtual public function add(Core:FlxCore):FlxCore
		{
			return _children.add(Core) as FlxCore;
		}
		
		//@desc		Automatically goes through and calls update on everything you added to the game loop, override this function to handle custom input and perform collisions
		virtual public function update():void
		{
			for(var i:uint = 0; i < _children.length; i++)
				if(_children[i].exists && _children[i].active) _children[i].update();
		}
		
		//@desc		Automatically goes through and calls render on everything you added to the game loop, override this loop to do crazy graphical stuffs I guess?
		virtual public function render():void
		{
			for(var i:uint = 0; i < _children.length; i++)
				if(_children[i].exists && _children[i].visible) _children[i].render();
		}
		
		//@desc		Override this function to handle any deleting or "shutdown" type operations you might need (such as removing traditional Flash children like Sprite objects)
		virtual public function destroy():void { _children.clear(); }
	}
}