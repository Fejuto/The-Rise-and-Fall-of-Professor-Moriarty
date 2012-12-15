package rise;

class U {
	public static function distance(x:Float, y:Float, x2:Float, y2:Float):Float{
		var dx:Float = x - x2;
		var dy:Float = y - y2;
		return Math.sqrt(dx * dx + dy * dy);
	}
	
	public static function inCircle(cx : Float, cy : Float, radius : Float, x : Float, y : Float):Bool {
		var sqdist = Math.pow(cx - x, 2) + Math.pow(cy - y, 2);
		return sqdist <= Math.pow(radius, 2);
	}
	
	public static function toDegrees(radians:Float):Float{
		return radians * 180 / Math.PI;
	}
	public static function toRadians(degrees:Float):Float{
		return degrees / 180 * Math.PI;
	}
}
