package rise;
import engine.entities.C;
import org.flixel.FlxG;
import com.eclecticdesignstudio.motion.Actuate;
import com.eclecticdesignstudio.motion.easing.ExpoEaseInOut;

class RadialMenuC extends C{
	@inject var updateS:UpdateS;
	
	var mouseDown = false;
	
	public function init():Void{
		m.add(updateS, UpdateS.UPDATE, onUpdate);
	}
	
	function onUpdate():Void{
		var mouseX = FlxG.mouse.getWorldPosition().x;
		var mouseY = FlxG.mouse.getWorldPosition().y;
		
		var nodeX = e.getC(NodeC).x;
		var nodeY = e.getC(NodeC).y;
		var nodeRadius = e.getC(NodeC).radius;
	
		var newMouseDown = U.inCircle(nodeX, nodeY, nodeRadius, mouseX, mouseY);
		
		if (newMouseDown != mouseDown) {
			mouseDown = newMouseDown;
			animateMenu(mouseDown);	
		}
	}
	
	function animateMenu(show : Bool):Void {
		Actuate.tween(e.getC(NodeC), 1, { radius: show?Config.NodeHoverRadius:Config.NodeStartRadius }).ease(new ExpoEaseInOut());
		
		var colors = e.getC(NodeC).circleSprite.getColor();
		if (show)
			Actuate.update(setColor, 1, [colors[0], colors[1], colors[2], colors[3]], [255, 255, 255, 255]);
		else
			Actuate.update(setColor, 1, [colors[0], colors[1], colors[2], colors[3]], [209, 214, 223, 255]);
		
	}
	
	function setColor(red : Int, green : Int, blue : Int, alpha : Int) {
		e.getC(NodeC).circleSprite.setColor(red, green, blue, alpha);
	}
	
	override public function destroy():Void{
		super.destroy();
	}
}






