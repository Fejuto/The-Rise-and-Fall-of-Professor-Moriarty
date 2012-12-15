package;

import nme.Assets;
import nme.geom.Rectangle;
import nme.net.SharedObject;
import org.flixel.FlxButton;
import org.flixel.FlxG;
import org.flixel.FlxPath;
import org.flixel.FlxSave;
import org.flixel.FlxSprite;
import org.flixel.FlxState;
import org.flixel.FlxText;
import org.flixel.FlxU;
import engine.entities.E;
import engine.entities.C;
import flash.display.Sprite;
import rise.UpdateS;
import rise.SpriteC;
import rise.RenderS;
import rise.NodeFactoryS;

class MenuState extends FlxState
{
	var e:E;
	
	override public function create():Void{
		FlxG.bgColor = 0xfff1eae3;
		init();
	}
	
	function init():Void{
		e = new E();
		e.addC(UpdateS).init();
		e.addC(RenderS).init(this);
		e.addC(NodeFactoryS).init();
		
		
		var barracks:E = new E(e);
		barracks.addC(SpriteC).init("asdfas");
		barracks.addC(NodeC).init();
		barracks.addC(NodeBarracksC).init();
	}

	override public function update():Void{
		super.update();
		e.getC(UpdateS).update();
	}
}