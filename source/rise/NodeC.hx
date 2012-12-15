package rise;
import engine.entities.C;
import engine.entities.E;
import flash.events.Event;
import org.flixel.FlxG;
import com.eclecticdesignstudio.motion.Actuate;
import com.eclecticdesignstudio.motion.easing.Elastic;

class NodeC extends C{
	public static inline var MOVED = "MOVED";
	@inject var worldS:WorldS;
	@inject var renderS:RenderS;
	@inject var updateS:UpdateS;
	
	var circle:E;
	var graphic:E;
	var edges:Array<E>;
	
	public var gold:Int = 0;
	public var decayRate:Float = 3;
	var decayCounter:Float = 0;
	
	public var x(getX, setX):Float;
	function getX():Float{
		return circle.getC(SpriteC).x; 
	}
	function setX(v:Float):Float{
		graphic.getC(SpriteC).x = v;
		var r = circle.getC(SpriteC).x = v;
		dispatchEvent(new Event(MOVED));
		return r;
	}
	
	public var y(getY, setY):Float;
	function getY():Float{
		return circle.getC(SpriteC).y;
	}
	function setY(v:Float):Float{
		graphic.getC(SpriteC).y = v;
		var r = circle.getC(SpriteC).y = v;
		dispatchEvent(new Event(MOVED));
		return r;
	}
	
	// prolly do something with the radius itself
	var _radius:Float;
	public var radius(getRadius, setRadius):Float;
	function setRadius(v:Float):Float {
		var targetScale = (v / Config.NodeRadiusImageSize) * 2;
		Actuate.stop(circle.getC(SpriteC));
		Actuate.tween(circle.getC(SpriteC), 1, {scaleX:targetScale, scaleY:targetScale}).ease(Elastic.easeOut);
		return _radius = v;
	}
	function getRadius():Float {
		return _radius;
	}
	
	public var circleSprite(getCircleSprite, null):SpriteC;
	function getCircleSprite():SpriteC {
		return circle.getC(SpriteC);
	}
	
	public function init(g : Dynamic, x : Float, y : Float, radius : Float = Config.NodeStartRadius):Void{
		edges = new Array<E>();
		this.circle = createCircle();
		this.graphic = createGraphic(g);
		
		this.x = x;
		this.y = y;
		this.radius = radius;
		
		m.add(updateS, UpdateS.UPDATE, onUpdate);
	}
	
	override public function destroy():Void{
		super.destroy();
		//worldS.removeNode(e);
	}
	
	function onUpdate():Void{
		decayCounter += FlxG.elapsed;
		while(decayCounter > decayRate){
			decayCounter -= decayRate;
			evaporate();
		}
	}
	
	function evaporate():Void{
		radius *= 0.8;
	}
	
	function createCircle():E{
		var e = new E(e);
		e.addC(SpriteC).init('assets/rise_circle_highlight.png');
		return e;
	}
	
	function createGraphic(graphic):E{
		var e = new E(e);
		e.addC(SpriteC).init(graphic);
		return e;
	}
	
	public function addEdge(e:E):Void{
		if(!e.hasC(EdgeC)) throw "no EdgeC";
		edges.push(e);
	}
	
	public function removeEdge(e:E):Void{
		edges.remove(e);
	}
}






