package rise;
import engine.entities.C;
import org.flixel.FlxG;
import org.flixel.FlxText;

class BlinkC extends C{
	@inject var scoreS:ScoreS;
	@inject var updateS:UpdateS;
	
	var blink:Bool = false;
	var target:FlxText;
	
	public function init(target:FlxText):Void{
		this.target = target;
		m.add(updateS, UpdateS.UPDATE, onUpdate);
		m.add(scoreS, ScoreS.HIGHER_SCORE, onHigherScore);
		m.add(scoreS, ScoreS.LOWER_SCORE, onLowerScore);
	}
	
	override public function destroy():Void{
		super.destroy();
	}
	
	var counter:Float = 0;
	function onUpdate():Void{
		counter += FlxG.elapsed;
		
		if(blink){
			target.visible = counter % 0.66 < 0.44;
		}else{
			target.visible = false;
		}
	}
	
	function onLowerScore():Void{
		blink = true;
	}
	
	function onHigherScore():Void{
		blink = false;
	}
}