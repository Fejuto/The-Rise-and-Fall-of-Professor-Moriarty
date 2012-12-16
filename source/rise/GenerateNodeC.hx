package rise;
import engine.entities.C;
import engine.entities.E;
import org.flixel.FlxG;
import rise.NodeC.NodeType;
import rise.NodeC.NodeState;

class GenerateNodeC extends C{
	
	@inject var worldS:WorldS;
	
	var squareSize:Int = 2500;
	
	public function init():Void{
		// generate nearby content
		
		var mineCount = 10;
		var villageCount = 1;
		var mountains = 20;
		
		
		for (i in 0...mineCount){
			var point = randomPointInSquareCoord(0, 0);
			while (!worldS.isEmptySpot(point[0], point[1])) {
				point = randomPointInSquareCoord(0, 0);
			}
			
			var centerNode = worldS.createGold(point[0], point[1], Std.random(6) * 10 + 50);
			
			// have valid first point
			var clusterCount = Std.random(6) + 2;
			while(clusterCount > 0) {
				var distance = Config.RandomizerGoldClusterRadius;
				var clusterPoint = randomPointNearPoint(point[0], point[1], distance);
				while(!worldS.isEmptySpot(clusterPoint[0], clusterPoint[1], Config.RandomizerGoldClusterRadius)) {
					distance += 10;
					clusterPoint = randomPointNearPoint(point[0], point[1], distance);
				}
				worldS.createGold(clusterPoint[0], clusterPoint[1], Std.random(6) * 10 + 50);
				
				clusterCount--;
			}			
		}
		
		for (i in 0...villageCount) {
			var castleCount = Std.random(3) + 2;
			var barracksCount = Std.random(2) + 1;
			var minerCount = 1;
			
			var point = randomPointInSquareCoord(0, 0);
			while (!worldS.isEmptySpot(point[0], point[1])) {
				point = randomPointInSquareCoord(0, 0);
			}
			
			point = [400 + 250, 300];
			var centerCastleE = worldS.createCastle(point[0], point[1], 100, false);
			centerCastleE.getC(NodeC).state = active;
			
			for (z in 0...castleCount) {
				createEnemyNodeType(point, NodeType.castle, centerCastleE);
			}
			
			for (z in 0...minerCount) {
				var p = createEnemyNodeType(point, NodeType.mine, centerCastleE);
				worldS.createGold(p[0]+200, p[1], 100);
			}
		}
	}
	
	function createEnemyNodeType(point:Array<Int>, type:NodeType, fromE:E):Array<Int> {
		var distance = Config.RandomizerVillageClusterRadius;
		var p = randomPointNearPoint(point[0], point[1], distance);
		var da = 4;
		while (!worldS.isEmptySpot(p[0], p[1], Config.RandomizerVillageClusterRadius)) {
			if (da <= 0) {						
				distance += 10;
				da = 4;
			}
			p = randomPointNearPoint(point[0], point[1], distance);
			da--;
		}
	
		if (fromE != null) 
			worldS.createNodeFromEntity(fromE, p[0], p[1], type, false);
			
		return p;
	}
	
	function randomPointInSquareCoord(x:Int, y:Int):Array<Int> {
		var halfSquareSize = Std.int(squareSize/2);
		return [Std.random(squareSize) - halfSquareSize  + (x * halfSquareSize), Std.random(squareSize) - halfSquareSize + (y * halfSquareSize)];
	}
	
	function randomPointNearPoint(x:Int, y:Int, maxDistance:Int):Array<Int> {
		var halfDistance = Std.int(maxDistance/2);
		return [ Std.random(maxDistance) - halfDistance + x, Std.random(maxDistance) - halfDistance + y];
	}
	
	override public function destroy():Void{
		super.destroy();
	}
}