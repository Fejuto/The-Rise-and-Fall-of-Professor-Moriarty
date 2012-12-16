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
	
	public function init():Void{
		nodes = new Array<E>();
		
		for (i in 0...5){
			createGold(Math.random() * FlxG.width, Math.random() * FlxG.height, Std.random(6) * 10 + 50);
		}
		var c1 = createCastle(FlxG.width/2, FlxG.height/2, 100);
		c1.getC(NodeC).state = NodeState.active;
		
		m.add(updateS, UpdateS.UPDATE, onUpdate);
	}

	function onUpdate():Void {
	}

	override public function destroy():Void{
		super.destroy();
	}
	
	public function addNode(e:E):Void{
		if(!e.hasC(NodeC)) throw "must have NodeC";
		nodes.push(e);
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
	
	function createNode(graphic:Dynamic, ?layer:FlxGroup, x:Float, y:Float, gold:Int, decayRate:Float):E{
		var e = new E(e);
		e.addC(NodeC).init(graphic, layer, x, y, gold, decayRate);
		return e;
	}
	
	public function createCastle(x:Float, y:Float, gold:Int):E{
		var e = createNode("assets/rise_icon_home_blue.png", x, y, gold, Config.CastleDecayRate);
		e.addC(NodeCastleC).init();
		e.addC(RadialMenuC).init();
		return e;
	}
	
	public function createBarracks(x:Float, y:Float, gold:Int):E{
		var e = createNode("assets/rise_icon_monster_blue.png", x, y, gold, Config.BarracksDecayRate);
		e.addC(NodeBarracksC).init();
		return e;
	}
	
	public function createGoldMine(x:Float, y:Float, gold:Int):E{
		var e = createNode("assets/rise_icon_miner_blue.png", x, y, gold, Config.GoldMineDecayRate);
		e.addC(NodeMineC).init();
		return e;
	}
	
	public function createGold(x:Float, y:Float, gold:Int):E{
		var e = createNode("assets/rise_icon_gold.png", renderS.gaiaLayer, x, y, gold, 0);
		e.addC(NodeGoldC).init();
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







