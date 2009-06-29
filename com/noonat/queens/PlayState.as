package com.noonat.queens
{
	import com.adamatomic.flixel.FlxArray;
	import com.adamatomic.flixel.FlxBlock;
	import com.adamatomic.flixel.FlxG;
	import com.adamatomic.flixel.FlxSprite;
	import com.adamatomic.flixel.FlxState;
	import com.adamatomic.flixel.FlxText;
	
	public class PlayState extends FlxState
	{
		[Embed(source="../../../data/queens/dirt8.png")] private var ImgDirt:Class;
		[Embed(source="../../../data/queens/dirt_fringe.png")] private var ImgDirtFringe:Class;
		[Embed(source="../../../data/queens/dirt_objects.png")] private var ImgDirtObjects:Class;
		[Embed(source="../../../data/queens/roof_bricks.png")] private var ImgRoofBricks:Class;
		[Embed(source="../../../data/queens/roof_bricks2.png")] private var ImgRoofBricks2:Class;
		[Embed(source="../../../data/queens/roof_bricks3.png")] private var ImgRoofBricks3:Class;
		[Embed(source="../../../data/queens/roof_fringe.png")] private var ImgRoofFringe:Class;
		[Embed(source="../../../data/queens/wall_bricks.png")] private var ImgWallBricks:Class;
		[Embed(source="../../../data/queens/wall_bricks_fade.png")] private var ImgWallBricksFade:Class;
		
		private static var _playCount:int = 0;
		
		private var _arrows:FlxArray;
		private var _blocks:FlxArray;
		private var _platforms:FlxArray;
		private var _roofSpikes:FlxArray;
		private var _time:Number = 0;
		
		private var _king:King;
		private var _queen:Queen;
		private var _queenNames:Array = [
			"Abbatissa", "Abelota", "Achethe", "Ade", "Admiranda", "Agnes", "Aicusa",
			"Akelda", "Alainne", "Alba", "Albiona", "Aleusa", "Alice", "Alma", "Alsneta", "Andrie", "Angelet",
			"Angharad", "Anglides", "Anna", "Anthoinette", "Argante", "Astolat", "Atilda", "Avarona", "Avice",
			"Avilon", "Avoca", "Aysta", "Badelota", "Bausanne", "Bauteut", "Beatrice", "Bedegrayne", "Bedeluue",
			"Belakane", "Bencelina", "Berte", "Bertha", "Blancheflor", "Blissot", "Blitha",
			"Boime", "Branwyn", "Brise", "Calla", "Camilla", "Celestine",
			"Chelinda", "Clarine", "Cotovatre",
			"Dametta", "Damisona", "Deloys", "Desdemona",
			"Devonny", "Dinae",
			"Durilda", "Elaine", "Elaisse", "Ellerete", "Elsa",
			"Emeria", "Emma", "Enid", "Enide", "Enota", "Esa", "Eschiva", "Esdeline", "Estienne",
			"Estrangia", "Ettare", "Eugenia", "Eustachia", "Extranea", "Fina", "Finepopla", "Fortunata",
			"Fousafia", "Galiene", "Ganieda", "Gemma", "Gerbaga", "Germainne", "Gersendis", "Ginnade", "Giraude",
			"Gladuse", "Golla", "Grainne", "Guenloie", "Gvenour", "Gwenddydd",
			"Gwendolen", "Gwendoloena", "Gwenhwyfach", "Helmeth", "Helsin", "Helvynya", "Herzeloyde", "Hesse",
			"Hextilda", "Houdee", "Iblis", "Igerne", "Igrayne", "Ilene", "Imedia", "Isabella", "Isolde", "Isoude",
			"Italia", "Jeromia", "Jessamine", "Joanenna", "Josiane", "Jourdenete", "Juliana",
			"Justina", "Keina", "Kemma", "Kiena", "Kima", "Kinna", "Kymme", "Laudine", "Lausanne", "Leda", "Legarda",
			"Lena", "Letselina", "Lia", "Libourc", "Lictina", "Lidoine", "Ligarda", "Lige", "Lindara", "Llamrei", "Lota",
			"Lunet", "Lunete", "Lynelle", "Lynessa", "Lynley", "Lynnette", "Lyonesse", "Lyonet", "Lyonors", "Lysanor",
			"Magestya", "Margawse", "Maronne", "Marsilia", "Martine", "Matilda", "Maxencia", "Mazelina",
			"Melodie", "Melusine", "Michiele", "Minnota", "Mique", "Mitri", "Modron", "Morcades", "Morgawse",
			"Morguase", "Nicia", "Nimiane", "Nimue", "Nineve", "Noblete", "Nog", "Norma", "Nycaise", "Nyneve", "Olwyn",
			"Optata", "Oreute", "Orguelleuse", "Ottilia", "Pandonia", "Parise", "Parisete",
			"Pasques", "Paulina", "Pechel", "Philomena", "Plente", "Popelina",
			"Precious", "Pridwyn", "Primaveira", "Primeveire", "Pronele", "Prydwyn", "Quinevere", "Ragnall",
			"Raieyana", "Rametta", "Roana", "Roberge", "Rogerete", "Rohesia", "Salerna", "Saveage", "Sebille",
			"Sewenna", "Shalott", "Sigune", "Soredamors", "Souplice", "Splendora", "Sreda", "Swale",
			"Thangustella", "Tryamon", "Udeline", "Urie", "Viviane", "Vivien", "Watcelina", "Wenhaver",
			"Wimarc", "Wimarca", "Ygeme", "Ygraine", "Ynstauncia", "Ysane", "Ysenda", "Ysolde", "Ysopa", "Ysoria"];
		
		override public function PlayState():void
		{
			super();
			
			_playCount++;
			
			var i:int = Math.floor(Math.random()*_queenNames.length);
			var nameText:FlxText = new FlxText(0, 150, 320, 80, "queen " + _queenNames[i].toLowerCase(), 0xff1e2016, null, 24, "center");
			nameText.scrollFactor.x = 0.7;
			this.add(nameText);
			
			_queen = new Queen(72, 10); // 400,100
			FlxG.follow(_queen, 2.5);
			_king = new King(80, 10);
			_king.facing(false);
			
			_arrows = new FlxArray();
			_blocks = new FlxArray();
			_platforms = new FlxArray();
			_roofSpikes = new FlxArray();
			
			// upper castle
			this.add(new FlxBlock(32, 40, 32, 16, ImgWallBricks));
			this.add(new FlxBlock(32, 56, 32, 8, ImgWallBricksFade));
			this.add(new FlxBlock(0, -248, 960, 280, ImgWallBricks));
			this.addRoofBlock(0, 32);
			this.addRoofBlock(64, 960);
			
			// screen 1
			this.addDirtBlock(0, _playCount==1?96:98); //s1p1
			this.addDirtBlock(160, 192); //s1p2
			this.addDirtBlock(224, 320); //s1p3
			this.addDirtBlock(320, 396, -56); // s1p3step1
			this.addDirtBlock(396, 576, -80); // s1p3step2
			this.addRoofSpike(160, 1.0);
			this.addRoofSpike(180);
			this.addRoofSpike(200).maxVelocity.y = 10000;
			this.addRoofSpike(240, 0.0, 24);
			
			// screen 2
			this.addArrowShooter(544, -112, -80, 0.25);
			this.addArrowShooter(544, -96, -80, 1.25);
			_platforms.add(this.add(new Platform(650, 200, 32, 8, Platform.AXIS_X, -1, 625, 725, 40, 2)));
			_platforms.add(this.add(new Platform(800, 170, 32, 8, Platform.AXIS_X, 1, 800, 900, 40, 2)));
			this.addRoofSpike(740);
			this.addRoofSpike(805);
			
			this.add(_king);
			this.add(_queen);
		}
		
		public function addArrowShooter(x:Number, y:Number, y2:Number, timer:Number=-1):ArrowShooter
		{
			y += 240;
			_blocks.add(new FlxBlock(x, y, 16, 16, null));
			return this.add(new ArrowShooter(x, y, _arrows, _queen, timer)) as ArrowShooter;
		}
		
		public function addDirtBlock(x:Number, x2:Number, y:Number=-32, y2:Number=0, fringe:Boolean=true, objects:Boolean=true):void
		{
			y += 240;
			y2 += 240;
			var w:Number = x2-x;
			var h:Number = y2-y;
			_blocks.add(this.add(new FlxBlock(x, y, w, h, ImgDirt)));
			if (fringe) {
				this.add(new FlxBlock(x, y-32, Math.floor(w/32)*32, 32, ImgDirtFringe));
			}
			if (objects) {
				w -= 16;
				h -= 16;
				if (w >= 8 && h >= 8) {
					x += 8;
					y += 8;
				}
				this.add(new FlxBlock(x, y, w, h, ImgDirtObjects, 8));
			}
		}
		
		public function addRoofBlock(x:Number, x2:Number):void
		{
			var w:Number = x2-x;
			_blocks.add(this.add(new FlxBlock(x, 24, w, 16, ImgRoofBricks)));
			this.add(new FlxBlock(x, 40, w, 8, ImgRoofBricks2));
			this.add(new FlxBlock(x, 48, w, 8, ImgRoofBricks3));
			this.add(new FlxBlock(x, 56, w, 8, ImgRoofFringe));
		}
		
		public function addRoofSpike(x:Number, shakeTime:Number=0.2, triggerDistance:Number=4, y:Number=56):RoofSpike
		{
			var spike:RoofSpike = new RoofSpike(_queen, x, y, shakeTime, triggerDistance);
			_roofSpikes.add(this.add(spike));
			return spike;
		}
		
		public function arrowHitQueen(arrow:Arrow, queen:Queen):void
		{
			queen.kill();
		}
		
		public function spikeHitQueen(spike:RoofSpike, queen:Queen):void
		{
			queen.kill();
			queen.acceleration.x = 0;
			queen.acceleration.y = 2000;
		}
		
		override public function update():void
		{
			var x:Number = Math.floor(_queen.x / 480) * 480;
			FlxG.followBounds(x, -240, x + 480, 240);
			_time += FlxG.elapsed;
			super.update();
			var dead:Boolean = _queen.dead;
			_queen.dead = false;
			FlxBlock.collideArray(_blocks, _queen);
			FlxBlock.collideArray(_platforms, _queen);
			_queen.dead = dead;
			FlxBlock.collideArray(_blocks, _king);
			FlxBlock.collideArrays(_blocks, _roofSpikes);
			FlxSprite.overlapArray(_roofSpikes, _queen, spikeHitQueen);
			FlxSprite.overlapArray(_arrows, _queen, arrowHitQueen);
		}
	}
}