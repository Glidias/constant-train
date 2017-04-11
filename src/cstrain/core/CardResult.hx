package cstrain.core;

/**
 * @author Glidias
 */
enum CardResult 
{
	OK(okFlags:OkFlags);
	PENALIZE(penalty:Penalty);
	GUESS_CONSTANT(card:Card, wildGuess:Bool);
	NOTHING;
	NOT_YET_AVAILABLE(timeLeft:Float, penaltyTime:Float);
	GAMEOVER_OUTTA_CARDS;
}