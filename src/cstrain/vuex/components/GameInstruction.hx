package cstrain.vuex.components;

import haxevx.vuex.core.VComponent;
import haxevx.vuex.core.NoneT;

@:build(haxevx.vuex.core.VCSS.buildModuleStyleFromFile(null, "scss", "mySTYLE") )
class GameInstruction extends VComponent<NoneT, NoneT>
{

	public function new()
	{
		super();
	}

	function onClickClose() {
		this._vEmit('close');
	}

	override public function Template():String {
		return '<div class="${mySTYLE.root}">
			<a class="${mySTYLE.closeBtn}" @click="onClickClose">[X] Close</a>
			<div class=${mySTYLE.instructContainer}>
				<p>You will be presented with a main deck of operation cards which you must empty out one by one (as fast as possible) after each swipe, starting with card \'n\', where \'n\' represents an unknown number. Each card will have a mathematical operation (eg. add/divide/minus/multiply), by a given plain number constant expression, an unknown `n` number, or polynomial expression with a combination of powered `n` values. Anytime you swipe left/right, the mathematical operation presented on the card will applied to the expression, resulting in some kind of result. You are supposed to track the result (often roughly) in your head because....</p>
				<p>...whenever the expression will result in a constant due to the unknown variable `n` being canceled away completely by particular operation, you should swipe the card RIGHT in order to anticipate a "stop" at the next location (which is also known as a \'constant "station" stop\'), and will be given a chance to guess the value of the constant with 2 left/right choices (and minimal penalty if you accidentally chose the wrong value). If the expression still has an unknown `n` variable inside it, then you should continue swiping LEFT to move the train along continually. If you missed a station stop (ie. didn\'t swipe right when you should), you will incur a penalty delay and be forced to play a higher/lower guessing game at the given station stop (to guess the constant) before you can set off again. After stopping at any given station stop and setting off again, a value of `n` is will always be added to the existing constant expression.</p>
				<p>If you SWIPE right but the resulting value of the expression doesn\'t result in a constant value, then you will incur some penalty delay as well before you can start swiping again.</p>
				<p>Mathematical operators are:<p>
				<p>
				`*` Multiply<br>
				`/` Divide<br>
				`+` Plus<br>
				`-` Minus<br>
				`//` Divide to get quotient only (ie. ignore remainder)<br>
				`(d?/dn)` Deriative
				<p>
			</div>
		</div>';
    }

}

