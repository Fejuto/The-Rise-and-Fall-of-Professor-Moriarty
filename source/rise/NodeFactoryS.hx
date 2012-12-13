package rise;
import engine.entities.C;
import engine.entities.E;

class NodeFactoryS extends C{
	public function init():Void{
		createNode(0,0);
	}
	
	override public function destroy():Void{
		super.destroy();
	}
	
	public function createNode(x:Float, y:Float):Void{
		var node:E = new E(e);
		node.addC(SpriteC).init("data/stick.png");
	}
}
