package rise;
import engine.entities.C;
import engine.entities.E;
import NodeC.NodeState;
import nme.events.Event;

class NodeMineC extends C{
	@inject var worldS:WorldS;
	@inject var updateS:UpdateS;
	@inject var nodeC:NodeC;
	
	var edges:Array<E>;
	
	public function init():Void{
		edges = new Array<E>();
		nodeC.goldOffset = 10;
		m.add(updateS, UpdateS.UPDATE, onUpdate);
	}
	
	override public function destroy():Void{
		super.destroy();
	}
	
	function onUpdate():Void{
		if(nodeC.state == dragging){
			for(e in edges.copy()){
				if(e.getC(EdgeC).getLength() > Config.MineDistance){
					updateS.kill(e);
				}
			}
		}
		
		if(edges.length < 2){
			findClosestMine();		
		}
		
		nodeC.decline = edges.length == 0;
	}
	
	function findClosestMine():Void{
		//if(Math.random() < 0.99) return;
		
		var golds:Array<E> = worldS.getNodesWith(NodeGoldC);
		var golds = Lambda.array(Lambda.filter(golds, function(e){return U.distance(nodeC.x, nodeC.y, e.getC(NodeC).x, e.getC(NodeC).y) <= Config.MineDistance;}));
		var f = function(e1:E, e2:E):Int{
			var b:Bool = U.distance(nodeC.x, nodeC.y, e1.getC(NodeC).x, e1.getC(NodeC).y) > U.distance(nodeC.x, nodeC.y, e2.getC(NodeC).x, e2.getC(NodeC).y);
			return b?1:-1;
		}
		golds.sort(f);
		
		if(golds.length > 0){
			var edge = worldS.createEdge(e, golds[0]);
			edges.push(edge);
			m.add(edge, E.DESTROY, onEdgeDestroy);
		}
	}
	
	function onEdgeDestroy(e:Event):Void{
		edges.remove(e.target);
	}
}
