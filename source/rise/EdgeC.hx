package rise;
import engine.entities.C;

class EdgeC extends C{
	
	public var node1:E;
	public var node2:E;
	
	public function init(node1:E, node2:E):Void{
		this.node1 = node1;
		this.node2 = node2;
	}
	
	override public function destroy():Void{
		super.destroy();
	}

	public function getEndPoint(beginPoint:E):E{
		if(beginPoint == node1) return node2;
		if(beginPoint == node2) return node1;
		throw "neither";
	}
}






