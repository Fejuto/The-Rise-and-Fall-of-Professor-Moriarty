package rise;
import engine.entities.C;
import org.flixel.FlxPoint;
import org.flixel.FlxG;

class ScrollS extends C{
	@inject var updateS:UpdateS;
	
	public var enabled = false;
	
	public function init(enabled:Bool):Void{
		this.enabled = enabled;
		
		m.add(updateS, UpdateS.UPDATE, onUpdate);
	}
	
	public function modifyCameraScroll(x:Float, y:Float) {
		FlxG.camera.scroll.x += x;
		FlxG.camera.scroll.y += y;
	}
	
	var lastMousePoint:FlxPoint;
	function onUpdate():Void{
		if (!enabled)
			return;
		
		if (lastMousePoint == null)
			lastMousePoint = new FlxPoint();
	
	    if (FlxG.mouse.justPressed()) {
    	    lastMousePoint.x = FlxG.mouse.screenX;
       		lastMousePoint.y = FlxG.mouse.screenY;
    	}	
 
 	   if (FlxG.mouse.pressed()) {
			modifyCameraScroll(-(FlxG.mouse.screenX - lastMousePoint.x), -(FlxG.mouse.screenY - lastMousePoint.y));
       		lastMousePoint.x = FlxG.mouse.screenX;
       	 	lastMousePoint.y = FlxG.mouse.screenY;
	   }
		
	}
	
	override public function destroy():Void{
		super.destroy();
	}
}






