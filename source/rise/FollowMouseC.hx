package rise;
import engine.entities.C;
import org.flixel.FlxG;

class FollowMouseC extends C{
	@inject var updateS:UpdateS;
	@inject var scrollS:ScrollS;
	@inject var nodeC:NodeC;
	
	var screenWidth:Float;
	var screenHeight:Float;
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
			//if (Math.abs(screenWidth - screenPos.x) < 20) {
			//	scrollS.modifyCameraScroll((screenWidth - screenPos.x)/(screenWidth - screenPos.x), 0);
			//}
			
			var pos = FlxG.mouse.getWorldPosition();
			nodeC.x = pos.x;
			nodeC.y = pos.y;
		}
	}
	
	override public function destroy():Void{
		super.destroy();
	}
}






