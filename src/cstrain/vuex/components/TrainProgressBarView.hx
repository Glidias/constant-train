package cstrain.vuex.components;
import cstrain.vuex.store.GameStore;
import haxevx.vuex.core.NoneT;
import haxevx.vuex.core.VxComponent;

/**
 * ...
 * @author Glidias
 */
@:build(haxevx.vuex.core.VCSS.buildModuleStyleFromFile(null, "scss") )
class TrainProgressBarView extends VxComponent<GameStore, NoneT, NoneT>
{

	public static inline var NAME:String = "TrainProgressBarView";
	
	
	@:computed function get_scrubberStyle():Dynamic {
		var prog:Float = store.game.gameGetters.progress * 100; // factor this out to store getter
		return {
			transform: 'translateX(${prog}%)'
		};
	}
	
	@:computed function get_scrubberStyleMonster():Dynamic {
		var prog:Float = store.game.gameGetters.monsterProgress * 100; // factor this out to store getter
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
			<div class="${STYLE.scrubber}" v-bind:style="scrubberStyle">
				<div class="${STYLE.scrub}" v-bind:style="scrubStyle">
					<div class="fa fa-angle-up ${STYLE.marker}"></div>
				</div>
			</div>
			<div class="${STYLE.scrubber}" v-bind:style="scrubberStyleMonster">
				<div class="${STYLE.enemyScrub}" v-bind:style="scrubStyle">
					<div class="fa fa-angle-down ${STYLE.marker}"></div>
				</div>
			</div>
		</div>';
	}
	
	
	public function new() 
	{
		super();
		
	}
	

	
}
