package rise;
import org.flixel.FlxBasic;
import engine.entities.C;
import org.flixel.FlxState;
import org.flixel.FlxLayer;
import org.flixel.FlxGroup;

class RenderS extends C{
	public var gaiaLayer:FlxGroup;
	public var backgroundMenuLayer:FlxGroup;
	public var edgeLayer:FlxGroup;
	public var nodeLayer:FlxGroup;
	public var defaultLayer:FlxGroup;
	
	var flxState:FlxState;
	
	public function init(flxState:FlxState):Void{
		this.flxState = flxState;
		gaiaLayer= new FlxGroup();
		flxState.add(gaiaLayer);
		backgroundMenuLayer = new FlxGroup();
		flxState.add(backgroundMenuLayer);
		edgeLayer = new FlxGroup();
		flxState.add(edgeLayer);
		nodeLayer = new FlxGroup();
		flxState.add(nodeLayer);
		defaultLayer = new FlxGroup();
		flxState.add(defaultLayer);
	}
	
	override public function destroy():Void{
		super.destroy();
	}
	
	public function add(flxBasic:FlxBasic, layer:FlxGroup = null):Void{
		if(layer == null){
			layer = defaultLayer;
		}
		layer.add(flxBasic);
		//flxState.add(flxBasic);
	}
}
