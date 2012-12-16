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

class WorldS extends C{
	@inject var updateS:UpdateS;
	@inject var renderS:RenderS;
	@inject var scrollS:ScrollS;
	
	public var nodes:Array<E>;
	public var enemyNodes:Array<E>;
	
	public function init():Void{
		nodes = new Array<E>();
		enemyNodes = new Array<E>();
		
		e.addC(GenerateNodeC).init();
		
		for (i in 0...5){
			createGold(Math.random() * FlxG.width, Math.random() * FlxG.height, Std.random(6) * 10 + 50);
		}
		var c1 = createCastle(FlxG.width/2, FlxG.height/2, 100);
		c1.getC(NodeC).state = NodeState.active;
		
		var ec = createCastle(FlxG.width/2 - 200, FlxG.height/2, 100, false);

		m.add(updateS, UpdateS.UPDATE, onUpdate);
	}

	function onUpdate():Void {
	}

	override public function destroy():Void{
		super.destroy();
	}
	
	public function addNode(e:E):Void{
		if(!e.hasC(NodeC)) throw "must have NodeC";
		if (e.getC(NodeC).mine)
			nodes.push(e);
		else
			enemyNodes.push(e);
	}
	
	public function removeNode(e:E):Void{
		if(!e.hasC(NodeC)) throw "must have NodeC";
		if (e.getC(NodeC).mine)
			nodes.remove(e);
		else
			enemyNodes.remove(e);
	}
	
	public function getNodesWith<T>(type:Class<T>):Array<E>{
		return Lambda.array(Lambda.filter(nodes, function(e){return e.hasC(type);}));
	}
	
	public function createNodeFromEntity(fromE:E, x:Float, y:Float, type:NodeType):Void{
		scrollS.enabled = false;
		
		fromE.getC(NodeC).gold -= 20;
		
		var newE;
		
		switch(type) {
			case NodeType.barracks:
				newE = createBarracks(x,y,20);
			case NodeType.castle:
				newE = createCastle(x,y,20);
			case NodeType.mine:
				newE = createGoldMine(x,y,20);
		}
		
		newE.addC(FollowMouseC).init(true);
		newE.getC(NodeC).state = NodeState.dragging;
		if(fromE != null && newE != null){
			createEdge(fromE, newE);
		}
	}
	
	function createNode(graphic:Dynamic, ?layer:FlxGroup, x:Float, y:Float, gold:Int, decayRate:Float, ?state:NodeState, ?mine:Bool):E{
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
		var e = createNode("assets/rise_icon_gold.png", renderS.gaiaLayer, x, y, gold, 0, NodeState.active); // gold deposites start out active
		var flxSprite = e.getC(NodeC).graphic.getC(SpriteC).flxSprite;
		flxSprite.scale.x = flxSprite.scale.y = 0.5;
		e.addC(NodeGoldC).init();
		return e;
	}
	
	public function createGoldAgent(edge:E, fromNode:E, gold:Int, ?mine:Bool = true):E{
		if(!edge.hasC(EdgeC)) throw "must have edge";
		if(!fromNode.hasC(NodeC)) throw "most have node";
		
		var e = createNode("assets/rise_icon_gold.png", fromNode.getC(NodeC).x, fromNode.getC(NodeC).y, gold, 0, NodeState.active, mine);
		var flxSprite = e.getC(NodeC).graphic.getC(SpriteC).flxSprite;
		flxSprite.scale.x = flxSprite.scale.y = 0.25;
		e.addC(GoldAgentC).init(edge, fromNode);
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







