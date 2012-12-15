package rise;
import engine.entities.C;
import org.flixel.FlxPoint;
import org.flixel.FlxG;

class ScrollS extends C{
	@inject var updateS:UpdateS;
	
	public var enabled = false;
	var screenWidth:Float;
	var screenHeight:Float;
	var scrollSpeed = 5;
	var scrollThreshold = 40;
	
	public function init(enabled:Bool):Void{
		this.enabled = enabled;
		
		screenWidth = FlxG.width;
		screenHeight = FlxG.height;
		
		m.add(updateS, UpdateS.UPDATE, onUpdate);
	}
	
	public function modifyCameraScroll(x:Float, y:Float) {
		FlxG.camera.scroll.x += x;
		FlxG.camera.scroll.y += y;
	}
	
	var lastMousePoint:FlxPoint;
	function onUpdate():Void{
			
		if (lastMousePoint == null)
			lastMousePoint = new FlxPoint();
	
	    if (FlxG.mouse.justPressed()) {
    	    lastMousePoint.x = FlxG.mouse.screenX;
       		lastMousePoint.y = FlxG.mouse.screenY;
    	}	
 
 	   if (FlxG.mouse.pressed() && enabled) {
			modifyCameraScroll(-(FlxG.mouse.screenX - lastMousePoint.x), -(FlxG.mouse.screenY - lastMousePoint.y));
       		lastMousePoint.x = FlxG.mouse.screenX;
       	 	lastMousePoint.y = FlxG.mouse.screenY;
	   } else {
		return;
			var screenPos = FlxG.mouse.getScreenPosition();
			var rs = screenWidth - screenPos.x < scrollThreshold;
			var ls = screenPos.x < scrollThreshold;
			
			var ts = screenPos.y < scrollThreshold;
			var bs = screenHeight - screenPos.y < scrollThreshold;
			
			var x = 0;
			var y = 0;
			
			if (rs)
				x = scrollSpeed;
			else if (ls)
				x = -scrollSpeed;		
				
			if (ts)
				y = -scrollSpeed;
			else if (bs)
				y = scrollSpeed;
				
			modifyCameraScroll(x,y);
	   }
		
	}
	
	override public function destroy():Void{
		super.destroy();
	}
}






