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
		e.addC(CircleC).init(nodeC.x, nodeC.y, renderS.backgroundMenuLayer, [135, 111, 90, 225]);
		e.getC(CircleC).radius = 0;
		
		// create buttons
		buttonEntities = new Array();
		var buttonImageNames = [['rise_icon_monster_gray', NodeType.barracks], ['rise_icon_fort_gray', NodeType.castle], ['rise_icon_miner_gray', NodeType.mine]];//, ['rise_icon_road_gray', NodeType.road]];
		buttonDegrees = [360-degreesMargin, 0, degreesMargin, degreesMargin*2];
		var i = 0;
		while (i < buttonImageNames.length) {
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
		
		if (!e.getC(NodeC).canBuildSomething && !mouseOver)
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
		if (show) {
			e.getC(CircleC).radius = nodeC.radius;
			FlxG.play('assets/fs.mp3', 1.0, false, false);
		}
		Actuate.tween(e.getC(CircleC), 1, { radius: show?Config.NodeHoverRadius:0}).ease(new ElasticEaseOut(0.1, 0.4)).delay(show?0:0.2);
	
		for (e in buttonEntities) {
			Actuate.stop(e.getC(ButtonC));
			e.getC(ButtonC).disabled = !show;
			Actuate.tween(e.getC(ButtonC), 0.1, { scale: show?1:0 }).delay(show?0.2:0);
		}
		
	}
	
	override public function destroy():Void{
		super.destroy();
	}
}






