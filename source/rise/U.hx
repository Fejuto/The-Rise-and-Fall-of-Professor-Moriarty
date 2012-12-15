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
	
	public static function pointOnEdgeOfCircle(ix:Float, iy:Float, radius:Float, degrees:Float):Array<Float> {
		var tdegrees = degrees - 90;
		var x = ix + radius * Math.cos(tdegrees * Math.PI / 180);
		var y = iy + radius * Math.sin(tdegrees * Math.PI / 180);
		
		return [x,y];
	}
	
	public static function toDegrees(radians:Float):Float{
		return radians * 180 / Math.PI;
	}
	public static function toRadians(degrees:Float):Float{
		return degrees / 180 * Math.PI;
	}
}
