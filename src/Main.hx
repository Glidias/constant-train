package;
import cstrain.core.Polynomial;
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
		
		
		/*
			var polyI =  Polynomial.fromCoefs([2, 4, 3, 7]);
		polyI = polyI.add( Polynomial.createDeg1x());
		var polyV = polyI.evalValueFloat(5);
		trace(polyV);
		
		var poly =  polyI.divisionWithRemainder( Polynomial.createDeg1x() );
		trace(poly[0].add(poly[1]).evalValueFloat(5) );
		*/
	}
	
}