package rise;
import engine.entities.C;
import engine.entities.E;
import org.flixel.FlxG;
import org.flixel.FlxU;
import org.flixel.FlxPoint;
import rise.NodeC.NodeState;

class EdgeC extends C{
	@inject var spriteC:SpriteC;
	@inject var updateS:UpdateS;
	@inject var worldS:WorldS;
	
	public var node1:E;
	public var node2:E;
	public var sendCounter:Float;
	public var split:Bool = true;
	
	var tempHouses:Array<E>;
	
	public function init(node1:E, node2:E):Void{
		this.node1 = node1;
		node1.getC(NodeC).addEdge(e);
		this.node2 = node2;
		node2.getC(NodeC).addEdge(e);
		
		tempHouses = new Array<E>();
		
		updateEdge();
		
		m.add(node1.getC(NodeC), NodeC.MOVED, onMoved);
		m.add(node2.getC(NodeC), NodeC.MOVED, onMoved);
		m.add(node1, E.DESTROY, e.destroy);
		m.add(node2, E.DESTROY, e.destroy);
		m.add(updateS, UpdateS.UPDATE, onUpdate);
	}
	
	
	function onMoved():Void{
		updateEdge();
	}
	
	function updateEdge():Void{
		var distance = U.distance(node1.getC(NodeC).x, node1.getC(NodeC).y, node2.getC(NodeC).x, node2.getC(NodeC).y);
		
		if(!split && distance > Config.MaxEdgeDistance){
			updateS.kill(e);
		}
		
		spriteC.flxSprite.offset.x = 0;
		spriteC.flxSprite.origin.x = spriteC.flxSprite.offset.x;
		spriteC.flxSprite.origin.y = spriteC.flxSprite.offset.y;
		spriteC.flxSprite.scale.x = distance / spriteC.flxSprite.width; 
		spriteC.flxSprite.scale.y = 10 / spriteC.flxSprite.height;
		spriteC.flxSprite.x = node1.getC(NodeC).x;
		spriteC.flxSprite.y = node1.getC(NodeC).y;
		
		
		if (!node1.getC(NodeC).mine)
			spriteC.setColor(209, 214, 223, 225);
		else
			spriteC.setColor(54, 45, 34, 225);
		
		var dx:Float = node2.getC(NodeC).x - node1.getC(NodeC).x;
		var dy:Float = node2.getC(NodeC).y - node1.getC(NodeC).y;
		spriteC.flxSprite.angle = U.toDegrees(Math.atan2(dy, dx));
		
		setTempHouses();
	}
	
	function onUpdate():Void{
		sendCounter += FlxG.elapsed;
		
		var distance = U.distance(node1.getC(NodeC).x, node1.getC(NodeC).y, node2.getC(NodeC).x, node2.getC(NodeC).y);
		
		if(distance > Config.MaxEdgeDistance && node1.getC(NodeC).state != dragging && node2.getC(NodeC).state != dragging){
			setTempHouses();
			
			var lastHouse = node1;
			while(tempHouses.length > 0){
				var house = tempHouses.shift();
				worldS.createEdge(lastHouse, house);
				lastHouse = house;
				if(house.getC(NodeC).mine){
					house.getC(NodeC).state = building;				
				}else{
					house.getC(NodeC).state = active;
					house.getC(NodeC).gold = 40;
				}
			}
			worldS.createEdge(lastHouse, node2);
			updateS.kill(e);
		}
	}
	
	function setTempHouses():Void{
		var distance = U.distance(node1.getC(NodeC).x, node1.getC(NodeC).y, node2.getC(NodeC).x, node2.getC(NodeC).y);
		
		var numHouses:Int = Math.floor(distance / Config.MaxEdgeDistance);
		while(tempHouses.length != numHouses){
			if(tempHouses.length < numHouses){
				tempHouses.push(worldS.createCastle(0, 0, 0, node1.getC(NodeC).mine));
			}
			if(tempHouses.length > numHouses){
				updateS.kill(tempHouses.pop());
			}
		}
		
		var lastHouse = node1;
		for(i in 0...numHouses){
			var hx = node1.getC(NodeC).x + (node2.getC(NodeC).x - node1.getC(NodeC).x) / (numHouses + 1) * (i + 1);
			var hy = node1.getC(NodeC).y + (node2.getC(NodeC).y - node1.getC(NodeC).y) / (numHouses + 1) * (i + 1);
			tempHouses[i].getC(NodeC).x = hx;
			tempHouses[i].getC(NodeC).y = hy;
		}
	}
	
	override public function destroy():Void{		
		super.destroy();
		
		node1.getC(NodeC).removeEdge(e);
		node2.getC(NodeC).removeEdge(e);
		
		while(tempHouses.length > 0){
			updateS.kill(tempHouses.pop());
		}
	}

	public function getEndPoint(beginPoint:E):E{
		if(beginPoint.getC(NodeC) == node1.getC(NodeC)) return node2;
		if(beginPoint.getC(NodeC) == node2.getC(NodeC)) return node1;
		throw "neither";
	}
	
	public function getLength():Float{
		return U.distance(node1.getC(NodeC).x, node1.getC(NodeC).y, node2.getC(NodeC).x, node2.getC(NodeC).y);
	}
}






