package
{
	import org.flixel.*;
 
	public class FighterBase extends FlxSprite //NOTE: this is the base class for all "people". It contains functions that pertain to everyone
	{	
		//------------------------------------------DECLARATIONS---------------------------------------------
		[Embed(source = "../data/fighter2.png")] public var dummySprites:Class; //player sprites
		private var jumpheight:int = 0;
		private var jumpaccel:Number = 0;
		private var isAttacking:Boolean = false; //isAttacking is a boolean that prevents player movement during attacks
		private var holdAttack:Boolean = false;
		
		private const DEFAULTYOFFSET:int = 6 * 16;
		//----------------------------------------CREATE FUNCTION--------------------------------------------
		public function FighterBase(X: int, Y: int):void //X and Y define starting position of the player
		{
			super(X, Y); //x and y position of the player
			
			loadGraphic(dummySprites, true, true, 5 * 16 + 2, 7 * 16 + 2, false);
			//createGraphic(3 * 16, 6 * 16, 0xff0000ff);
			
			//Adjust size
			offset.x = 2*16;
			offset.y = DEFAULTYOFFSET;
			width = 16;
			height = 16;
			
			maxVelocity.x = 400; //maximum speed in the x direction
			maxVelocity.y = 50; //maximum speed in the y direction
			//drag.x = maxVelocity.x * 4; //slows the player down when they're not moving left or right
			//drag.y = maxVelocity.y * 4; //slows the player down when they're not moving up or down
			
			//Animations
			addAnimation("idle", [1]);
			addAnimation("walking", [1, 2], 12);
			addAnimation("jump", [3]);
			addAnimation("kick", [4, 5], 6, false);
			addAnimation("kick2", [5], 60, true);
			addAnimation("punch", [6, 6, 7, 8, 8, 8], 12, false);
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
				if (FlxG.keys.Z && !isAttacking && jumpheight == 0)
				{
					holdAttack = true;
					FighterPunch();
				}
				else if (FlxG.keys.Z && !isAttacking && jumpheight > 0)
				{
					holdAttack = true;
					FighterKick();
				}
			}
			else if (holdAttack && !FlxG.keys.Z)
			{
				holdAttack = false;
			}
				
			//-------------------------------------------MOVEMENT------------------------------------------------
			if (jumpheight > 0)
			{
				jumpheight = jumpheight + jumpaccel;
				if(!isAttacking)
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
					
					if (FlxG.keys.LEFT){
						velocity.x = -maxVelocity.x/2;
						facing = LEFT;
					}
					else if (FlxG.keys.RIGHT){
						velocity.x = maxVelocity.x/2;
						facing = RIGHT;
					}
					if (FlxG.keys.UP){
						velocity.y = -maxVelocity.y;
					}
					else if (FlxG.keys.DOWN){
						velocity.y = maxVelocity.y;
					}
				}
				if (FlxG.keys.X && jumpheight==0 && jumpaccel==0){
					jumpaccel = 5;
					jumpheight = 1;
				}
			}
			
			offset.y = DEFAULTYOFFSET + jumpheight;
			
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
			if (animState == "punch" && frameNo == 5)
			{
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
			}
			else if (animState == "kick2" && jumpheight <= 0)
			{
				FlxG.log("trigger");
				velocity.x = 0;
				jumpaccel = 0;
				jumpheight = 0;
				isAttacking = false;
			}
		}
	}
}