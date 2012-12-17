package rise;
import engine.entities.C;
import com.eclecticdesignstudio.motion.Actuate;
import rise.NodeC.NodeState;

class NodeCastleC extends C{
	
	@inject var updateS:UpdateS;
	@inject var nodeC:NodeC;
	@inject var scoreS:ScoreS;
	
	var addedToScore = false;
	
	public function init():Void{
		nodeC.goldOffset = Config.CastleLie;
		nodeC.maxGold = nodeC.mine ? 9999 : Config.CastleMax;
		if(nodeC.mine) 	
		//nodeC.maxGold = 9999;
		m.add(updateS, UpdateS.UPDATE, onUpdate);
	}
	
	function onUpdate():Void{
		if(!addedToScore && nodeC.state == active && nodeC.mine){
			addedToScore = true;
			scoreS.score += 1;  
		}
	}
	
	override public function destroy():Void{
		super.destroy();
		if(addedToScore) scoreS.score -= 1;	
	}
}