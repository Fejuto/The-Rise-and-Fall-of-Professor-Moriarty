package engine.entities;
import nme.events.EventDispatcher;
import nme.events.Event;

class C extends EventDispatcher, implements haxe.rtti.Infos{
	@inject public var e:E;
		
	var m:EventMap;
	
	public function new(){
		super();
		m = new EventMap();
	}
	
	@postInject function postInject():Void{
		trace('asdfasfd');
		m.add(e, E.DESTROY, onDestroy, false, e.getNextPriority());
	}
	
	function onDestroy():Void{
		destroy();
	}
	
	function destroy():Void{
		m.removeAll();
	}
}
