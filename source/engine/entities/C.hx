package engine.entities;
import nme.events.EventDispatcher;
import nme.events.Event;

class C extends EventDispatcher, implements haxe.rtti.Infos{
	@inject public var e:E;
	public var m:EventMap;
	
	public function new(){
		super();
		m = new EventMap();
		//m.add(e, E.DESTROY, onDestroy);
	}
	
	function onDestroy():Void{
		destroy();
	}
	
	function destroy():Void{
		m.removeAll();
	}
}
