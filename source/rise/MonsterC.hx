package rise;
import engine.entities.C;
import org.flixel.FlxG;
import com.eclecticdesignstudio.motion.Actuate;
import com.eclecticdesignstudio.motion.easing.Linear;

enum MonsterState {
	inactive;
	idle;
	wandering;
	approaching;
	combat;
}

class MonsterC extends C{
	
	@inject var updateS:UpdateS;
	@inject var nodeC:NodeC;
	
	var wanderCounter : Float = 4;
	var wanderDelay : Float = 0;
	
	var health = 100;
	var attack = 100;
	var speed = 20;
	
	public var state (default, setState): MonsterState;
	function setState(v : MonsterState):MonsterState {
		if (v != state) {
			switch (v) {
				case MonsterState.combat:
					//bounce();
				case MonsterState.idle:
					monsterBounceY = 0;
					Actuate.stop(this);				
				case MonsterState.inactive:
					monsterBounceY = 0;
					Actuate.stop(this);				
				case MonsterState.wandering:
					bounce();
				case MonsterState.approaching:
					bounce();
			}
		}
		return state = v;
	}
	
	var targetNodeC:NodeC = null;
	
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
	
	var monsterBounceY = 0;
	
	public function init(x:Float, y:Float):Void{
		e.addC(CircleC).init(x, y, [209, 214, 223, 225]);
		e.getC(CircleC).radius = 12;
		
		e.addC(SpriteC).init(nodeC.mine?'assets/rise_icon_monster_red.png':'assets/rise_icon_monster_blue.png', x, y);
		e.getC(SpriteC).scaleX = 0.3;
		e.getC(SpriteC).scaleY = 0.3;
	
		//wanderDelay = 5;
		wanderDelay = Math.random() * 5 + 4;
	
		m.add(updateS, UpdateS.UPDATE, onUpdate);
		
	}
	
	function onUpdate():Void {
		
		if (wanderCounter > wanderDelay && state == MonsterState.idle) {
			
			wanderDelay = Math.random() * 5 + 4;			
			wanderCounter = 0;
			
			var distance = Math.random() * 40 + 20;
			var pn = Math.random() > 0.5;
			var newdeg = lastDegrees + (pn?distance:-distance);
			
			state = MonsterState.wandering;
			Actuate.update(wander, distance/speed, [lastDegrees], [newdeg], false).ease(Linear.easeNone).onComplete(function () {
				if (state == MonsterState.wandering) // validate that the state is still the one i started with
					state = MonsterState.idle;
			});
			
			lastDegrees = newdeg;
		} else if (state == MonsterState.approaching) {
			if (targetNodeC == null) {
				// return to base thing if target is gone and i'm still alive	
				state = MonsterState.idle; 
			}
		}
		
		if (state == MonsterState.idle)		
			wanderCounter += FlxG.elapsed;	
	}
	
	function bounce():Void {
		monsterBounceY = 0;
		Actuate.tween(this, 0.1, { monsterBounceY: 5 }, false).ease(Linear.easeNone).repeat().reflect();
	}
	
	function wander(td:Float):Void {

	  	var point = U.pointOnEdgeOfCircle(nodeC.x, nodeC.y, Config.NodeStartRadius + 20, td);
	  	x = point[0];
	  	y = point[1] + monsterBounceY;

	}
	
	function moveTo(x:Float, y:Float):Void {
		this.x = x;
		this.y = y + monsterBounceY;
	}
	
	public function attackTarget(targetNodeC:NodeC):Void {
		// stop any running wandering animation
		//Actuate.stop(this);
		//Actuate.stop(wander);
		return;
		
		this.targetNodeC = targetNodeC;
		var distance = U.distance(nodeC.x, nodeC.y, targetNodeC.x, targetNodeC.y);
		
		state = approaching;
		Actuate.update(moveTo, distance/speed, [x, y], [targetNodeC.x, targetNodeC], false).ease(Linear.easeNone).onComplete(function () {
			if (state == approaching) {
				state = combat;	
			}
		});
	}
	
	override public function destroy():Void{
		Actuate.stop(nodeC);
		Actuate.stop(this);
		
		super.destroy();
	}
}