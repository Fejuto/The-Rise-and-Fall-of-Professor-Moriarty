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
		m.add(updateS, UpdateS.UPDATE, onUpdate);
		
		
		//createNode('', FlxG.mouse.getWorldPosition().x, FlxG.mouse.getWorldPosition().y);
		createCastle(FlxG.width/2, FlxG.height/2);
		//createCastle(0,0);
		
		FlxG.log(FlxG.width);
	}
	
	override public function destroy():Void{
		super.destroy();
	}
	
	function onUpdate():Void{
		if(FlxG.mouse.justPressed()){
			//createNode(FlxG.mouse.getWorldPosition().x, FlxG.mouse.getWorldPosition().y);
		}
	}
	
	/*public function createNode(x:Float, y:Float):Void{
		var node:E = new E(e);
		node.addC(SpriteC).init("assets/data/stick.png", x, y);
		
		node.getC(SpriteC).scaleX = 0;
		node.getC(SpriteC).scaleY = 0;
		Actuate.tween(node.getC(SpriteC), 1, {scaleX:1, scaleY:1}).ease(new ElasticEaseOut(0.1, 0.2));
		FlxG.play("assets/pop.wav", 0.5);
	}*/
	
	function createNode(graphic:Dynamic, x:Float, y:Float):E{
		var node = new E(e);
		node.addC(NodeC).init(graphic);
		node.getC(NodeC).x = x;
		node.getC(NodeC).y = y;

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
}







