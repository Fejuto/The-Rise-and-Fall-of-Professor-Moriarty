package engine.entities;
import nme.events.EventDispatcher;
import haxe.rtti.Meta;
import haxe.rtti.Infos;
import nme.events.Event;
import flash.events.Event;

class E extends EventDispatcher, implements Infos{
	public static inline var DESTROY = "DESTROY";
	
	public var m:EventMap;
	var parent:E;
	var children:Array<E>;
	var map:Hash<Dynamic>;
	
	public function new(parent : E = null){
		super();
		this.m = new EventMap();
		this.parent = parent;
		this.children = new Array<E>();
		this.map = new Hash<Dynamic>();

		map.set(getName(E, ""), this);
		if(parent != null){
			parent.addChild(this);
			m.add(parent, DESTROY, onDestroy);
		}
	}
	
	public function destroy():Void{
		onDestroy();
	}
	
	function onDestroy():Void{
		dispatchEvent(new Event(DESTROY));
		m.removeAll();
		if(parent != null){
			parent.removeChild(this);		
		}
		for(key in map.keys()){
			map.remove(key);
		}
	}
	
	public function addC<T:(Infos)>(type:Class<T>, name:String = "", args:Array<Dynamic> = null):T{
		if(args == null) args = [];
		var instance = Type.createInstance(type, args);
		map.set(getName(type, name), instance);
		inject(instance);
		return instance;
	}
	
	public function hasC<T:(Infos)>(type:Class<T>, name:String = ""):Bool{
		return getMapping(type, name) != null;
	}
	
	public function getC<T:(Infos)>(type:Class<T>, name:String = ""):T{
		var mapping = getMapping(type, name);
		if(mapping == null) throw "could not find mapping for " + getName(type, name);
		return mapping;
	}
	
	public function broadcast(e:Event):Void{
		
	}
	
	function addChild(e:E):Void{
		children.push(e);
	}
	
	function removeChild(e:E):Void{
		children.remove(e);
	}
	
	inline function getName<T:(Infos)>(type:Class<T>, name:String):String{
		return Type.getClassName(type) + "|" + name;
	}
	
	function inject<T:(Infos)>(instance:T):Void{
		var instanceType = Type.getClass(instance);
		var metaFields = Meta.getFields(instanceType);
		for(field in Reflect.fields(metaFields)){
			var metaField = Reflect.field(metaFields, field);
			if(Reflect.hasField(metaField, "inject")){
				var injectMeta = Reflect.field(metaField, "inject");
				var injectType = getFieldType(instanceType, field);
				var injectName = injectMeta != null ? injectMeta[0] : ""; 
				var mapping = getMapping(injectType, injectName);
				if(mapping == null) throw "could not find mapping for " + getName(injectType, injectName);
				Reflect.setField(instance, field, mapping);
			}
		}
	}
	
	function getMapping<T:(Infos)>(type:Class<T>, name:String = ""):T{
		if(map.exists(getName(type, name))){
			return map.get(getName(type, name));
		}else{
			if(parent != null){
				return parent.getMapping(type, name);
			}else{
				return null;
			}
		}
	}
	
	static var getFieldTypeCache = new Hash<Xml>();
	static function getFieldType<T>(type:Class<T>, field:String):Class<Dynamic>{
		var typeName = Type.getClassName(type);
		if(!getFieldTypeCache.exists(typeName)){
			var rtti:String = Reflect.field(type, "__rtti");
			getFieldTypeCache.set(typeName, Xml.parse(rtti).firstElement());
		}
		var fieldTypeName = getFieldTypeCache.get(typeName).elementsNamed(field).next().elementsNamed("c").next().get("path");
		return Type.resolveClass(fieldTypeName);
	}
}
