package rise;
import engine.entities.C;
import com.eclecticdesignstudio.motion.Actuate;
import rise.NodeC.NodeState;

class NodeCastleC extends C{
	
	@inject var updateS:UpdateS;
	@inject var nodeC:NodeC;
	
	var initbool = false;
		
	public var canBuildSomething(default, setCanBuildSomething):Bool;
	function setCanBuildSomething(v : Bool):Bool {
		if (!initbool || v != canBuildSomething) {
			initbool = true;
			Actuate.tween(nodeC.graphic.getC(SpriteC).flxSprite, 1, { alpha:v?1.0:0.2 } );	
		}
		return canBuildSomething = v;
	}
	
	public function init():Void{
		nodeC.goldOffset = Config.CastleLie;
		//nodeC.maxGold = nodeC.mine ? 9999 : Config.CastleMax;
		nodeC.maxGold = 9999;
		setCanBuildSomething(ableToBuild());
		
		m.add(updateS, UpdateS.UPDATE, onUpdate);		
	}
	
	function onUpdate():Void {
		if (nodeC.mine)
			setCanBuildSomething(ableToBuild());
		else
			setCanBuildSomething(true);
	}

	function ableToBuild():Bool {
		//return (nodeC.gold > Config.NodeBarracksCost || nodeC.gold > Config.NodeCastleCost || nodeC.gold > Config.NodeMineCost || nodeC.gold > Config.NodeRoadCost);
		return nodeC.state == active;
	}
	
	override public function destroy():Void{
		super.destroy();
	}
}