package rise;
import engine.entities.C;
import org.flixel.FlxG;

class GenerateNodeC extends C{
	
	@inject var worldS:WorldS;
	
	var squareSize:Int = 2500;
	
	public function init():Void{
		// generate nearby content
		
		var mineCount = 10;
		var village = 1;
		var mountains = 20;
		
		
		for (i in 0...mineCount){
			var point = randomPointInSquareCoord(0, 0);						
			worldS.createGold(point[0], point[1], Std.random(6) * 10 + 50);
		}
	}
	
	function randomPointInSquareCoord(x:Int, y:Int):Array<Int> {
		var halfSquareSize = Std.int(squareSize/2);
		return [Std.random(squareSize) - halfSquareSize  + (x * halfSquareSize), Std.random(squareSize) - halfSquareSize + (y * halfSquareSize)];
	}
	
	override public function destroy():Void{
		super.destroy();
	}
}