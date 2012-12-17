package rise;
import org.flixel.FlxBasic;
import engine.entities.C;
import org.flixel.FlxState;
import org.flixel.FlxLayer;
import org.flixel.FlxGroup;

class RenderS extends C{
	@inject var updateS:UpdateS;
	
	public var edgeLayer:FlxGroup;
	public var gaiaLayer:FlxGroup;
	public var backgroundMenuLayer:FlxGroup;
	public var nodeLayer:FlxGroup;
	public var defaultLayer:FlxGroup;
	public var agentLayer:FlxGroup;
	public var topLayer:FlxGroup;
	public var interfaceLayer:FlxGroup;
	
	var flxState:FlxState;
	
	public function init(flxState:FlxState):Void{
		this.flxState = flxState;		
		gaiaLayer= new FlxGroup();
		flxState.add(gaiaLayer);
		edgeLayer = new FlxGroup();
		flxState.add(edgeLayer);
		backgroundMenuLayer = new FlxGroup();
		flxState.add(backgroundMenuLayer);
		nodeLayer = new FlxGroup();
		flxState.add(nodeLayer);
		defaultLayer = new FlxGroup();
		flxState.add(defaultLayer);
		agentLayer = new FlxGroup();
		flxState.add(agentLayer);
		topLayer = new FlxGroup();
		flxState.add(topLayer);
		interfaceLayer = new FlxGroup();
		flxState.add(interfaceLayer);
		
		m.add(updateS, UpdateS.UPDATE, onUpdate);
	}
	
	function onUpdate():Void {
		// would require extending FlxSprite and adding a z 'value', why it doens't have it by default is beyond me?1
		//nodeLayer.sort('z', 1);
		
	}
	
	override public function destroy():Void{
		super.destroy();
	}
	
	public function add(flxBasic:FlxBasic, layer:FlxGroup = null):Void{
		if(layer == null){
			layer = defaultLayer;
		}
		layer.add(flxBasic);
	}
	
	public function remove(flxBasic:FlxBasic, layer:FlxGroup = null):Void{
		if(layer == null){
			layer = defaultLayer;
		}
		layer.remove(flxBasic);
	}
}
