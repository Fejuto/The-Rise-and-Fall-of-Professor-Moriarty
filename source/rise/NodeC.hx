package rise;
import engine.entities.C;
import engine.entities.E;

class NodeC extends C{
	@inject var worldS:WorldS;
	
	var circle:E;
	var graphic:E;
	
	public var x(getX, setX):Float;
	function getX():Float{
		FlxG.Log(circle);
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
	
	public function init(graphic : Dynamic):Void{
		circle = createCircle();
		graphic = createGraphic(graphic);
		worldS.addNode(e);
	}
	
	override public function destroy():Void{
		super.destroy();
	}
	
	function createCircle():E{
		var e = new E(e);
		e.addC(SpriteC).init('assets/rise_circle_light.png');
		return e;
	}
	
	function createGraphic(graphic):E{
		var e = new E(e);
		e.addC(SpriteC).init(graphic);
		return e;
	}
}






