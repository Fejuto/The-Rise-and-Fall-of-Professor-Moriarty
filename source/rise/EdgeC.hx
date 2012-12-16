package rise;
import engine.entities.C;
import engine.entities.E;
import org.flixel.FlxG;
import org.flixel.FlxU;
import org.flixel.FlxPoint;

class EdgeC extends C{
	@inject var spriteC:SpriteC;
	
	public var node1:E;
	public var node2:E;
	public var agents:Array<E>;
	
	public function init(node1:E, node2:E):Void{
		this.node1 = node1;
		node1.getC(NodeC).addEdge(e);
		this.node2 = node2;
		node2.getC(NodeC).addEdge(e);
		agents = new Array<E>();
		
		updateEdge();
		
		m.add(node1.getC(NodeC), NodeC.MOVED, onMoved);
		m.add(node2.getC(NodeC), NodeC.MOVED, onMoved);
		m.add(node1, E.DESTROY, e.destroy);
		m.add(node2, E.DESTROY, e.destroy);
		
		if (!node1.getC(NodeC).mine || !node1.getC(NodeC).mine) {
			
		}
	}
	
	
	function onMoved():Void{
		updateEdge();		
	}
	
	function updateEdge():Void{
		var distance = U.distance(node1.getC(NodeC).x, node1.getC(NodeC).y, node2.getC(NodeC).x, node2.getC(NodeC).y);
		
		spriteC.flxSprite.offset.x = 0;
		spriteC.flxSprite.origin.x = spriteC.flxSprite.offset.x;
		spriteC.flxSprite.origin.y = spriteC.flxSprite.offset.y;
		spriteC.flxSprite.scale.x = distance / spriteC.flxSprite.width; 
		spriteC.flxSprite.scale.y = 10 / spriteC.flxSprite.height;
		spriteC.flxSprite.x = node1.getC(NodeC).x;
		spriteC.flxSprite.y = node1.getC(NodeC).y;
		
		var dx:Float = node2.getC(NodeC).x - node1.getC(NodeC).x;
		var dy:Float = node2.getC(NodeC).y - node1.getC(NodeC).y;
		spriteC.flxSprite.angle = U.toDegrees(Math.atan2(dy, dx));  
	}
	
	override public function destroy():Void{
		super.destroy();
		
		node1.getC(NodeC).removeEdge(e);
		node2.getC(NodeC).removeEdge(e);
	}

	public function getEndPoint(beginPoint:E):E{
		if(beginPoint.getC(NodeC) == node1.getC(NodeC)) return node2;
		if(beginPoint.getC(NodeC) == node2.getC(NodeC)) return node1;
		throw "neither";
	}
	
	public function getAgentsWithEndPoint(endPoint:E):Array<E>{
		return Lambda.array(Lambda.filter(agents, function(agent){
				return getEndPoint(agent.getC(GoldAgentC).fromNode).getC(NodeC) == endPoint.getC(NodeC);
			}
		));
	}
	
	public function addAgent(agent:E):Void{
		agents.push(agent);
	}
	
	public function removeAgent(agent:E):Void{
		agents.remove(agent);	
	}
	
	public function getLength():Float{
		return U.distance(node1.getC(NodeC).x, node1.getC(NodeC).y, node2.getC(NodeC).x, node2.getC(NodeC).y);
	}
}






