package rise;
import engine.entities.C;
import engine.entities.E;
import org.flixel.FlxG;
import rise.NodeC.NodeType;
import com.eclecticdesignstudio.motion.Actuate;
import com.eclecticdesignstudio.motion.easing.Elastic.ElasticEaseOut;
import com.eclecticdesignstudio.motion.easing.Linear;

class ButtonC extends C{
	
	@inject var updateS:UpdateS;
	@inject var worldS:WorldS;
	@inject var renderS:RenderS;
	
	var circle:E;
	var graphic:E;
	var initialCircleScale:Float = (Config.NodeHoverButtonRadius / Config.NodeCircleImageSize ) * 2;
	var type:NodeType;
	public var disabled = false;
	
	var mouseOver = false;	
		
	public var x(getX, setX):Float;
	function getX():Float{
		return circle.getC(SpriteC).x; 
	}
	function setX(v:Float):Float{
		graphic.getC(SpriteC).x = v;
		return circle.getC(SpriteC).x = v;
	}
	
	public var y(getY, setY):Float;
	function getY():Float{
		return circle.getC(SpriteC).y;
	}
	function setY(v:Float):Float{
		graphic.getC(SpriteC).y = v;
		return circle.getC(SpriteC).y = v;
	}
	
	public var scale(getScale, setScale):Float;
	function getScale():Float{
		return circle.getC(SpriteC).scaleX;
	}
	function setScale(v:Float):Float{
		graphic.getC(SpriteC).scaleX = v;
		graphic.getC(SpriteC).scaleY = v;
		circle.getC(SpriteC).scaleX = v * initialCircleScale;
		return circle.getC(SpriteC).scaleY = v * initialCircleScale;
	}
	
	public function init(graphic:Dynamic, type:NodeType):Void{
		this.type = type;
		this.circle = createCircle();
		this.graphic = createGraphic(graphic);
		
		this.scale = 0;
		
		m.add(updateS, UpdateS.UPDATE, onUpdate);
	}
	
	function onUpdate():Void{ 
		/*var dis = (e.getC(NodeC).getEffectiveGold() <= goldCost() + 20);
		if (disabled != dis) {
			disabled = dis;
			Actuate.tween(graphic.getC(SpriteC).flxSprite, 1, { alpha: disabled?0.2:1 }).onComplete( function () { animating: false } ); 
		}*/
		
		if (disabled)
			return;
		if (scale == 0)
			return;
		
		var mouseX = FlxG.mouse.getWorldPosition().x;
		var mouseY = FlxG.mouse.getWorldPosition().y;
		
		var nodeRadius = e.getC(NodeC).radius;
			
		var newMouseOver = U.distance(mouseX, mouseY, x, y) < 36;		
		if (newMouseOver != mouseOver) {
			mouseOver = newMouseOver;
			animateMenu(mouseOver);
		}
		
		if (!FlxG.mouse.justPressed()) // dont bother testing of mouse isn't pressed down
			return;		
			
		if (mouseOver) {
			worldS.createNodeFromEntity(e, mouseX, mouseY, type);
			e.getC(RadialMenuC).animateMenu(false);
		}

	}
	
	public function animateMenu(show : Bool):Void {
		if (show) {			
			FlxG.play('assets/fs.mp3', 1.0, false, false);
		}		
		Actuate.tween(this, 1, { scale: show?1.2:1 }, false).ease(new ElasticEaseOut(0.9, 1.0));
	}
	
	function goldCost():Int {
		switch(type) {
			case NodeType.barracks:
				return Config.NodeBarracksCost;
			case NodeType.castle:
				return Config.NodeCastleCost;
			case NodeType.mine:
				return Config.NodeMineCost;
			case NodeType.road:
				return Config.NodeRoadCost;
		}
	}
		
	function createCircle():E{
		var e = new E(e);
		e.addC(SpriteC).init('assets/rise_circle_white.png', renderS.interfaceLayer);
		e.getC(SpriteC).setColor(135, 111, 90, 225);
		return e;
	}
	
	function createGraphic(graphic):E{
		var e = new E(e);
		e.addC(SpriteC).init(graphic, renderS.interfaceLayer);
		return e;
	}
	
	override public function destroy():Void{
		super.destroy();
	}
}






