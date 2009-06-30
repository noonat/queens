package com.noonat.queens
{
	import com.adamatomic.flixel.FlxArray;
	import com.adamatomic.flixel.FlxBlock;
	import com.adamatomic.flixel.FlxEmitter;
	import com.adamatomic.flixel.FlxG;
	import com.adamatomic.flixel.FlxSprite;
	import com.adamatomic.flixel.FlxState;
	import com.adamatomic.flixel.FlxText;
	
	public class PlayState extends FlxState
	{
		[Embed(source="../../../data/queens/crusher.png")] private var ImgCrusher:Class;
		[Embed(source="../../../data/queens/dirt8.png")] private var ImgDirt:Class;
		[Embed(source="../../../data/queens/dirt_fringe.png")] private var ImgDirtFringe:Class;
		[Embed(source="../../../data/queens/dirt_objects.png")] private var ImgDirtObjects:Class;
		[Embed(source="../../../data/queens/glow.png")] private var ImgGlow:Class;
		[Embed(source="../../../data/queens/bridge.mp3")] private var SndBridge:Class;
		[Embed(source="../../../data/queens/platform_wide.png")] private var ImgPlatformWide:Class;
		[Embed(source="../../../data/queens/roof_bricks.png")] private var ImgRoofBricks:Class;
		[Embed(source="../../../data/queens/roof_brick_4px.png")] private var ImgRoofBricks4px:Class;
		[Embed(source="../../../data/queens/roof_bricks_dark.png")] private var ImgRoofBricksDark:Class;
		[Embed(source="../../../data/queens/roof_bricks_dark_bloody.png")] private var ImgRoofBricksDarkBloody:Class;
		[Embed(source="../../../data/queens/roof_bricks_dark_large.png")] private var ImgRoofBricksDarkLarge:Class;
		[Embed(source="../../../data/queens/roof_bricks2.png")] private var ImgRoofBricks2:Class;
		[Embed(source="../../../data/queens/roof_bricks3.png")] private var ImgRoofBricks3:Class;
		[Embed(source="../../../data/queens/roof_fringe.png")] private var ImgRoofFringe:Class;
		[Embed(source="../../../data/queens/wall_bricks.png")] private var ImgWallBricks:Class;
		[Embed(source="../../../data/queens/rock_gibs.png")] private var ImgRockGibs:Class;
		[Embed(source="../../../data/queens/wall_bricks_fade.png")] private var ImgWallBricksFade:Class;
		[Embed(source="../../../data/queens/explode.mp3")] private var SndExplode:Class;
		[Embed(source="../../../data/queens/gear.png")] private var ImgGear:Class;
		[Embed(source="../../../data/queens/gear2.png")] private var ImgGear2:Class;
		
		public static var _playCount:int = 0;
		
		private var _arrows:FlxArray;
		private var _blocks:FlxArray;
		private var _bridge:FlxBlock;
		private var _bridgeGibs:FlxEmitter=null;
		private var _crushers:FlxArray;
		private var _gears1:FlxArray;
		private var _gears2:FlxArray;
		private var _platforms:FlxArray;
		private var _roofSpikes:FlxArray;
		private var _time:Number = 0;
		public var broken:Boolean = false;
		private var _preBroken:FlxArray;
		private var _preBrokenNoCollide:FlxArray;
		private var _postBroken:FlxArray;
		
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
			"Lena", "Letselina", "Lia", "Libourc", "Lidoine", "Ligarda", "Lige", "Lindara", "Llamrei", "Lota",
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
		private var _rock:Rock;
		
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
			_king = new King(_queen, 80, 10);
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
			_blocks.add(new FlxBlock(-32, 0, 32, 240, null));
			this.addDirtBlock(0, _playCount==1?97:98); //s1p1
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
			_platforms.add(this.add(new Platform(650, 200, 32, 8, Platform.AXIS_X, -1, 625, 725, 40, 2)));
			_platforms.add(this.add(new Platform(800, 170, 32, 8, Platform.AXIS_X, 1, 800, 900, 40, 2)));
			this.addRoofSpike(740);
			this.addRoofSpike(805);
			
			// screen 3
			this.addDirtBlock(940, 1024);
			this.addCaveBlock(1056, -240, 384, 560, ImgRoofBricksDark, false); // background tiles
			this.addCaveBlock(1056, -240, 384, 560, ImgRoofBricksDarkLarge, false, 4); // large background tiles
			
			this.addCaveBlock(1152, -240, 288, 128, ImgRoofBricks); // roof <
			_blocks.add(this.add(new FlxBlock(1160, -64, 8, 4, ImgRoofBricks4px)));
			_blocks.add(this.add(new FlxBlock(1160, -28, 8, 4, ImgRoofBricks4px)));
			_rock = this.add(new Rock(1312, -112)) as Rock; // rock
			this.addCaveBlock(1168, -96, 144, 72, ImgRoofBricks); // rock platform
			this.addCaveBlock(1312, -96, 32, 32, ImgRoofBricks); // left of rock drop
			this.addCaveBlock(1376, -112, 26, 48, ImgRoofBricks); // right of rock drop
			
			this.addCaveBlock(1040, -240, 112, 368, ImgRoofBricks); // roof <
			this.addCaveBlock(1152, 0, 160, 128, ImgRoofBricks); // roof <
			_blocks.add(this.add(new FlxBlock(1312, 28, 8, 4, ImgRoofBricks4px)));
			_blocks.add(this.add(new FlxBlock(1312, 60, 8, 4, ImgRoofBricks4px)));
			_blocks.add(this.add(new FlxBlock(1312, 92, 8, 4, ImgRoofBricks4px)));
			_blocks.add(this.add(new FlxBlock(1312, 124, 8, 4, ImgRoofBricks4px)));
			this.addCaveBlock(1408, -112, 32, 240, ImgRoofBricks); // roof >
			
			this.addCaveBlock(1328, 168, 16, 16, ImgRoofBricks); // bridge
			_bridge = this.addCaveBlock(1344, 160, 64, 24, ImgRoofBricks, false); // bridge
			//_bridge.kill();
			this.addCaveBlock(1024, 192, 64, 48, ImgRoofBricks); // floor steps
			this.addCaveBlock(1088, 176, 256, 80, ImgRoofBricks); // floor <
			this.addCaveBlock(1408, 160, 32, 80, ImgRoofBricks); // floor >
			
			// screen 4
			_preBroken = new FlxArray();
			_preBrokenNoCollide = new FlxArray();
			_postBroken = new FlxArray();
			_crushers = new FlxArray();
			for (i = 0; i < 6; i++) {
				var plt:Platform = new Platform(
					1464 + (i * 48), 160-128 + Math.floor(Math.random()*64), 32, 64,
					Platform.AXIS_Y, Math.floor(Math.random() * 2) ? -1 : 1, 160-128, 160-64,
					[150, 900 + Math.random()*200], Math.random() * 0.2 + 0.1, ImgCrusher);
				_crushers.add(this.add(plt));
			}
			var spr:FlxSprite;
			_gears1 = new FlxArray();
			for (i=0; i < 11; i++) {
				spr = new FlxSprite(ImgGear2, 1464 + i * 40, 285);
				spr.angularAcceleration = 5;
				this.add(spr);
				_gears1.add(spr);
			}
			_gears2 = new FlxArray();
			for (i=0; i < 10; i++) {
				spr = new FlxSprite(ImgGear, 1488 + i * 40, 285);
				spr.angularAcceleration = 10;
				this.add(spr);
				_gears2.add(spr);
			}
			this.add(new FlxBlock(1696, 96, 64, 64, ImgGlow));
			this.add(new FlxBlock(1440, 0, 320, 104, ImgWallBricks));
			this.addCaveBlock(1440, 104, 320, 16, ImgRoofBricks);
			_preBroken.add(this.addCaveBlock(1440, 160, 320, 16, ImgRoofBricksDarkBloody, false)); // walkway
			this.addCaveBlock(1440, 176, 32, 16, ImgRoofBricksDark); // v walkway, <^ 2x1
			_preBroken.add(this.addCaveBlock(1440, 192, 16, 48, ImgRoofBricksDark, false)); // v walkway, <^ 1x3
			this.addCaveBlock(1088, 256, 352, 64, ImgRoofBricks); // v walkway, <v 2x3 (and floor on screen 3)
			this.addCaveBlock(1440, 256, 32, 64, ImgRoofBricksDark); // v walkway, <v 2x3 (and floor on screen 3)
			_preBroken.add(this.addCaveBlock(1728, 176, 32, 16, ImgRoofBricksDark, false)); // v walkway, >^ 2x1
			_preBroken.add(this.addCaveBlock(1744, 192, 16, 48, ImgRoofBricksDark, false)); // v walkway, >^ 1x3
			this.addCaveBlock(1728, 256, 32, 48, ImgRoofBricksDark); // v walkway, >v 2x3
			this.addCaveBlock(1472, 304, 288, 16, ImgRoofBricksDark); // floor v gears
			_preBrokenNoCollide.add(this.addCaveBlock(1536, 176, 16, 128, ImgRoofBricksDark, false)); // < pillar
			_preBrokenNoCollide.add(this.addCaveBlock(1648, 176, 16, 128, ImgRoofBricksDark, false)); // > pillar
			// -- gears here --
			
			var tiles:Array = [
				[2.5,  -.5,   .5,  .5, ImgRoofBricksDark],
				[4,    -2.5,   1,  .5, ImgRoofBricksDark],
				[6.5,  -.5,   .5,  .5, ImgRoofBricksDark],
				[9,    -1.5,  .5, 1.5, ImgRoofBricksDark],
				[9.5,  -.5,   .5,  .5, ImgRoofBricksDark],
				[10.5, -2.5,  .5,  .5, ImgRoofBricksDark],
				[12.5, -5.5, 1.5,  .5, ImgRoofBricksDark],
				[13.5, -6,    .5,  .5, ImgRoofBricksDark],
				[0,    -9,    12,   1, ImgRoofBricksDarkBloody], // < walkway
				[9,    -12.5,  3,   1, ImgWallBricksFade], // missing blocks in roof
				[9,    -10,    1,   1, ImgRoofBricks], // block next to king on walkway
				[11,   -10,    1,   1, ImgRoofBricks], // block next to king on walkway
				[11.5, -11,    1,   1, ImgRoofBricks], // block next to king on walkway
				[0,    -8,     4,   1, ImgRoofBricksDark], // <v walkway
				[0,    -7,     1,   4, ImgRoofBricksDark], // <v wall
				[3,    -2,     3,   2, ImgRoofBricksDark], // 3x2
				[7,    -3,     2,   3, ImgRoofBricksDark], // 2x3
				[10,   -2,     2,   2, ImgRoofBricksDark], // 2x2
				[11,   -5,     3,   3, ImgRoofBricksDark], // ^ 3x3
				[13,   -2,     4,   2, ImgRoofBricksDark], // v 4x2
				[14.5, -4,     2,   2, ImgRoofBricksDark], // ^ 2x2
				[18,   -4,     1,   1, ImgRoofBricksDark],
				[14.5, -6,     4,   2, ImgRoofBricksDark], // ^ 4x2
				[14,   -8,     2,   2, ImgRoofBricksDark], // ^ 2x2
				[19,   -7,     1,   5, ImgRoofBricksDark],
				[17,   -8,     3,   1, ImgRoofBricksDark], // ^ >v walkway
				[16,   -9,    4,   1, ImgRoofBricksDark], // ^ > walkway
			];
			for (i=0; i < tiles.length; ++i) {
				var t:Array = tiles[i];
				_postBroken.add(new FlxBlock(1440 + t[0]*16, 304+t[1]*16, t[2]*16, t[3]*16, t[4]));
			}
			
			this.add(_king);
			this.add(_queen);
		}
		
		public function addArrowShooter(x:Number, y:Number, y2:Number, timer:Number=-1):ArrowShooter
		{
			y += 240;
			_blocks.add(new FlxBlock(x+6, y, 20, 32, null));
			var shooter:ArrowShooter = this.add(new ArrowShooter(x, y, _arrows, _queen, timer)) as ArrowShooter;
			this.add(new FlxBlock(x, y, 32, 32, ImgDirtFringe));
			this.add(new FlxBlock(x, y, 32, 32, ImgDirtFringe));
			this.add(new FlxBlock(x, y, 32, 32, ImgDirtFringe));
			return shooter;
		}
		
		public function addCaveBlock(x:Number, y:Number, w:Number, h:Number, image:Class, collide:Boolean=true, empties:int=0):FlxBlock
		{
			var block:FlxBlock = new FlxBlock(x, y, w, h, image, empties);
			this.add(block);
			if (collide) {
				_blocks.add(block);
			}
			return block;
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
		
		public function crusherHitQueen(crusher:Platform, queen:Queen):void
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
			if (_bridge.exists && _rock.y > 120) {
				_rock.x = 1392;
				_rock.y = 240;
				_bridge.kill();
			}
			if (!_bridge.exists && !_bridgeGibs && _queen.y > 30) {
				FlxG.play(SndBridge);
				_bridgeGibs = FlxG.state.add(new FlxEmitter(
					_bridge.x, _bridge.y, _bridge.width, _bridge.height, // x, y, w, h
					null, // sprites
					-5, // lifespan
					-50, 50, // minVelocityX, maxVelocityX
					-100, 0, // minVelocityY, maxVelocityY
					-720, 720, // minRotation, maxRotation
					400, 0, // gravity, drag
					ImgRockGibs, // graphics
					60, // quantity
					true // true if graphics is a sprite sheet
				)) as FlxEmitter;
				_bridgeGibs.reset();
				FlxG.quake(0.005, 0.2);
			}
			if (!broken) {
				if (_rock.y > 272) {
					broken = true;
					FlxG.play(SndExplode);
					FlxG.flash(0xffd8eba2,3.0);
					FlxG.quake(0.02, 1.0);
					_crushers[0].y = 73;
					_crushers[1].y = 91;
					_crushers[2].kill();
					_crushers[3].kill();
					_crushers[4].kill();
					_crushers[5].kill();
					for (var i:int=0; i < _preBroken.length; ++i) {
						_preBroken[i].kill();
					}
					for (i=0; i < _preBrokenNoCollide.length; ++i) {
						_preBrokenNoCollide[i].kill();
					}
					for (i=0; i < _postBroken.length; ++i) {
						this.add(_postBroken[i]);
					}
					for (i=0; i < _gears1.length; ++i) {
						_gears1[i].angularAcceleration = 0;
						_gears1[i].angularVelocity = 0;
					}
					for (i=0; i < _gears2.length; ++i) {
						_gears2[i].kill();
					}
					_queen.x = 1460;
					_queen.y = 200;
					_king.x = 1608;
					_king.y = 146;
					_king.kill();
				}
				if (_queen.y > 272) {
					_queen.kill();
				}
			}
			if (_queen.x > 1760) {
				FlxG.switchState(MenuState);
			}
			var x:Number = Math.floor(_queen.x / 480) * 480;
			var x2:Number = Math.min(x+480, 1760);
			FlxG.followBounds(x, -240, x2, _bridge.exists?240:320);
			_time += FlxG.elapsed;
			super.update();
			var dead:Boolean = _queen.dead;
			_queen.dead = false;
			FlxBlock.collideArray(_blocks, _queen);
			FlxBlock.collideArray(broken ? _postBroken : _preBroken, _queen);
			if (_bridge.exists) {
				_bridge.collide(_queen);
			}
			FlxBlock.collideArray(_platforms, _queen);
			_rock.block.collide(_queen);
			_queen.dead = dead;
			FlxBlock.collideArray(_blocks, _king);
			FlxBlock.collideArray(broken ? _postBroken : _preBroken, _king);
			FlxBlock.collideArray(_blocks, _rock);
			FlxBlock.collideArrays(_blocks, _roofSpikes);
			FlxBlock.collideArrays(_platforms, _roofSpikes);
			FlxSprite.overlapArray(_roofSpikes, _queen, spikeHitQueen);
			FlxSprite.overlapArray(_arrows, _queen, arrowHitQueen);
			if (!broken) {
				for each (var crusher:Platform in _crushers) {
					if (crusher.overlaps(_queen)) {
						_queen.kill();
					}
				}
			}
		}
	}
}