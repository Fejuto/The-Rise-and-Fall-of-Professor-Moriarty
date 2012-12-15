package rise;
import engine.entities.C;
import engine.entities.E;

class ButtonC extends C{
	
	var circle:E;
	var graphic:E;
	var initialCircleScale:Float = (Config.NodeHoverButtonRadius / Config.NodeRadiusImageSize) * 2;
	
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
	
	public function init(graphic:Dynamic):Void{
		this.circle = createCircle();
		this.graphic = createGraphic(graphic);
		
		this.scale = 0;
	}
		
	function createCircle():E{
		var e = new E(e);
		e.addC(SpriteC).init('assets/rise_circle_highlight.png');
		return e;
	}
	
	function createGraphic(graphic):E{
		var e = new E(e);
		e.addC(SpriteC).init(graphic);
		return e;
	}
	
	override public function destroy():Void{
		super.destroy();
	}
}






