package rise;
import engine.entities.C;
import engine.entities.E;
import nme.events.Event;
import org.flixel.FlxG;
import com.eclecticdesignstudio.motion.Actuate;
import com.eclecticdesignstudio.motion.easing.Elastic.ElasticEaseOut;

class NodeFactoryS extends C{
	@inject var updateS:UpdateS;
	
	public function init():Void{
		m.add(updateS, UpdateS.UPDATE, onUpdate);
	}
	
	override public function destroy():Void{
		super.destroy();
	}
	
	function onUpdate():Void{
		if(FlxG.mouse.justPressed()){
			createNode(FlxG.mouse.getWorldPosition().x, FlxG.mouse.getWorldPosition().y);
		}
	}
	
	public function createNode(x:Float, y:Float):Void{
		var node:E = new E(e);
		node.addC(SpriteC).init("assets/data/stick.png", x, y);
		
		node.getC(SpriteC).scaleX = 0;
		node.getC(SpriteC).scaleY = 0;
		Actuate.tween(node.getC(SpriteC), 1, {scaleX:1, scaleY:1}).ease(new ElasticEaseOut(0.1, 0.2));
		FlxG.play("assets/pop.wav", 0.5);
	}
}







