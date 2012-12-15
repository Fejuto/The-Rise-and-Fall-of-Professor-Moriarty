package rise;
import engine.entities.C;
import engine.entities.E;

class EdgeC extends C{
	
	public var node1:E;
	public var node2:E;
	
	public function init(node1:E, node2:E):Void{
		this.node1 = node1;
		node1.getC(NodeC).addEdge(e);
		this.node2 = node2;
		node2.getC(NodeC).addEdge(e);
	}
	
	override public function destroy():Void{
		super.destroy();
		
		node1.getC(NodeC).removeEdge(e);
		node2.getC(NodeC).removeEdge(e);
	}

	public function getEndPoint(beginPoint:E):E{
		if(beginPoint == node1) return node2;
		if(beginPoint == node2) return node1;
		throw "neither";
	}
}






