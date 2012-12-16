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
		setRadius(Math.sqrt(area / Math.PI) * originalGraphicSize / 2);
		return _gold = v;
	}
		
	public var decayRate:Float = 5;
	var decayCounter:Float = 0;
	var sendCounter:Float= 0;
	public var decline:Bool = false;
	public var originalGraphicSize:Float;
	public var targetScaleFactor:Float = 2;
	
	public var state(default, default):NodeState;
	public var mine(default, default):Bool;
	
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
		var targetScale = (v / originalGraphicSize) * targetScaleFactor;
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
	
	public function init(g : Dynamic, ?layer:FlxGroup, x : Float, y : Float, gold:Int, decayRate:Float, ?state : NodeState = null, ?mine:Bool = true):Void{
		name = Math.random() + "";
		
		if (state == null)
			this.state = NodeState.inactive;
		else 
			this.state = state;
			
		if (layer == null)
			layer = renderS.defaultLayer;
		
		edges = new Array<E>();
		
		// grpahics
		this.mine = mine;
		this.circle = createCircle(layer);
		circle.getC(SpriteC).scaleX = circle.getC(SpriteC).scaleY = 0;
		this.graphic = createGraphic(g, layer);
		
		// position and size
		this.x = x;
		this.y = y;
		this.radius = radius;
		
		this.gold = gold;
		this.decayRate = decayRate;
		
		worldS.addNode(e);
		m.add(updateS, UpdateS.UPDATE, onUpdate);
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
						return 1;
					if (other2.getC(NodeC).state != NodeState.active)
						return -1;
					
					var b = other1.getC(NodeC).getTimeUntilDeath() < other2.getC(NodeC).getTimeUntilDeath();
					return b?-1:1; 
				});
				
				if(edges.length > 0 && decline || edges[0].getC(EdgeC).getEndPoint(e).getC(NodeC).getTimeUntilDeath() < getTimeUntilDeath()){
					var otherNode = edges[0].getC(EdgeC).getEndPoint(e).getC(NodeC); 
					if((otherNode.state != NodeState.active) || otherNode.decline) // if the most important edge node is inactive dont send any gold 
						break;
						
					trace(otherNode.decline);
					
					gold -= Config.AgentSize;
					worldS.createGoldAgent(edges[0], e, Config.AgentSize, mine);
					//edges[0].getC(EdgeC).getEndPoint(e).getC(NodeC).gold += Config.AgentSize;
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
		if (mine)
			e.getC(SpriteC).setColor(209, 214, 223, 225);
		else
			e.getC(SpriteC).setColor(54, 45, 34, 225);
		originalGraphicSize = e.getC(SpriteC).flxSprite.width;
		return e;
	}
	
	function createGraphic(graphic, layer:FlxGroup):E{
		var e = new E(e);
		e.addC(SpriteC).init(graphic, layer);
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
		worldS.removeNode(e);
	}
	
	public var goldOffset:Int = 0;
	public function getEffectiveGold():Int{
		var total = 0;
		for(edge in edges){
			for(agent in edge.getC(EdgeC).getAgentsWithEndPoint(e)){
				total += agent.getC(NodeC).gold;
			}
		}
		return cast Math.max(total + gold + goldOffset, 0);
	}
	
	public function getTimeUntilDeath():Float{
		if(decayRate == 0) return Math.POSITIVE_INFINITY;
		return getEffectiveGold() / Config.Evaporation * decayRate;
	}
	
	public function getDistance(other:E):Float{
		return U.distance(x, y, other.getC(NodeC).x, other.getC(NodeC).y);
	}
}






