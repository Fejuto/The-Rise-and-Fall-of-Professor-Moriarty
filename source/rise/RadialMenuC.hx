package rise;
import engine.entities.C;
import org.flixel.FlxG;

class RadialMenuC extends C{
	@inject var updateS:UpdateS;
	
	public function init():Void{
		m.add(updateS, UpdateS.UPDATE, onUpdate);
	}
	
	function onUpdate():Void{
		var mouseX = FlxG.mouse.getWorldPosition().x;
		var mouseY = FlxG.mouse.getWorldPosition().y;
		
		//e.getC(NodeC).x;
	}	
	
	override public function destroy():Void{
		super.destroy();
	}
}






