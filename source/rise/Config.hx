package rise;

class Config {
	public static inline var NodeStartRadius = 64;
	public static inline var NodeHoverRadius = 100;
	public static inline var NodeCircleImageSize = 256;
	public static inline var NodeHoverButtonRadius = 40;
	public static inline var NodeHoverButtonDegreesMargin = 55;
	
	public static inline var MineDistance = 200;
	public static inline var MaxEdgeDistance = 240;
	
	public static inline var Evaporation = 5;
	public static inline var SendRate = 1;
	public static inline var AgentSize = 10;
	public static inline var AgentSpeed = 100; //pixels per second
	
	public static inline var CastleDecayRate = 5;
	public static inline var BarracksDecayRate = 5;
	public static inline var GoldMineDecayRate = 5;
	
	public static inline var NodeCastleCost = 20;
	public static inline var NodeBarracksCost = 20;
	public static inline var NodeMineCost = 20;
	public static inline var NodeRoadCost = 10;
	
	public static inline var CastleLie = 0;
	public static inline var BarracksLie = 0;
	public static inline var MineLie = 0;
	
	public static inline var CastleMax = 100;
	public static inline var BarracksMax = 50;
	public static inline var GoldMineMax = 30;
	
	public static inline var BarracksAttackRange = 200;
	
	public static inline var RandomizerPlacementRadius = 120;
	public static inline var RandomizerGoldClusterRadius = 50;
	public static inline var RandomizerVillageClusterRadius = 120;
	
	public static inline var RandomizerTypedGoldDistance = 600;
	public static inline var RandomizerTypedVillageDistance = 1200;
	
}
