package
{
	import org.flixel.*;
 
	public class Player2 extends FighterBase
	{	
		//------------------------------------------DECLARATIONS---------------------------------------------
		
		//----------------------------------------CREATE FUNCTION--------------------------------------------
		public function Player2(X: int, Y: int, redSprites:Boolean):void //X and Y define starting position of the player
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
			
			if (FlxG.keys.Q)
			{
				moveATTACK = true;
			}
			if (FlxG.keys.E)
			{
				moveJUMP = true;
			}
			
			if (FlxG.keys.A)
			{
				moveLEFT = true;
			}
			else if (FlxG.keys.D)
			{
				moveRIGHT = true;
			}
			if (FlxG.keys.W)
			{
				moveUP = true;
			}
			else if (FlxG.keys.S)
			{
				moveDOWN = true;
			}
			
			super.update();
		}
	}
}