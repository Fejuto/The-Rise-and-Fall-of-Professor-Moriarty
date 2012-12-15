package rise;
import engine.entities.C;
import engine.entities.E;

class NodeC extends C{
	@inject var worldS:WorldS;
	
	var circle:E;
	var graphic:E;
	var edges:Array<E>;
	
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
	
	// prolly do something with the radius itself
	public var radius(getRadius, setRadius):Float;
	function setRadius(v:Float):Float {
		circle.getC(SpriteC).scaleY = v / Config.NodeRadiusImageSize;
		return circle.getC(SpriteC).scaleX = v / Config.NodeRadiusImageSize;
	}
	function getRadius():Float {
		return circle.getC(SpriteC).scaleX * Config.NodeRadiusImageSize;
	}
	
	public function init(g : Dynamic, x : Float, y : Float, radius : Float = Config.NodeStartRadius):Void{
		edges = new Array<E>();
		this.circle = createCircle();
		this.graphic = createGraphic(g);
		//worldS.addNode(e);
		
		this.x = x;
		this.y = y;
		this.radius = radius;
	}
	
	override public function destroy():Void{
		super.destroy();
		//worldS.removeNode(e);
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
	
	public function addEdge(e:E):Void{
		if(!e.hasC(EdgeC)) throw "no EdgeC";
		edges.push(e);
	}
	
	public function removeEdge(e:E):Void{
		edges.remove(e);
	}
}






