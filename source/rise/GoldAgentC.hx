package rise;
import engine.entities.C;
import engine.entities.E;
import com.eclecticdesignstudio.motion.Actuate;
import com.eclecticdesignstudio.motion.easing.Linear;

class GoldAgentC extends C{
	@inject var updateS:UpdateS;
	@inject var nodeC:NodeC;
	@inject var worldS:WorldS;
	
	public var targetNode:E;
	var temp:Float;
	
	public function init(targetNode:E):Void{
		setTarget(targetNode);
		m.add(updateS, UpdateS.UPDATE, onUpdate);
	}
	
	override public function destroy():Void{
		super.destroy();
		setTarget(null);
	}
	
	function setTarget(target:E):Void{
		if(targetNode != null){
			if(!targetNode.destroyed) targetNode.getC(NodeC).agents.remove(e);
		}
		targetNode = target;
		if(targetNode != null){
			targetNode.getC(NodeC).agents.push(e);
			Actuate.tween(nodeC, 1.0 / Config.AgentSpeed * nodeC.getDistance(targetNode), {x:targetNode.getC(NodeC).x, y:targetNode.getC(NodeC).y}).ease(Linear.easeNone).onComplete(onComplete);
		}
	}
	
	function onUpdate():Void{
		if(targetNode.destroyed){
			findTarget();
		}
	}
	
	function findTarget():Void{
		Actuate.stop(nodeC, null, false, false);
		var closest = worldS.getClosestBuilding(nodeC.x, nodeC.y, nodeC.mine);
		if(closest != null){
			setTarget(closest);
		}else{
			nodeC.gold = 0;
			updateS.kill(e);
		}
	}
	
	function onComplete():Void{
		if(targetNode.destroyed){
			findTarget();
		}else{
			targetNode.getC(NodeC).gold += nodeC.gold;
			nodeC.gold = 0;
			updateS.kill(e);
		}
	}
}






