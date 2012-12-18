package rise;
import engine.entities.C;
import nme.installer.Assets;
import nme.media.Sound;
import flash.media.SoundChannel;
import org.flixel.FlxG;

class SoundS extends C{
		
	public function init():Void{		 
		 playBackgroundMusic();
	}
	
	public function playBackgroundMusic():Void {
		FlxG.playMusic('assets/lazu.mp3');
	}
	
	override public function destroy():Void{
		super.destroy();
	}
}