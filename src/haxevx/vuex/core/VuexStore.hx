package haxevx.vuex.core;
import haxevx.vuex.core.NativeTypes.NativeModule;
import haxevx.vuex.native.CommitOptions;
import haxevx.vuex.native.DispatchOptions;
import haxevx.vuex.native.Vuex.Store;
import js.Promise;

/**
 * A Haxe class that extends Vuex.Store directly, able to function as both a Vuex.Store and Vuex's StoreOptions simulatenously.
 * @author Glidias
 */

class VuexStore<S,G> implements IVxStoreContext<S> extends Store<S,G>
{
	
	public var strict:Bool = false;
	
	public function new():Void {
		super(untyped this);
		_PostConstruct();
	}
	
	/* INTERFACE haxevx.vuex.core.IVxStoreContext.IVxStoreContext<S> */
	
	@:final function _PostConstruct():Void {	// NOTE: Duplicate  code from VxBoot
		var storeParams:Dynamic = this;
			var md:Dynamic;
		if ( storeParams.getters != null) {
			var o:Dynamic;
			var storeGetters:Dynamic = untyped this.getters;
				
			if (storeParams.modules != null) {  
				var moduleNameStack:Array<String> = [];
				
				for (p in Reflect.fields((o = storeParams.modules))) {
					moduleNameStack.push(p);
					
					var m:NativeModule<Dynamic,Dynamic> = untyped o[p];// Reflect.field(o, p);
					md = untyped storeParams[p];// Reflect.field(storeParams, p); //VModule<Dynamic>
					
					untyped store[p] = md;

					if (m.getters != null) {	
						untyped md._stg = storeGetters;
					}
					moduleNameStack.pop();
				}
			}
		}

	}
	
}
	
	
