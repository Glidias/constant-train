package cstrain.h2d;
import cstrain.util.CSMath;
import h2d.Graphics;
import cstrain.h2d.NativeTypes;
/**
 * ...
 * @author Glidias
 */
class Mountain extends Entity
{
	private var heightMap:Vector<Float> = new Vector<Float>();
	private static inline var SEGMENT_LENGTH:Int = 10;

	private var baseHeight:Float;
	private var color:UInt;
	private var speed:Float;
	private var lastScreenHeight:Int;

	var graphics:Graphics;

	public function new(speed:Float, baseHeight:Float, color:UInt)
	{
		super();
		graphics = new Graphics(this);
		this.baseHeight = baseHeight;
		this.color = color;
		this.speed = speed;

		lastScreenHeight = SceneSettings.HEIGHT;
		generateHeightMap();
		createShape();
	}

	override public function reset():Void {
		x = 0;

		heightMap = new Vector<Float>();

		lastScreenHeight = SceneSettings.HEIGHT;
		generateHeightMap();
		createShape();
	}

	var width:Float;

	public override function update(dt:Float):Void
	{
		x += speed * dt;
		//trace(x);

		if (x < -(width - SceneSettings.WIDTH)) {

			var removeSegmentNumber:Int = Std.int(  (width - SceneSettings.WIDTH) / SEGMENT_LENGTH );
			heightMap.splice(0, removeSegmentNumber);

			x += removeSegmentNumber * SEGMENT_LENGTH;

			generateHeightMap();
			createShape();

		}
	}

	function generateHeightMap():Void
	{
		// 再帰で分割していく
		divide(baseHeight, baseHeight, 0, 200);
		width =  heightMap.length * SEGMENT_LENGTH; // getBounds().width;

	}

	function divide(left:Float, right:Float, depth:Int, offset:Float):Void
	{
		if (depth < 6) {
			var half:Float = (left + right) / 2 + CSMath.rnd( -offset / 2, offset / 2);

			divide(left, half, depth + 1, offset / 2);
			divide(half, right, depth + 1, offset / 2);
		} else {
			// 十分に分割したら順番に書き出し
			//if (heightMap.length != 0) trace(Math.abs(left- heightMap[heightMap.length-1] ));
			heightMap.push(left);

		}
	}

	public function onResize() {
		//baseHeight = SceneSettings.HEIGHT * 0.55 + i * 25;
		//y =  SceneSettings.HEIGHT*0.55 - SceneSettings.HEIGHT*0.55;
		y = SceneSettings.HEIGHT - lastScreenHeight;
		if (SceneSettings.WIDTH > width) {
			generateHeightMap();
			createShape();
		}

	}

	function createShape():Void
	{
		var g:Graphics = graphics;

		g.clear();
		g.beginFill(color);
		g.moveTo(0, SceneSettings.HEIGHT);
		var i:Int = 0;
		 while( i < heightMap.length) {
			g.lineTo(i * SEGMENT_LENGTH, heightMap[i]);
			i++;
		}
		g.lineTo((i - 1) * SEGMENT_LENGTH, SceneSettings.HEIGHT);
		g.endFill();

		// デバッグ表示
		g.lineStyle(1, color);
		g.moveTo(0, heightMap[0]);
		g.lineTo(0, SceneSettings.HEIGHT * 2);


	}
}