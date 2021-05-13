package cstrain.h2d;
import cstrain.core.BGTrainState;
import cstrain.core.GameSettings;
import cstrain.core.IBGTrain;
import cstrain.util.CSMath;
import cstrain.util.EaseFunctions;
import h2d.Sprite;
import h2d.Graphics;
import h2d.SpriteBatch;
import h2d.Tile;
import h2d.css.Fill;
import h3d.mat.Data.TextureFlags;
import h3d.mat.Texture;
import hxd.Key;
import hxd.Timer;

import h2d.css.Defs;

/**
 * A port of  http://wonderfl.net/c/qldl  to Haxe +Heaps
 * wip.
 * @author Glidias
 */
class TrainBGScene extends AbstractBGScene
{

	private var entities:Array<Entity> = [];
	var scene:Sprite;
	private var debug:Bool = false;
	var model:IBGTrain;
	var fillGrad:Fill;

	private var mountains:Array<Mountain> = [];


	public function new(model:IBGTrain)
	{
		super();
		this.model = model;

	}

	private function reset():Void {
		_curLoc = 0;
		_needToRender = true;
		for ( entity in entities)
		{
			entity.reset();
		}
	}
	var _curLoc:Float = 0;
	var unitTimeLength:Float = GameSettings.SHARED_FPS  / 1;
	var renderCount:Int = 0;

	// NOTE: Currently, until shader implementation is used over manual uplaod of webGL, pausing/minimising and returning back to screen will yield visual flickerings in re-renderings

	override function update(dt:Float) {

		if (Key.isPressed(Key.G)) {	// to depreciate when no longer testing

			model.travelTo( Std.int(model.targetDest + 1 ) );

		}

		model.update();

		AbstractBGScene.signalUpdate.dispatch(dt);


		var tarLoc = model.currentPosition;
		var diff = (tarLoc - _curLoc) * unitTimeLength;
		if (diff < 0 && tarLoc ==0) {	// assume resetting

			reset();
			return;
		}

		if (renderCount < 60) {
			_needToRender = true;
			renderCount++;
		}

		if (_needToRender || model.movingState != BGTrainState.STOPPED) {  // perform necessary render updates
			_needToRender = model.movingState != BGTrainState.STOPPED;







			for ( entity in entities)
			{
				entity.update(diff);
			}

			//emitter.step();

			//renderedScene.fillRect(renderedScene.rect, 0);
			//renderedScene.draw(scene);
			//sun.update();

			/*
			if (soundRunChannel && soundRunChannel.position >= 14025)
			{
				soundRunChannel.stop();
				soundRunChannel = soundRun.play(3169);
				trace(soundRunChannel.position);
			}
			*/

			_curLoc = tarLoc;
		}
		else _needToRender = false;



	}

	override function onResize() {
		super.onResize();
		fillGrad.clear();
		fillGrad.fillRectGradient(0, 0, s2d.width, s2d.height, 0xFF51484A, 0xFF51484A, 0xFF96644E, 0xFF96644E);

		for (i in 0...mountains.length) {
			mountains[i].onResize();
		}

	}

	// -- The port



	override function init() {
		super.init();


		new h2d.Graphics(scene);

		fillGrad = new Fill(s2d);
		//var grad:Gradient = { spread:SMPad, interpolate:IMLinearRGB, data:[GradRecord.GRRGB(0, {r:255, g:255, b:0} ), GradRecord.GRRGB(1, {r:255,g:0,b:0} ) ]   };
		//var matrix:Matrix = { translate:{x:0, y:0 }, scale:null, rotate:{rs0:0, rs1:1} };
		//FSLinearGradient(matrix, grad)
		//fillGrad.fillRect(h2d.css.FillStyle.Gradient(0x51484A,0x51484A,0x96644E,0x96644E), 0, 0, s2d.width, s2d.height);
		fillGrad.fillRectGradient(0, 0, s2d.width, s2d.height, 0xFF51484A, 0xFF51484A, 0xFF96644E, 0xFF96644E);



		s2d.addChild( scene = new Sprite());
		scene.y += s2d.height * .12;

		var fogR = 0x40;
		var fogG = 0x35;
		var fogB = 0x2c;

		var mountainR = 0x17;
		var mountainG = 0x13;
		var mountainB = 0x15;

		var NUMBER_OF_MOUNTAINS = 4;

		for (i in 0...NUMBER_OF_MOUNTAINS) {
			var blend = i / (NUMBER_OF_MOUNTAINS - 1);

			var _r = CSMath.lerp(fogR, mountainR, blend);
			var _g = CSMath.lerp(fogG, mountainG, blend);
			var _b = CSMath.lerp(fogB, mountainB, blend);

			var baseHeight = s2d.height * 0.55 + i * 25;
			var color:UInt = ( Std.int(_r) << 16) | ( Std.int(_g) << 8) | Std.int(_b);

			var mountain:Mountain = new Mountain( -Math.pow(i + 1, 2), baseHeight, color);
			scene.addChild(mountain);
			entities.push(mountain);
			mountains.push(mountain);
		}

		  restoreFilters(debug);


		  /*
		var gTriTest:Graphics = new Graphics(s2d);

		gTriTest.beginFill(0xFF0000, 1);
		gTriTest.lineTo(64, 64);
		gTriTest.lineTo(64, 0);
		gTriTest.lineTo(0, 0);
		 gTriTest.endFill();
		 var tx:h3d.mat.Texture = new Texture(64, 64, [ TextureFlags.Target]);
		 gTriTest.drawTo( tx);
		 var tile:Tile =  Tile.fromTexture(tx);
		 var spriteBatch:SpriteBatch = new SpriteBatch(tile, s2d);
		 spriteBatch.hasRotationScale = true;
		 var e;
		 spriteBatch.add( e=new BatchElement(tile));
		//  gTriTest.scaleX = 10;

		e.scaleX = -1;// 1 / 64 * 10;
		//e.scaleY = 1 / 64 * 15;
		 e.x = 100;
		  e.y  = 100;
		  */

	}




	function restoreFilters(debug:Bool):Void
	{
		for (entity in entities)
		{
			entity.restoreFilter(debug);
		}
	}

}

