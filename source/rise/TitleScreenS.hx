package rise;
import engine.entities.C;
import engine.entities.E;
import org.flixel.FlxG;
import com.eclecticdesignstudio.motion.Actuate;
import com.eclecticdesignstudio.motion.easing.Linear;
import com.eclecticdesignstudio.motion.easing.Quad;

class TitleScreenS extends C{
	@inject var renderS:RenderS;
	@inject var updateS:UpdateS;
	@inject var scoreS:ScoreS;
	
	public function init():Void{
		if(scoreS.highScore > 1) return;
		e = new E(this.e);
		e.addC(SpriteC).init("assets/rise_title.png", renderS.interfaceLayer, 0,0);
		//e.getC(SpriteC).pixelWidth = FlxG.width;
		//e.getC(SpriteC).pixelHeight = FlxG.height; 
		e.getC(SpriteC).flxSprite.scrollFactor.x = 0;
		e.getC(SpriteC).flxSprite.scrollFactor.y = 0;
		e.getC(SpriteC).flxSprite.offset.x = 0;
		e.getC(SpriteC).flxSprite.offset.y = 0;
		
		m.add(updateS, UpdateS.UPDATE, onUpdate);
	}
	
	override public function destroy():Void{
		super.destroy();
	}
	
	function onUpdate():Void{
		if(FlxG.mouse.justPressed()){
			Actuate.tween(e.getC(SpriteC).flxSprite, 1, {alpha:0}).onComplete(function(){
				FlxG.switchState(new MenuState());
			}).ease(Linear.easeNone);
		}
	}
}