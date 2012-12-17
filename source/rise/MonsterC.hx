package rise;
import engine.entities.C;
import engine.entities.E;
import org.flixel.FlxG;
import com.eclecticdesignstudio.motion.Actuate;
import com.eclecticdesignstudio.motion.easing.Linear;
import flash.geom.Point;

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
	@inject var worldS:WorldS;
	
	var monsterBounceY = 0;
	var lastMonsterBounceY = 0;
	
	var wanderCounter : Float = 0;
	var wanderDelay : Float = 0; // at first 0, will be randomly set later
	
	var attackCounter : Float = 0;
	var attackDelay : Float = 1;
	
	var attack = 100;
	var speed = 40;
	var attackRadius = 40;
	
	public var rawY (getRawY, null):Float;
	function getRawY():Float {
		return nodeC.y - lastMonsterBounceY;
	}
	
	public var state (default, setState): MonsterState;
	function setState(v : MonsterState):MonsterState {
		if (v != state) {
			switch (v) {
				case MonsterState.combat:
				case MonsterState.idle:
					wanderDelay = Math.random() * 2 + 1;
					wanderCounter = 0;				
				case MonsterState.inactive:	
				case MonsterState.wandering:					
					bounce();
				case MonsterState.approaching:					
					bounce();
			}
		}
		return state = v;
	}
	
	var parentNode:E;
	
	var _targetNode:NodeC = null;
	var targetNodeC(getTargetNode, setTargetNode):NodeC = null;
	function getTargetNode():NodeC{
		return _targetNode;
	}
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
	
	public function init(parentNode:E):Void{
		this.parentNode = parentNode;
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
				if(!e.destroyed){
				if (state == MonsterState.wandering) // validate that the state is still the one i started with
					state = MonsterState.idle;
				}
			});
			
			lastDegrees = newdeg;
		} else if (state == MonsterState.approaching) {
				
			if (targetNodeC != null) {
				// move towards
				var tp = new Point(targetNodeC.x, targetNodeC.y);
				if (targetNodeC.e.hasC(MonsterC)) {
					tp = new Point(targetNodeC.x, targetNodeC.e.getC(MonsterC).rawY);
				}
				var mp = new Point(nodeC.x, rawY);
				var vel = tp.subtract(mp);
				vel.normalize((speed*2)*FlxG.elapsed);
				
				mp = mp.add(vel);
				moveTo(mp.x, mp.y);
				
				if (targetNodeC.getDistance(e) < attackRadius) {
					state = combat;
				} 
			}
			
		} else if (state == combat) {
			if (targetNodeC.getDistance(e) > attackRadius * 2) {				
				state = approaching;
				
			} else {
			
				// mosnter standing on top of building
				if (attackCounter > attackDelay) {
					attackCounter = 0;

					var newY = nodeC.y - 30;
					Actuate.tween(nodeC, 0.2, { y: newY }).repeat(1).reflect().onComplete(function () {
						if (targetNodeC.e.destroyed) {							
							returnToBase();
							return;
						}
						
						targetNodeC.gold -= 10;						
					});
				}
				
				attackCounter += FlxG.elapsed;
				
			}
		}
		
		if (state == MonsterState.idle)		
			wanderCounter += FlxG.elapsed;
			
		if (nodeC.gold <= 0)
			parentNode.getC(NodeBarracksC).monsterDied(e);
		
	}
	
	function bounce():Void {
		Actuate.stop(this);
		monsterBounceY = 0;
		Actuate.tween(this, 0.1, { monsterBounceY: -5 }, false).ease(Linear.easeNone).repeat().reflect();
	}
	
	function wander(td:Float):Void {
		if(e.destroyed) return;
	  	var point = U.pointOnEdgeOfCircle(parentNode.getC(NodeC).x, parentNode.getC(NodeC).y, Config.NodeStartRadius + 20, td);
	  	nodeC.x = point[0];
	  	nodeC.y = point[1] + monsterBounceY;

	}
	
	function moveTo(nx:Float, ny:Float):Void {		
		nodeC.x = nx;
		nodeC.y = ny + monsterBounceY;
		lastMonsterBounceY = monsterBounceY;
	}
	
	public function returnToBase():Void {
		targetNodeC = null;
		stopAllAnimations();
		
		var point = U.pointOnEdgeOfCircle(parentNode.getC(NodeC).x, parentNode.getC(NodeC).y, Config.NodeStartRadius + 20, lastDegrees);
		var distance = U.distance(nodeC.x, nodeC.y, point[0], point[1]);
		
		state = approaching;
		Actuate.update(moveTo, distance/(speed * 2), [nodeC.x,nodeC.y], [point[0], point[1]], false).ease(Linear.easeNone).onComplete(function () {			
			state = idle;
		});
	}
	
	public function attackTarget(targetNodeC:NodeC):Void {
		// stop any running wandering animation
		//Actuate.stop(this);
		//Actuate.stop(wander);
		
		this.targetNodeC = targetNodeC;		
		var distance = U.distance(nodeC.x, nodeC.y, targetNodeC.x, targetNodeC.y);
		
		state = approaching;
		/*Actuate.update(moveTo, distance/(speed * 2), [nodeC.x, nodeC.y], [targetNodeC.x, targetNodeC.y], false).ease(Linear.easeNone).onComplete(function () {
			if (state == approaching) {
				state = combat;	
			}
		});*/
	}
	
	function stopAllAnimations():Void {
		Actuate.stop(nodeC);
		Actuate.stop(this);
		Actuate.stop(moveTo);
		Actuate.stop(wander);
		
	}
	
	override public function destroy():Void{
		setTargetNode(null);
		stopAllAnimations();
		
		super.destroy();
	}
}