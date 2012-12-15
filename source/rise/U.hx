package rise;

class U {
	public static function distance(x:Float, y:Float, x2:Float, y2:Float):Void{
		var dx:Float = x - x2;
		var dy:Float = y - y2;
		return Math.sqrt(dx * dx + dy * dy);
	}
}
