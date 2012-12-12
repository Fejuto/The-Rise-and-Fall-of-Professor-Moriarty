package;

import engine.entities.C;
import nme.events.Event;

class TestC extends C{
	public var param:String;
	
	public function init(param:String):Void{
		this.param = param;
		
		m.add(this, "lol", onLol);
	}
	
	function onLol(?e:Event):Void{
		
	}
	
	override function destroy():Void{
		super.destroy();
	}
}
