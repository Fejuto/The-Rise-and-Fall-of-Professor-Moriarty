package rise;
import engine.entities.C;
import engine.entities.E;
import org.flixel.FlxG;
import com.eclecticdesignstudio.motion.MotionPath;
import com.eclecticdesignstudio.motion.Actuate;

class NodeBarracksC extends C{
	
	@inject var nodeC:NodeC;
	@inject var updateS:UpdateS;
	
	var monsters : Array<E>;
	var maxMonsterCount = 1;
	
	var spawnCounter : Float = 0;
	var spawnAttempt = 1;

	public function init():Void{
		monsters = new Array();
		
		m.add(updateS, UpdateS.UPDATE, onUpdate);
	}
	
	function onUpdate():Void {
		if (nodeC.gold > 80 && monsters.length <= 0 && spawnCounter > spawnAttempt) {			
			nodeC.gold -= 40;
			spawnMonster();
		}
		
		if (spawnCounter > spawnAttempt)
			spawnCounter = 0;
			
		spawnCounter += FlxG.elapsed;
	}
	
	function spawnMonster():Void {		
		
		var monster = new E(e);
		
		monster.addC(MonsterC).init(nodeC.x, nodeC.y);
		monsters.push(monster);
		
		var degrees = Math.random()*360;
		var point = U.pointOnEdgeOfCircle(nodeC.x, nodeC.y, Config.NodeStartRadius + 20, degrees);
		monster.getC(MonsterC).lastDegrees = degrees;
		Actuate.tween(monster.getC(MonsterC), 1, { x: point[0], y:point[1] });		
		
		//var path:MotionPath = new MotionPath().bezier(100, 100, 50, 50).line(20, 20);
		//Actuate.tween(monster.getC(MonsterC), 1, { x: path.x, y: path.y } );
	}
	
	override public function destroy():Void{
		super.destroy();
	}
}
