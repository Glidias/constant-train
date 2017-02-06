package cstrain.core;

/**
 * @author Glidias
 */
enum CardResult 
{
	OK;
	PENALIZE(penalty:Penalty);
	GUESS_CONSTANT(choice1:Float, choice2:Float);
	NOTHING;
}