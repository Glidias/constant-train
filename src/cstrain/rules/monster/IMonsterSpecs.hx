package cstrain.rules.monster;

/**
 * @author Glidias
 */
interface IMonsterSpecs 
{
  
  var baseAttackRange(get, null):Float;
  
  var baseDamage(get, null):Float;
  
  var baseAttackRate(get, null):Float;
  
  var baseSpeed(get, null):Float;
  
  var startSleepTime(get, null):Float;
}