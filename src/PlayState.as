package
{
	import flash.display.InteractiveObject;
	import org.flixel.*;
 
	public class PlayState extends FlxState
	{	
		//---------------------------------------CURRENT OBJECTIVES------------------------------------------
		//
		//------------------------------------------DECLARATIONS---------------------------------------------
		public var level:Level; //level oblect
		
		public var debugcounter:int = 0;
		
		public static var fighters:FlxGroup; //group of normal fighter
		public var player:Player; //the person the player controls
		public var player2:Player2; //the person the player controls
		
		public var testPlayer:FighterBase;
		public var playerShadow:Shadows;
		
		public const PUNCHDAMAGE:int = 10;
		public const KICKDAMAGE:int = 20;
		
		public var frame:FlxSprite = new FlxSprite(4, 4);
			public var inside:FlxSprite = new FlxSprite(5, 5);
			public var bar:FlxSprite = new FlxSprite(5, 5);
			
			private var _hud_test:FlxText;
			
		//----------------------------------------CREATE FUNCTION--------------------------------------------
		override public function create():void
		{
			bgColor = 0xffffffff; //change bgcolour
			
			level = new Level(); //initiate level as a Level (the class)
			
			_hud_test = new FlxText(8, 16, FlxG.width, "Feel free to pick up a controller and play!");
			_hud_test.setFormat(null, 8, 0xff000000, null);
			_hud_test.scrollFactor.x = _hud_test.scrollFactor.y = 0;
			
			fighters = new FlxGroup; //initilaizing people
			player = new Player(3 * 16, 17 * 16, true); //initializing player
			//player2 = new Player2(5 * 16, 18 * 16, true); //initializing player
			fighters.add(player, true); //adding player to list of people, NPCs will be added in the same manner
			//fighters.add(player2, true); //adding player to list of people, NPCs will be added in the same manner
			
			fighters.add(new Enemy(10 * 16, 16 * 16, false), true); //dummy 1
			fighters.add(new Enemy(20 * 16, 16 * 16, false), true); //dummy 2
			fighters.add(new Enemy(30 * 16, 16 * 16, false), true);
			fighters.add(new Enemy(40 * 16, 16 * 16, false), true);
			fighters.add(new Enemy(50 * 16, 16 * 16, false), true);
			fighters.add(new Enemy(60 * 16, 16 * 16, false), true);
			
			
			
			
			playerShadow = new Shadows(1*-16, 1*-16);
			
			
			frame.createGraphic(102,10); //White frame for the health bar
			frame.scrollFactor.x = frame.scrollFactor.y = 0;
			
			
			inside.createGraphic(100,8,0xff000000); //Black interior, 48 pixels wide
			inside.scrollFactor.x = inside.scrollFactor.y = 0;
			
			
			bar.createGraphic(1,8,0xffff0000); //The red bar itself
			bar.scrollFactor.x = bar.scrollFactor.y = 0;
			bar.origin.x = bar.origin.y = 0; //Zero out the origin
			bar.scale.x = 100; //Fill up the health bar all the way
			
			
			add(level);
			add(playerShadow);
			add(fighters);
			add(frame);
			add(inside);
			add(bar);
			add(_hud_test);
			
			//set up camera
			FlxG.follow(player,2.5);
			FlxG.followAdjust(0.5,0.0);
			level.follow();	//Set the followBounds to the map dimensions
		}
		
		override public function update():void //update function
		{
			playerShadow.x = player.x;
			playerShadow.y = player.y - 8;
			
			super.update();
			
			//------------------------------------------DRAW ORDER-----------------------------------------------
			fighters.sort("y", FlxGroup.ASCENDING);
			
			
			if (FlxG.keys.justPressed("B")) FlxG.showBounds = !FlxG.showBounds; //bounding box debug
			
			//------------------------------------------ATTACKING------------------------------------------------
			for (var i:int = 0; i < fighters.countLiving() + fighters.countDead(); i++) {
				if (fighters.members[i].punchDamage || fighters.members[i].kickDamage)
				{
					FlxU.overlap(fighters.members[i], fighters, calcDamage);
				}
				if (fighters.members[i].isPlayer)
				{
					bar.scale.x = fighters.members[i].health;
					
					if (fighters.members[i].health <= 0)
					{
						fighters.kill();
						fighters.reset(0, 0);
						fighters.resetFirstAvail(3 * 16, 16 * 16);
						fighters.resetFirstAvail(5 * 16, 16 * 16);
						fighters.resetFirstAvail(10 * 16, 16 * 16);
						fighters.resetFirstAvail(15 * 16, 16 * 16);
						fighters.resetFirstAvail(20 * 16, 16 * 16);
						fighters.resetFirstAvail(25 * 16, 16 * 16);
						fighters.resetFirstAvail(30 * 16, 16 * 16);
						//fighters.resetFirstAvail(35 * 16, 16 * 16);
					}
				}
			}
			
			
			if (fighters.countLiving() <= 2)
			{
				fighters.kill();
				fighters.reset(0, 0);
				fighters.resetFirstAvail(3 * 16, 16 * 16);
				fighters.resetFirstAvail(5 * 16, 16 * 16);
				fighters.resetFirstAvail(10 * 16, 16 * 16);
				fighters.resetFirstAvail(15 * 16, 16 * 16);
				fighters.resetFirstAvail(20 * 16, 16 * 16);
				fighters.resetFirstAvail(25 * 16, 16 * 16);
				fighters.resetFirstAvail(30 * 16, 16 * 16);
				//fighters.resetFirstAvail(35 * 16, 16 * 16);
			}
			
			FlxU.collide(level, fighters);
		}
		
		public function calcDamage(f1:FighterBase, f2:FighterBase):void //this determines who hit who and dishes out damage accordingly
		{
			if (f1.punchDamage && !f2.punchDamage && !f2.isHurt && f1.facing == 1 && f2.x > f1.x)
			{
				f2.facing = -1 * (f1.facing - 1);
				f2.hurt(PUNCHDAMAGE);
			}
			else if (f1.punchDamage && !f2.punchDamage && !f2.isHurt && f1.facing == 0 && f2.x < f1.x)
			{
				f2.facing = -1 * (f1.facing - 1);
				f2.hurt(PUNCHDAMAGE);
			}
			else if (!f1.punchDamage && f2.punchDamage && !f1.isHurt && f2.facing == 1 && f1.x > f2.x)
			{
				f1.facing = -1 * (f2.facing - 1);
				f1.hurt(PUNCHDAMAGE);
			}
			else if (!f1.punchDamage && f2.punchDamage && !f1.isHurt && f2.facing == 0 && f1.x < f2.x)
			{
				f1.facing = -1 * (f2.facing - 1);
				f1.hurt(PUNCHDAMAGE);
			}
			if (f1.kickDamage && !f2.kickDamage && !f2.isHurt && f1.isPlayer)
			{
				f2.facing = -1 * (f1.facing - 1);
				f2.hurt(KICKDAMAGE);
			}
			else if (!f1.kickDamage && f2.kickDamage && !f1.isHurt && f1.isPlayer)
			{
				f1.facing = -1 * (f2.facing - 1);
				f1.hurt(KICKDAMAGE);
			}
		}
	}
}