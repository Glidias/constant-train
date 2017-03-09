# constant-train

HaxeVx+Vuex example train racing game prototype.

Leverages the following technologies under Haxe:
	
Cross-platform codebase:

- Plain Haxe platform/framework-agnostic codes (Model/server) `cstrain.core`,  `cstrain.rules`,  `cstrain.util` 
- Heaps (for background scenery View)  `cstrain.h2d` https://github.com/HeapsIO/heaps

For HTML5-specific target (A view implementation for browser/webapps):
	
- HaxeVx + Vuex `cstrain.vuex`  https://github.com/Glidias/haxevx
- Swing JS for card swiping feature `gajus.swing`  (<- NOTE: The externs in tihs package aren't complete/updated.) https://github.com/gajus/swing 

To start viewing on browser as a developer, configure `npm start` command at `bin/package.json` location to point to the relavant host/port. A host of `localhost"` would suffice if you need to view it offline. 

	"start": "webpack-dev-server --port 8080 --host 192.168.1.19 --entry ./ConstantTrain.js"

or

	"start": "webpack-dev-server --port 8080 --host 192.168.1.19 --entry ./ConstantTrain.js"`
	
	
## How to play?

You are presented with a main deck of operation cards which you must empty out one by one (as fast as possible) after each swipe, starting with card 'n', where 'n' represents an unknown number. Each card will have a mathematical operation (add/divide/minus/multiply), by a given plain number constant expression, an unknown `n` number, or polynomial expression with a combination of powered `n` values. Anytime you swipe left/right, the mathematical operation presented on the card will applied to the expression, resulting in some kind of result. You are supposed to track the result (often roughly) in your head because....

...whenever the expression will result in a constant due to the unknown `n` number being canceled away by a card showing a particular operation, you should swipe the card RIGHT in order to anticipate a "stop" at the next location (which is also known as 'a Constant "station"'), and will be given a chance to guess the value of the constant with 2 left/right choices and minimal penalty if you accidentally chose the wrong value. If the expression still has an unknown `n` variable inside it, then you should continue swiping LEFT to move the train along continually. If you missed a stop (ie. didn't swipe right when you should), you will incur a penalty delay and be  be forced to play a higher/lower guessing game at the given station stop to guess the constant before you can set off again. After stopping at a given station and setting off again, a value of `n` is always added to the existing constant expression.  

If you SWIPE right but the value of the expression doesn't result in a constant  value, then you will incur some penalty delay as well before you can start swiping again.

The objective is to challenge your friend with the same main deck of platform cards, and see who finishes the race first with the background scene train moving forward to it's end destination. Some memory, speed,  guessing work and calculated-risk taking is done to minimise missing stops and also determine when it's deemed "safe" to speed ahead (ie. keep swiping left) if you know the  polynomial expression is bound to be complex and unlikely to be reduced down to a constant.

Mathmatical operators are:
	
- `*` Multiply
- `/` Divide
- `+` Plus
- `-` Minus
- `\` Divide but get quotient only (ie. ignore remainder)
- `dy/dx()` Get deriative 
