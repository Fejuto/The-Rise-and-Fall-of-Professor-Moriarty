package rise;
import engine.entities.C;
import org.flixel.FlxG;

class FollowMouseC extends C{
	@inject var updateS:UpdateS;
	@inject var scrollS:ScrollS;
	@inject var nodeC:NodeC;
	@inject var worldS:WorldS;
	
	public var enabled:Bool = true;
	
	public function init(enabled = false):Void{		
		this.enabled = enabled;
		m.add(updateS, UpdateS.UPDATE, onUpdate);
	}
	
	function onUpdate():Void{
		if(enabled){
							
			var pos = FlxG.mouse.getWorldPosition();
			var changed:Bool = false;
			if(nodeC.x != pos.x){
				changed = true;
			}
			if(nodeC.y != pos.y){
				changed = true;
			}
			nodeC.x = pos.x;
			nodeC.y = pos.y;
			
			if(changed){
				var evt = new MovedEvent(NodeC.MOVED);
				evt.who = e;
				worldS.dispatchEvent(evt);
			}
		}
		
		scrollS.edgeScrollEnabled = enabled;
	}
	
	override public function destroy():Void{
		super.destroy();
	}
}






