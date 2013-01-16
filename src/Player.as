package
{
	import org.flixel.*;
 
	public class Player extends FighterBase
	{	
		//------------------------------------------DECLARATIONS---------------------------------------------
		
		//----------------------------------------CREATE FUNCTION--------------------------------------------
		public function Player(X: int, Y: int, redSprites:Boolean):void //X and Y define starting position of the player
		{
			super(X, Y, redSprites);
			isPlayer = true;
			
			//Create player
			//createGraphic(1 * 16, 1 * 16, 0xff000000)
			
			//Adjust size
			//offset.x = 11;
			//offset.y = 7;
			//width = 20;
			//height = 45;
			
			health = 100;

			//Animations
		}
		
		override public function update():void //update function
		{
			//------------------------------------------ANIMATIONS-----------------------------------------------
			
			//-------------------------------------------MOVEMENT------------------------------------------------
			moveATTACK = false;
			moveJUMP = false;
			moveLEFT = false;
			moveRIGHT = false;
			moveUP = false;
			moveDOWN = false;
			
			if (FlxG.keys.Z)
			{
				moveATTACK = true;
			}
			if (FlxG.keys.X)
			{
				moveJUMP = true;
			}
			
			if (FlxG.keys.LEFT)
			{
				moveLEFT = true;
			}
			else if (FlxG.keys.RIGHT)
			{
				moveRIGHT = true;
			}
			if (FlxG.keys.UP)
			{
				moveUP = true;
			}
			else if (FlxG.keys.DOWN)
			{
				moveDOWN = true;
			}
			
			super.update();
		}
	}
}