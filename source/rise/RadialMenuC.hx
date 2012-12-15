package rise;
import engine.entities.C;
import engine.entities.E;
import org.flixel.FlxG;
import com.eclecticdesignstudio.motion.Actuate;
import com.eclecticdesignstudio.motion.easing.Elastic.ElasticEaseOut;
import rise.NodeC.NodeState;
import rise.NodeC.NodeType;


class RadialMenuC extends C{
	@inject var updateS:UpdateS;
	
	var mouseOver = false;
	var buttonEntities : Array<E>;
	
	public function init():Void{
		m.add(updateS, UpdateS.UPDATE, onUpdate);
		
		buttonEntities = new Array();
		
		var buttonImageNames = [['rise_icon_monster_gray', NodeType.barracks], ['rise_icon_fort_gray', NodeType.castle], ['rise_icon_miner_gray', NodeType.mine]];
		var degreesMargin = Config.NodeHoverButtonDegreesMargin;
		var buttonDegrees = [360-degreesMargin, 0, degreesMargin];
		
		var i = 0;
		while (i < 3) {
			var button = new E(e);	
			button.addC(ButtonC).init('assets/'+buttonImageNames[i][0]+'.png', buttonImageNames[i][1]);
			var pointOnEdge = U.pointOnEdgeOfCircle(e.getC(NodeC).x, e.getC(NodeC).y, e.getC(NodeC).radius*2, buttonDegrees[i]);
			button.getC(ButtonC).x = pointOnEdge[0];
			button.getC(ButtonC).y = pointOnEdge[1];
			buttonEntities[i] = button;
			i++;
		}
	}
	
	function onUpdate():Void{
		if (e.getC(NodeC).state != NodeState.active) 
			return;
			
		if (FlxG.mouse.pressed())
			return;
			
		
		var mouseX = FlxG.mouse.getWorldPosition().x;
		var mouseY = FlxG.mouse.getWorldPosition().y;
		
		var nodeX = e.getC(NodeC).x;
		var nodeY = e.getC(NodeC).y;
		var nodeRadius = e.getC(NodeC).radius;
	
		var newMouseOver = U.inCircle(nodeX, nodeY, nodeRadius, mouseX, mouseY);
		
		if (newMouseOver != mouseOver) {
			mouseOver = newMouseOver;
			animateMenu(mouseOver);
		}
	}
	
	function animateMenu(show : Bool):Void {
		Actuate.stop(e.getC(NodeC));
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






