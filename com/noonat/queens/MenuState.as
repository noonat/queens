package com.noonat.queens
{
	import com.adamatomic.flixel.FlxArray;
	import com.adamatomic.flixel.FlxBlock;
	import com.adamatomic.flixel.FlxButton;
	import com.adamatomic.flixel.FlxEmitter;
	import com.adamatomic.flixel.FlxG;
	import com.adamatomic.flixel.FlxSprite;
	import com.adamatomic.flixel.FlxState;
	import com.adamatomic.flixel.FlxText;
	import com.noonat.queens.PlayState;

	public class MenuState extends FlxState
	{
		[Embed(source="../../../data/queens/wall_bricks.png")] private var ImgWallBricks:Class;
		[Embed(source="../../../data/cursor.png")] private var ImgCursor:Class;
		
		private static var _firstTime:Boolean=true;
		private var _b:FlxButton;
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
			FlxG.setCursor(ImgCursor);
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
					this.add(new FlxBlock(0, 0, FlxG.width, FlxG.height, ImgWallBricks));
					_title = this.add(new FlxText(0, 70, FlxG.width, 80, "queens", 0xffcccccc, null, 32, "center")) as FlxText;
					this.add(new FlxText(170, 120, 110, 20, "by noonat", 0xff666666, null, 8, "left"));
					
					this.add(new FlxText(120, 200, 110, 20, "PRESS X TO PLAY", 0x8db0d4, null, 8, "left"));
					if (_firstTime) {
						_firstTime = false;
						_b = this.add(new FlxButton(
							110, 200,
							new FlxSprite(null, 0, 0, false, false, 104, 15, 0xff102233),
							onButton,
							new FlxSprite(null, 0, 0, false, false, 104, 15, 0xff223c54),
							new FlxText(25, 1, 100, 10, "CLICK HERE", 0x7b92af),
							new FlxText(25, 1, 100, 10, "CLICK HERE", 0x8db0d4))) as FlxButton;
					}
				}
			}
			if (FlxG.justPressed(FlxG.A)) {
				FlxG.switchState(PlayState);
			}
			super.update();
		}

		private function onButton():void
		{
			_b.visible = false;
		}
	}
}
