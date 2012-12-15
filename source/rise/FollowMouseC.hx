package rise;
import engine.entities.C;
import org.flixel.FlxG;

class FollowMouseC extends C{
	@inject var updateS:UpdateS;
	@inject var nodeC:NodeC;
	
	public function init():Void{
		m.add(updateS, UpdateS.UPDATE, onUpdate);
	}
	
	function onUpdate():Void{
		var pos = FlxG.mouse.getWorldPosition();
		nodeC.x = pos.x;
		nodeC.y = pos.y;
	}
	
	override public function destroy():Void{
		super.destroy();
	}
}






