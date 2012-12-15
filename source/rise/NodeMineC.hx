package rise;
import engine.entities.C;
import engine.entities.E;

class NodeMineC extends C{
	@inject var worldS:WorldS;
	@inject var updateS:UpdateS;
	@inject var nodeC:NodeC;
	
	public function init():Void{
		m.add(updateS, UpdateS.UPDATE, onUpdate);
	}
	
	override public function destroy():Void{
		super.destroy();
	}
	
	function onUpdate():Void{
		var golds:Array<E> = worldS.getNodesWith(NodeGoldC);
		var f = function(e1:E, e2:E):Int{
			var b:Bool = U.distance(nodeC.x, nodeC.y, e1.getC(NodeC).x, e1.getC(NodeC).y) > U.distance(nodeC.x, nodeC.y, e2.getC(NodeC).x, e2.getC(NodeC).y);
			return b?1:-1;
		}
		golds.sort(f);
	}
}
