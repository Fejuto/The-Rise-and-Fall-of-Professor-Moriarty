package engine.entities;
import nme.events.EventDispatcher;
import nme.events.Event;

class C extends EventDispatcher, implements haxe.rtti.Infos{
	@inject public var e(default, setE):E;
	function setE(v:E):E{
		if(e != null) throw "can't change e";
		m.add(e, E.DESTROY, onDestroy, false, e.getNextPriority());
		return e = v;
	}
	
	var m:EventMap;
	
	public function new(){
		super();
		m = new EventMap();
	}
	
	function onDestroy():Void{
		destroy();
	}
	
	function destroy():Void{
		m.removeAll();
	}
}
