package rise;
import engine.entities.C;
import engine.entities.E;

class WorldS extends C{
	
	public var nodes:Array<E>;
	
	public function init():Void{
	}
	
	override public function destroy():Void{
		super.destroy();
	}
	
	public function addNode(e:E):Void{
		if(!e.hasC(NodeC)) throw "must have NodeC";
		nodes.push(e);
	}
	
	public function removeNode(e:E):Void{
		nodes.remove(e);
	}
}






