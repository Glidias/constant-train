package cstrain.vuex.components;
import cstrain.vuex.store.GameStore;
import haxevx.vuex.core.NoneT;
import haxevx.vuex.core.VCSS;
import haxevx.vuex.core.VxComponent;

/**
 * ...
 * @author Glidias
 */
@:build(haxevx.vuex.core.VCSS.buildModuleStyle(' 
.trainprogress-bar {
	box-sizing:border-box;
	padding-left:20px;	
	padding-right:20px;	
	position:relative;
	.scrubber {
		position:absolute;
		top:0;
		left:0;
		width:100%;
		height:100%;
		.scrub {
			height:100%;
		}
	}
}
',  "scss"))
class TrainProgressBarView extends VxComponent<GameStore, NoneT, NoneT>
{
	
	override public function Template():String {
		return '
			<div class="trainprogress-bar">
				<div class="${STYLE.scrubber}" v-bind:style="scrubberStyle">
					<div class="${STYLE.scrub}" v-bind:style="scrubStyle"></div>
				</div>
			</div>
		';
	}
	public static inline var NAME:String = "TrainProgressBarView";
	
	public function get_scrubberStyle():Dynamic {
		var prog:Float = store.state.game.currentProgress;
		return {
			transform: 'translateX(${prog}%)'
		};
	}
	public function get_scrubStyle():Dynamic {
			var division:Float  = store.game.gameGetters.progressUnit;
			return {
				width: (division*100)+"%"
				
				//transform: 
			};
	}
	
		public function new() 
	{
		super();
	}
	

	
	
	
	
	
}