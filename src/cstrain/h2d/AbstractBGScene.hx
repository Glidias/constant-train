package cstrain.h2d;

/**
 * contains any boilerplate for basic BG scenes
 * @author Glidias
 */
class AbstractBGScene extends hxd.App 
{
	
	override function init() {
		super.init();
		SceneSettings.WIDTH = s2d.width;
		SceneSettings.HEIGHT = s2d.height;
	}
	
}