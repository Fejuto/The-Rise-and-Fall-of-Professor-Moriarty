package rise;
import engine.entities.C;
import engine.entities.E;
import com.eclecticdesignstudio.motion.Actuate;
import com.eclecticdesignstudio.motion.easing.Linear;

class GoldAgentC extends C{
	@inject var updateS:UpdateS;
	@inject var nodeC:NodeC;
	
	var edge:E;
	public var fromNode:E;
	var alive:Bool = true;
	
	public function init(edge:E, fromNode:E):Void{
		this.edge = edge;
		this.fromNode = fromNode;
		
		edge.getC(EdgeC).addAgent(e);
		var toNode = edge.getC(EdgeC).getEndPoint(fromNode);
		Actuate.tween(nodeC, 1.0 / Config.AgentSpeed * fromNode.getC(NodeC).getDistance(toNode), {x:toNode.getC(NodeC).x, y:toNode.getC(NodeC).y}).ease(Linear.easeNone).onComplete(onComplete);
		
		m.add(edge, E.DESTROY, e.destroy);
	}
	
	override public function destroy():Void{
		super.destroy();
		alive = false;
		Actuate.stop(nodeC);
		edge.getC(EdgeC).removeAgent(e);
		fromNode.getC(NodeC).gold += nodeC.gold;
	}
	
	function onComplete():Void{
		if(alive){
			edge.getC(EdgeC).removeAgent(e);
			edge.getC(EdgeC).getEndPoint(fromNode).getC(NodeC).gold += nodeC.gold;
			nodeC.gold = 0;
			updateS.kill(e);
		}
	}
}






