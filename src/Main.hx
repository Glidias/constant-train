package;
import cstrain.core.Polynomial;
import cstrain.h2d.TrainBGScene;
import cstrain.rules.SceneModel;
import cstrain.rules.TestGame;
import cstrain.vuex.components.GameView;
import cstrain.vuex.store.GameStore;
import haxevx.vuex.core.VxBoot;

/**
 * ...
 * @author Glidias
 */
class Main
{

	public static function main() 
	{
		// Main App
		var boot:VxBoot = new VxBoot();
		var gs = new GameStore(new TestGame()) ;
	
		
		var sm = new SceneModel();
		
		var store = boot.startStore( gs) ;
	
		
		
		boot.startVueWithRootComponent( "#app", new GameView());
		VxBoot.notifyStarted();
		
		// Background scene visual
		//hxd.Res.initEmbed();
		
		new TrainBGScene( sm);
	
		

	}
	
}