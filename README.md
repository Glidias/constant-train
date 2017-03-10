# constant-train

HaxeVx+Vuex example train racing game prototype.

Leverages the following technologies under Haxe:
	
Cross-platform codebase:

- Plain Haxe cross-platform/framework-agnostic codes (Model/server) `cstrain.core`,  `cstrain.rules`,  `cstrain.util` 
- Heaps (for background scenery View)  `cstrain.h2d` https://github.com/HeapsIO/heaps

For HTML5-specific target (A view implementation for browser/webapps):
	
- HaxeVx + Vuex (Vue2) `cstrain.vuex`  https://github.com/Glidias/haxevx
- Vue-touch (`next` branch) (for Vue2 compatibility) https://github.com/vuejs/vue-touch/tree/next
- Swing JS for card swiping feature `gajus.swing`  (<- NOTE: The externs in this package isn't complete/accruate.) https://github.com/gajus/swing 

To start viewing on browser as a developer, configure `npm start` command at `bin/package.json` location to point to the relavant host/port. A host of `localhost"` would suffice if you need to view it offline. 

	"start": "webpack-dev-server --port 8080 --host localhost --entry ./ConstantTrain.js"`
	
Start webpack server on the  command line at the `bin` location with: `npm start`. Remember to also compile the Haxe codebase  using any one of the `.hxml` build files/settings in the repo. Then, jump to your configured host url on your browser to view the example.
	
## How to play?

You are presented with a main deck of operation cards which you must empty out one by one (as fast as possible) after each swipe, starting with card 'n', where 'n' represents an unknown number. Each card will have a mathematical operation (eg. add/divide/minus/multiply), by a given plain number constant expression, an unknown `n` number, or polynomial expression with a combination of powered `n` values. Anytime you swipe left/right, the mathematical operation presented on the card will applied to the expression, resulting in some kind of result. You are supposed to track the result (often roughly) in your head because....

...whenever the expression will result in a constant due to the unknown `n` number being canceled away by a card showing a particular operation, you should swipe the card RIGHT in order to anticipate a "stop" at the next location (which is also known as a 'constant "station" stop'), and will be given a chance to guess the value of the constant with 2 left/right choices and minimal penalty if you accidentally chose the wrong value. If the expression still has an unknown `n` variable inside it, then you should continue swiping LEFT to move the train along continually. If you missed a station stop (ie. didn't swipe right when you should), you will incur a penalty delay and be  forced to play a higher/lower guessing game at the given station stop (to guess the constant) before you can set off again. After stopping at any given station stop and setting off again, a value of `n` is always added to the existing constant expression.  

If you SWIPE right but the value of the expression doesn't result in a constant  value, then you will incur some penalty delay as well before you can start swiping again.

The basic objective is to challenge your friend with the same main deck of platform cards, and see who finishes the race first with the background scene train moving forward to it's end destination. Some memory, speed,  guessing work and calculated-risk taking is done to minimise missing stops and also determine when it's deemed "safe" to speed ahead (ie. keep swiping left) if you know the  polynomial expression is bound to be complex and unlikely to be reduced down to a constant.

Mathmatical operators are:
	
- `*` Multiply
- `/` Divide
- `+` Plus
- `-` Minus
- `\` Divide to get quotient only (ie. ignore remainder)
- `(d?/dn)` Deriative 
