package
{
	import org.flixel.*; //Allows you to refer to flixel objects in your code
	[SWF(width = "1366", height = "768", backgroundColor = "#000000")] //Set the size and color of the Flash file
	[Frame(factoryClass="Preloader")]
 
	public class Main extends FlxGame
	{
		public function Main() 
		{
			//super(683, 384, MenuState, 2); //Create a new FlxGame object at 320x240 with 2x pixels, then load PlayState
			super(320,240,MenuState,2); //Create a new FlxGame object at 320x240 with 2x pixels, then load PlayState
	 		//super(840,525,MenuState,2); //Create a new FlxGame object at 320x240 with 2x pixels, then load PlayState
		} //1680x1050
 	}
}