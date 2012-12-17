package rise;
import engine.entities.C;
import org.flixel.FlxG;

class FollowMouseC extends C{
	@inject var updateS:UpdateS;
	@inject var scrollS:ScrollS;
	@inject var nodeC:NodeC;
	
	public var enabled:Bool = true;
	
	public function init(enabled = false):Void{		
		this.enabled = enabled;
		m.add(updateS, UpdateS.UPDATE, onUpdate);
	}
	
	function onUpdate():Void{
		if(enabled){
							
			var pos = FlxG.mouse.getWorldPosition();
			nodeC.x = pos.x;
			nodeC.y = pos.y;
		}
		
		scrollS.edgeScrollEnabled = enabled;
	}
	
	override public function destroy():Void{
		super.destroy();
	}
}






