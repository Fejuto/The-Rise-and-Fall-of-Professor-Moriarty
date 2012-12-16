package rise;
import engine.entities.C;
import org.flixel.FlxG;

class GenerateNodeC extends C{
	
	@inject var worldS:WorldS;
	
	var squareSize:Int = 2500;
	
	public function init():Void{
		// generate nearby content
		
		var mineCount = 20;
		var villageCount = 5;
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
				var distance = 100;
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
			var point = randomPointInSquareCoord(0, 0);
			while (!worldS.isEmptySpot(point[0], point[1])) {
				point = randomPointInSquareCoord(0, 0);
			}
			
			worldS.createCastle(point[0], point[1], 100, false);		
		}
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