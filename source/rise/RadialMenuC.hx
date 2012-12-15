package rise;
import engine.entities.C;
import org.flixel.FlxG;
import com.eclecticdesignstudio.motion.Actuate;

class RadialMenuC extends C{
	@inject var updateS:UpdateS;
	
	var mouseOver = false;
	
	public function init():Void{
		m.add(updateS, UpdateS.UPDATE, onUpdate);
	}
	
	function onUpdate():Void{
		var mouseX = FlxG.mouse.getWorldPosition().x;
		var mouseY = FlxG.mouse.getWorldPosition().y;
		
		var nodeX = e.getC(NodeC).x;
		var nodeY = e.getC(NodeC).y;
		var nodeRadius = e.getC(NodeC).radius;
		FlxG.log(nodeRadius);
	
		mouseOver = inCircle(nodeX, nodeY, nodeRadius, mouseX, mouseY); 
		Actuate.tween(e.getC(NodeC), 1, { radius: mouseOver?Config.NodeHoverRadius:100 });
	}
	
	function inCircle(cx : Float, cy : Float, radius : Float, x : Float, y : Float):Bool {
		var sqdist = Math.pow(cx - x, 2) + Math.pow(cy - y, 2);
		return sqdist <= Math.pow(radius, 2);
	}
	
	override public function destroy():Void{
		super.destroy();
	}
}






