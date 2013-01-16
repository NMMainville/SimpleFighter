package
{
	import org.flixel.*;
 
	public class FighterBase extends FlxSprite //NOTE: this is the base class for all "people". It contains functions that pertain to everyone
	{	
		//------------------------------------------DECLARATIONS---------------------------------------------
		[Embed(source = "../data/fighter2hat.png")] public var dummySprites:Class; //player sprites
		[Embed(source = "../data/playerhat.png")] public var playerSprites:Class; //player sprites
		public var isPlayer:Boolean = false;
		private var jumpheight:int = 0;
		private var jumpaccel:Number = 0;
		public var isAttacking:Boolean = false; //isAttacking is a boolean that prevents player movement during attacks
		private var holdAttack:Boolean = false;
		public var isHurt:Boolean = false;
		
		public var moveUP:Boolean = false; //input variables that mimic buttons
		public var moveDOWN:Boolean = false;
		public var moveLEFT:Boolean = false;
		public var moveRIGHT:Boolean = false;
		
		public var moveATTACK:Boolean = false;
		public var moveJUMP:Boolean = false;
		
		public var kickDamage:Boolean = false; //frames in which the fighter's specific attack deals damage
		public var punchDamage:Boolean = false;
		
		private const DEFAULTYOFFSET:int = 7 * 16;
		//----------------------------------------CREATE FUNCTION--------------------------------------------
		public function FighterBase(X: int, Y: int, redSprites:Boolean):void //X and Y define starting position of the player
		{
			super(X, Y); //x and y position of the player
			
			if (redSprites)
			loadGraphic(playerSprites, true, true, 5 * 16 + 2, 7 * 16 + 2, false);
			else
			loadGraphic(dummySprites, true, true, 5 * 16 + 2, 7 * 16 + 2, false);
			//createGraphic(3 * 16, 6 * 16, 0xff0000ff);
			
			//Adjust size
			offset.x = 16;// 2 * 16;
			offset.y = DEFAULTYOFFSET;
			width = 3*16;
			height = 8;
			
			maxVelocity.x = 400; //maximum speed in the x direction
			maxVelocity.y = 50; //maximum speed in the y direction
			drag.x = maxVelocity.x * 4; //slows the player down when they're not moving left or right
			//drag.y = maxVelocity.y * 4; //slows the player down when they're not moving up or down
			
			health = 5;
			
			//Animations
			addAnimation("idle", [1]);
			addAnimation("walking", [1, 2], 12);
			addAnimation("jump", [3]);
			addAnimation("kick", [4, 5], 6, false);
			addAnimation("kick2", [5], 60, true);
			addAnimation("punch", [6, 6, 7, 8, 8, 8], 12, false);
			addAnimation("hurt", [9, 9, 1], 6, false);
			addAnimation("fling", [10], 6, true);
			addAnimation("dead", [11], 6, true);
			play("idle");
			
			addAnimationCallback(animDetect);
		}
		
		override public function update():void //update function
		{
			//------------------------------------------ANIMATIONS-----------------------------------------------
			if (!isAttacking)
			if (jumpheight > 0)
			{
				play("jump");
			}
			else if (velocity.x != 0 || velocity.y != 0)
			{
				play("walking");
			}
			else
			{
				play("idle");
			}
			
			
			//-------------------------------------------ATTACKS------------------------------------------------
			//NOTE: THIS CODE IS ONLY TEMPORARY UNTIL HITBOXES AND HEALTH ARE CODED!
			if (!holdAttack)
			{
				if (moveATTACK && !isAttacking && jumpheight == 0)
				{
					holdAttack = true;
					FighterPunch();
				}
				else if (moveATTACK && !isAttacking && jumpheight > 0)
				{
					if (moveLEFT) facing = LEFT;
					if (moveRIGHT) facing = RIGHT;
					holdAttack = true;
					FighterKick();
				}
			}
			else if (holdAttack && !moveATTACK)
			{
				holdAttack = false;
			}
				
			//-------------------------------------------MOVEMENT------------------------------------------------
			if (jumpheight > 0)
			{
				jumpheight = jumpheight + jumpaccel;
				if(!isAttacking || health <= 0)
					jumpaccel -= 0.2;
			}
			if (jumpheight <= 0 && jumpaccel < 0)
			{
				jumpheight = 0;
				jumpaccel = 0;
			}
				
			if (!isAttacking)
			{
				if (jumpheight <= 0)
				{
					velocity.x = 0;
					velocity.y = 0;
					
					if (moveLEFT){
						velocity.x = -maxVelocity.x/2;
						facing = LEFT;
					}
					else if (moveRIGHT){
						velocity.x = maxVelocity.x/2;
						facing = RIGHT;
					}
					if (moveUP){
						velocity.y = -maxVelocity.y;
					}
					else if (moveDOWN){
						velocity.y = maxVelocity.y;
					}
				}
				if (moveJUMP && jumpheight==0 && jumpaccel==0){
					jumpaccel = 5;
					jumpheight = 1;
				}
			}
			
			//--------------------------------------------DAMAGE-------------------------------------------------
			//TODO: write the function for getting hurt/thrown/killed here
			//The actual code for enemies hitting each other will occur in the playstate, and will call the appropriate function here.
			
			offset.y = DEFAULTYOFFSET + jumpheight;
			
			if (jumpheight > 0)
			{
				drag.x = 0;
			}
			else
			{
				drag.x = maxVelocity.x * 4;
			}
			
			super.update();
		}

		public function FighterPunch():void //functions set the initial state of attacks while animDetect follows through with them
		{
			isAttacking = true;
			velocity.x = 0;
			velocity.y = 0;
			play("punch");
		}
		
		public function FighterKick():void
		{
			isAttacking = true;
			velocity.x = 0;
			velocity.y = 0;
			play("kick");
		}
		
		public function animDetect(animState:String, frameNo:int, spriteNo:int):void //reads the animation state
		{
			if (animState == "punch" && frameNo == 3)
			{
				punchDamage = true;
			}
			if (animState == "punch" && frameNo == 5)
			{
				punchDamage = false;
				isAttacking = false;
			}
			if (animState == "kick" && frameNo == 0)
			{
				velocity.x = 0;
				velocity.y = 0;
				jumpaccel = 0;
			}
			if (animState == "kick" && frameNo == 1 && jumpheight > 0)
			{
				if (facing == RIGHT)
					velocity.x = maxVelocity.x;
				else
					velocity.x = -maxVelocity.x;
				jumpaccel = -5;
				play("kick2");
				kickDamage = true;
			}
			else if (animState == "kick2" && jumpheight <= 0)
			{
				velocity.x = 0;
				jumpaccel = 0;
				jumpheight = 0;
				kickDamage = false;
				isAttacking = false;
			}
			
			if (animState == "hurt" && frameNo == 2)
			{
				isAttacking = false;
				isHurt = false;
			}
			
			if (animState == "fling" && jumpheight == 0)
			{
				play("dead");
				
				dead = true;
				//exists = false;
			}
		}
		
		override public function hurt(Damage:Number):void
		{
			flicker(0.5);
			
			if (health > 0)
			{
			velocity.y = 0;
			health = health - Damage;
			if(health <= 0)
				kill();
			
			if (facing == RIGHT)
			{
				velocity.x = -20*Damage;
			}
			else
			{
				velocity.x = 20*Damage;
			}
			isAttacking = true;
			isHurt = true;
			play("hurt");
			}
			else
			{
				kill();
			}
		}
		
		/*override public function kill():void
		{
			if (exists)
			{
			isAttacking = true;
			play("fling");
			jumpaccel = 5;
			jumpheight = jumpheight + 1;
			}
			//exists = false;
			//dead = true;
		}*/
		
		override public function reset(X:Number,Y:Number):void
		{
			x = X;
			y = Y;
			exists = true;
			dead = false;
			health = 100;
		}
	}
}