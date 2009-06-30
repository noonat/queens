package {
	import com.adamatomic.flixel.FlxGame;
	import com.noonat.queens.MenuState;
	import com.noonat.queens.PlayState;
	
	[SWF(width="640", height="480", backgroundColor="#000000")]
	[Frame(factoryClass="Preloader")]

	public class Queens extends FlxGame
	{
		public function Queens():void
		{
			super(320, 240, MenuState, 2, 0xff0f110b, 0xffffffff);
			help("Jump", "Unused", "Unused");
		}
	}
}
