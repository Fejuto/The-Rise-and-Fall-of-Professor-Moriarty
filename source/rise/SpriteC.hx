package rise;
import engine.entities.C;
import org.flixel.FlxSprite;

class SpriteC extends C{
	@inject public var renderS:RenderS;
	@inject public var updateS:UpdateS;
	public var flxSprite:FlxSprite;
		
	public function init(graphic:Dynamic):Void{
		flxSprite = new FlxSprite();
		//flxSprite.loadGraphic(graphic);
		renderS.add(flxSprite);
		
		m.add(updateS, UpdateS.UPDATE, onUpdate);
	}
	
	override public function destroy():Void{
		super.destroy();
	}
	
	function onUpdate():Void{
		
	}
}
