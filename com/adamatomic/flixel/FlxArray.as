package com.adamatomic.flixel
{
	import com.adamatomic.flixel.data.FlxCore;
	
	//@desc		This class wraps the normal Flash array and adds a couple of extra functions...
	dynamic public class FlxArray extends Array
	{
		//@desc		Constructor
		public function FlxArray()
		{
			super();
		}

		//@desc		Picks an entry at random from an array
		//@param	Arr		The array you want to pick the object from
		//@return	Any object
		static public function getRandom(Arr:Array):Object
		{
			return Arr[Math.floor(Math.random()*Arr.length)];
		}
		
		//@desc		Find the first entry in the array that doesn't "exist"
		//@return	Anything based on FlxCore (FlxSprite, FlxText, FlxBlock, etc)
		public function getNonexist():FlxCore
		{
			var i:uint = 0;
			do
			{
				if(!(this[i] as FlxCore).exists)
					return this[i];
			} while (++i < this.length);
			return null;
		}
		
		//@desc		Add an object to this array
		//@param	Obj		The object you want to add to the array
		//@return	Just returns the object you passed in in the first place
		public function add(Obj:Object):Object
		{
			for(var i:uint = 0; i < this.length; i++)
				if(this[i] == null)
					return this[i] = Obj;
			return this[this.push(Obj)-1];
		}
		
		//@desc		Remove any FlxCore-based object (FlxSprite, FlxText, etc) from this array
		//@param	Core	The object you want to remove from this array
		//@param	ForceDelete		Whether or not to set this entry to null, or just set to not "exist"
		public function remove(Core:FlxCore,ForceDelete:Boolean=false):void
		{
			removeAt(indexOf(Core),ForceDelete);
		}
		
		//@desc		Remove any FlxCore-based object (FlxSprite, FlxText, etc) from this array
		//@param	Index	The entry in the array that you want to delete
		//@param	ForceDelete		Whether or not to set this entry to null, or just set to not "exist"
		public function removeAt(Index:uint,ForceDelete:Boolean=false):void
		{
			if(ForceDelete)
			{
				delete this[Index];
				this[Index] = null;
			}
			else if(this[Index] is FlxCore)
				this[Index].kill();
		}
		
		//@desc		Pops every entry out of the array
		public function clear():void
		{
			for(var i:int = this.length-1; i >= 0; i--)
				this.pop();
		}
	}
}