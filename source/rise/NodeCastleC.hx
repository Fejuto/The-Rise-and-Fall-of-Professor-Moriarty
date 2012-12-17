package rise;
import engine.entities.C;
import com.eclecticdesignstudio.motion.Actuate;
import rise.NodeC.NodeState;

class NodeCastleC extends C{
	
	@inject var updateS:UpdateS;
	@inject var nodeC:NodeC;
	
	public function init():Void{
		nodeC.goldOffset = Config.CastleLie;
		nodeC.maxGold = nodeC.mine ? 9999 : Config.CastleMax;
		//nodeC.maxGold = 9999;
	}
	
	override public function destroy():Void{
		super.destroy();
	}
}