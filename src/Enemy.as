package
{
	import flash.display.ColorCorrectionSupport;
	import org.flixel.*;
 
	public class Enemy extends FighterBase
	{	
		//------------------------------------------DECLARATIONS---------------------------------------------
		private var targetNumber:int = -1;
		private var agressionLevel:int = 0;
		private var relativetoPlayer:Boolean = false;
		private var distanceThreshold:Number = Math.random()*10 + 32;
		private var timeSinceHurt:Number = 0;
		private var agressionThreshold:Number = Math.random() * 1 + 1;
		private var windupTime: int = 10;
		//----------------------------------------CREATE FUNCTION--------------------------------------------
		public function Enemy(X: int, Y: int, redSprites:Boolean):void //X and Y define starting position of the player
		{
			super(X, Y, redSprites);
			isPlayer = false;
			maxVelocity.y = 30;
			maxVelocity.x = 300;
			
			//Create player
			//createGraphic(1 * 16, 1 * 16, 0xff000000)
			
			//Adjust size
			//offset.x = 11;
			//offset.y = 7;
			//width = 20;
			//height = 45;
			
			health = 75;

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
			
			for (var i:int = 0; i < PlayState.fighters.countLiving() + PlayState.fighters.countDead(); i++) {
				if (PlayState.fighters.members[i].isPlayer)
				{
					targetNumber = i;
				}
			}
			
			if (agressionLevel == 1)
			{
				if (this.y > PlayState.fighters.members[targetNumber].y + 8){
					moveUP = true;
				}
				if (this.y < PlayState.fighters.members[targetNumber].y - 8){
					moveDOWN = true;
				}
			
				if (this.x > PlayState.fighters.members[targetNumber].x + 32){
					moveLEFT = true;
				}
				if (this.x < PlayState.fighters.members[targetNumber].x - 32){
					moveRIGHT = true;
				}
			}
			else if (agressionLevel == 0)
			{
				if (!relativetoPlayer)
				{
					if (this.x > PlayState.fighters.members[targetNumber].x - 128){
						moveLEFT = true;
					}
					if (this.x < PlayState.fighters.members[targetNumber].x - 128 - distanceThreshold){
						moveRIGHT = true;
					}
				}
				else if (relativetoPlayer)
				{
					if (this.x > PlayState.fighters.members[targetNumber].x + 128 + distanceThreshold){
						moveLEFT = true;
					}
					if (this.x < PlayState.fighters.members[targetNumber].x + 128){
						moveRIGHT = true;
					}
				}
			}
			else if (agressionLevel == -1)
			{
				if (!relativetoPlayer)
				{
					if (this.x > PlayState.fighters.members[targetNumber].x - 128){
						moveLEFT = true;
					}
					if (this.x > PlayState.fighters.members[targetNumber].x - 48)
					{
						moveJUMP = true;
					}
				}
				else if (relativetoPlayer)
				{
					if (this.x < PlayState.fighters.members[targetNumber].x + 128){
						moveRIGHT = true;
					}
					if (this.x < PlayState.fighters.members[targetNumber].x + 16)
					{
						moveJUMP = true;
					}
				}
			}
			
			if (this.x > PlayState.fighters.members[targetNumber].x) {
				relativetoPlayer = true;
			}
			else
			{
				relativetoPlayer = false;
			}
			
			timeSinceHurt += FlxG.elapsed;
			
			if (timeSinceHurt > agressionThreshold && agressionLevel == 0)
			{
				agressionLevel = 1;
			}
			else if (timeSinceHurt > agressionThreshold*10 && agressionLevel == -1)
			{
				agressionLevel = 0;
			}
			
			if (isHurt == true)
			{
				agressionLevel = 0;
				timeSinceHurt = 0;
				agressionThreshold = Math.random()*1 + 1;
			}
			
			if (isHurt && health <= 10 && agressionLevel == 0)
			{
				agressionLevel = -1
			}
			
			//--------------------------------------------DAMAGE-------------------------------------------------
			if (this.x < PlayState.fighters.members[targetNumber].x + 48 && this.x > PlayState.fighters.members[targetNumber].x - 32 && agressionLevel > 0){
				windupTime --;
				if (windupTime <= 0)
				{
					moveATTACK = true;
					windupTime = 20;
				}
			}
			
			if (dead)
			{
				agressionLevel = 0;
			}
			
			super.update();
		}
	}
}