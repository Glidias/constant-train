package cstrain.core;

/**
 * likely to be depciated, for much use for it atm
 * @author Glidias
 */
enum Operation 
{
	ADD(val:Float, varSuffix:Bool);
	SUBTRACT(val:Float, varSuffix:Bool);
	MULTIPLY(val:Float, varSuffix:Bool);
	DIVIDE(val:Float, varSuffix:Bool);
	DIVIDE_BY_POLYNOMIAL(coefs:Array<Float>);
	EQUAL(val:Float, varSuffix:Bool);
}