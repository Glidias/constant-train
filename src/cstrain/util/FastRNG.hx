package cstrain.util;
abstract FastRNG(Int) from Int to Int{
  static inline var FLOAT_MULT = 0.00000000046566128742;
  static inline var INT_MULT = 0x7FFFFFFF;

  public function new(?seed:Int){
    this = (seed == null) ? newSeed() : seed;
  }

  static inline function mutate(v){
    var t:Int = (v^(v<<11));
    return (v ^ (v >> 19))^(t ^ (t >> 8));
  }

  public inline function getInt():Int{
    return this = mutate(this);
  }

  public inline function getFloat()
    return getInt() * FLOAT_MULT;

  public inline function getIntB(bound:Int) return getInt() % bound;

  public inline function getIntBB(lb:Int, rb:Int)
    return lb + getIntB(rb - lb);

  public inline function getFloatB(bound:Float) return bound * getFloat();

  public inline function getFloatBB(lb:Float, rb:Float)
    return lb + getFloatB(rb - lb);

  public inline function getBool() return (getInt() & 1) == 0;

  public static function newSeed():Int{
    return Std.int((Math.random()*2 - 1) * INT_MULT);
    }


  public inline function bool(?chance:Float)
    return (chance == null) ? getBool() : getFloat() < chance;

  public inline function int(?b1:Int, ?b2:Int)
    return
      (b2 == null) ?
        (b1 == null) ? getInt() : getIntB( b1):
        getIntBB(b1, b2);

  public inline function float(?b1:Null<Float>, ?b2:Null<Float>)
    return
      (b2 == null) ?
        (b1 == null) ? getFloat() : getFloatB(b1):
        getFloatBB(b1, b2);

}