package rise;
import engine.entities.C;
import nme.events.Event;

class UpdateS extends C{
	public static inline var UPDATE = "UPDATE";
	
	public function init():Void{
	}
	
	override public function destroy():Void{
		super.destroy();
	}
	
	public function update():Void{
		dispatchEvent(new Event(UPDATE));
	}
}
