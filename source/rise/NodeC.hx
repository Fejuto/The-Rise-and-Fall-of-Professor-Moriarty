package rise;
import engine.entities.C;
import engine.entities.E;

class NodeC extends C{
	@inject var worldS:WorldS;
	
	var circle:E;
	var graphic:E;
	var edges:Array<E>;
	
	public function init(x:Float, y:Float):Void{
		edges = new Array<E>();
		circle = createCircle(x,y);
		graphic = createGraphic(x,y);
		
		worldS.addNode(e);
	}
	
	override public function destroy():Void{
		super.destroy();
		worldS.removeNode(e);
	}
	
	function createCircle(x:Float, y:Float):E{
		var e = new E(e);
		e.addC(SpriteC).init("", x, y);
		return e;
	}
	
	function createGraphic(x:Float, y:Float):E{
		var e = new E(e);
		e.addC(SpriteC).init("", x, y);
		return e;
	}
}






