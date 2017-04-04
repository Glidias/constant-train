package cstrain.vuex.components;
import cstrain.vuex.store.GameStore;
import haxe.ds.StringMap;
import haxevx.vuex.core.NoneT;
import haxevx.vuex.core.VCSS;
import haxevx.vuex.core.VxComponent;
import haxevx.vuex.util.VHTMacros;

/**
 * ...
 * @author Glidias
 */
@:build(haxevx.vuex.core.VCSS.buildModuleStyleFromFile(null, "scss") )
class TrainProgressBarView extends VxComponent<GameStore, NoneT, NoneT>
{

	public static inline var NAME:String = "TrainProgressBarView";
	
	
	@:computed function get_scrubberStyle():Dynamic {
		var prog:Float = store.state.game.vueData.currentProgress;
		return {
			transform: 'translateX(${prog}%)'
		};
	}

	@:computed function get_scrubStyle():Dynamic {
			var division:Float  = store.game.gameGetters.progressUnit;
			
			return {
				width: (division*100)+"%"
				
				//transform: 
			};
	}
	
	override public function Template():String {
		return '
		<div class="${STYLE.trainprogressBar}">
			<div class="${STYLE.scrubber} ${SharedCSS.allowselect}" v-bind:style="scrubberStyle">
				<div class="${STYLE.scrub}" v-bind:style="scrubStyle"></div>
			</div>
		</div>';
	}
	
	
	public function new() 
	{
		super();
		
	}
	

	
}
