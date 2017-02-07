package;
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
		var boot:VxBoot = new VxBoot();
		var gs = new GameStore(new TestGame()) ;
	
		var store = boot.startStore( gs) ;
		
		
		boot.startVueWithRootComponent( "#app", new GameView());
		VxBoot.notifyStarted();
		
	}
	
}