package cstrain.core;

/**
 * @author Glidias
 */
enum PenaltyDesc 
{
	LOST_IN_TRANSIT;
	MISSED_STOP;
	WRONG_CONSTANT;
	FURTHER_GUESS(answerHigher:Bool);
	CLOSER_GUESS(answerHigher:Bool);
	//UNKNOWN_GUESS(answerHigher:Bool);
}