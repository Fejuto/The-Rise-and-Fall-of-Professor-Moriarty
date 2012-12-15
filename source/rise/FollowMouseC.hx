package rise;
import engine.entities.C;
import org.flixel.FlxG;

class FollowMouseC extends C{
	@inject var updateS:UpdateS;
	@inject var scrollS:ScrollS;
	@inject var nodeC:NodeC;
	
	var screenWidth:Float;
	var screenHeight:Float;
	var scrollSpeed = 5;
	var scrollThreshold = 80;
	public var enabled:Bool = true;
	
	public function init(enabled = false):Void{
		screenWidth = FlxG.width;
		screenHeight = FlxG.height;
		
		this.enabled = enabled;
		m.add(updateS, UpdateS.UPDATE, onUpdate);
	}
	
	function onUpdate():Void{
		if(enabled){
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
				
			scrollS.modifyCameraScroll(x,y);
						
			var pos = FlxG.mouse.getWorldPosition();
			nodeC.x = pos.x;
			nodeC.y = pos.y;
		}
	}
	
	override public function destroy():Void{
		super.destroy();
	}
}






