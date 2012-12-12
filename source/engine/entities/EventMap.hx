package engine.entities;
import nme.events.IEventDispatcher;
import nme.events.Event;

typedef Subscription = {
	var dispatcher:IEventDispatcher;
	var type:String;
	var listener:Dynamic->Void;
	var useCapture:Bool;
}

class EventMap {
	var subscriptions:Array<Subscription>;
	
	public function new(){
		subscriptions = new Array<Subscription>();
	}
	
	public function add(dispatcher:IEventDispatcher, type:String, ?listener:Void->Void, ?fullListener:Dynamic->Void, useCapture:Bool = false, priority:Int = 0, useWeakReference:Bool = false):Void{
		if(listener == null && fullListener == null) throw "Provide one listener";
		if(listener != null && fullListener != null) throw "Provide only one listener";
		
		var f = function(e:Event):Void{
			if(fullListener != null){
				fullListener(e);
			}else{
				listener();
			}
		}
		
		dispatcher.addEventListener(type, f, useCapture, priority, useWeakReference);
		subscriptions.push({dispatcher:dispatcher, type:type, listener:f, useCapture:useCapture});	
	}
	
	public function removeAll():Void{
		while(subscriptions.length > 0){
			var subscription = subscriptions.pop();
			subscription.dispatcher.removeEventListener(subscription.type, subscription.listener, subscription.useCapture);
		}
	}
}

