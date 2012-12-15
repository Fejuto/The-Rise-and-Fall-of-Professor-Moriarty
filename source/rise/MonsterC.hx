package rise;
import engine.entities.C;

class MonsterC extends C{
	
	@inject var updateS:UpdateS;
	@inject var nodeC:NodeC;
	
	var health = 100;
	var attack = 100;
	
	public var x(getX, setX):Float;
	function getX():Float{
		return e.getC(SpriteC).x; 
	}
	function setX(v:Float):Float{
		e.getC(CircleC).x = v;
		return e.getC(SpriteC).x = v;
	}
	
	public var y(getY, setY):Float;
	function getY():Float{
		return e.getC(SpriteC).y;
	}
	function setY(v:Float):Float{
		e.getC(CircleC).y = v;
		return e.getC(SpriteC).y = v;		
	}
	
	public function init(x:Float, y:Float):Void{
		e.addC(CircleC).init(x, y, [209, 214, 223, 225]);
		e.getC(CircleC).radius = 12;
		
		e.addC(SpriteC).init('assets/rise_icon_monster_blue.png', x, y);
		e.getC(SpriteC).scaleX = 0.3;
		e.getC(SpriteC).scaleY = 0.3;
		
		m.add(updateS, UpdateS.UPDATE, onUpdate);
	}
	
	function onUpdate():Void {
		
	}
	
	override public function destroy():Void{
		super.destroy();
	}
}