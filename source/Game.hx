package;

import nme.Lib;
import org.flixel.FlxGame;
import nme.events.Event;
	
class Game extends FlxGame
{	
	public function new()
	{
		var stageWidth:Int = Lib.current.stage.stageWidth;
		var stageHeight:Int = Lib.current.stage.stageHeight;
		var ratioX:Float = stageWidth / 800;
		var ratioY:Float = stageHeight / 600;
		var ratio:Float = Math.min(ratioX, ratioY);
		super(Math.floor(stageWidth / ratio), Math.floor(stageHeight / ratio), MenuState, ratio, 60, 60, true);
		forceDebugger = true;
		
		addEventListener(Event.ADDED_TO_STAGE, create);
	}
	
	override function create(FlashEvent:Event):Void{
		super.create(FlashEvent);
		stage.removeEventListener(Event.DEACTIVATE, onFocusLost);
		stage.removeEventListener(Event.ACTIVATE, onFocus);
	}
}
