package rise;
import engine.entities.C;
import engine.entities.E;
import org.flixel.FlxG;
import rise.NodeC.NodeType;
import com.eclecticdesignstudio.motion.Actuate;

class ButtonC extends C{
	
	@inject var updateS:UpdateS;
	@inject var worldS:WorldS;
	@inject var renderS:RenderS;
	
	var circle:E;
	var graphic:E;
	var initialCircleScale:Float = (Config.NodeHoverButtonRadius / Config.NodeCircleImageSize ) * 2;
	var type:NodeType;
	var disabled = false;
		
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

		var dis = (e.getC(NodeC).gold <= goldCost());
		if (disabled != dis) {
			disabled = dis;
			Actuate.tween(graphic.getC(SpriteC).flxSprite, 1, { alpha: disabled?0.2:1 }).onComplete( function () { animating: false } ); 
		}
		
		if (disabled)
			return;
		
		if (!FlxG.mouse.justPressed()) // dont bother testing of mouse isn't pressed down
			return;		
	
		var mouseX = FlxG.mouse.getWorldPosition().x;
		var mouseY = FlxG.mouse.getWorldPosition().y;
		
		var nodeRadius = e.getC(NodeC).radius;
			
		if (U.inCircle(x, y, (Config.NodeCircleImageSize * circle.getC(SpriteC).scaleX)/2, mouseX, mouseY)) {
			worldS.createNodeFromEntity(e, mouseX, mouseY, type);
			e.getC(RadialMenuC).animateMenu(false);
		}

	}
	
	function goldCost():Int {
		switch(type) {
			case NodeType.barracks:
				return Config.NodeBarracksCost;
			case NodeType.castle:
				return Config.NodeCastleCost;
			case NodeType.mine:
				return Config.NodeMineCost;
		}
	}
		
	function createCircle():E{
		var e = new E(e);
		e.addC(SpriteC).init('assets/rise_circle_highlight.png', renderS.interfaceLayer);
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






