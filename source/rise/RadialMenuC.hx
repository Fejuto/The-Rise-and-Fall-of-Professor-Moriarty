package rise;
import engine.entities.C;
import engine.entities.E;
import org.flixel.FlxG;
import com.eclecticdesignstudio.motion.Actuate;
import com.eclecticdesignstudio.motion.easing.Elastic.ElasticEaseOut;

class RadialMenuC extends C{
	@inject var updateS:UpdateS;
	
	var mouseDown = false;
	var buttonEntities : Array<E>;
	
	public function init():Void{
		m.add(updateS, UpdateS.UPDATE, onUpdate);
		
		buttonEntities = new Array();
		
		var denButton = new E(e);
		denButton.addC(ButtonC).init('assets/rise_icon_monster_gray.png');
		denButton.getC(ButtonC).x = e.getC(NodeC).x - e.getC(NodeC).radius * 2;
		denButton.getC(ButtonC).y = e.getC(NodeC).y - e.getC(NodeC).radius;				
		buttonEntities[0] = denButton;
		
		var castleButton = new E(e);
		castleButton.addC(ButtonC).init('assets/rise_icon_fort_gray.png');
		castleButton.getC(ButtonC).x = e.getC(NodeC).x;
		castleButton.getC(ButtonC).y = e.getC(NodeC).y - e.getC(NodeC).radius*2;				
		buttonEntities[1] = castleButton;		
		
		var mineButton = new E(e);
		mineButton.addC(ButtonC).init('assets/rise_icon_miner_gray.png');
		mineButton.getC(ButtonC).x = e.getC(NodeC).x + e.getC(NodeC).radius * 2;
		mineButton.getC(ButtonC).y = e.getC(NodeC).y - e.getC(NodeC).radius;				
		buttonEntities[2] = mineButton;
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
		Actuate.tween(e.getC(NodeC), 1, { radius: show?Config.NodeHoverRadius:Config.NodeStartRadius }).ease(new ElasticEaseOut(0.1, 0.4)).delay(show?0:0.2);
		
		var colors = e.getC(NodeC).circleSprite.getColor();
		if (show) {
			Actuate.update(setColor, 1, [colors[0], colors[1], colors[2], colors[3]], [255, 255, 255, 255]);
		} else {
			Actuate.update(setColor, 1, [colors[0], colors[1], colors[2], colors[3]], [209, 214, 223, 255]);
		}
		
		for (e in buttonEntities) {
			Actuate.tween(e.getC(ButtonC), 0.1, { scale: show?1:0 }).delay(show?0.2:0);
			
		}
		
	}
	
	function setColor(red : Int, green : Int, blue : Int, alpha : Int) {
		e.getC(NodeC).circleSprite.setColor(red, green, blue, alpha);
	}
	
	override public function destroy():Void{
		super.destroy();
	}
}






