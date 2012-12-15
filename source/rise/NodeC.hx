package rise;
import engine.entities.C;
import engine.entities.E;

class NodeC extends C{
	
	var circle:E;
	var graphic:E;
	
	public function init():Void{
		circle = createCircle();
		graphic = createGraphic();
	}
	
	override public function destroy():Void{
		super.destroy();
	}
	
	function createCircle():E{
		var e = new E(e);
		e.addC(SpriteC).init("");
		return e;
		//SpriteC
	}
	
	function createGraphic():E{
		return null;
		//SpriteC
	}
}






