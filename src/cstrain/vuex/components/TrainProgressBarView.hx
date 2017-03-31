package cstrain.vuex.components;
import cstrain.vuex.store.GameStore;
import haxevx.vuex.core.NoneT;
import haxevx.vuex.core.VxComponent;

/**
 * ...
 * @author Glidias
 */
@:style('

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

',  "scss")
class TrainProgressBarView extends VxComponent<GameStore, NoneT, NoneT>
{
	
	public static inline var NAME:String = "TrainProgressBarView";

	public function new() 
	{
		super();
	}
	
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
	
	override public function Template():String {
		return '
			<div class="trainprogress-bar">
				<div class="scrubber" v-bind:style="scrubberStyle">
					<div class="scrub" v-bind:style="scrubStyle"></div>
				</div>
			</div>
		';
	}
	
	
	
}