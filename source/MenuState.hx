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
import haxe.Json;

class MenuState extends FlxState
{
	override public function create():Void
	{
		#if !neko
		FlxG.bgColor = 0xffffffff;
		#else
		FlxG.bgColor = {rgb: 0xffffff, a: 0xff};
		#end	
		
		init();	
	}
	
	override public function destroy():Void
	{
		super.destroy();
	}

	override public function update():Void
	{
		super.update();
	}	
	
	function init():Void{
		var e = new E();
		var c = e.addC(C);
		trace(c);
	}
}