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
	@inject var renderS:RenderS;
	@inject var nodeC:NodeC;
	@inject var nodeBarracksC:NodeBarracksC;
	
	var monsterBounceY = 0;
	
	var wanderCounter : Float = 0;
	var wanderDelay : Float = 0; // at first 0, will be randomly set later
	
	var attackCounter : Float = 0;
	var attackDelay : Float = 1;
	
	var health = 100;
	var attack = 100;
	var speed = 40;
	
	public var state (default, setState): MonsterState;
	function setState(v : MonsterState):MonsterState {
		if (v != state) {
			switch (v) {
				case MonsterState.combat:
					
				case MonsterState.idle:					
					Actuate.stop(this);
					wanderDelay = Math.random() * 2 + 1;
					wanderCounter = 0;				
				case MonsterState.inactive:
					Actuate.stop(this);				
				case MonsterState.wandering:					
					bounce();
				case MonsterState.approaching:
					Actuate.stop(this);
					bounce();
			}
		}
		return state = v;
	}
	
	var _targetNode:NodeC = null;
	var targetNodeC(default, setTargetNode):NodeC = null;
	function setTargetNode(v:NodeC):NodeC{
		if(_targetNode != null){
			_targetNode.attackers.remove(e);
		}
		if(v != null){
			v.attackers.push(e);
		}
		return _targetNode = v;
	}
	
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
		e.addC(CircleC).init(x, y, renderS.topLayer, nodeC.mine?[209, 214, 223, 225]:[54, 45, 34, 225]);
		e.getC(CircleC).radius = 12;		

		e.addC(SpriteC).init(nodeC.mine?'assets/rise_icon_monster_red.png':'assets/rise_icon_monster_blue.png', renderS.topLayer, x, y);
		e.getC(SpriteC).scaleX = 0.3;
		e.getC(SpriteC).scaleY = 0.3;
	
		m.add(updateS, UpdateS.UPDATE, onUpdate);
		
	}
	
	function onUpdate():Void {
		
		if (wanderCounter > wanderDelay && state == MonsterState.idle) {
			
			wanderDelay = Math.random() * 2 + 1;			
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
			
		} else if (state == combat) {
			// mosnter standing on top of building
			if (attackCounter > attackDelay) {
				attackCounter = 0;
				
				var newY = y - 30;
				Actuate.tween(this, 0.2, { y: newY }).repeat(1).reflect().onComplete(function () {
					targetNodeC.gold -= 10;
					if (targetNodeC.gold <= 0) {
						nodeBarracksC.targetDestroyed(targetNodeC, this);
						returnToBase();
					}
				});
			}
			
			attackCounter += FlxG.elapsed;
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
	
	function moveTo(nx:Int, ny:Int):Void {		
		x = nx;
		y = ny + monsterBounceY;
	}
	
	function returnToBase():Void {
		targetNodeC = null;
		
		var point = U.pointOnEdgeOfCircle(nodeC.x, nodeC.y, Config.NodeStartRadius + 20, lastDegrees);
		var distance = U.distance(x, y, point[0], point[1]);
				
		state = approaching;
		Actuate.update(moveTo, distance/(speed * 2), [x,y], [point[0], point[1]], false).ease(Linear.easeNone).onComplete(function () {			
			state = idle;
		});
	}
	
	public function attackTarget(targetNodeC:NodeC):Void {
		// stop any running wandering animation
		//Actuate.stop(this);
		//Actuate.stop(wander);
		
		this.targetNodeC = targetNodeC;
		var distance = U.distance(x, y, targetNodeC.x, targetNodeC.y);
		
		state = approaching;
		Actuate.update(moveTo, distance/(speed * 2), [x, y], [targetNodeC.x, targetNodeC.y], false).ease(Linear.easeNone).onComplete(function () {
			if (state == approaching) {
				state = combat;	
			}
		});
	}
	
	override public function destroy():Void{
		setTargetNode(null);
		Actuate.stop(nodeC);
		Actuate.stop(this);
		Actuate.stop(moveTo);
		
		super.destroy();
	}
}