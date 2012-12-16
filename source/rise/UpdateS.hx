package rise;
import engine.entities.C;
import nme.events.Event;
import engine.entities.E;

class UpdateS extends C{
	public static inline var UPDATE = "UPDATE";
	var killed:Array<E>;
	
	public function init():Void{
		killed = new Array<E>();
	}
	
	override public function destroy():Void{
		super.destroy();
	}
	
	public function update():Void{
		dispatchEvent(new Event(UPDATE));
		while(killed.length > 0){
			killed.pop().destroy();
		}
	}
	
	public function kill(e:E):Void{
		if(!Lambda.has(killed, e)){
			killed.push(e);
		}
	}
}