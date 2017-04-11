package cstrain.core;

/**
 * A macro builder could be done to generate boilerplate and even assign flag values
 * @author Glidias
 */
@:enum abstract OkFlags(Int) 
{
	// flags
	inline var GAME_OVER = 4;
    inline var GUESSED_CONSTANT = 2;
	inline var PROGRESSED = 1;
	inline var NONE = 0;
	
	
	
	// boilerplate
    inline public function new(bits:Int = 0) {
        this = bits;
    }

    inline public function has(flags:OkFlags):Bool {
        return (this & flags.value) != 0;
    }
	 inline public function hasBits(bits:Int):Bool {
        return (this & bits) != 0;
    }

    inline public function add(flags:OkFlags):OkFlags {
        return new OkFlags(this | flags.value);
    }

    public var value(get, never):Int;
    inline function get_value():Int {
        return this;
    }
}