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
	this.varValues = null;
	this.operator = op;
	this.value = value;
	this.isVar = isVar;
	this.virtualRight = virtualRight;
};
cstrain_core_Card.__name__ = true;
cstrain_core_Card.isIncreasingMagnitude = function(op) {
	return op <= 3 && (op & 1) == 0;
};
cstrain_core_Card.canOperate = function(op) {
	return op <= 3;
};
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
cstrain_core_Card.getRegularVarCard = function(operator) {
	return new cstrain_core_Card(operator,1,true);
};
cstrain_core_Card.getRegularGuessConstantCard = function(value,value2) {
	return new cstrain_core_Card(4,value,false,new cstrain_core_Card(4,value2,false));
};
cstrain_core_Card.getRegularStartingVarCard = function() {
	return new cstrain_core_Card(0,1,true);
};
var cstrain_core_CardResult = { __ename__ : true, __constructs__ : ["OK","PENALIZE","GUESS_CONSTANT","NOTHING","GAMEOVER_OUTTA_CARDS"] };
cstrain_core_CardResult.OK = ["OK",0];
cstrain_core_CardResult.OK.toString = $estr;
cstrain_core_CardResult.OK.__enum__ = cstrain_core_CardResult;
cstrain_core_CardResult.PENALIZE = function(penalty) { var $x = ["PENALIZE",1,penalty]; $x.__enum__ = cstrain_core_CardResult; $x.toString = $estr; return $x; };
cstrain_core_CardResult.GUESS_CONSTANT = function(card,wildGuess) { var $x = ["GUESS_CONSTANT",2,card,wildGuess]; $x.__enum__ = cstrain_core_CardResult; $x.toString = $estr; return $x; };
cstrain_core_CardResult.NOTHING = ["NOTHING",3];
cstrain_core_CardResult.NOTHING.toString = $estr;
cstrain_core_CardResult.NOTHING.__enum__ = cstrain_core_CardResult;
cstrain_core_CardResult.GAMEOVER_OUTTA_CARDS = ["GAMEOVER_OUTTA_CARDS",4];
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
	,aimRandomCard: function() {
		return this.cards[Std["int"](Math.random() * this.cards.length)];
	}
	,popCard: function() {
		return this.cards.pop();
	}
	,addCard: function(card) {
		this.cards.push(card);
	}
	,addCardUnderneath: function(card) {
		this.cards.unshift(card);
		return;
	}
	,addCards: function(cards,placeOnTop) {
		if(placeOnTop == null) placeOnTop = true;
		if(placeOnTop) this.cards = this.cards.concat(cards); else this.cards = cards.concat(this.cards);
	}
};
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
var cstrain_core_Polynomial = function() {
	this.coefs = [0];
};
cstrain_core_Polynomial.__name__ = true;
cstrain_core_Polynomial.fromCoefs = function(arr) {
	var d = new cstrain_core_Polynomial();
	d.coefs = arr;
	return d;
};
cstrain_core_Polynomial.gcd = function(x,y) {
	var z = 1;
	x = Math.abs(x | 0);
	y = Math.abs(y | 0);
	while(z != 0) {
		z = x % y | 0;
		x = y;
		y = z;
	}
	return x;
};
cstrain_core_Polynomial.gcd_mult = function(ref) {
	var d = ref[ref.length - 1];
	var i = ref.length - 1;
	while(--i > -1) if((ref[i] | 0) != 0) d = cstrain_core_Polynomial.gcd(d,ref[i]);
	return d;
};
cstrain_core_Polynomial.isWholeNum = function(num) {
	return num % 1 == 0;
};
cstrain_core_Polynomial.divisible = function(a,d) {
	return a % d == 0;
};
cstrain_core_Polynomial.evaluateDivisionRemAsFloat = function(quotRem,varValue) {
	return quotRem[0].evalValueFloat(varValue) + quotRem[1].evalValueFloat(varValue) / varValue;
};
cstrain_core_Polynomial.evaluateDivisionsAsFloat = function(basePoly,remPoly,varValue) {
	return basePoly.evalValueFloat(varValue) + remPoly.evalValueFloat(varValue) / varValue;
};
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
cstrain_core_Polynomial.precision = function(co) {
	return cstrain_core_Polynomial.floatToStringPrecision(co,2);
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
	isRootFor: function(x) {
		return this.coefs.length > 1 && this.evalValueFloat(x) == 0;
	}
	,findRoot: function() {
		if(this.isRootFor(0)) return 0;
		if(!(this.coefs[0] % 1 == 0) || !(this.coefs[this.coefs.length - 1] % 1 == 0)) return null;
		var last = Std["int"](Math.abs(this.coefs[0]));
		var first = Std["int"](Math.abs(this.coefs[this.coefs.length - 1]));
		var _g1 = 1;
		var _g = last + 1;
		while(_g1 < _g) {
			var l = _g1++;
			if(last % l != 0) continue;
			var _g3 = 1;
			var _g2 = first + 1;
			while(_g3 < _g2) {
				var f = _g3++;
				if(first % f != 0) continue;
				var r = l / f;
				if(this.isRootFor(r)) return r;
				if(this.isRootFor(-r)) return -r;
			}
		}
		return null;
	}
	,reduceByRoot: function(r) {
		var new_p = [];
		var carry = .0;
		var down = 9999;
		var gotDown = false;
		var i = this.coefs.length;
		while(--i > -1) {
			var coef = this.coefs[i];
			down = coef + carry;
			gotDown = true;
			carry = down * r;
			new_p.unshift(down);
		}
		if(gotDown && down == 0) {
			new_p.shift();
			this.coefs = new_p;
			return true;
		} else return false;
	}
	,isWhole: function() {
		var _g1 = 0;
		var _g = this.coefs.length;
		while(_g1 < _g) {
			var i = _g1++;
			if(!(this.coefs[i] % 1 == 0)) return false;
		}
		return true;
	}
	,findCommonFactor: function() {
		if(this.isWhole() && this.coefs.length > 1) return cstrain_core_Polynomial.gcd_mult(this.coefs); else return 1;
	}
	,factorisation: function() {
		var factors = [];
		var root = this.findRoot();
		if(root != null) {
			factors.push(cstrain_core_Polynomial.fromCoefs([-root,1]));
			var p = cstrain_core_Polynomial.Copy(this);
			p.reduceByRoot(root);
			this.addToArray(factors,p.factorisation());
		} else {
			var p1 = cstrain_core_Polynomial.Copy(this);
			var cf = p1.findCommonFactor();
			if(cf != 1) {
				var _g1 = 0;
				var _g = this.coefs.length;
				while(_g1 < _g) {
					var i = _g1++;
					this.coefs[i] /= cf;
				}
				factors.push(cstrain_core_Polynomial.fromCoefs([cf]));
			}
			factors.push(p1);
		}
		return factors;
	}
	,toString: function() {
		return "[Polynomial: " + cstrain_core_Polynomial.PrintOut(this,"x",false) + "]";
	}
	,addToArray: function(a,ref) {
		var _g1 = 0;
		var _g = ref.length;
		while(_g1 < _g) {
			var i = _g1++;
			a.push(ref[i]);
		}
	}
	,differentiate: function() {
		var deriv = new cstrain_core_Polynomial();
		if(this.coefs.length - 1 == 0) return deriv;
		var _g1 = 0;
		var _g = this.coefs.length - 1;
		while(_g1 < _g) {
			var i = _g1++;
			deriv.coefs[i] = this.coefs[i + 1] * (i + 1);
		}
		return deriv;
	}
	,deg: function() {
		return this.coefs.length - 1;
	}
	,getCoef: function(i) {
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
	,rem: function(b) {
		return this.divisionWithRemainder(b)[1];
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
	,clone: function() {
		return cstrain_core_Polynomial.Copy(this);
	}
	,get_isUnknown: function() {
		return this.coefs.length > 1;
	}
	,get_constantInteger: function() {
		return this.coefs[0] | 0;
	}
	,get_constantValue: function() {
		return this.coefs[0];
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
	,evalValueFloat: function(varValue) {
		var sum = 0;
		var _g1 = 0;
		var _g = this.coefs.length;
		while(_g1 < _g) {
			var i = _g1++;
			sum += this.coefs[i] * Math.pow(varValue,i);
		}
		return sum;
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
	this.polynomialValueCached = false;
	this.restart();
};
cstrain_rules_TestGame.__name__ = true;
cstrain_rules_TestGame.__interfaces__ = [cstrain_core_IRules];
cstrain_rules_TestGame.prototype = {
	recreateSecret: function() {
		this.secretVarValue = Std["int"](Math.ceil(Math.random() * 10));
		this.polynomialValueCached = false;
	}
	,getSecretValue: function() {
		if(this.polynomialValueCached) return this.polynomialValue; else return this.polynomialValue = this.polynomial.evalValueInt(this.secretVarValue);
	}
	,buildDeck: function() {
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
		var magnitudeBase = Math.ceil(val / 20) * 40;
		var minBase = Std["int"](Math.ceil(magnitudeBase / 8));
		if(Math.random() >= .5) return Std["int"](val - minBase - Std["int"](magnitudeBase * Math.random())); else return Std["int"](val + minBase + Std["int"](magnitudeBase * Math.random()));
	}
	,getCloserValueTo: function(val,from) {
		var amt = val - from;
		if(val >= from) from += Std["int"](Math.ceil(Math.random() * amt)); else from += Std["int"](Math.floor(Math.random() * amt));
		return from;
	}
	,getFakeValueOfCloserValue: function(val) {
		var magnitudeBase = Math.ceil(val / 20) * 40;
		var minBase = Std["int"](Math.ceil(magnitudeBase / 2));
		if(Math.random() >= .5) return Std["int"](val - minBase - Std["int"](magnitudeBase * Math.random())); else return Std["int"](val + minBase + Std["int"](magnitudeBase * Math.random()));
	}
	,getCardResult: function(isSwipeRight) {
		var curCard;
		if(this.thePopupCard != null) curCard = this.thePopupCard; else if(this.curDeckIndex >= 0) curCard = this.curDeck.cards[this.curDeckIndex--]; else curCard = null;
		if(curCard == null) return cstrain_core_CardResult.GAMEOVER_OUTTA_CARDS;
		this.thePopupCard = null;
		if(curCard.operator <= 3) {
			this.polynomial.performOperation(cstrain_core_Card.toOperation(curCard));
			if(isSwipeRight) {
				if(!(this.polynomial.coefs.length > 1)) if(Math.random() >= .5) return cstrain_core_CardResult.GUESS_CONSTANT(cstrain_core_Card.getRegularGuessConstantCard(this.polynomial.coefs[0] | 0,this.getFakeValueOf(this.polynomial.coefs[0])),false); else return cstrain_core_CardResult.GUESS_CONSTANT(cstrain_core_Card.getRegularGuessConstantCard(this.getFakeValueOf(this.polynomial.coefs[0]),this.polynomial.coefs[0] | 0),false); else return cstrain_core_CardResult.PENALIZE({ desc : cstrain_core_PenaltyDesc.LOST_IN_TRANSIT, delayNow : 2});
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
	,getConstant: function() {
		return this.polynomial.coefs[0] | 0;
	}
	,getPolynomialValue: function(varValue) {
		return this.polynomial.evalValueInt(varValue);
	}
	,isConstant: function() {
		return !(this.polynomial.coefs.length > 1);
	}
	,restart: function() {
		this.deck = new cstrain_core_Deck();
		this.thePopupCard = null;
		this.polynomial = new cstrain_core_Polynomial();
		this.wildGuess = false;
		this.secretVarValue = Std["int"](Math.ceil(Math.random() * 10));
		this.polynomialValueCached = false;
		this.buildDeck();
	}
	,getAllCards: function() {
		return this.deck.cards;
	}
	,playCard: function(isSwipeRight) {
		var result = this.getCardResult(isSwipeRight);
		switch(result[1]) {
		case 2:
			var wildGuess = result[3];
			var guessConstantCard = result[2];
			this.wildGuess = wildGuess;
			var c = this.polynomial.coefs[0] | 0;
			this.thePopupCard = guessConstantCard;
			break;
		case 1:
			switch(result[2].desc[1]) {
			case 1:case 0:
				this.wildGuess = true;
				break;
			case 4:case 3:
				var v;
				if(this.wildGuess) {
					if(this.polynomialValueCached) v = this.polynomialValue; else v = this.polynomialValue = this.polynomial.evalValueInt(this.secretVarValue);
				} else v = this.polynomial.coefs[0] | 0;
				var to;
				if(this.polynomialValueCached) to = this.polynomialValue; else to = this.polynomialValue = this.polynomial.evalValueInt(this.secretVarValue);
				var firstChoice = this.getCloserValueTo(v,this._valueChosen);
				var secondChoice = this.getCloserValueTo(v,this._valueChosen);
				if(secondChoice == firstChoice) secondChoice = this.getFakeValueOfCloserValue(firstChoice);
				this.thePopupCard = new cstrain_core_Card(4,firstChoice,false,new cstrain_core_Card(4,secondChoice,false));
				break;
			default:
			}
			break;
		default:
		}
		return result;
	}
	,getTopCard: function() {
		if(this.curDeckIndex >= 0) return this.curDeck.cards[this.curDeckIndex]; else return null;
	}
	,getBelowCardCard: function() {
		if(this.curDeckIndex >= 1) return this.curDeck.cards[this.curDeckIndex - 1]; else return null;
	}
	,getTopmostCard: function() {
		if(this.thePopupCard != null) return this.thePopupCard; else if(this.curDeckIndex >= 0) return this.curDeck.cards[this.curDeckIndex]; else return null;
	}
	,getNextCardBelow: function() {
		if(this.thePopupCard != null) {
			if(this.curDeckIndex >= 0) return this.curDeck.cards[this.curDeckIndex]; else return null;
		} else if(this.curDeckIndex >= 1) return this.curDeck.cards[this.curDeckIndex - 1]; else return null;
	}
	,getPolynomial: function() {
		return this.polynomial;
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
	,get__props: function() {
		return this;
	}
	,get__vData: function() {
		return this.$data;
	}
	,PropsData: function() {
		return null;
	}
	,Data: function() {
		return null;
	}
	,Created: function() {
	}
	,BeforeCreate: function() {
	}
	,BeforeDestroy: function() {
	}
	,Destroy: function() {
	}
	,BeforeMount: function() {
	}
	,Mounted: function() {
	}
	,BeforeUpdate: function() {
	}
	,Updated: function() {
	}
	,Activated: function() {
	}
	,Deactivated: function() {
	}
	,El: function() {
		return null;
	}
	,Render: function(c) {
		return null;
	}
	,Template: function() {
		return null;
	}
	,Components: function() {
		return null;
	}
	,GetDefaultPropSettings: function() {
		return null;
	}
	,GetDefaultPropValues: function() {
		return null;
	}
});
var haxevx_vuex_core_VxComponent = function() {
	haxevx_vuex_core_VComponent.call(this);
};
haxevx_vuex_core_VxComponent.__name__ = true;
haxevx_vuex_core_VxComponent.__super__ = haxevx_vuex_core_VComponent;
haxevx_vuex_core_VxComponent.prototype = $extend(haxevx_vuex_core_VComponent.prototype,{
	get_store: function() {
		return this.$store;
	}
});
var cstrain_vuex_components_CardView = function() {
	haxevx_vuex_core_VxComponent.call(this);
};
cstrain_vuex_components_CardView.__name__ = true;
cstrain_vuex_components_CardView.__super__ = haxevx_vuex_core_VxComponent;
cstrain_vuex_components_CardView.prototype = $extend(haxevx_vuex_core_VxComponent.prototype,{
	swipe: function(isRight) {
		this.$store.dispatch("cstrain_vuex_game_GameActions|swipe",isRight);
	}
	,Template: function() {
		return "\r\n\t\t\t<div class=\"cardview\">\r\n\t\t\t\t<h3>Swipe</h3>\r\n\t\t\t\t<div class=\"card\" v-if=\"currentCard\">\r\n\t\t\t\t\t{{ cardCopy }} \r\n\t\t\t\t\t<br/>\r\n\t\t\t\t\t\r\n\t\t\t\t</div>\r\n\t\t\t\t<button v-on:click=\"swipe(false)\">Left</button>\r\n\t\t\t\t<button v-on:click=\"swipe(true)\">Right</button>\r\n\t\t\t</div>\r\n\t\t";
	}
	,get_cardCopy: function() {
		return cstrain_core_Card.stringifyOp(this.currentCard.operator) + (this.currentCard.isVar?"n":this.currentCard.value + "");
	}
	,_Init: function() {
		var cls = cstrain_vuex_components_CardView;
		var clsP = cls.prototype;
		this.template = this.Template();
		this.computed = { cardCopy : clsP.get_cardCopy};
		this.methods = { swipe : clsP.swipe, get_cardCopy : clsP.get_cardCopy};
		this.props = { currentCard : { type : Object}};
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
		return "\r\n\t\t\t<div class=\"gameview\">\r\n\t\t\t\tThe Constant Train :: Polynomial Express\r\n\t\t\t\t<hr/>\r\n\t\t\t\t<p>Swipe right to infer result as constant to stop the train!<br/>Swipe left to infer result as variable and to move along!</b>\r\n\t\t\t\t<" + "CardView" + " :currentCard=\"currentCard\"></" + "CardView" + ">\r\n\t\t\t\t<div class=\"traceResult\" v-if=\"cardResult\">\r\n\t\t\t\t\t<p>{{ cardResult }}</p>\r\n\t\t\t\t</div>\r\n\t\t\t\t<div class=\"xpression\" style=\"font-style:italic\" v-html=\"polyexpression\"></div>\r\n\t\t\t\t<br/>\r\n\t\t\t\t<button class=\"cheat\" v-on:click=\"toggleExpression()\">{{ toggleExprLabel }} expression</button>\r\n\t\t\t</div>\r\n\t\t";
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
var haxevx_vuex_core_IAction = function() { };
haxevx_vuex_core_IAction.__name__ = true;
var cstrain_vuex_game_GameActions = function() {
	null;
};
cstrain_vuex_game_GameActions.__name__ = true;
cstrain_vuex_game_GameActions.prototype = {
	swipe: function(context,isRight) {
		var result = context.state._rules.playCard(isRight);
		switch(result[1]) {
		case 2:
			var wildGuessing = result[3];
			var guessCard = result[2];
			context.commit("cstrain_vuex_game_GameMutator|setPopupCard");
			context.commit("cstrain_vuex_game_GameMutator|resume");
			break;
		case 1:
			var penalty = result[2];
			if(penalty.delayNow != null) context.commit("cstrain_vuex_game_GameMutator|setDelay",penalty.delayNow);
			context.commit("cstrain_vuex_game_GameMutator|resume");
			break;
		case 0:
			context.commit("cstrain_vuex_game_GameMutator|resume");
			break;
		default:
			console.log("Uncaught case: " + Std.string(result));
		}
		context.commit("cstrain_vuex_game_GameMutator|traceCardResult",result);
	}
	,_SetInto: function(d,ns) {
		var cls = cstrain_vuex_game_GameActions;
		var clsP = cls.prototype;
		d[ns + "cstrain_vuex_game_GameActions|swipe"] = clsP.swipe;
	}
};
var haxevx_vuex_core_IGetters = function() { };
haxevx_vuex_core_IGetters.__name__ = true;
var cstrain_vuex_game_GameGetters = function() {
};
cstrain_vuex_game_GameGetters.__name__ = true;
cstrain_vuex_game_GameGetters.Get_polynomialExpr = function(state) {
	if(state.showExpression) {
		if(state.polynomial != null) return cstrain_core_Polynomial.PrintOut(state.polynomial,"n",true); else return "..";
	} else return "";
};
cstrain_vuex_game_GameGetters.prototype = {
	get_polynomialExpr: function() {
		return this._stg[this._ + "polynomialExpr_cstrain_vuex_game_GameGetters"];
	}
	,_SetInto: function(d,ns) {
		this._ = ns;
		haxevx_vuex_core_ModuleStack.stack.push(this);
		var cls = cstrain_vuex_game_GameGetters;
		d[ns + "polynomialExpr_cstrain_vuex_game_GameGetters"] = cls.Get_polynomialExpr;
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
var haxevx_vuex_core_IMutator = function() { };
haxevx_vuex_core_IMutator.__name__ = true;
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
	,setPopupCard: function(state,isPopup) {
		if(isPopup == null) isPopup = true;
		state.isPopup = isPopup;
	}
	,setDelay: function(state,delay) {
		state.delayTimeLeft = delay;
	}
	,traceCardResult: function(state,result) {
		state.cardResult = result;
	}
	,resume: function(state) {
		state.topCard = state._rules.getTopmostCard();
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
		d[ns + "cstrain_vuex_game_GameMutator|setPopupCard"] = clsP.setPopupCard;
		d[ns + "cstrain_vuex_game_GameMutator|setDelay"] = clsP.setDelay;
		d[ns + "cstrain_vuex_game_GameMutator|traceCardResult"] = clsP.traceCardResult;
		d[ns + "cstrain_vuex_game_GameMutator|resume"] = clsP.resume;
		d[ns + "cstrain_vuex_game_GameMutator|showOrHideExpression"] = clsP.showOrHideExpression;
	}
};
var cstrain_vuex_game_GameState = function(rules) {
	this.showExpression = false;
	this.polynomial = null;
	this.cardResult = null;
	this.isPopup = false;
	this.delayTimeLeft = 0;
	this.topCard = null;
	this.cards = rules.getAllCards();
};
cstrain_vuex_game_GameState.__name__ = true;
var haxevx_vuex_core_IVxContext = function() { };
haxevx_vuex_core_IVxContext.__name__ = true;
var haxevx_vuex_core_IVxContext1 = function() { };
haxevx_vuex_core_IVxContext1.__name__ = true;
var haxevx_vuex_core_IVxStoreContext = function() { };
haxevx_vuex_core_IVxStoreContext.__name__ = true;
var haxevx_vuex_core_VxStore = function() {
	this.strict = false;
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
var haxevx_vuex_core_IPayload = function() { };
haxevx_vuex_core_IPayload.__name__ = true;
var haxevx_vuex_core_IVxContext2 = function() { };
haxevx_vuex_core_IVxContext2.__name__ = true;
var haxevx_vuex_core_IVxContext3 = function() { };
haxevx_vuex_core_IVxContext3.__name__ = true;
var haxevx_vuex_core_IVxContext4 = function() { };
haxevx_vuex_core_IVxContext4.__name__ = true;
var haxevx_vuex_core_NoneT = function() { };
haxevx_vuex_core_NoneT.__name__ = true;
haxevx_vuex_core_NoneT.prototype = {
	toString: function() {
		return "NoneT";
	}
};
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
var haxevx_vuex_native_ActionContext = function() { };
haxevx_vuex_native_ActionContext.__name__ = true;
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
String.__name__ = true;
Array.__name__ = true;
cstrain_core_Card.OPERATOR_ADD = 0;
cstrain_core_Card.OPERATOR_SUBTRACT = 1;
cstrain_core_Card.OPERATOR_MULTIPLY = 2;
cstrain_core_Card.OPERATOR_DIVIDE = 3;
cstrain_core_Card.OPERATION_EQUAL = 4;
cstrain_core_Deck.SET_NUMBERS = 1;
cstrain_core_Deck.SET_VARIABLE = 2;
cstrain_core_Deck.MASK_SET_ALL = 3;
cstrain_core_Deck.NUM_1 = 1;
cstrain_core_Deck.NUM_2 = 2;
cstrain_core_Deck.NUM_3 = 4;
cstrain_core_Deck.NUM_4 = 8;
cstrain_core_Deck.NUM_5 = 16;
cstrain_core_Deck.NUM_6 = 32;
cstrain_core_Deck.NUM_7 = 64;
cstrain_core_Deck.NUM_8 = 128;
cstrain_core_Deck.NUM_9 = 256;
cstrain_core_Deck.NUM_10 = 512;
cstrain_core_Deck.MASK_NUMBER_ALL = 1023;
cstrain_core_Deck.MASK_NUMBER_ALL_EXCEPT_1 = 1022;
cstrain_core_Deck.MASK_NUMBER_EVEN = 682;
cstrain_core_Deck.MASK_NUMBER_ODD = 341;
cstrain_core_Deck.OP_ADD = 1;
cstrain_core_Deck.OP_SUBTRACT = 2;
cstrain_core_Deck.OP_MULTIPLY = 4;
cstrain_core_Deck.OP_DIVIDE = 8;
cstrain_core_Deck.MASK_OPERATOR_ALL = 15;
cstrain_vuex_components_GameView.Comp_CardView = "CardView";
haxevx_vuex_core_ModuleStack.stack = [];
Main.main();
})(typeof console != "undefined" ? console : {log:function(){}});
