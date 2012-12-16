package rise;
import engine.entities.C;
import com.eclecticdesignstudio.motion.Actuate;

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
		//nodeC.goldOffset = -10;
		setCanBuildSomething(ableToBuild());
		
		m.add(updateS, UpdateS.UPDATE, onUpdate);		
	}
	
	function onUpdate():Void {
		setCanBuildSomething(ableToBuild());
	}

	function ableToBuild():Bool {
		return (nodeC.gold > Config.NodeBarracksCost || nodeC.gold > Config.NodeCastleCost || nodeC.gold > Config.NodeMineCost);
	}
	
	override public function destroy():Void{
		super.destroy();
	}
}






