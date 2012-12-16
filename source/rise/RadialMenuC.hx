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
	@inject var renderS:RenderS;
	@inject var nodeC:NodeC;
	
	var mouseOver = false;
	var buttonEntities : Array<E>;
	var degreesMargin = Config.NodeHoverButtonDegreesMargin;
	var buttonDegrees : Array<Int>;
	
	var circle:E;
	
	public function init():Void{
		
		// setup circle
		e.addC(CircleC).init(nodeC.x, nodeC.y, renderS.backgroundMenuLayer);
		e.getC(CircleC).radius = 0;
		
		// create buttons
		buttonEntities = new Array();
		var buttonImageNames = [['rise_icon_monster_gray', NodeType.barracks], ['rise_icon_fort_gray', NodeType.castle], ['rise_icon_miner_gray', NodeType.mine]];
		buttonDegrees = [360-degreesMargin, 0, degreesMargin];
		var i = 0;
		while (i < 3) {
			var button = new E(e);	
			button.addC(ButtonC).init('assets/'+buttonImageNames[i][0]+'.png', buttonImageNames[i][1]);
			buttonEntities[i] = button;
			i++;
		}
		layout();
		
		// event listeners
		m.add(nodeC, NodeC.MOVED, layout);
		m.add(updateS, UpdateS.UPDATE, onUpdate);
	}
	
	function layout():Void {
		
		for (i in  0...buttonEntities.length) {
			var e = buttonEntities[i]; 
			var pointOnEdge = U.pointOnEdgeOfCircle(nodeC.x, nodeC.y, Config.NodeHoverRadius, buttonDegrees[i]);
			e.getC(ButtonC).x = pointOnEdge[0];
			e.getC(ButtonC).y = pointOnEdge[1];	
		}
		
		e.getC(CircleC).x = nodeC.x;
		e.getC(CircleC).y = nodeC.y;
			
	}
	
	function onUpdate():Void{
		if (nodeC.state != NodeState.active) 
			return;
		
		if (FlxG.mouse.pressed())
			return;
		
		if ((nodeC.gold <= Config.NodeBarracksCost|Config.NodeCastleCost|Config.NodeMineCost) && !mouseOver)
			return;
		
		
		// a wild menu appears!
		var mouseX = FlxG.mouse.getWorldPosition().x;
		var mouseY = FlxG.mouse.getWorldPosition().y;
		
		var nodeX = nodeC.x;
		var nodeY = nodeC.y;
		var nodeRadius = nodeC.radius;
	
		var newMouseOver = U.inCircle(nodeX, nodeY, mouseOver?Config.NodeHoverRadius+30:Config.NodeStartRadius, mouseX, mouseY);
		
		if (newMouseOver != mouseOver) {
			mouseOver = newMouseOver;
			animateMenu(mouseOver);
		}
	}
	
	public function animateMenu(show : Bool):Void {
		if (show)
			e.getC(CircleC).radius = nodeC.radius;
		Actuate.tween(e.getC(CircleC), 1, { radius: show?Config.NodeHoverRadius:0}).ease(new ElasticEaseOut(0.1, 0.4)).delay(show?0:0.2);
		
		/*
		var colors = nodeC.circleSprite.getColor();
		if (show) {
			Actuate.update(setColor, 1, [colors[0], colors[1], colors[2], colors[3]], [255, 255, 255, 255]);
		} else {
			Actuate.update(setColor, 1, [colors[0], colors[1], colors[2], colors[3]], [209, 214, 223, 255]);
		}*/
		
		for (e in buttonEntities) {
			Actuate.tween(e.getC(ButtonC), 0.1, { scale: show?1:0 }).delay(show?0.2:0);
		}
		
	}
	
	function setColor(red : Int, green : Int, blue : Int, alpha : Int) {
		nodeC.circleSprite.setColor(red, green, blue, alpha);
	}
	
	override public function destroy():Void{
		super.destroy();
	}
}






