package cstrain.h2d;

import msignal.Signal;
/**
 * contains any boilerplate for basic BG scenes
 * @author Glidias
 */
class AbstractBGScene extends hxd.App 
{
	private var _needToRender:Bool = true;	// to track need to re-render scene
	public static var signalUpdate(default, never):Signal1<Float> = new Signal1<Float>();
	public static var signalInited(default, never):Signal0 = new Signal0();
	
	override function init() {
		super.init();
		SceneSettings.WIDTH = s2d.width;
		SceneSettings.HEIGHT = s2d.height;
		signalInited.dispatch();
	}



	
}