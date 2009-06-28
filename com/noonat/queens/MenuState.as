package com.noonat.queens
{
	import com.adamatomic.flixel.FlxArray;
	import com.adamatomic.flixel.FlxButton;
	import com.adamatomic.flixel.FlxEmitter;
	import com.adamatomic.flixel.FlxG;
	import com.adamatomic.flixel.FlxSprite;
	import com.adamatomic.flixel.FlxState;
	import com.adamatomic.flixel.FlxText;
	import com.noonat.queens.PlayState;

	public class MenuState extends FlxState
	{
		private var _bg:FlxSprite;
		private var _fading:Boolean;
		private var _fadingTime:Number;
		private var _title:FlxText;
		private var _pressedA:Boolean;
		private var _pressedB:Boolean;
		
		override public function MenuState():void
		{
			super();
			_fading = false;
			_fadingTime = 1.2;
		}
		
		override public function update():void
		{
			if (!_fading) {
				_fading = true;
				FlxG.fade(0xffffffff, 1.0);
			}
			if (_fadingTime > 0) {
				_fadingTime -= FlxG.elapsed;
				if (_fadingTime < 0) {
					FlxG.fade(0);
					FlxG.flash(0xffffffff, 1);
					_bg = this.add(new FlxSprite(null, 0, 0, false, false, FlxG.width, FlxG.height, 0xffff1133)) as FlxSprite;
					_title = this.add(new FlxText((FlxG.width/2)-70, 80, 140, 80, "queens", 0xffffffff, null, 32)) as FlxText;
				}
			}
			if (FlxG.kA) {
				_pressedA = true;
			}
			if (FlxG.kB) {
				_pressedB = true;
			}
			if (_pressedA && _pressedB) {
				FlxG.switchState(PlayState);
			}
			super.update();
		}
		
		/*
		override public function update():void
		{
			//Slides the text ontot he screen
			var t1m:uint = FlxG.width/2-54;
			if(_t1.x > t1m)
			{
				_t1.x -= FlxG.elapsed*FlxG.width;
				if(_t1.x < t1m) _t1.x = t1m;
			}
			var t2m:uint = FlxG.width/2+6;
			if(_t2.x < t2m)
			{
				_t2.x += FlxG.elapsed*FlxG.width;
				if(_t2.x > t2m) _t2.x = t2m;
			}
			
			//Check to see if the text is in position
			if(!_ok && ((_t1.x == t1m) || (_t2.x == t2m)))
			{
				//explosion
				_ok = true;
				FlxG.play(SndHit);
				FlxG.flash(0xffd8eba2,0.5);
				FlxG.quake(0.035,0.5);
				_t1.setColor(0xd8eba2);
				_t2.setColor(0xd8eba2);
				_e.reset();
				_t1.angle = Math.random()*40-20;
				_t2.angle = Math.random()*40-20;
				
				this.add(new FlxText(t1m,FlxG.height/3+39,110,20,"by Adam Atomic",0x3a5c39,null,8,"center"));
				
				//flixel button
				this.add(new FlxSprite(null,t1m+1,FlxG.height/3+53,false,false,106,19,0xff131c1b));
				this.add(new FlxButton(t1m+2,FlxG.height/3+54,new FlxSprite(null,0,0,false,false,104,15,0xff3a5c39),onFlixel,new FlxSprite(null,0,0,false,false,104,15,0xff729954),new FlxText(15,1,100,10,"www.flixel.org",0x729954),new FlxText(15,1,100,10,"www.flixel.org",0xd8eba2)));
				
				//danny B button
				this.add(new FlxSprite(null,t1m+1,FlxG.height/3+75,false,false,106,19,0xff131c1b));
				this.add(new FlxButton(t1m+2,FlxG.height/3+76,new FlxSprite(null,0,0,false,false,104,15,0xff3a5c39),onDanny,new FlxSprite(null,0,0,false,false,104,15,0xff729954),new FlxText(8,1,100,10,"music by danny B",0x729954),new FlxText(8,1,100,10,"music by danny B",0xd8eba2)));
				
				//play button
				this.add(new FlxSprite(null,t1m+1,FlxG.height/3+137,false,false,106,19,0xff131c1b));
				this.add(new FlxText(t1m,FlxG.height/3+139,110,20,"PRESS X+C TO PLAY",0x729954,null,8,"center"));
				_b = this.add(new FlxButton(t1m+2,FlxG.height/3+138,new FlxSprite(null,0,0,false,false,104,15,0xff3a5c39),onButton,new FlxSprite(null,0,0,false,false,104,15,0xff729954),new FlxText(25,1,100,10,"CLICK HERE",0x729954),new FlxText(25,1,100,10,"CLICK HERE",0xd8eba2))) as FlxButton;
			}
			
			//X + C were pressed, fade out and change to play state
			if(_ok && !_ok2 && FlxG.kA && FlxG.kB)
			{
				_ok2 = true;
				FlxG.play(SndHit2);
				FlxG.flash(0xffd8eba2,0.5);
				FlxG.fade(0xff131c1b,1,onFade);
			}

			super.update();
		}
		
		private function onFlixel():void
		{
			FlxG.openURL("http://flixel.org");
		}
		
		private function onDanny():void
		{
			FlxG.openURL("http://dbsoundworks.com");
		}
		
		private function onButton():void
		{
			_b.visible = false;
			FlxG.play(SndHit2);
		}
		
		private function onFade():void
		{
			//FlxG.switchState(PlayState);
		}
		*/
	}
}
