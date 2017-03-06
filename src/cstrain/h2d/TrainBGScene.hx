package cstrain.h2d;
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
class TrainBGScene extends AbstractBGScene implements IBGTrain
{
	
	private var entities:Array<Entity> = new Array<Entity>();
	var scene:Sprite;
	private var debug:Bool = false;
	

	public function new() 
	{
		super();
		calcPickupTime();
		setPickupTimespans(6,3);
	}
	

	// -- The impl for IBGTrain
	var _curLoc:Float = 0;
	
	var _targetDest:Float = 0;
	
	var _reseting:Bool = true;
	
	var _cruisingSpeed:Float = 1;  
	static inline var PUSH_FORWARD_ERROR:Float = .75;
	
	
	var _maxSpeed:Float = 3;
	var _isStarted:Bool = false;
	var _startIndex:Float = -1;
	var _tweenProgress:Float = 0;
	var _tweenDuration:Float = 0;

	
	//  deriative engine
	var _pickupTime:Float;
	var _pickupTimeDiff:Float; // difference in time with pickup acceleration speed compared to constant speed
	var _pickupTimeDistCovered:Float;
	function calcPickupTime():Void {	
		//    find x _pickupTime  where   ( dy/dx(f(x) == maxSpeed  )  
		_pickupTime = easeFuncs.deriativeGetX(_maxSpeed);

		// precalculate difference in time compared to linear function of (maxSpeed*x).  (ie. differenceInTime = pickupTime - timeItTakesToCoverPickupDistWithLinearFunction)
		//  y = pickupTime*pickupTime*pickupTime;   // eg. cubic
		_pickupTimeDistCovered = easeFuncs.distCovered(_pickupTime);
		//  Sub y distance into: y =  _maxSpeed * pickupTime;  and find x  // ie. timeItTakesToCoverPickupDistWithLinearFunction
		//  pickupTime*pickupTime*pickupTime = _maxSpeed * x
		//  x = pickupTime*pickupTime*pickupTime/ maxSpeed;	// eg.cubic
		// So, compare difference in x as below..
		_pickupTimeDiff = _pickupTime -  _pickupTimeDistCovered / _maxSpeed; 	// compared time difference with linear displacement to accelerated displacement.
		//trace(_pickupTime + ", " + _pickupTimeDiff);
	}
	/* INTERFACE cstrain.core.IBGTrain */
	
		
	// Acceleration power functions. 
	var easeFuncs:EaseFunctions = EaseFunctions.create(EaseFunctions.CUBIC);
	
	var unitTimeLength:Float = hxd.Timer.wantedFPS  / 1;	// how much dt equates to 1 unit world distance
	var pickupTimeSpan:Float = 1;		
	var pickdownTimeSpan:Float = 1;
	var pickupAndDownMidpointRatio:Float = .5;
	function setPickupTimespans(accelSpan:Float, brakeSpan:Float):Void {
		pickupTimeSpan = accelSpan;
		pickdownTimeSpan = brakeSpan;
		pickupAndDownMidpointRatio = pickupTimeSpan / (pickupTimeSpan + pickdownTimeSpan);
	}
	
	 var pickupUnitTimeLength(get, never):Float;
	inline function get_pickupUnitTimeLength():Float {
		return pickupTimeSpan * unitTimeLength;
	}
	 var pickdownUnitTimeLength(get, never):Float;
	inline function get_pickdownUnitTimeLength():Float {
		return pickdownTimeSpan * unitTimeLength;
	}
	
	
	

	var pickupTimeDur(get, never):Float;
	inline function get_pickupTimeDur():Float {
		return _pickupTime * unitTimeLength * pickupTimeSpan;
	}
	
	var pickdownTimeDur(get, never):Float;
	inline function get_pickdownTimeDur():Float {
		return _pickupTime * unitTimeLength * pickdownTimeSpan;
	}
	
	var totalPickupAndDownTimeDur(get, never):Float;
	inline function get_totalPickupAndDownTimeDur():Float {
		return pickupTimeDur + pickdownTimeDur;
	}
	inline public function isBlendAccelBrake():Bool {
		return _pickupTimeDistCovered *pickupTimeSpan + _pickupTimeDistCovered*pickdownTimeSpan >= ( _targetDest - _startIndex);
	}
	//  might depreciate>>> this only applies if 1st case is correct and _tweenDuration is adjusted to fit correctly
	inline public function isBlendAccelBrake2():Bool { 
		return  totalPickupAndDownTimeDur   >= _tweenDuration;
	}
	


	public function resetTo(index:Int):Void 
	{
		_reseting = true;
		_targetDest = index;
		
	}

	var _forceStop = false;
	
	public function travelTo(index:Int):Void 
	{
		if (!_isStarted) {
			_targetDest = index;
			_isStarted = true;
			_startIndex = Std.int(_curLoc);
			trace("START:" + _startIndex);
			_tweenProgress = 0;
			_tweenDuration = (index - _startIndex ) * unitTimeLength/_maxSpeed +  _pickupTimeDiff*pickupTimeSpan* unitTimeLength +  _pickupTimeDiff*pickdownTimeSpan* unitTimeLength ; 
		}
		else {
			
			if (_braking) { // adjust pickup based on current de-accelerate slope
				
				// recalculated projected target location again for deacceleration graph, just in case for better frame accruacy.
				var tarLoc:Float = _tweenProgress - _tweenDuration + pickdownUnitTimeLength;
				tarLoc /= pickdownUnitTimeLength;	// find x ratio
				var xRatio = tarLoc;
	
				tarLoc = easeFuncs.distCovered_Out(tarLoc);
				tarLoc *= pickdownTimeSpan;
					
				tarLoc +=  _targetDest - pickdownTimeSpan;
				_curLoc = tarLoc;
				
				// Now setup new tween for pickup
				xRatio = 1 - xRatio;
				//xRatio *= (1 - pickupAndDownMidpointRatio) / pickupAndDownMidpointRatio;
				tarLoc -= easeFuncs.distCovered(xRatio)*pickupTimeSpan;	// backtrack along clamp distance
				
	
				_startIndex = tarLoc;		
				_tweenProgress = xRatio * pickupUnitTimeLength;	// cheat by simply setting starting tweenProgress further  up to match clamp
				
				
				_targetDest = index;
				//trace("Picking up from deaccleration:" + xRatio + " from:" + _startIndex + " to "+_targetDest);
			
			}
			else {
				_targetDest = index;
				trace("Extend cruising time");
			}
			_tweenDuration = (index - _startIndex) * unitTimeLength / _maxSpeed  + _pickupTimeDiff*pickupTimeSpan* unitTimeLength +  _pickupTimeDiff*pickdownTimeSpan* unitTimeLength ; 
		
		}
		
		
		if ( isBlendAccelBrake() ) { 
			var y = (_targetDest - _startIndex);
		//	trace("old tween duration:" + _tweenDuration);
			_tweenDuration = easeFuncs.distCoveredGetX( y / pickupTimeSpan * pickupAndDownMidpointRatio) *  unitTimeLength * pickupTimeSpan   + easeFuncs.distCoveredGetX( y / pickdownTimeSpan *  (1-pickupAndDownMidpointRatio) ) *  unitTimeLength * pickdownTimeSpan;
			trace("New tween duration for crossover: "+_tweenDuration);
			
		}

	}
	
	public function stopAt(index:Int):Void 
	{
		_targetDest = index;
	}
	
	public function missStopAt(index:Int):Void 
	{
		if ( _curLoc <= index + PUSH_FORWARD_ERROR) {
			_targetDest =  index + PUSH_FORWARD_ERROR;
		}
		else _targetDest = index;
	}
	
	
	public function setMaxSpeed(maxSpeed:Float):Void 
	{
		_maxSpeed = maxSpeed;
		calcPickupTime();
	}
	
	public function setCruisingSpeed(speed:Float):Void 
	{
		_cruisingSpeed = speed;
	}
	
	// ---
	

	// Called each frame
	
	var curTime:Float = 0;
	

	
	var _braking:Bool = true;
	
	override function update(dt:Float) {
	
	
		if (Key.isPressed(Key.G)) {

			travelTo( Std.int(_targetDest + 1 ) );
		
		}
		
		if (!Key.isPressed(Key.H)) {
		//return;
		
		}
	
		//else return;
		
		
		if (_isStarted) {
			
			if (_tweenProgress > _tweenDuration) _tweenProgress = _tweenDuration;  // force clammp tween progress to duration
			
		
			_braking = false;
			
			var tarLoc:Float = 0;
			var exceed:Bool = isBlendAccelBrake() ;
			var exceed2:Bool = isBlendAccelBrake2();
			if (exceed != exceed2) trace("Error MISMATCH assertion!:"+exceed + " , "+exceed2);
			var exceedBreaking:Bool = false;
			if (exceed) {
				
				exceedBreaking = _tweenProgress >= _tweenDuration  * pickupAndDownMidpointRatio;
				
				//trace("Exceeded brake? " + exceedBreaking);
			}
			
			 if ( (exceed && !exceedBreaking) || (!exceed && _tweenProgress < pickupTimeDur) ) {
				 trace("Accelerating..."+(exceed ? ":" : ""));
				//trace("PICKUP:" + _curLoc);
				
				tarLoc = (_tweenProgress / pickupUnitTimeLength);	
				tarLoc = easeFuncs.distCovered(tarLoc); // tarLoc * tarLoc * tarLoc;
				tarLoc *= pickupTimeSpan;
				tarLoc += _startIndex;
			}
			else if ( (exceed && exceedBreaking)  ||  (!exceed && _tweenProgress >=  _tweenDuration  - pickdownTimeDur) ) {
			
				_braking = true;
				
				tarLoc = _tweenProgress - _tweenDuration + pickdownUnitTimeLength;
				tarLoc /= pickdownUnitTimeLength;
				trace("Braking..."+(exceed ? ":" : ""));
				//trace("PICKDOWN:" + _curLoc+  " : "+tarLoc);
	
				tarLoc = easeFuncs.distCovered_Out(tarLoc);
				tarLoc *= pickdownTimeSpan;
				
				tarLoc +=  _targetDest - pickdownTimeSpan;
			//	trace(tarLoc);
			
			}
			else if (!exceed) {
				trace("Cruising...");
				//trace("CONSTANT:" +_curLoc);
				tarLoc = CSMath.lerp( _startIndex + _pickupTimeDistCovered*pickupTimeSpan, _targetDest - _pickupTimeDistCovered*pickdownTimeSpan, (_tweenProgress - pickupTimeDur) / (_tweenDuration - totalPickupAndDownTimeDur ) );
				

			}
			else {
				trace("ERROr no resolution!");
			}
			
			var diff = (tarLoc - _curLoc)*unitTimeLength;
			if (tarLoc >= _targetDest) {
				tarLoc = _targetDest;
				diff = (tarLoc - _curLoc) * unitTimeLength;
			}
	
			for ( entity in entities)
			{
				entity.update(diff);
			}
			
			_curLoc = tarLoc;
			
			if (tarLoc >= _targetDest) {
				_isStarted = false;
				trace("END:" + tarLoc);
				
			}
			_tweenProgress += dt;
			
		}
		
		if (_forceStop) {
			_forceStop = false;
			_isStarted = false;
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
		
	}
	
	// -- The port
	
	

	override function init() {
		super.init();
	
		s2d.addChild( scene = new Sprite());

		var g = new h2d.Graphics(s2d);
	
		var fillGrad:Fill = new Fill(s2d);
		//var grad:Gradient = { spread:SMPad, interpolate:IMLinearRGB, data:[GradRecord.GRRGB(0, {r:255, g:255, b:0} ), GradRecord.GRRGB(1, {r:255,g:0,b:0} ) ]   };
		//var matrix:Matrix = { translate:{x:0, y:0 }, scale:null, rotate:{rs0:0, rs1:1} };
		//FSLinearGradient(matrix, grad)
		//fillGrad.fillRect(h2d.css.FillStyle.Gradient(0x51484A,0x51484A,0x96644E,0x96644E), 0, 0, s2d.width, s2d.height);
		fillGrad.fillRectGradient(0, 0, s2d.width, s2d.height, 0xFF51484A, 0xFF51484A, 0xFF96644E, 0xFF96644E);
		
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
			s2d.addChild(mountain);
			entities.push(mountain);
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

