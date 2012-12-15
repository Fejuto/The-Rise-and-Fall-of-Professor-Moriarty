package rise;
import engine.entities.C;
import engine.entities.E;
import nme.events.Event;
import org.flixel.FlxG;
import com.eclecticdesignstudio.motion.Actuate;
import com.eclecticdesignstudio.motion.easing.Elastic.ElasticEaseOut;

class WorldS extends C{
	@inject var updateS:UpdateS;
	
	public function init():Void{
		createCastle(FlxG.width/2, FlxG.height/2);
	}
	
	override public function destroy():Void{
		super.destroy();
	}
	
	function createNode(graphic:Dynamic, x:Float, y:Float):E{
		var e = new E(e);
		e.addC(NodeC).init(graphic, x, y);
		return e;
	}
	
	public function createCastle(x:Float, y:Float):E{
		var e = createNode("assets/rise_icon_home_blue.png", x, y);
		e.addC(NodeCastleC).init();
		return e;
	}
	
	public function createGoldMine(x:Float, y:Float):E{
		return null;
	}
	
	public function createEdge(node1:E, node2:E):E{
		var e = new E(e);
		return e;
	}
}







