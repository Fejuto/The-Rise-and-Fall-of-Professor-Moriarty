package rise;
import engine.entities.C;
import org.flixel.FlxText;
import org.flixel.FlxG;

class ScoreS extends C{
	@inject var renderS:RenderS;
	
	var text:FlxText;
	var text2:FlxText;

	var _score:Int = 0;
	public var score(getScore, setScore):Int;
	function getScore():Int{
		return _score;
	}
	function setScore(v:Int):Int{
		text.text = Std.string(v);
		if(v > highScore){
			highScore = v;
		}
		return _score = v;
	}

	var _highScore:Int = 0;
	public var highScore(getHighScore, setHighScore):Int;
	function getHighScore():Int{
		return _highScore;
	}
	function setHighScore(v:Int):Int{
		text2.text = Std.string(v);
		return _highScore = v;
	}
	
	public function init():Void{
		text = new FlxText(FlxG.width - 100,0,100,"1", true);
		text.size = 20;
		text.alignment = "right";
		text.scrollFactor.x = text.scrollFactor.y = 0;
		renderS.add(text, renderS.interfaceLayer);

		text2 = new FlxText(FlxG.width - 100,20,100,"1", true);
		text2.size = 20;
		text2.alignment = "right";
		text2.scrollFactor.x = text2.scrollFactor.y = 0;
		renderS.add(text2, renderS.interfaceLayer);
	}
	
	override public function destroy():Void{
		super.destroy();
	}
}