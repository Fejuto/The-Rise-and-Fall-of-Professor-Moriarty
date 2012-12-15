package rise;
import engine.entities.C;
import org.flixel.FlxG;
import com.eclecticdesignstudio.motion.Actuate;
import com.eclecticdesignstudio.motion.easing.Linear;

class MonsterC extends C{
	
	@inject var updateS:UpdateS;
	@inject var nodeC:NodeC;
	
	var wanderCounter : Float = 4;
	var wanderDelay : Float = 0;
	var wandering = false;
	
	var health = 100;
	var attack = 100;
	var speed = 50;
	
	public var lastDegrees : Float;
	
	public var x(getX, setX):Float;
	function getX():Float{
		return e.getC(SpriteC).x; 
	}
	function setX(v:Float):Float{
		e.getC(CircleC).x = v;
		return e.getC(SpriteC).x = v;
	}
	
	public var y(getY, setY):Float;
	function getY():Float{
		return e.getC(SpriteC).y;
	}
	function setY(v:Float):Float{	
		e.getC(CircleC).y = v;
		return e.getC(SpriteC).y = v;		
	}
	
	public function init(x:Float, y:Float):Void{
		e.addC(CircleC).init(x, y, [209, 214, 223, 225]);
		e.getC(CircleC).radius = 12;
		
		e.addC(SpriteC).init('assets/rise_icon_monster_blue.png', x, y);
		e.getC(SpriteC).scaleX = 0.3;
		e.getC(SpriteC).scaleY = 0.3;
	
		//wanderDelay = 5;
		wanderDelay = Math.random() * 5 + 4;
	
		m.add(updateS, UpdateS.UPDATE, onUpdate);
	}
	
	function onUpdate():Void {
		
		if (wanderCounter > wanderDelay && !wandering) {
			wanderDelay = Math.random() * 5 + 4;			
			wanderCounter = 0;
			
			wandering  = true;
			
			var distance = Math.random() * 40 + 20;
			var pn = Math.random() > 0.5;
			var newdeg = lastDegrees + (pn?distance:-distance);
			
			Actuate.update(wander, distance/speed, [lastDegrees], [newdeg], false).onComplete(function () {
				wandering = false;
			});
											
			lastDegrees = newdeg;
		}
		
		if (!wandering)		
			wanderCounter += FlxG.elapsed;	
	}
	
	function wander(td:Float):Void {
		var point = U.pointOnEdgeOfCircle(nodeC.x, nodeC.y, Config.NodeStartRadius + 20, Math.random() * 360);
	  	var point = U.pointOnEdgeOfCircle(nodeC.x, nodeC.y, Config.NodeStartRadius + 20, td);
	  	x = point[0];
	  	y = point[1];
	}
	
	override public function destroy():Void{
		Actuate.stop(nodeC);
		Actuate.stop(this);
		
		super.destroy();
	}
}