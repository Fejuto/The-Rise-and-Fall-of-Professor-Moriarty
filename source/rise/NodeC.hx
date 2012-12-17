package rise;
import engine.entities.C;
import engine.entities.E;
import flash.events.Event;
import org.flixel.FlxG;
import com.eclecticdesignstudio.motion.Actuate;
import com.eclecticdesignstudio.motion.easing.Elastic;
import rise.MonsterC.MonsterState;
import org.flixel.FlxGroup;
import haxe.Json;

enum NodeState {
	dragging;
	building;
	active;
}

enum NodeType {
	barracks;
	mine;
	castle;
	road;
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
	public var edges:Array<E>;
	public var agents:Array<E>;
	public var attackers:Array<E>;
	
	var _gold:Int = 100;
	public var gold(getGold, setGold):Int;
	function getGold():Int{
		return _gold;
	}
	function setGold(v:Int):Int{
		var visual = v;
		if(state == building && v > 20){
			state = active;
		}
		if(v <= 5 && getEffectiveGold() > 0){
			visual = 5;
		}
		
		var area = visual / 100.0;
		if(area <= 0){
			if(v == 0 && state == building){
				
			}else{
				updateS.kill(e);
				if (!mine && !e.hasC(MonsterC) && !e.hasC(NodeGoldC)) // if enemy building dies drop gold
					//worldS.createGold(x, y, Std.random(6) * 10 + 50 * (e.hasC(NodeCastleC)?3:1));
					worldS.createGold(x, y, 50);
			}
		}
		
		if(area > 1){
			area = Math.pow(area, 0.5);
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
	public var maxGold:Int = 99999;
	
	public var state(default, default):NodeState;
	public var mine(default, default):Bool;
	
	public var x(getX, setX):Float;
	function getX():Float{
		return circle.getC(SpriteC).x; 
	}
	function setX(v:Float):Float{
		graphic.getC(SpriteC).x = v;
		var r = circle.getC(SpriteC).x = v;
		var evt = new MovedEvent(MOVED);
		evt.who = e;
		dispatchEvent(evt);
		return r;
	}
	
	public var y(getY, setY):Float;
	function getY():Float{
		return circle.getC(SpriteC).y;
	}
	function setY(v:Float):Float{
		graphic.getC(SpriteC).y = v;
		var r = circle.getC(SpriteC).y = v;
		var evt = new MovedEvent(MOVED);
		evt.who = e;
		dispatchEvent(evt);
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
			this.state = NodeState.dragging;
		else 
			this.state = state;
			
		if (layer == null)
			layer = renderS.defaultLayer;
		
		edges = new Array<E>();
		agents = new Array<E>();
		attackers = new Array<E>();
		
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
		
		m.add(worldS, NodeC.MOVED, onAnyMoved);
	}
	
	function onAnyMoved(evt:MovedEvent):Void{
		if(evt.who.hasC(NodeCastleC)){
			if(e.hasC(GoldAgentC)) return;
			if(e.hasC(MonsterC)) return;
			var hasAlreadyEdge:Bool = false;
			var theEdge:E = null;
			for(edge in edges){
				if(edge.getC(EdgeC).getEndPoint(e).getC(NodeC) == evt.who.getC(NodeC)){
					hasAlreadyEdge = true;
					theEdge = edge;
					break;
				}
			}
			
			if(evt.who.getC(NodeC).getDistance(e) <= Config.MaxEdgeDistance && !hasAlreadyEdge){
				if(evt.who.getC(NodeC).mine == mine){
					worldS.createEdge(e, evt.who);
				}
			}else if(evt.who.getC(NodeC).getDistance(e) > Config.MaxEdgeDistance && hasAlreadyEdge){
				updateS.kill(theEdge);
			}
		}
	}
	
		
	function onUpdate():Void {
		if (mine)
			setCanBuildSomething(state == active);
		else
			setCanBuildSomething(true);
		
		decline = decline || (isUnderAttack() && !e.hasC(NodeBarracksC));
		
		if (this.state == NodeState.dragging) {
			if (FlxG.mouse.justReleased()) {
				scrollS.enabled = true;
				if (e.hasC(FollowMouseC)) {
					e.getC(FollowMouseC).enabled = false;
				} 
				
				var validBuildingDropLocation = false;
				
				if (edges.length > 0) {
					
					if (e.hasC(NodeRoadC)) {
						var myClosestBuilding = worldS.getClosestBuilding(x, y, mine);						
						if (U.distance(myClosestBuilding.getC(NodeC).x, myClosestBuilding.getC(NodeC).y, x, y) < Config.NodeStartRadius) {
							worldS.createEdge(myClosestBuilding, edges[0].getC(EdgeC).getEndPoint(e));							
						} else {
							refund();		
						}
					} else {
						var closestNode = worldS.getClosestNodeToNode(e);
						var distance = U.distance(closestNode.getC(NodeC).x, closestNode.getC(NodeC).y, x, y);						
						validBuildingDropLocation = distance > Config.NodeStartRadius; 
						if (validBuildingDropLocation) {
							this.state = NodeState.building;
							gold = 0;
						} else {
							refund();
						}
					}
				}
				
				if (e.hasC(NodeRoadC) || !validBuildingDropLocation) 
					updateS.kill(e);
			}
		} else if (this.state == NodeState.active){
			decayCounter += FlxG.elapsed;
			while(decayRate > 0 && decayCounter > decayRate){
				decayCounter -= decayRate;
				evaporate();
			}
			
			sendCounter += FlxG.elapsed;
			sendCounter+=Math.random() / 1000;		
			while(sendCounter > Config.SendRate){
				sendCounter = 0;
				edges.sort(function(edge1, edge2){
					var other1 = edge1.getC(EdgeC).getEndPoint(e);
					var other2 = edge2.getC(EdgeC).getEndPoint(e);
					
					if (other1.getC(NodeC).state == NodeState.dragging) // move inactive ones to bottom 
						return 1;
					if (other2.getC(NodeC).state == NodeState.dragging)
						return -1;
						
					if(other1.hasC(NodeGoldC)){
						return 1;
					}
					if(other2.hasC(NodeGoldC)){
						return -1;
					}
						
					if(other1.getC(NodeC).mine != other2.getC(NodeC).mine){
						if(other1.getC(NodeC).mine && !other2.getC(NodeC).mine){
							return -1;
						}
					}
					
					var b = other1.getC(NodeC).getTimeUntilDeath() < other2.getC(NodeC).getTimeUntilDeath();
					return b?-1:1; 
				});
				
				//var targets = Lambda.array(Lambda.filter(edges, function(edge){}));
				
				var otherNode = null;
				if(edges.length>0){
					otherNode = edges[0].getC(EdgeC).getEndPoint(e).getC(NodeC);
				} 
				if((edges.length > 0) && (decline || gold > maxGold || otherNode.getTimeUntilDeath() < getTimeUntilDeath())){
					if(otherNode.e.hasC(NodeGoldC)){
						break;
					}
					
					if(otherNode.state == dragging || otherNode.decline) // if the most important edge node is inactive dont send any gold 
						break;
						
					if(otherNode.state != building && !e.hasC(NodeGoldC) && otherNode.e.hasC(NodeMineC)){
						break;
					}
					
					if(!(e.hasC(NodeGoldC) && otherNode.mine) && otherNode.getEffectiveGold() > otherNode.maxGold){
						break;
					}
					
					//if(e.hasC(NodeGoldC) && otherNode.e.hasC(NodeMineC) && otherNode.mine){
					if(!otherNode.mine && otherNode.e.hasC(NodeMineC)){
					}else{
						gold -= Config.AgentSize;
					}
					
					worldS.createGoldAgent(e, edges[0].getC(EdgeC).getEndPoint(e), Config.AgentSize, mine);
				}
			}			
		}
	}
	
	function refund():Void {
		var draggedFromNode = edges[0].getC(EdgeC).getEndPoint(e);
		draggedFromNode.getC(NodeC).gold += gold;
	}
	
	function isUnderAttack():Bool{
		for(attacker in attackers){
			if(attacker.getC(MonsterC).state == MonsterState.combat) return true;
		}
		
		return false;
	}
	
	function evaporate():Void{
		if(mine){
			gold -= Config.Evaporation;
		}else{
			gold -= Config.Evaporation * 1;
		}
	}
	
	function createCircle(layer:FlxGroup):E{
		var e = new E(e);
		e.addC(SpriteC).init('assets/rise_circle_white.png', layer);		
		if (!mine)
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
	
	public function isBuilding():Bool {
		return (e.hasC(NodeBarracksC) || e.hasC(NodeCastleC) || e.hasC(NodeMineC));
	}
	
	override public function destroy():Void{
		super.destroy();
		worldS.removeNode(e);
	}
	
	public var goldOffset:Int = 0;
	public function getEffectiveGold():Int{
		var total = 0;
		for(agent in agents){
			total += agent.getC(NodeC).gold;
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
	
	var initbool = false;
	public var canBuildSomething(default, setCanBuildSomething):Bool;
	function setCanBuildSomething(v : Bool):Bool {
		if (!initbool || v != canBuildSomething) {
			initbool = true;
			Actuate.tween(graphic.getC(SpriteC).flxSprite, 1, { alpha:v?1.0:0.2 } );	
		}
		return canBuildSomething = v;
	}
}






