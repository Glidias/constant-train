(function (console) { "use strict";
var $estr = function() { return js_Boot.__string_rec(this,''); };
function $extend(from, fields) {
	function Inherit() {} Inherit.prototype = from; var proto = new Inherit();
	for (var name in fields) proto[name] = fields[name];
	if( fields.toString !== Object.prototype.toString ) proto.toString = fields.toString;
	return proto;
}
var HxOverrides = function() { };
HxOverrides.__name__ = true;
HxOverrides.substr = function(s,pos,len) {
	if(pos != null && pos != 0 && len != null && len < 0) return "";
	if(len == null) len = s.length;
	if(pos < 0) {
		pos = s.length + pos;
		if(pos < 0) pos = 0;
	} else if(len < 0) len = s.length + len - pos;
	return s.substr(pos,len);
};
var Main = function() { };
Main.__name__ = true;
Main.main = function() {
	var boot = new haxevx_vuex_core_VxBoot();
	var gs = new cstrain_vuex_store_GameStore(new cstrain_rules_TestGame());
	var store = boot.startStore(gs);
	boot.startVueWithRootComponent("#app",new cstrain_vuex_components_GameView());
	haxevx_vuex_core_VxBoot.notifyStarted();
};
Math.__name__ = true;
var Reflect = function() { };
Reflect.__name__ = true;
Reflect.field = function(o,field) {
	try {
		return o[field];
	} catch( e ) {
		if (e instanceof js__$Boot_HaxeError) e = e.val;
		return null;
	}
};
Reflect.fields = function(o) {
	var a = [];
	if(o != null) {
		var hasOwnProperty = Object.prototype.hasOwnProperty;
		for( var f in o ) {
		if(f != "__id__" && f != "hx__closures__" && hasOwnProperty.call(o,f)) a.push(f);
		}
	}
	return a;
};
var Std = function() { };
Std.__name__ = true;
Std.string = function(s) {
	return js_Boot.__string_rec(s,"");
};
Std["int"] = function(x) {
	return x | 0;
};
var cstrain_core_Card = function(op,value,isVar,virtualRight) {
	if(isVar == null) isVar = false;
	this.operator = op;
	this.value = value;
	this.isVar = isVar;
	this.virtualRight = virtualRight;
};
cstrain_core_Card.__name__ = true;
cstrain_core_Card.stringifyOp = function(op) {
	if(op == 0) return "+"; else if(op == 1) return "-"; else if(op == 2) return "*"; else if(op == 3) return "/"; else if(op == 4) return "="; else return "?";
};
cstrain_core_Card.toOperation = function(card) {
	var _g = card.operator;
	switch(_g) {
	case 0:
		return cstrain_core_Operation.ADD(card.value,card.isVar);
	case 1:
		return cstrain_core_Operation.SUBTRACT(card.value,card.isVar);
	case 2:
		return cstrain_core_Operation.MULTIPLY(card.value,card.isVar);
	case 3:
		return cstrain_core_Operation.DIVIDE(card.value,card.isVar);
	case 4:
		return cstrain_core_Operation.EQUAL(card.value,card.isVar);
	default:
		throw new js__$Boot_HaxeError("Card:: toOperation invalid operator:" + card.operator);
		return null;
	}
};
cstrain_core_Card.getRegularGuessConstantCard = function(value,value2) {
	return new cstrain_core_Card(4,value,false,new cstrain_core_Card(4,value2,false));
};
var cstrain_core_CardResult = { __ename__ : true, __constructs__ : ["OK","PENALIZE","GUESS_CONSTANT","NOTHING","NOT_YET_AVAILABLE","GAMEOVER_OUTTA_CARDS"] };
cstrain_core_CardResult.OK = ["OK",0];
cstrain_core_CardResult.OK.toString = $estr;
cstrain_core_CardResult.OK.__enum__ = cstrain_core_CardResult;
cstrain_core_CardResult.PENALIZE = function(penalty) { var $x = ["PENALIZE",1,penalty]; $x.__enum__ = cstrain_core_CardResult; $x.toString = $estr; return $x; };
cstrain_core_CardResult.GUESS_CONSTANT = function(card,wildGuess) { var $x = ["GUESS_CONSTANT",2,card,wildGuess]; $x.__enum__ = cstrain_core_CardResult; $x.toString = $estr; return $x; };
cstrain_core_CardResult.NOTHING = ["NOTHING",3];
cstrain_core_CardResult.NOTHING.toString = $estr;
cstrain_core_CardResult.NOTHING.__enum__ = cstrain_core_CardResult;
cstrain_core_CardResult.NOT_YET_AVAILABLE = function(timeLeft,penaltyTime) { var $x = ["NOT_YET_AVAILABLE",4,timeLeft,penaltyTime]; $x.__enum__ = cstrain_core_CardResult; $x.toString = $estr; return $x; };
cstrain_core_CardResult.GAMEOVER_OUTTA_CARDS = ["GAMEOVER_OUTTA_CARDS",5];
cstrain_core_CardResult.GAMEOVER_OUTTA_CARDS.toString = $estr;
cstrain_core_CardResult.GAMEOVER_OUTTA_CARDS.__enum__ = cstrain_core_CardResult;
var cstrain_core_Deck = function() {
	this.cards = [];
};
cstrain_core_Deck.__name__ = true;
cstrain_core_Deck.arrayShuffleFisherYates = function(array) {
	var m = array.length;
	var i;
	var temp;
	while(m != 0) {
		i = Std["int"](Math.random() * m--);
		temp = array[m];
		array[m] = array[i];
		array[i] = temp;
	}
	return array;
};
cstrain_core_Deck.getCards = function(setMask,operatorMask,constantMask,numTimes) {
	if(numTimes == null) numTimes = 1;
	if(constantMask == null) constantMask = 0;
	var cards = [];
	if(setMask == 0) setMask = 3;
	if(operatorMask == 0) operatorMask = 15;
	if(constantMask == 0) constantMask = 1023;
	if((setMask & 1) != 0) {
		var _g = 0;
		while(_g < numTimes) {
			var i = _g++;
			var _g1 = 0;
			while(_g1 < 4) {
				var o = _g1++;
				if((operatorMask & 1 << o) != 0) {
					var _g2 = 0;
					while(_g2 < 10) {
						var i1 = _g2++;
						if((constantMask & 1 << i1) != 0) cards.push(new cstrain_core_Card(o,i1 + 1));
					}
				}
			}
		}
	}
	if((setMask & 2) != 0) {
		var _g3 = 0;
		while(_g3 < numTimes) {
			var i2 = _g3++;
			var _g11 = 0;
			while(_g11 < 4) {
				var o1 = _g11++;
				if((operatorMask & 1 << o1) != 0) cards.push(new cstrain_core_Card(o1,1,true));
			}
		}
	}
	return cards;
};
cstrain_core_Deck.prototype = {
	shuffle: function() {
		cstrain_core_Deck.arrayShuffleFisherYates(this.cards);
	}
	,addCards: function(cards,placeOnTop) {
		if(placeOnTop == null) placeOnTop = true;
		if(placeOnTop) this.cards = this.cards.concat(cards); else this.cards = cards.concat(this.cards);
	}
};
var cstrain_core_GameSettings = function() {
	this.penaltyDelayMs = 0;
	this.minTurnTime = 1;
};
cstrain_core_GameSettings.__name__ = true;
var cstrain_core_IRules = function() { };
cstrain_core_IRules.__name__ = true;
var cstrain_core_Operation = { __ename__ : true, __constructs__ : ["ADD","SUBTRACT","MULTIPLY","DIVIDE","EQUAL"] };
cstrain_core_Operation.ADD = function(val,varSuffix) { var $x = ["ADD",0,val,varSuffix]; $x.__enum__ = cstrain_core_Operation; $x.toString = $estr; return $x; };
cstrain_core_Operation.SUBTRACT = function(val,varSuffix) { var $x = ["SUBTRACT",1,val,varSuffix]; $x.__enum__ = cstrain_core_Operation; $x.toString = $estr; return $x; };
cstrain_core_Operation.MULTIPLY = function(val,varSuffix) { var $x = ["MULTIPLY",2,val,varSuffix]; $x.__enum__ = cstrain_core_Operation; $x.toString = $estr; return $x; };
cstrain_core_Operation.DIVIDE = function(val,varSuffix) { var $x = ["DIVIDE",3,val,varSuffix]; $x.__enum__ = cstrain_core_Operation; $x.toString = $estr; return $x; };
cstrain_core_Operation.EQUAL = function(val,varSuffix) { var $x = ["EQUAL",4,val,varSuffix]; $x.__enum__ = cstrain_core_Operation; $x.toString = $estr; return $x; };
var cstrain_core_PenaltyDesc = { __ename__ : true, __constructs__ : ["LOST_IN_TRANSIT","MISSED_STOP","WRONG_CONSTANT","FURTHER_GUESS","CLOSER_GUESS"] };
cstrain_core_PenaltyDesc.LOST_IN_TRANSIT = ["LOST_IN_TRANSIT",0];
cstrain_core_PenaltyDesc.LOST_IN_TRANSIT.toString = $estr;
cstrain_core_PenaltyDesc.LOST_IN_TRANSIT.__enum__ = cstrain_core_PenaltyDesc;
cstrain_core_PenaltyDesc.MISSED_STOP = ["MISSED_STOP",1];
cstrain_core_PenaltyDesc.MISSED_STOP.toString = $estr;
cstrain_core_PenaltyDesc.MISSED_STOP.__enum__ = cstrain_core_PenaltyDesc;
cstrain_core_PenaltyDesc.WRONG_CONSTANT = ["WRONG_CONSTANT",2];
cstrain_core_PenaltyDesc.WRONG_CONSTANT.toString = $estr;
cstrain_core_PenaltyDesc.WRONG_CONSTANT.__enum__ = cstrain_core_PenaltyDesc;
cstrain_core_PenaltyDesc.FURTHER_GUESS = function(answerHigher) { var $x = ["FURTHER_GUESS",3,answerHigher]; $x.__enum__ = cstrain_core_PenaltyDesc; $x.toString = $estr; return $x; };
cstrain_core_PenaltyDesc.CLOSER_GUESS = function(answerHigher) { var $x = ["CLOSER_GUESS",4,answerHigher]; $x.__enum__ = cstrain_core_PenaltyDesc; $x.toString = $estr; return $x; };
var cstrain_core_PlayerStats = function() {
	this.startTime = 0;
	this.lastMovedTime = 0;
	this.lostInTransits = 0;
	this.reachedStops = 0;
	this.missedStops = 0;
};
cstrain_core_PlayerStats.__name__ = true;
var cstrain_core_Polynomial = function() {
	this.coefs = [0];
};
cstrain_core_Polynomial.__name__ = true;
cstrain_core_Polynomial.createDeg1x = function() {
	var poly = new cstrain_core_Polynomial();
	poly.coefs.push(1);
	return poly;
};
cstrain_core_Polynomial.trim = function(a) {
	var i = a.coefs.length - 1;
	while(i > 0 && (a.coefs.length - 1 < i?null:a.coefs[i]) == 0) {
		a.coefs.splice(i,1);
		i--;
	}
};
cstrain_core_Polynomial.floatToStringPrecision = function(n,prec) {
	n *= Math.pow(10,prec);
	return Std.string(Math.round(n) / Math.pow(10,prec));
};
cstrain_core_Polynomial.getSign = function(co) {
	if(co != 0) {
		if(co < 0) return ""; else return "+";
	} else return "";
};
cstrain_core_Polynomial.getRepresentation = function(co,level,varLabel,isHTML) {
	if(co != 0) return (co != 1 || level < 1?cstrain_core_Polynomial.floatToStringPrecision(co,2) + "":"") + (level >= 1?varLabel:"") + (level >= 2?isHTML?"<sup>" + level + "</sup>":"^" + level:""); else return "";
};
cstrain_core_Polynomial.PrintOut = function(poly,varLabel,isHTML) {
	var arr = [cstrain_core_Polynomial.getSign(poly.coefs[0]) + cstrain_core_Polynomial.getRepresentation(poly.coefs[0],0,varLabel,isHTML)];
	var _g1 = 1;
	var _g = poly.coefs.length;
	while(_g1 < _g) {
		var i = _g1++;
		arr.push(cstrain_core_Polynomial.getSign(poly.coefs[i]) + cstrain_core_Polynomial.getRepresentation(poly.coefs[i],i,varLabel,isHTML));
	}
	arr.reverse();
	if(arr[0].charAt(0) == "+") arr[0] = HxOverrides.substr(arr[0],1,null);
	return arr.join(" ");
};
cstrain_core_Polynomial.Copy = function(poly) {
	var me = new cstrain_core_Polynomial();
	me.coefs = poly.coefs.concat([]);
	return me;
};
cstrain_core_Polynomial.prototype = {
	getCoef: function(i) {
		if(this.coefs.length - 1 < i) return null; else return this.coefs[i];
	}
	,isZero: function() {
		return this.coefs.length - 1 == 0 && (this.coefs.length - 1 < 0?null:this.coefs[0]) == 0;
	}
	,addCoef: function(i,value) {
		var oldCoef;
		if(this.coefs.length - 1 < i) oldCoef = null; else oldCoef = this.coefs[i];
		if(oldCoef == null) oldCoef = 0;
		this.setCoef(i,oldCoef + value);
	}
	,setCoef: function(i,value) {
		while(this.coefs.length - 1 < i) this.coefs.push(0);
		this.coefs[i] = value;
	}
	,copyFrom: function(p) {
		var coefs = [];
		var _g1 = 0;
		var _g = p.coefs.length;
		while(_g1 < _g) {
			var i = _g1++;
			coefs[i] = p.coefs[i];
		}
		this.coefs = coefs;
	}
	,add: function(b) {
		var result;
		var shorterOne;
		if(this.coefs.length - 1 > b.coefs.length - 1) {
			result = cstrain_core_Polynomial.Copy(this);
			shorterOne = b;
		} else {
			result = cstrain_core_Polynomial.Copy(b);
			shorterOne = this;
		}
		var _g1 = 0;
		var _g = shorterOne.coefs.length - 1 + 1;
		while(_g1 < _g) {
			var i = _g1++;
			result.addCoef(i,shorterOne.coefs.length - 1 < i?null:shorterOne.coefs[i]);
		}
		cstrain_core_Polynomial.trim(result);
		return result;
	}
	,sub: function(b) {
		var result = this.add(b.mulI(-1));
		cstrain_core_Polynomial.trim(result);
		return result;
	}
	,divisionWithRemainder: function(b) {
		if(b.isZero()) throw new js__$Boot_HaxeError("divisionWithRemainder:: / by zero");
		var result = [];
		var a = this;
		var integer = new cstrain_core_Polynomial();
		var deg = a.coefs.length - 1 - (b.coefs.length - 1);
		while(deg >= 0 && !a.isZero()) {
			var coefA = a.getCoef(a.coefs.length - 1);
			var coefB = b.getCoef(b.coefs.length - 1);
			var coefI = coefA / coefB;
			integer.setCoef(deg,coefI);
			var temp = new cstrain_core_Polynomial();
			temp.setCoef(deg,coefI);
			a = a.sub(b.mul(temp));
			deg = a.coefs.length - 1 - (b.coefs.length - 1);
		}
		result.push(integer);
		result.push(a);
		return result;
	}
	,div: function(b) {
		return this.divisionWithRemainder(b)[0];
	}
	,mul: function(b) {
		var result = new cstrain_core_Polynomial();
		var degA = this.coefs.length - 1;
		var degB = b.coefs.length - 1;
		var _g1 = 0;
		var _g = degA + 1;
		while(_g1 < _g) {
			var i = _g1++;
			var _g3 = 0;
			var _g2 = degB + 1;
			while(_g3 < _g2) {
				var j = _g3++;
				var termA;
				if(this.coefs.length - 1 < i) termA = null; else termA = this.coefs[i];
				var termB;
				if(b.coefs.length - 1 < j) termB = null; else termB = b.coefs[j];
				result.addCoef(i + j,termA * termB);
			}
		}
		cstrain_core_Polynomial.trim(result);
		return result;
	}
	,mulI: function(a) {
		var result = cstrain_core_Polynomial.Copy(this);
		var _g1 = 0;
		var _g = result.coefs.length;
		while(_g1 < _g) {
			var i = _g1++;
			result.setCoef(i,(result.coefs.length - 1 < i?null:result.coefs[i]) * a);
		}
		cstrain_core_Polynomial.trim(result);
		return result;
	}
	,evalValueInt: function(varValue) {
		var sum = 0;
		var _g1 = 0;
		var _g = this.coefs.length;
		while(_g1 < _g) {
			var i = _g1++;
			sum += this.coefs[i] * Math.pow(varValue,i);
		}
		return sum | 0;
	}
	,cleanupPolynomial: function() {
		var i = this.coefs.length;
		while(--i > 0) if(this.coefs[i] != 0) break; else this.coefs.pop();
	}
	,performOperation: function(op) {
		switch(op[1]) {
		case 0:
			var isVar = op[3];
			var value = op[2];
			if(isVar && this.coefs.length < 2) this.coefs.push(0);
			this.coefs[isVar?1:0] += value;
			break;
		case 1:
			var isVar1 = op[3];
			var value1 = op[2];
			if(isVar1 && this.coefs.length < 2) this.coefs.push(0);
			this.coefs[isVar1?1:0] -= value1;
			break;
		case 2:
			var isVar2 = op[3];
			var value2 = op[2];
			if(isVar2) this.coefs.unshift(0);
			var _g1 = 0;
			var _g = this.coefs.length;
			while(_g1 < _g) {
				var i = _g1++;
				this.coefs[i] *= value2;
			}
			break;
		case 3:
			var isVar3 = op[3];
			var value3 = op[2];
			if(value3 == 0) throw new js__$Boot_HaxeError("Divide by zero error detected!");
			if(isVar3) this.copyFrom(this.div(cstrain_core_Polynomial.createDeg1x())); else {
				var _g11 = 0;
				var _g2 = this.coefs.length;
				while(_g11 < _g2) {
					var i1 = _g11++;
					this.coefs[i1] /= value3;
				}
			}
			break;
		default:
			console.log("UInaccounted for operation:" + Std.string(op));
		}
		this.cleanupPolynomial();
	}
};
var cstrain_rules_TestGame = function() {
	this._lastReceivedTime = 0;
	this.commenced = false;
	this.gameSettings = new cstrain_core_GameSettings();
	this.polynomialValueCached = false;
	this.gameSettings.penaltyDelayMs = 3000;
	this.restart();
};
cstrain_rules_TestGame.__name__ = true;
cstrain_rules_TestGame.__interfaces__ = [cstrain_core_IRules];
cstrain_rules_TestGame.prototype = {
	buildDeck: function() {
		var baseMult = 8;
		this.deck.addCards(cstrain_core_Deck.getCards(1,3,0,baseMult));
		this.deck.addCards(cstrain_core_Deck.getCards(1,12,2,baseMult));
		this.deck.addCards(cstrain_core_Deck.getCards(2,1,0,8 * baseMult - 1));
		this.deck.addCards(cstrain_core_Deck.getCards(2,2,0,8 * baseMult));
		this.deck.addCards(cstrain_core_Deck.getCards(2,12,0,4 * baseMult));
		this.deck.shuffle();
		this.curDeck = this.deck;
		this.curDeckIndex = this.curDeck.cards.length - 1;
		this.thePopupCard = new cstrain_core_Card(0,1,true);
	}
	,getFakeValueOf: function(val) {
		var ceilVal = Math.ceil(val / 20);
		if(ceilVal == 0) ceilVal = 1;
		var magnitudeBase = ceilVal * 20;
		var minBase = Std["int"](Math.ceil(magnitudeBase / 8));
		if(Math.random() >= .5) return Std["int"](val - minBase - Std["int"](magnitudeBase * Math.random())); else return Std["int"](val + minBase + Std["int"](magnitudeBase * Math.random()));
	}
	,getCloserValueTo: function(val,from) {
		var amt = val - from;
		if(val >= from) from += Std["int"](Math.ceil(Math.random() * amt)); else from += Std["int"](Math.floor(Math.random() * amt));
		return from;
	}
	,getFakeValueOfCloserValue: function(val) {
		var ceilVal = Math.ceil(val / 20);
		if(ceilVal == 0) ceilVal = 1;
		var magnitudeBase = ceilVal * 20;
		var minBase = Std["int"](Math.ceil(magnitudeBase / 2));
		if(Math.random() >= .5) return Std["int"](val - minBase - Std["int"](Math.floor(magnitudeBase * Math.random()))); else return Std["int"](val + minBase + Std["int"](Math.ceil(magnitudeBase * Math.random())));
	}
	,getCardResult: function(isSwipeRight) {
		var curCard;
		if(this.thePopupCard != null) curCard = this.thePopupCard; else if(this.curDeckIndex >= 0) curCard = this.curDeck.cards[this.curDeckIndex--]; else curCard = null;
		if(curCard == null) return cstrain_core_CardResult.GAMEOVER_OUTTA_CARDS;
		this.thePopupCard = null;
		if(curCard.operator <= 3) {
			this.polynomial.performOperation(cstrain_core_Card.toOperation(curCard));
			this.currentPlayerStats.lastMovedTime = new Date().getTime();
			if(isSwipeRight) {
				if(!(this.polynomial.coefs.length > 1)) if(Math.random() >= .5) return cstrain_core_CardResult.GUESS_CONSTANT(cstrain_core_Card.getRegularGuessConstantCard(this.polynomial.coefs[0] | 0,this.getFakeValueOf(this.polynomial.coefs[0])),false); else return cstrain_core_CardResult.GUESS_CONSTANT(cstrain_core_Card.getRegularGuessConstantCard(this.getFakeValueOf(this.polynomial.coefs[0]),this.polynomial.coefs[0] | 0),false); else return cstrain_core_CardResult.PENALIZE({ desc : cstrain_core_PenaltyDesc.LOST_IN_TRANSIT, delayNow : 1});
			} else if(!(this.polynomial.coefs.length > 1)) return cstrain_core_CardResult.PENALIZE({ desc : cstrain_core_PenaltyDesc.MISSED_STOP, delayNow : 2}); else return cstrain_core_CardResult.OK;
			console.log("UNaccounted operation");
		} else if(curCard.operator == 4) {
			var c;
			if(!this.wildGuess) c = this.polynomial.coefs[0] | 0; else if(this.polynomialValueCached) c = this.polynomialValue; else c = this.polynomialValue = this.polynomial.evalValueInt(this.secretVarValue);
			var rightIsRight;
			if(this.wildGuess) rightIsRight = Math.abs(curCard.virtualRight.value - c) < Math.abs(curCard.value - c); else rightIsRight = curCard.virtualRight.value == c;
			var valueChosen;
			if(isSwipeRight) valueChosen = curCard.virtualRight.value; else valueChosen = curCard.value;
			this._valueChosen = valueChosen;
			if(isSwipeRight && rightIsRight || !isSwipeRight && !rightIsRight) {
				if(c != valueChosen) {
					if(!this.wildGuess) console.log("Should not happen exception occured mismatch with swipe and correct answre for !wildGuess..");
					return cstrain_core_CardResult.PENALIZE({ desc : cstrain_core_PenaltyDesc.CLOSER_GUESS(c > valueChosen), delayNow : 1});
				} else {
					this.thePopupCard = new cstrain_core_Card(0,1,true);
					this.secretVarValue = Std["int"](Math.ceil(Math.random() * 10));
					this.polynomialValueCached = false;
					return cstrain_core_CardResult.OK;
				}
			} else if(!this.wildGuess) return cstrain_core_CardResult.PENALIZE({ desc : cstrain_core_PenaltyDesc.WRONG_CONSTANT, delayNow : 1}); else return cstrain_core_CardResult.PENALIZE({ delayNow : 2, desc : cstrain_core_PenaltyDesc.FURTHER_GUESS(c > valueChosen)});
		} else console.log("Unaccounted for opreation: " + cstrain_core_Card.stringifyOp(curCard.operator));
		console.log("Exception CardResult.NOTHING detected. Should not happen!");
		return cstrain_core_CardResult.NOTHING;
	}
	,restart: function() {
		this.deck = new cstrain_core_Deck();
		this.thePopupCard = null;
		this.polynomial = new cstrain_core_Polynomial();
		this.wildGuess = false;
		this.secretVarValue = Std["int"](Math.ceil(Math.random() * 10));
		this.polynomialValueCached = false;
		this._lastReceivedTime = 0;
		this._penaltyTime = 0;
		this.commenced = false;
		this.currentPlayerStats = new cstrain_core_PlayerStats();
		this.buildDeck();
	}
	,getAllCards: function() {
		return this.deck.cards;
	}
	,playCard: function(isSwipeRight) {
		var currentTime = new Date().getTime();
		var timeCap;
		if(this._penaltyTime >= this.gameSettings.minTurnTime) timeCap = this._penaltyTime; else timeCap = this.gameSettings.minTurnTime;
		if(currentTime - this._lastReceivedTime < timeCap) return cstrain_core_CardResult.NOT_YET_AVAILABLE(timeCap - (currentTime - this._lastReceivedTime),this._penaltyTime);
		var result = this.getCardResult(isSwipeRight);
		switch(result[1]) {
		case 2:
			var wildGuess = result[3];
			var guessConstantCard = result[2];
			this.wildGuess = wildGuess;
			var c = this.polynomial.coefs[0] | 0;
			this.thePopupCard = guessConstantCard;
			this.currentPlayerStats.reachedStops++;
			break;
		case 1:
			switch(result[2].desc[1]) {
			case 0:
				this.wildGuess = true;
				this.currentPlayerStats.lostInTransits++;
				break;
			case 1:
				this.wildGuess = true;
				var to;
				if(this.polynomialValueCached) to = this.polynomialValue; else to = this.polynomialValue = this.polynomial.evalValueInt(this.secretVarValue);
				if(to != (this.polynomial.coefs[0] | 0)) console.log("Assertion failed values mismatched between secret and constant at constant station!:" + Std.string([to,this.polynomial.coefs[0] | 0]));
				var firstChoice = this.getFakeValueOf(to);
				var secondChoice = this.getFakeValueOf(to);
				if(secondChoice == firstChoice) secondChoice = this.getFakeValueOfCloserValue(firstChoice);
				this.thePopupCard = new cstrain_core_Card(4,firstChoice,false,new cstrain_core_Card(4,secondChoice,false));
				this.currentPlayerStats.missedStops++;
				break;
			case 4:case 3:
				var v;
				if(this.wildGuess) {
					if(this.polynomialValueCached) v = this.polynomialValue; else v = this.polynomialValue = this.polynomial.evalValueInt(this.secretVarValue);
				} else v = this.polynomial.coefs[0] | 0;
				var to1;
				if(this.polynomialValueCached) to1 = this.polynomialValue; else to1 = this.polynomialValue = this.polynomial.evalValueInt(this.secretVarValue);
				var firstChoice1 = this.getCloserValueTo(v,this._valueChosen);
				var secondChoice1 = this.getCloserValueTo(v,this._valueChosen);
				if(secondChoice1 == firstChoice1) secondChoice1 = this.getFakeValueOfCloserValue(firstChoice1);
				this.thePopupCard = new cstrain_core_Card(4,firstChoice1,false,new cstrain_core_Card(4,secondChoice1,false));
				break;
			default:
			}
			break;
		default:
		}
		switch(result[1]) {
		case 1:
			var penalty = result[2];
			if(penalty.delayNow != null) this._penaltyTime = penalty.delayNow * this.gameSettings.penaltyDelayMs;
			break;
		default:
			this._penaltyTime = 0;
		}
		this._lastReceivedTime = currentTime;
		return result;
	}
	,getPlayerStats: function() {
		return this.currentPlayerStats;
	}
	,getGameSettings: function() {
		return this.gameSettings;
	}
	,getTopmostCard: function() {
		if(!this.commenced) {
			this.commenced = true;
			this.currentPlayerStats.startTime = new Date().getTime();
		}
		if(this.thePopupCard != null) return this.thePopupCard; else if(this.curDeckIndex >= 0) return this.curDeck.cards[this.curDeckIndex]; else return null;
	}
	,getPolynomial: function() {
		return this.polynomial;
	}
	,getDeckIndex: function() {
		return this.curDeck.cards.length - this.curDeckIndex - 1;
	}
};
var haxevx_vuex_core_VComponent = function() {
	this._Init();
};
haxevx_vuex_core_VComponent.__name__ = true;
haxevx_vuex_core_VComponent.__super__ = Object;
haxevx_vuex_core_VComponent.prototype = $extend(Object.prototype,{
	_Init: function() {
	}
});
var haxevx_vuex_core_VxComponent = function() {
	haxevx_vuex_core_VComponent.call(this);
};
haxevx_vuex_core_VxComponent.__name__ = true;
haxevx_vuex_core_VxComponent.__super__ = haxevx_vuex_core_VComponent;
haxevx_vuex_core_VxComponent.prototype = $extend(haxevx_vuex_core_VComponent.prototype,{
});
var cstrain_vuex_components_CardView = function() {
	haxevx_vuex_core_VxComponent.call(this);
};
cstrain_vuex_components_CardView.__name__ = true;
cstrain_vuex_components_CardView.getCardCopy = function(card) {
	return (card.operator <= 3?cstrain_core_Card.stringifyOp(card.operator):"") + (card.isVar?"n":card.value + "");
};
cstrain_vuex_components_CardView.__super__ = haxevx_vuex_core_VxComponent;
cstrain_vuex_components_CardView.prototype = $extend(haxevx_vuex_core_VxComponent.prototype,{
	tickDown: function() {
		this.secondsLeft--;
	}
	,Data: function() {
		return { secondsLeft : 0};
	}
	,get_cardCopy: function() {
		var delayTimeLeft = this.secondsLeft;
		var regularCopy;
		if(this.currentCard.operator <= 3) regularCopy = cstrain_vuex_components_CardView.getCardCopy(this.currentCard); else regularCopy = cstrain_vuex_components_CardView.getCardCopy(this.currentCard) + " :: " + cstrain_vuex_components_CardView.getCardCopy(this.currentCard.virtualRight);
		var penaltyPhrase = this.$store.game.gameGetters.get_simplePenaltyPhrase() + ": " + this.secondsLeft;
		if(this.$store.state.game.delayTimeLeft > 0) return penaltyPhrase;
		return regularCopy;
	}
	,get_delayTimeInSec: function() {
		return Std["int"](Math.ceil(this.$store.state.game.delayTimeLeft / 1000));
	}
	,watch_delayTimeInSec: function(val) {
		this.secondsLeft = val;
		if(val > 0) {
			this.$data._timer = new haxe_Timer(1000);
			this.$data._timer.run = $bind(this,this.tickDown);
		} else this.$data._timer.stop();
	}
	,swipe: function(isRight) {
		this.$store.dispatch("cstrain_vuex_game_GameActions|swipe",isRight);
	}
	,get_tickStr: function() {
		if(this.$store.game.gameGetters.get_swipedCorrectly()) return "✓"; else return "✗";
	}
	,get_penaltiedStr: function() {
		if(this.$store.game.gameGetters.get_isPenalized()) return "!"; else return "...";
	}
	,get_curCardIndex: function() {
		return this.$store.game.gameGetters.get_curCardIndex();
	}
	,get_totalCards: function() {
		return this.$store.game.gameGetters.get_totalCards();
	}
	,Template: function() {
		return "\r\n\t\t\t<div class=\"cardview\">\r\n\t\t\t\t<h3>Swipe {{ tickStr }} {{ penaltiedStr }} &nbsp; {{ curCardIndex+1}} / {{ totalCards}}</h3>\r\n\t\t\t\t\r\n\t\t\t\t<div class=\"card\" v-if=\"currentCard\">\r\n\t\t\t\t\t{{ cardCopy }} \r\n\t\t\t\t\t<br/>\r\n\t\t\t\t\t\r\n\t\t\t\t</div>\r\n\t\t\t\t<button v-on:click=\"swipe(false)\">Left</button>\r\n\t\t\t\t<button v-on:click=\"swipe(true)\">Right</button>\r\n\t\t\t</div>\r\n\t\t";
	}
	,_Init: function() {
		var cls = cstrain_vuex_components_CardView;
		var clsP = cls.prototype;
		this.data = clsP.Data;
		this.template = this.Template();
		this.computed = { cardCopy : clsP.get_cardCopy, delayTimeInSec : clsP.get_delayTimeInSec, tickStr : clsP.get_tickStr, penaltiedStr : clsP.get_penaltiedStr, curCardIndex : clsP.get_curCardIndex, totalCards : clsP.get_totalCards};
		this.methods = { tickDown : clsP.tickDown, get_cardCopy : clsP.get_cardCopy, get_delayTimeInSec : clsP.get_delayTimeInSec, watch_delayTimeInSec : clsP.watch_delayTimeInSec, swipe : clsP.swipe, get_tickStr : clsP.get_tickStr, get_penaltiedStr : clsP.get_penaltiedStr, get_curCardIndex : clsP.get_curCardIndex, get_totalCards : clsP.get_totalCards};
		this.props = { currentCard : { type : Object}};
		this.watch = { delayTimeInSec : clsP.watch_delayTimeInSec};
	}
});
var cstrain_vuex_components_GameView = function() {
	haxevx_vuex_core_VxComponent.call(this);
};
cstrain_vuex_components_GameView.__name__ = true;
cstrain_vuex_components_GameView.__super__ = haxevx_vuex_core_VxComponent;
cstrain_vuex_components_GameView.prototype = $extend(haxevx_vuex_core_VxComponent.prototype,{
	Components: function() {
		var _m_ = { };
		_m_["" + "CardView"] = new cstrain_vuex_components_CardView();
		return _m_;
	}
	,Created: function() {
		this.$store.commit("cstrain_vuex_game_GameMutator|resume");
	}
	,toggleExpression: function() {
		this.$store.commit("cstrain_vuex_game_GameMutator|showOrHideExpression");
	}
	,Template: function() {
		return "\r\n\t\t\t<div class=\"gameview\">\r\n\t\t\t\tThe Constant Train :: Polynomial Express\r\n\t\t\t\t<hr/>\r\n\t\t\t\t<p>Swipe right to infer result as constant to stop the train!<br/>Swipe left to infer result as variable to move along!</b>\r\n\t\t\t\t<" + "CardView" + " :currentCard=\"currentCard\"></" + "CardView" + ">\r\n\t\t\t\t<div class=\"traceResult\" v-if=\"cardResult\">\r\n\t\t\t\t\t<p>{{ cardResult }}</p>\r\n\t\t\t\t</div>\r\n\t\t\t\t<div class=\"xpression\" style=\"font-style:italic\" v-html=\"polyexpression\"></div>\r\n\t\t\t\t<br/>\r\n\t\t\t\t<button class=\"cheat\" v-on:click=\"toggleExpression()\">{{ toggleExprLabel }} expression</button>\r\n\t\t\t</div>\r\n\t\t";
	}
	,get_currentCard: function() {
		return this.$store.state.game.topCard;
	}
	,get_cardResult: function() {
		return this.$store.state.game.cardResult;
	}
	,get_toggleExprLabel: function() {
		if(this.$store.state.game.showExpression) return "Hide"; else return "Show";
	}
	,get_polyexpression: function() {
		return this.$store.game.gameGetters.get_polynomialExpr();
	}
	,_Init: function() {
		var cls = cstrain_vuex_components_GameView;
		var clsP = cls.prototype;
		this.components = this.Components();
		this.created = clsP.Created;
		this.template = this.Template();
		this.computed = { currentCard : clsP.get_currentCard, cardResult : clsP.get_cardResult, polyexpression : clsP.get_polyexpression, toggleExprLabel : clsP.get_toggleExprLabel};
		this.methods = { toggleExpression : clsP.toggleExpression, get_currentCard : clsP.get_currentCard, get_cardResult : clsP.get_cardResult, get_toggleExprLabel : clsP.get_toggleExprLabel, get_polyexpression : clsP.get_polyexpression};
	}
});
var cstrain_vuex_game_GameActions = function() {
	null;
};
cstrain_vuex_game_GameActions.__name__ = true;
cstrain_vuex_game_GameActions.prototype = {
	swipe: function(context,isRight) {
		context.commit("cstrain_vuex_game_GameMutator|notifySwipe",isRight?2:1);
		var result = context.state._rules.playCard(isRight);
		switch(result[1]) {
		case 2:
			var wildGuessing = result[3];
			var guessCard = result[2];
			context.commit("cstrain_vuex_game_GameMutator|resume");
			break;
		case 1:
			var penalty = result[2];
			context.commit("cstrain_vuex_game_GameMutator|setPenalty",penalty);
			if(penalty.delayNow != null) {
				var calcTime = penalty.delayNow * context.state.settings.penaltyDelayMs;
				context.commit("cstrain_vuex_game_GameMutator|setDelay",calcTime);
				if(penalty.delayNow > 0) haxe_Timer.delay(function() {
					context.commit("cstrain_vuex_game_GameMutator|setDelay",0);
					context.commit("cstrain_vuex_game_GameMutator|resume");
				},calcTime | 0); else context.commit("cstrain_vuex_game_GameMutator|resume");
			}
			{
				var _g = penalty.desc;
				switch(_g[1]) {
				case 4:
					context.commit("cstrain_vuex_game_GameMutator|setPenaltySwipeCorrect",true);
					break;
				default:
					context.commit("cstrain_vuex_game_GameMutator|setPenaltySwipeCorrect",false);
				}
			}
			break;
		case 0:
			context.commit("cstrain_vuex_game_GameMutator|setPenalty",null);
			context.commit("cstrain_vuex_game_GameMutator|updateProgress");
			context.commit("cstrain_vuex_game_GameMutator|resume");
			break;
		case 4:
			var penaltyTime = result[3];
			var timeLeft = result[2];
			console.log("Not yet available to swipe!:" + Std.string([timeLeft,penaltyTime]));
			break;
		case 5:
			context.commit("cstrain_vuex_game_GameMutator|traceCardResult",result);
			break;
		default:
			console.log("Uncaught case: " + Std.string(result));
		}
	}
	,_SetInto: function(d,ns) {
		var cls = cstrain_vuex_game_GameActions;
		var clsP = cls.prototype;
		d[ns + "cstrain_vuex_game_GameActions|swipe"] = clsP.swipe;
	}
};
var cstrain_vuex_game_GameGetters = function() {
};
cstrain_vuex_game_GameGetters.__name__ = true;
cstrain_vuex_game_GameGetters.Get_polynomialExpr = function(state) {
	if(state.showExpression) {
		if(state.polynomial != null) return cstrain_core_Polynomial.PrintOut(state.polynomial,"n",true); else return "..";
	} else return "";
};
cstrain_vuex_game_GameGetters.Get_simpleChosenNumber = function(state) {
	if(state.chosenSwipe == 2) return state.topCard.virtualRight.value; else return state.topCard.value;
};
cstrain_vuex_game_GameGetters.Get_notChosenNumber = function(state) {
	if(state.chosenSwipe == 2) return state.topCard.value; else return state.topCard.virtualRight.value;
};
cstrain_vuex_game_GameGetters.Get_isPenalized = function(state) {
	return state.curPenalty != null;
};
cstrain_vuex_game_GameGetters.Get_swipedCorrectly = function(state) {
	if(state.curPenalty != null) return state.penaltySwipeCorrect; else return true;
};
cstrain_vuex_game_GameGetters.Get_totalCards = function(state) {
	if(state.cards != null) return state.cards.length; else return 0;
};
cstrain_vuex_game_GameGetters.Get_curCardIndex = function(state) {
	return state.curCardIndex;
};
cstrain_vuex_game_GameGetters.Get_simplePenaltyPhrase = function(state) {
	var penalty = state.curPenalty;
	if(penalty == null) return "Unknown reason delay!";
	{
		var _g = penalty.desc;
		switch(_g[1]) {
		case 1:
			return "You missed a stop!";
		case 0:
			return "Lost in transit...";
		case 2:
			return "Oops, Guessed constant wrongly. The answer is: " + (state.chosenSwipe == 2?state.topCard.value:state.topCard.virtualRight.value);
		case 4:
			var answerHigher = _g[2];
			return "You guessed " + (state.chosenSwipe == 2?state.topCard.virtualRight.value:state.topCard.value) + ", which is a closer answer. Guess " + (answerHigher?"higher":"lower") + "!";
		case 3:
			var answerHigher1 = _g[2];
			return "You guessed " + (state.chosenSwipe == 2?state.topCard.virtualRight.value:state.topCard.value) + ", which is a further answer. Guess " + (answerHigher1?"higher":"lower") + "!";
		}
	}
	return "Unknown penalty reason delay!";
};
cstrain_vuex_game_GameGetters.prototype = {
	get_polynomialExpr: function() {
		return this._stg[this._ + "polynomialExpr_cstrain_vuex_game_GameGetters"];
	}
	,get_simpleChosenNumber: function() {
		return this._stg[this._ + "simpleChosenNumber_cstrain_vuex_game_GameGetters"];
	}
	,get_notChosenNumber: function() {
		return this._stg[this._ + "notChosenNumber_cstrain_vuex_game_GameGetters"];
	}
	,get_isPenalized: function() {
		return this._stg[this._ + "isPenalized_cstrain_vuex_game_GameGetters"];
	}
	,get_swipedCorrectly: function() {
		return this._stg[this._ + "swipedCorrectly_cstrain_vuex_game_GameGetters"];
	}
	,get_totalCards: function() {
		return this._stg[this._ + "totalCards_cstrain_vuex_game_GameGetters"];
	}
	,get_curCardIndex: function() {
		return this._stg[this._ + "curCardIndex_cstrain_vuex_game_GameGetters"];
	}
	,get_simplePenaltyPhrase: function() {
		return this._stg[this._ + "simplePenaltyPhrase_cstrain_vuex_game_GameGetters"];
	}
	,_SetInto: function(d,ns) {
		this._ = ns;
		haxevx_vuex_core_ModuleStack.stack.push(this);
		var cls = cstrain_vuex_game_GameGetters;
		d[ns + "polynomialExpr_cstrain_vuex_game_GameGetters"] = cls.Get_polynomialExpr;
		d[ns + "simpleChosenNumber_cstrain_vuex_game_GameGetters"] = cls.Get_simpleChosenNumber;
		d[ns + "notChosenNumber_cstrain_vuex_game_GameGetters"] = cls.Get_notChosenNumber;
		d[ns + "isPenalized_cstrain_vuex_game_GameGetters"] = cls.Get_isPenalized;
		d[ns + "swipedCorrectly_cstrain_vuex_game_GameGetters"] = cls.Get_swipedCorrectly;
		d[ns + "totalCards_cstrain_vuex_game_GameGetters"] = cls.Get_totalCards;
		d[ns + "curCardIndex_cstrain_vuex_game_GameGetters"] = cls.Get_curCardIndex;
		d[ns + "simplePenaltyPhrase_cstrain_vuex_game_GameGetters"] = cls.Get_simplePenaltyPhrase;
	}
	,_InjNative: function(g) {
		this._stg = g;
	}
};
var haxevx_vuex_core_IModule = function() { };
haxevx_vuex_core_IModule.__name__ = true;
var haxevx_vuex_core_VModule = function() { };
haxevx_vuex_core_VModule.__name__ = true;
haxevx_vuex_core_VModule.__interfaces__ = [haxevx_vuex_core_IModule];
haxevx_vuex_core_VModule.prototype = {
	_InjNative: function(g) {
		this._stg = g;
	}
};
var cstrain_vuex_game_GameModule = function(rules) {
	this.rules = rules;
	this.state = new cstrain_vuex_game_GameState(rules);
};
cstrain_vuex_game_GameModule.__name__ = true;
cstrain_vuex_game_GameModule.__super__ = haxevx_vuex_core_VModule;
cstrain_vuex_game_GameModule.prototype = $extend(haxevx_vuex_core_VModule.prototype,{
	_InjNative: function(g) {
		haxevx_vuex_core_VModule.prototype._InjNative.call(this,g);
		this.state._rules = this.rules;
	}
	,_Init: function(ns) {
		this._ = ns;
		haxevx_vuex_core_ModuleStack.stack.push(this);
		if(this.state != null) this.state._ = ns; else this.state = { _ : ns};
		var useNS = ns;
		var cls = cstrain_vuex_game_GameModule;
		var clsP = cls.prototype;
		var key;
		var d;
		d = { };
		this.getters = d;
		this.gameGetters = new cstrain_vuex_game_GameGetters();
		this.gameGetters._SetInto(d,useNS);
		d = { };
		this.mutations = d;
		new cstrain_vuex_game_GameMutator()._SetInto(d,"");
		d = { };
		this.actions = d;
		new cstrain_vuex_game_GameActions()._SetInto(d,"");
	}
});
var cstrain_vuex_game_GameMutator = function() {
	null;
};
cstrain_vuex_game_GameMutator.__name__ = true;
cstrain_vuex_game_GameMutator.Restart = function(g) {
	g._rules.restart();
	g.cards = g._rules.getAllCards();
};
cstrain_vuex_game_GameMutator.prototype = {
	restart: function(g) {
		cstrain_vuex_game_GameMutator.Restart(g);
	}
	,notifySwipe: function(state,swipeState) {
		state.chosenSwipe = swipeState;
	}
	,updateProgress: function(state) {
		state.curCardIndex = state._rules.getDeckIndex();
	}
	,setPenalty: function(state,penalty) {
		state.curPenalty = penalty;
	}
	,setPenaltySwipeCorrect: function(state,correct) {
		state.penaltySwipeCorrect = correct;
	}
	,setDelay: function(state,delay) {
		state.delayTimeLeft = delay;
	}
	,traceCardResult: function(state,result) {
		state.cardResult = result;
	}
	,resume: function(state) {
		state.penaltySwipeCorrect = true;
		state.delayTimeLeft = 0;
		state.topCard = state._rules.getTopmostCard();
		state.polynomial = cstrain_core_Polynomial.Copy(state._rules.getPolynomial());
	}
	,updateExpression: function(state) {
		state.polynomial = cstrain_core_Polynomial.Copy(state._rules.getPolynomial());
	}
	,showOrHideExpression: function(state,showExpression) {
		if(showExpression == null) showExpression = !state.showExpression;
		state.showExpression = showExpression;
	}
	,_SetInto: function(d,ns) {
		var cls = cstrain_vuex_game_GameMutator;
		var clsP = cls.prototype;
		d[ns + "cstrain_vuex_game_GameMutator|restart"] = clsP.restart;
		d[ns + "cstrain_vuex_game_GameMutator|notifySwipe"] = clsP.notifySwipe;
		d[ns + "cstrain_vuex_game_GameMutator|updateProgress"] = clsP.updateProgress;
		d[ns + "cstrain_vuex_game_GameMutator|setPenalty"] = clsP.setPenalty;
		d[ns + "cstrain_vuex_game_GameMutator|setPenaltySwipeCorrect"] = clsP.setPenaltySwipeCorrect;
		d[ns + "cstrain_vuex_game_GameMutator|setDelay"] = clsP.setDelay;
		d[ns + "cstrain_vuex_game_GameMutator|traceCardResult"] = clsP.traceCardResult;
		d[ns + "cstrain_vuex_game_GameMutator|resume"] = clsP.resume;
		d[ns + "cstrain_vuex_game_GameMutator|updateExpression"] = clsP.updateExpression;
		d[ns + "cstrain_vuex_game_GameMutator|showOrHideExpression"] = clsP.showOrHideExpression;
	}
};
var cstrain_vuex_game_GameState = function(rules) {
	this.chosenSwipe = 0;
	this.penaltySwipeCorrect = true;
	this.curPenalty = null;
	this.delayTimeLeft = 0;
	this.showExpression = false;
	this.polynomial = null;
	this.cardResult = null;
	this.topCard = null;
	this.curCardIndex = 0;
	this.cards = rules.getAllCards();
	this.settings = rules.getGameSettings();
	this.playerStats = rules.getPlayerStats();
};
cstrain_vuex_game_GameState.__name__ = true;
var haxevx_vuex_core_IVxContext = function() { };
haxevx_vuex_core_IVxContext.__name__ = true;
var haxevx_vuex_core_IVxContext1 = function() { };
haxevx_vuex_core_IVxContext1.__name__ = true;
var haxevx_vuex_core_VxStore = function() {
};
haxevx_vuex_core_VxStore.__name__ = true;
haxevx_vuex_core_VxStore.prototype = {
	dispatch: function(type,payload,opts) {
		return null;
	}
	,commit: function(type,payload,opts) {
	}
};
var cstrain_vuex_store_GameStore = function(rules) {
	haxevx_vuex_core_VxStore.call(this);
	this.state = new cstrain_vuex_store_GameStoreState();
	this.game = new cstrain_vuex_game_GameModule(rules);
	this._Init("");
};
cstrain_vuex_store_GameStore.__name__ = true;
cstrain_vuex_store_GameStore.__super__ = haxevx_vuex_core_VxStore;
cstrain_vuex_store_GameStore.prototype = $extend(haxevx_vuex_core_VxStore.prototype,{
	_Init: function(ns) {
		this._ = ns;
		haxevx_vuex_core_ModuleStack.stack.push(this);
		if(this.state != null) this.state._ = ns; else this.state = { _ : ns};
		var useNS = ns;
		var cls = cstrain_vuex_store_GameStore;
		var clsP = cls.prototype;
		var key;
		var d;
		d = { };
		this.modules = d;
		if(this.game != null) {
			d.game = this.game;
			this.game._Init(ns + "game/");
		}
	}
	,_InjNative: function(g) {
		this._stg = g;
	}
});
var cstrain_vuex_store_GameStoreState = function() {
};
cstrain_vuex_store_GameStoreState.__name__ = true;
var haxe_Timer = function(time_ms) {
	var me = this;
	this.id = setInterval(function() {
		me.run();
	},time_ms);
};
haxe_Timer.__name__ = true;
haxe_Timer.delay = function(f,time_ms) {
	var t = new haxe_Timer(time_ms);
	t.run = function() {
		t.stop();
		f();
	};
	return t;
};
haxe_Timer.prototype = {
	stop: function() {
		if(this.id == null) return;
		clearInterval(this.id);
		this.id = null;
	}
	,run: function() {
	}
};
var haxevx_vuex_core_NoneT = function() { };
haxevx_vuex_core_NoneT.__name__ = true;
var haxevx_vuex_core_VxBoot = function() {
};
haxevx_vuex_core_VxBoot.__name__ = true;
haxevx_vuex_core_VxBoot.notifyStarted = function() {
};
haxevx_vuex_core_VxBoot.getRenderComponentMethod = function(nativeComp) {
	return function(h) {
		return h(nativeComp,null,null);
	};
};
haxevx_vuex_core_VxBoot.prototype = {
	startStore: function(storeParams) {
		if(this.STORE != null) throw new js__$Boot_HaxeError("Vuex store already started! Only 1 store is allowed");
		var metaFields;
		var md;
		var noNamespaceGetterProps;
		var store = new Vuex.Store(storeParams);
		var o;
		var storeGetters = store.getters;
		var stack = haxevx_vuex_core_ModuleStack.stack;
		var i = stack.length;
		while(--i > -1) stack[i]._InjNative(storeGetters);
		stack = [];
		if(storeParams.modules != null) {
			var _g = 0;
			var _g1 = Reflect.fields(o = storeParams.modules);
			while(_g < _g1.length) {
				var p = _g1[_g];
				++_g;
				var m = Reflect.field(o,p);
				md = storeParams[p];
				store[p] = md;
			}
		}
		this.STORE = store;
		return store;
	}
	,startVueWithRootComponent: function(el,rootComponent) {
		var bootVueParams = { };
		bootVueParams.el = el;
		if(this.STORE != null) bootVueParams.store = this.STORE;
		bootVueParams.render = haxevx_vuex_core_VxBoot.getRenderComponentMethod(rootComponent);
		var vm = new Vue(bootVueParams);
		haxevx_vuex_core_VxBoot.notifyStarted();
		return vm;
	}
};
var haxevx_vuex_core_ModuleStack = function() { };
haxevx_vuex_core_ModuleStack.__name__ = true;
var js__$Boot_HaxeError = function(val) {
	Error.call(this);
	this.val = val;
	this.message = String(val);
	if(Error.captureStackTrace) Error.captureStackTrace(this,js__$Boot_HaxeError);
};
js__$Boot_HaxeError.__name__ = true;
js__$Boot_HaxeError.__super__ = Error;
js__$Boot_HaxeError.prototype = $extend(Error.prototype,{
});
var js_Boot = function() { };
js_Boot.__name__ = true;
js_Boot.__string_rec = function(o,s) {
	if(o == null) return "null";
	if(s.length >= 5) return "<...>";
	var t = typeof(o);
	if(t == "function" && (o.__name__ || o.__ename__)) t = "object";
	switch(t) {
	case "object":
		if(o instanceof Array) {
			if(o.__enum__) {
				if(o.length == 2) return o[0];
				var str2 = o[0] + "(";
				s += "\t";
				var _g1 = 2;
				var _g = o.length;
				while(_g1 < _g) {
					var i1 = _g1++;
					if(i1 != 2) str2 += "," + js_Boot.__string_rec(o[i1],s); else str2 += js_Boot.__string_rec(o[i1],s);
				}
				return str2 + ")";
			}
			var l = o.length;
			var i;
			var str1 = "[";
			s += "\t";
			var _g2 = 0;
			while(_g2 < l) {
				var i2 = _g2++;
				str1 += (i2 > 0?",":"") + js_Boot.__string_rec(o[i2],s);
			}
			str1 += "]";
			return str1;
		}
		var tostr;
		try {
			tostr = o.toString;
		} catch( e ) {
			if (e instanceof js__$Boot_HaxeError) e = e.val;
			return "???";
		}
		if(tostr != null && tostr != Object.toString && typeof(tostr) == "function") {
			var s2 = o.toString();
			if(s2 != "[object Object]") return s2;
		}
		var k = null;
		var str = "{\n";
		s += "\t";
		var hasp = o.hasOwnProperty != null;
		for( var k in o ) {
		if(hasp && !o.hasOwnProperty(k)) {
			continue;
		}
		if(k == "prototype" || k == "__class__" || k == "__super__" || k == "__interfaces__" || k == "__properties__") {
			continue;
		}
		if(str.length != 2) str += ", \n";
		str += s + k + " : " + js_Boot.__string_rec(o[k],s);
		}
		s = s.substring(1);
		str += "\n" + s + "}";
		return str;
	case "function":
		return "<function>";
	case "string":
		return o;
	default:
		return String(o);
	}
};
var $_, $fid = 0;
function $bind(o,m) { if( m == null ) return null; if( m.__id__ == null ) m.__id__ = $fid++; var f; if( o.hx__closures__ == null ) o.hx__closures__ = {}; else f = o.hx__closures__[m.__id__]; if( f == null ) { f = function(){ return f.method.apply(f.scope, arguments); }; f.scope = o; f.method = m; o.hx__closures__[m.__id__] = f; } return f; }
String.__name__ = true;
Array.__name__ = true;
Date.__name__ = ["Date"];
cstrain_vuex_components_GameView.Comp_CardView = "CardView";
haxevx_vuex_core_ModuleStack.stack = [];
Main.main();
})(typeof console != "undefined" ? console : {log:function(){}});
