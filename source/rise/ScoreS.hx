package rise;
import engine.entities.C;
import org.flixel.FlxText;
import org.flixel.FlxG;
import engine.entities.E;

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
		var e:E = new E(e);
		e.addC(SpriteC).init("assets/rise_score_background.png", renderS.interfaceLayer, 667, 43);
		e.getC(SpriteC).flxSprite.scrollFactor.x = 0;
		e.getC(SpriteC).flxSprite.scrollFactor.y = 0;
		
		e = new E(this.e);
		e.addC(SpriteC).init("assets/rise_icon_fort_white.png", renderS.interfaceLayer, FlxG.width - 34, 29);
		e.getC(SpriteC).pixelWidth = e.getC(SpriteC).pixelHeight = 30;
		e.getC(SpriteC).flxSprite.scrollFactor.x = 0;
		e.getC(SpriteC).flxSprite.scrollFactor.y = 0;

		e = new E(this.e);
		e.addC(SpriteC).init("assets/rise_icon_fort_white.png", renderS.interfaceLayer, FlxG.width - 34, 59);
		e.getC(SpriteC).pixelWidth = e.getC(SpriteC).pixelHeight = 30;
		e.getC(SpriteC).flxSprite.scrollFactor.x = 0;
		e.getC(SpriteC).flxSprite.scrollFactor.y = 0;
		
		var temp = new FlxText(FlxG.width - 250,15,300,"Current score", true);
		temp.size = 20;
		temp.alignment = "left";
		temp.scrollFactor.x = temp.scrollFactor.y = 0;
		renderS.add(temp, renderS.interfaceLayer);

		temp = new FlxText(FlxG.width - 250,45,300,"High score", true);
		temp.size = 20;
		temp.alignment = "left";
		temp.scrollFactor.x = temp.scrollFactor.y = 0;
		renderS.add(temp, renderS.interfaceLayer);

		temp = new FlxText(FlxG.width - 250,75,300,"Press R to restart", true);
		temp.size = 20;
		temp.alignment = "left";
		temp.scrollFactor.x = temp.scrollFactor.y = 0;
		renderS.add(temp, renderS.interfaceLayer);
		
		text = new FlxText(FlxG.width - 150,15,100,"1", true);
		text.size = 20;
		text.alignment = "right";
		text.scrollFactor.x = text.scrollFactor.y = 0;
		renderS.add(text, renderS.interfaceLayer);

		text2 = new FlxText(FlxG.width - 150,45,100,"1", true);
		text2.size = 20;
		text2.alignment = "right";
		text2.scrollFactor.x = text2.scrollFactor.y = 0;
		renderS.add(text2, renderS.interfaceLayer);
		
		e = new E(this.e);
		e.addC(SpriteC).init("assets/paper-texture.png", renderS.mostTopLayer, 0,0);
		//e.getC(SpriteC).pixelWidth = FlxG.width;
		//e.getC(SpriteC).pixelHeight = FlxG.height; 
		e.getC(SpriteC).flxSprite.scrollFactor.x = 0;
		e.getC(SpriteC).flxSprite.scrollFactor.y = 0;
		e.getC(SpriteC).flxSprite.offset.x = 0;
		e.getC(SpriteC).flxSprite.offset.y = 0;
		
	}
	
	override public function destroy():Void{
		super.destroy();
	}
}