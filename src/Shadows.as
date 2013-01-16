package
{
	import org.flixel.*;
 
	public class Shadows extends FlxSprite
	{	
		//------------------------------------------DECLARATIONS---------------------------------------------
		[Embed(source = "../data/shadow.png")] public var shadowSprite:Class; //shadow sprite
		//----------------------------------------CREATE FUNCTION--------------------------------------------
		public function Shadows(X: int, Y: int):void //X and Y define starting position of the player
		{
			super(X, Y);
			
			loadGraphic(shadowSprite, false, false);
		}
		
		override public function update():void //update function
		{
			//------------------------------------------ANIMATIONS-----------------------------------------------
			//-------------------------------------------MOVEMENT------------------------------------------------
			
			super.update();
		}
	}
}