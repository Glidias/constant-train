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
		
		
		///*
			var polyI =  Polynomial.fromCoefs([11, 4, 3, 7]);
		polyI = polyI.add( Polynomial.createDeg1x());
		
		
		trace(Polynomial.fromCoefs([1,0,0,0,1]).factorisation());
		trace(Polynomial.fromCoefs([-20,24,1,-6,1]).factorisation());
		
		trace("End factorisation");
		var polyV = polyI.evalValueFloat(5);
		trace(polyI.coefs);
		trace(polyV);
		
		
		
		var poly =  polyI.divisionWithRemainder( Polynomial.createDeg1x() );
		trace(poly[0].coefs + " > "+poly[1].coefs);
		trace( poly[0].evalValueFloat(5) + " , "+ Polynomial.evaluateDivisionRemAsFloat(poly, 5) );
	//	*/
	}
	
}