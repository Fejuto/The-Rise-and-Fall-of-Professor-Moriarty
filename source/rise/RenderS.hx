package rise;
import org.flixel.FlxBasic;
import engine.entities.C;
import org.flixel.FlxState;

class RenderS extends C{
	var flxState:FlxState;
	
	public function init(flxState:FlxState):Void{
		this.flxState = flxState;
	}
	
	override public function destroy():Void{
		super.destroy();
	}
	
	public function add(flxBasic:FlxBasic):Void{
		flxState.add(flxBasic);
	}
}
