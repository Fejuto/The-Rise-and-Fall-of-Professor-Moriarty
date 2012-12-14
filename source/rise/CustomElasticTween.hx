package rise;
import com.eclecticdesignstudio.motion.easing.IEasing;

class CustomElasticTween implements IEasing{
	public var a:Float;
	public var p:Float;
	
	public function new (a:Float, p:Float) {
		this.a = a;
		this.p = p;
	}


	public function calculate (k:Float):Float {

		if (k == 0) return 0; if (k == 1) return 1;
		var s:Float;
		if (a < 1) { a = 1; s = p / 4; }
		else s = p / (2 * Math.PI) * Math.asin (1 / a);
		return (a * Math.pow(2, -10 * k) * Math.sin((k - s) * (2 * Math.PI) / p ) + 1);

	}


	public function ease (t:Float, b:Float, c:Float, d:Float):Float {

		if (t == 0) {
			return b;
		}
		if ((t /= d) == 1) {
			return b + c;
		}
		var s:Float;
		if (a < Math.abs(c)) {
			a = c;
			s = p / 4;
		}
		else {
			s = p / (2 * Math.PI) * Math.asin(c / a);
		}
		return a * Math.pow(2, -10 * t) * Math.sin((t * d - s) * (2 * Math.PI) / p) + c + b;

	}
}
