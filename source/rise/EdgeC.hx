package rise;
import engine.entities.C;
import engine.entities.E;
import org.flixel.FlxG;
import org.flixel.FlxU;
import org.flixel.FlxPoint;

class EdgeC extends C{
	@inject var spriteC:SpriteC;
	
	public var node1:E;
	public var node2:E;
	
	public function init(node1:E, node2:E):Void{
		this.node1 = node1;
		node1.getC(NodeC).addEdge(e);
		this.node2 = node2;
		node2.getC(NodeC).addEdge(e);
		
		updateEdge();
		
		m.add(node1.getC(NodeC), NodeC.MOVED, onMoved);
		m.add(node2.getC(NodeC), NodeC.MOVED, onMoved);
	}
	
	
	function onMoved():Void{
		updateEdge();		
	}
	
	function updateEdge():Void{
		var distance = U.distance(node1.getC(NodeC).x, node1.getC(NodeC).y, node2.getC(NodeC).x, node2.getC(NodeC).y);
		
		spriteC.flxSprite.offset.x = 0;
		spriteC.flxSprite.origin.x = spriteC.flxSprite.offset.x;
		spriteC.flxSprite.origin.y = spriteC.flxSprite.offset.y;
		spriteC.flxSprite.scale.x = distance / spriteC.flxSprite.width; 
		spriteC.flxSprite.scale.y = 10 / spriteC.flxSprite.height;
		spriteC.flxSprite.angle = FlxU.getAngle(new FlxPoint(node2.getC(NodeC).x, node2.getC(NodeC).y), new FlxPoint(node1.getC(NodeC).x, node1.getC(NodeC).y)) + 90;
	}
	
	override public function destroy():Void{
		super.destroy();
		
		node1.getC(NodeC).removeEdge(e);
		node2.getC(NodeC).removeEdge(e);
	}

	public function getEndPoint(beginPoint:E):E{
		if(beginPoint == node1) return node2;
		if(beginPoint == node2) return node1;
		throw "neither";
	}
}






