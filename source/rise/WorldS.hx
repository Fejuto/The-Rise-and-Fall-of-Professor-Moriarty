package rise;
import engine.entities.C;
import engine.entities.E;
import nme.events.Event;
import org.flixel.FlxG;
import com.eclecticdesignstudio.motion.Actuate;
import com.eclecticdesignstudio.motion.easing.Elastic.ElasticEaseOut;
import rise.NodeC.NodeState;
import rise.NodeC.NodeType;
import org.flixel.FlxGroup;
import org.flixel.FlxPoint;
import org.flixel.FlxU;

class WorldS extends C{
	@inject var updateS:UpdateS;
	@inject var renderS:RenderS;
	@inject var scrollS:ScrollS;
	
	public var nodes:Array<E>;
		
	public function init():Void{
		nodes = new Array<E>();
		
		var sX = FlxG.width/2;
		var sY = FlxG.height/2;
		var playerBase = createCastle(sX, sY, 300);
		playerBase.getC(NodeC).state = NodeState.active;
		return;
		
		var mine = createGoldMine(sX + 100, sY + 100, 30, true);
		mine.getC(NodeC).state = NodeState.active;
		createEdge(playerBase, mine);
		
		var monsterDen = createBarracks(sX - 100, sY + 100, 0, true);
		monsterDen.getC(NodeC).state = NodeState.building;
		createEdge(playerBase, monsterDen);
		
		var gold = createGold(sX + 200, sY + 100, 150);
		
		var opponent = createCastle(sX - 200, sY + 100, 50, false);
		opponent.getC(NodeC).state = active;
		
		//var ec = createCastle(FlxG.width/2 - 200, FlxG.height/2, 100, false);
		//ec.getC(NodeC).state = NodeState.active;
		
		var generate = e.addC(GenerateNodeC);
		
		generate.createVillageAtPoint([0,0]);
		generate.createVillageAtPoint([FlxG.width,0]);
		
		
		m.add(updateS, UpdateS.UPDATE, onUpdate);
	}

	function onUpdate():Void {
		return;
		if (FlxG.mouse.justReleased()) {
			trace('mouse click at ' + FlxG.mouse.getWorldPosition().x + ',' + FlxG.mouse.getWorldPosition().y);
		}
	}

	override public function destroy():Void{
		super.destroy();
	}
	
	public function addNode(e:E):Void{
		if(!e.hasC(NodeC)) throw "must have NodeC";
		nodes.push(e);
	}
	
	public function removeNode(e:E):Void{
		if(!e.hasC(NodeC)) throw "must have NodeC";
		nodes.remove(e);
	}
	
	public function isEmptySpot<T>(x:Int, y:Int, ?distanceRadius:Int = Config.RandomizerPlacementRadius, ?type:Class<T>, ?typedDistance:Int):Bool {
		
		for (node in nodes) {
			var nodeC = node.getC(NodeC);
			if (type != null && node.hasC(type)) {
				if (U.distance(x, y, nodeC.x, nodeC.y) < typedDistance)
					return false; 
			} else {
				if (U.distance(x, y, nodeC.x, nodeC.y) < distanceRadius) 
					return false;	
			}
			
		}
			
		return true;
	}
	
	public function getNodesWith<T>(type:Class<T>):Array<E>{		
		return Lambda.array(Lambda.filter(nodes, function(e){return e.hasC(type);}));
	}

	public function getClosestNodeToNode(e:E):E {
		var winner : E = null;
		var minDist:Float = Math.POSITIVE_INFINITY;
		var x = e.getC(NodeC).x;
		var y = e.getC(NodeC).y;
		
		for (node in nodes){
			if (e == node) continue; // skip myself
			
			var dist = U.distance(x,y,node.getC(NodeC).x,node.getC(NodeC).y);
			if(dist < minDist){
				winner = node;
				minDist = dist;
			}
		}
		return winner;
	}
	
	public function getClosestNodeToPoint(x:Float, y:Float):E {
		var winner : E = null;
		var minDist:Float = Math.POSITIVE_INFINITY;
		
		for (node in nodes){
			if (e == node) continue; // skip myself
			
			var dist = U.distance(x,y,node.getC(NodeC).x,node.getC(NodeC).y);
			if(dist < minDist){
				winner = node;
				minDist = dist;
			}
		}
		return winner;
	}

	public function getClosestBuilding(x:Float, y:Float, mine:Bool, includingMonsters:Bool = false):E{
		var winner : E = null;
		var minDist:Float = Math.POSITIVE_INFINITY;
		for (node in nodes){
			if (includingMonsters) {
				if(!node.hasC(MonsterC)) {
					if (!node.getC(NodeC).isBuilding()) continue;
				}
			} else {
				if(!node.getC(NodeC).isBuilding()) continue;
			}
			if(node.getC(NodeC).mine != mine) continue;
			if(node.getC(NodeC).state != active) continue;
			var dist = U.distance(x,y,node.getC(NodeC).x,node.getC(NodeC).y);
			if(dist < minDist){
				winner = node;
				minDist = dist;
			}
		}
		return winner;		
	}
	
	public function createNodeFromEntity(fromE:E, x:Float, y:Float, type:NodeType, ?mine:Bool = true):Void{
		
		//fromE.getC(NodeC).gold -= 20;
		
		var newE;
		
		switch(type) {
			case NodeType.barracks:
				newE = createBarracks(x,y,50, mine);
			case NodeType.castle:
				newE = createCastle(x,y,50, mine);
			case NodeType.mine:
				newE = createGoldMine(x,y,50, mine);
			case NodeType.road:
				newE = createRoad(x,y,50);			
		}
		
		if (mine) {
			scrollS.enabled = false;
			newE.addC(FollowMouseC).init(true);
			newE.getC(NodeC).state = dragging;	
		} else {
			newE.getC(NodeC).state = active;
		}
		
		if(fromE != null && newE != null){
			createEdge(fromE, newE);
		}
	}
	
	function createNode(graphic:Dynamic, ?layer:FlxGroup, x:Float, y:Float, gold:Int, ?decayRate:Float, ?state:NodeState, ?mine:Bool):E{
		var e = new E(e);
		e.addC(NodeC).init(graphic, layer, x, y, gold, decayRate, state, mine);
		return e;
	}
	
	public function createCastle(x:Float, y:Float, gold:Int, ?mine:Bool = true):E{
		var e = createNode(mine?"assets/rise_icon_home_red.png":'assets/rise_icon_home_blue.png', x, y, gold, Config.CastleDecayRate, mine);		
		e.addC(NodeCastleC).init();
		if (mine) 
			e.addC(RadialMenuC).init();
		return e;
	}
	
	public function createBarracks(x:Float, y:Float, gold:Int, ?mine:Bool = true):E{
		var e = createNode(mine?"assets/rise_icon_monster_red.png":"assets/rise_icon_monster_blue.png", x, y, gold, Config.BarracksDecayRate, mine);
		e.addC(NodeBarracksC).init();		
		return e;
	}
	
	public function createGoldMine(x:Float, y:Float, gold:Int, ?mine:Bool = true):E{
		var e = createNode(mine?"assets/rise_icon_miner_red.png":"assets/rise_icon_miner_blue.png", x, y, gold, Config.GoldMineDecayRate, mine);
		e.addC(NodeMineC).init();
		return e;
	}
	
	public function createGold(x:Float, y:Float, gold:Int):E{
		var e = createNode("assets/rise_icon_gold.png", renderS.backgroundMenuLayer, x, y, gold, 0, NodeState.active); // gold deposites start out active
		var flxSprite = e.getC(NodeC).graphic.getC(SpriteC).flxSprite;
		flxSprite.scale.x = flxSprite.scale.y = 0.5;
		e.addC(NodeGoldC).init();
		return e;
	}
	
	public function createRoad(x:Float, y:Float, gold:Int):E {
		var e = createNode("assets/rise_icon_road_red.png", renderS.topLayer, x, y, gold);
		e.addC(NodeRoadC).init();		
		return e;
	}
	
	public function createMountain(x:Float, y:Float):E {
		var e = createNode('assets/rise_mountain.png', renderS.gaiaLayer, x, y, 1);
		e.getC(NodeC).state = active;
		return e;
	}
	
	public function createGoldAgent(fromNode:E, toNode:E, gold:Int, ?mine:Bool = true):E{
		if(!toNode.hasC(NodeC)) throw "must have edge";
		if(!fromNode.hasC(NodeC)) throw "most have node";
		
		var e = createNode("assets/rise_icon_gold.png", renderS.agentLayer, fromNode.getC(NodeC).x, fromNode.getC(NodeC).y, gold, 0, NodeState.active, mine);
		e.getC(NodeC).targetScaleFactor *= 0.75;
		e.getC(NodeC).gold = e.getC(NodeC).gold;
		var flxSprite = e.getC(NodeC).graphic.getC(SpriteC).flxSprite;
		flxSprite.scale.x = flxSprite.scale.y = 0.25;
		e.addC(GoldAgentC).init(toNode);
		return e;
	}
	
	public function createMonster(fromNode:E, gold:Int, ?mine:Bool = true):E {
		var e = createNode(mine?'assets/rise_icon_monster_red.png':'assets/rise_icon_monster_blue.png', renderS.topLayer, fromNode.getC(NodeC).x, fromNode.getC(NodeC).y, gold, 0, NodeState.active, mine);
		e.getC(NodeC).targetScaleFactor *= 0.4;
		e.getC(NodeC).gold = e.getC(NodeC).gold;
		var flxSprite = e.getC(NodeC).graphic.getC(SpriteC).flxSprite;
		flxSprite.scale.x = flxSprite.scale.y = 0.25;
		e.addC(MonsterC).init(fromNode);
		return e;
	}
	
	public function createEdge(node1:E, node2:E):E{
		var e = new E(e);
		var bmd = FlxG.createBitmap(1, 1, 0xffffffff, false, "WorldS.createEdge");
		
		e.addC(SpriteC).init(bmd, renderS.edgeLayer, node1.getC(NodeC).x, node1.getC(NodeC).y, false, false, 0, 0, false, "WorldS.createEdge");
		e.addC(EdgeC).init(node1, node2);
		return e;
	}
	
}







