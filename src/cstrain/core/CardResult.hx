package cstrain.core;

/**
 * @author Glidias
 */
enum CardResult 
{
	OK;
	PENALIZE(penalty:Penalty);
	GUESS_CONSTANT(card:Card, wildGuess:Bool);
	NOTHING;
	GAMEOVER_OUTTA_CARDS;
}