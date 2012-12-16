package rise;
import engine.entities.C;
import engine.entities.E;
import flash.events.Event;
import org.flixel.FlxG;
import com.eclecticdesignstudio.motion.Actuate;
import com.eclecticdesignstudio.motion.easing.Elastic;
import org.flixel.FlxGroup;
import haxe.Json;

enum NodeState {
	inactive;
	active;
	dragging;
}

enum NodeType {
	barracks;
	mine;
	castle;
}

class NodeC extends C{
	public var name:String;
	
	public static inline var MOVED = "MOVED";
	@inject var worldS:WorldS;
	@inject var renderS:RenderS;
	@inject var updateS:UpdateS;
	@inject var scrollS:ScrollS;
	
	var circle:E;
	public var graphic:E;
	var edges:Array<E>;
	
	var _gold:Int = 100;
	public var gold(getGold, setGold):Int;
	function getGold():Int{
		return _gold;
	}
	function setGold(v:Int):Int{
		var area = v / 100.0;
		if(area <= 0){
			updateS.kill(e);
		}		
		setRadius(Math.sqrt(area / Math.PI) * Config.NodeCircleImageSize / 2);
		return _gold = v;
	}
		
	public var decayRate:Float = 5;
	var decayCounter:Float = 0;
	var sendCounter:Float= 0;
	
	public var state(default, default):NodeState;
	
	public var x(getX, setX):Float;
	function getX():Float{
		return circle.getC(SpriteC).x; 
	}
	function setX(v:Float):Float{
		graphic.getC(SpriteC).x = v;
		var r = circle.getC(SpriteC).x = v;
		dispatchEvent(new Event(MOVED));
		return r;
	}
	
	public var y(getY, setY):Float;
	function getY():Float{
		return circle.getC(SpriteC).y;
	}
	function setY(v:Float):Float{
		graphic.getC(SpriteC).y = v;
		var r = circle.getC(SpriteC).y = v;
		dispatchEvent(new Event(MOVED));
		return r;
	}
	
	// prolly do something with the radius itself
	var _radius:Float;
	public var radius(getRadius, setRadius):Float;
	function setRadius(v:Float):Float {
		var targetScale = (v / Config.NodeCircleImageSize) * 2;
		Actuate.stop(circle.getC(SpriteC));
		Actuate.tween(circle.getC(SpriteC), 1, {scaleX:targetScale, scaleY:targetScale}).ease(Elastic.easeOut);
		return _radius = v;
	}
	function getRadius():Float {
		return _radius;
	}
	
	public var circleSprite(getCircleSprite, null):SpriteC;
	function getCircleSprite():SpriteC {
		return circle.getC(SpriteC);
	}
	
	public function init(g : Dynamic, ?layer:FlxGroup, x : Float, y : Float, gold:Int, decayRate:Float, state : NodeState = null):Void{
		name = Math.random() + "";
		
		if (state == null)
			this.state = NodeState.inactive;
		else 
			this.state = state;
			
		if (layer == null)
			layer = renderS.defaultLayer;
		
		edges = new Array<E>();
		this.circle = createCircle(layer);
		this.graphic = createGraphic(g, layer);
		
		this.x = x;
		this.y = y;
		this.radius = radius;
		
		m.add(updateS, UpdateS.UPDATE, onUpdate);
		
		this.gold = gold;
		this.decayRate = decayRate;
	
				
		worldS.addNode(e);
	}
		
	function onUpdate():Void {
		if (this.state == NodeState.dragging) {
			if (FlxG.mouse.justReleased()) { 
				
				// check if able to drop there
				
			
				scrollS.enabled = true;				
				this.state = NodeState.active;
				if (e.hasC(FollowMouseC)) {
					e.getC(FollowMouseC).enabled = false;
				}
			}
		} else if (this.state == NodeState.active){
			decayCounter += FlxG.elapsed;
			while(decayRate > 0 && decayCounter > decayRate){
				decayCounter -= decayRate;
				evaporate();
			}
			
			sendCounter += FlxG.elapsed;
			while(sendCounter > Config.SendRate){
				sendCounter -= Config.SendRate;		
				edges.sort(function(edge1, edge2){
					var other1 = edge1.getC(EdgeC).getEndPoint(e);
					var other2 = edge2.getC(EdgeC).getEndPoint(e);
					
					if (other1.getC(NodeC).state != NodeState.active) // move inactive ones to bottom 
						return -1;
					if (other2.getC(NodeC).state != NodeState.active)
						return 1;
					
					var b = other1.getC(NodeC).getTimeUntilDeath() < other2.getC(NodeC).getTimeUntilDeath();
					return b?-1:1; 
				});
				
				if(edges.length > 0 && edges[0].getC(EdgeC).getEndPoint(e).getC(NodeC).getTimeUntilDeath() < getTimeUntilDeath()){
					if(edges[0].getC(EdgeC).getEndPoint(e).getC(NodeC).state != NodeState.active) // if the most important edge node is inactive dont send any gold 
						break;
					
					gold -= Config.AgentSize;
					edges[0].getC(EdgeC).getEndPoint(e).getC(NodeC).gold += Config.AgentSize;
				}
			}			
		}
		
		
	}
	
	function evaporate():Void{
		gold -= Config.Evaporation;
	}
	
	function createCircle(layer:FlxGroup):E{
		var e = new E(e);
		e.addC(SpriteC).init('assets/rise_circle_highlight.png', layer);
		e.getC(SpriteC).setColor(209, 214, 223, 225);
		return e;
	}
	
	function createGraphic(graphic, layer:FlxGroup):E{
		var e = new E(e);
		e.addC(SpriteC).init(graphic, layer);
		e.getC(SpriteC).scaleX = 0.8;
		e.getC(SpriteC).scaleY = 0.8;
		return e;
	}
	
	public function addEdge(e:E):Void{
		if(!e.hasC(EdgeC)) throw "no EdgeC";
		edges.push(e);
	}
	
	public function removeEdge(e:E):Void{
		edges.remove(e);
	}
	
	
	override public function destroy():Void{
		super.destroy();
		//worldS.removeNode(e);
	}
	
	public var goldOffset:Int = 0;
	public function getEffectiveGold():Int{
		return cast Math.max(gold + goldOffset, 0);
	}
	
	public function getTimeUntilDeath():Float{
		if(decayRate == 0) return Math.POSITIVE_INFINITY;
		return getEffectiveGold() / Config.Evaporation * decayRate;
	}
}






