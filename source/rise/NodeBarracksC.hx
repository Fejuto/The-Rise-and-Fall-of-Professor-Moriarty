package rise;
import engine.entities.C;
import engine.entities.E;
import org.flixel.FlxG;
import com.eclecticdesignstudio.motion.MotionPath;
import com.eclecticdesignstudio.motion.Actuate;
import rise.MonsterC.MonsterState;
import rise.NodeC.NodeState;

class NodeBarracksC extends C{
	
	@inject var nodeC:NodeC;
	@inject var updateS:UpdateS;
	@inject var worldS:WorldS;
	
	var monsters : Array<E>;
	var maxMonsterCount = 1;
	
	var spawnCounter : Float = 0;
	var spawnDelay = 1;
	
	public var targetNode:E = null;

	public function init():Void{
		monsters = new Array<E>();
		nodeC.goldOffset = Config.BarracksLie;
		nodeC.maxGold = Config.BarracksMax;
		
		m.add(updateS, UpdateS.UPDATE, onUpdate);
		//spawnMonster();
	}
	
	function onUpdate():Void {
		if (nodeC.state != active)
			return;
		
		if (nodeC.gold >= 40 && monsters.length < maxMonsterCount && spawnCounter > spawnDelay) {			
			nodeC.gold -= 20;
			spawnMonster();
		}
		
		if (spawnCounter > spawnDelay)
			spawnCounter = 0;
			
		spawnCounter += FlxG.elapsed;
		
		if (targetNode == null) { // only start looking for things to attack when i actually have monsters
			
			var node = worldS.getClosestBuilding(nodeC.x, nodeC.y, !nodeC.mine, true); // including monsters			
			if (node != null && node.getC(NodeC).gold > 0){										
				if(U.distance(nodeC.x, nodeC.y, node.getC(NodeC).x, node.getC(NodeC).y) < Config.BarracksAttackRange) {
					targetNode = node;
				}
			}
			
		} else {
			if (targetNode.destroyed) {
				targetNode = null;
				// call back monsters
				for (monster in monsters) {
					monster.getC(MonsterC).returnToBase();			
				}
			} else {
				// dispatch monsters
				for (monster in monsters) {
					if (monster.getC(MonsterC).state == idle || monster.getC(MonsterC).state == wandering) {				
						monster.getC(MonsterC).attackTarget(targetNode.getC(NodeC));
					}
				}		
				
			}
		}
		
		nodeC.decline = (targetNode == null) && nodeC.mine;
		
	}
	
	function spawnMonster():Void {		
		
		var monster = worldS.createMonster(e, 20, nodeC.mine);		
		monster.getC(MonsterC).state = MonsterState.inactive;
		monsters.push(monster);
		
		var degrees = Math.random()*360;
		var point = U.pointOnEdgeOfCircle(nodeC.x, nodeC.y, Config.NodeStartRadius + 20, degrees);
		monster.getC(MonsterC).lastDegrees = degrees;
		Actuate.tween(monster.getC(NodeC), 1, { x: point[0], y:point[1] }).onComplete(function(){
			monster.getC(MonsterC).state = MonsterState.idle;
		});		
		
	}
	
	// monster 'delegation'
	
	public function monsterDied(monster:E):Void {
		monsters.remove(monster);
	}
	
	override public function destroy():Void{
		// kill my monsters
		for (monster in monsters) {
			updateS.kill(monster);
		}
		
		super.destroy();
	}
}
