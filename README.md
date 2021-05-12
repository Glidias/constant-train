# constant-train

HaxeVx+Vuex example train racing game prototype. 

For an online preview of web-app, go to: https://glidias.github.io/constant-train/

Leverages the following technologies under Haxe:
	
Cross-platform codebase:

- Haxe 3.4. Plain Haxe cross-platform/framework-agnostic codes (Model/server) `cstrain.core`,  `cstrain.rules`,  `cstrain.util` 
- Heaps (v1.0.0) (for background scenery View)  `cstrain.h2d` https://github.com/HeapsIO/heaps
- HashIDs (for generating unique ids of play decks) https://libraries.io/haxelib/hashids
- MSignals (basic Signals implementation) https://lib.haxe.org/p/msignal/
- ECX (entity-component-system) framework https://github.com/Glidias/ecx

For HTML5-specific target (A view implementation for browser/webapps):
	
- HaxeVx + Vuex (Vue2) `cstrain.vuex`  https://github.com/Glidias/haxevx
- Vue-touch (`next` branch) (for Vue2 compatibility) https://github.com/vuejs/vue-touch/tree/next
- Swing JS for card swiping feature `gajus.swing`  (<- NOTE: The externs in this package isn't complete/accruate.) https://github.com/gajus/swing 


## Installation

Before compiling, run `haxelib install all` (to ensure all you install all necessary haxe library packages), and  `npm install` (for node JS packages) at root working location folder to install any dev dependencies required for compiling. 

Also ensure NPM packages are installed at `\bin\` location via `npm install` at `bin` location for Previewing and Building.

## Compiling (Haxe codebase)

To compile, just use any of the relavant `build_????.hxml` files.  Or alternatively, if using some IDE to compile without hxml files, compile `Main.hx` and also remember to post-run `gulpcss.bat` (which simply executes `gulp css` task to compile the main `scss/index.scss` stylesheet together with it's CSS modules. By default, the hxml files already executes the `gulp css` process after compiling! A reference/cache file dump of `processing-modules`  and `processing-styles` will be generated withthe Haxe compiling/macro-building process. These cache files can be safely deleted away, if you wish, but they serve as a persitant cache reference to speed up later Haxe compiles by knowing which CSS module style files had changed or not.

## Previewing

To start previewing the compiled `bin` contents on browser as a developer. Configure `npm start` command at `bin/package.json` location to point to the relavant host/port. A host of `localhost"` would suffice if you just need to view it offline. 

	"start": "webpack-dev-server --port 8080 --host localhost --entry ./ConstantTrain.js"`
	
Then, start webpack dev server on the  command line at the `bin` location with: `npm run serve`.  In the example configuration above, you can  preview the app on your browser with the configured  address, which would be `http://localhost:8080` based on the example.
	
## Building

After compiling Haxe codebase (to `ConstantTrain.js`), Run `npm run build` to pack it to a minified `bundle.js` deployable. Open `index.html` from a web server and you should be able to view it.

## Deploying

Entire contents in `bin` folder need not be uploaded. Only `index.html`, `bundle.js`, and all folders except `node_modules` to be uploaded.

## How to play?

You are presented with a main deck of operation cards which you must empty out one by one (as fast as possible) after each swipe, starting with card 'n', where 'n' represents an unknown number. Each card will have a mathematical operation (eg. add/divide/minus/multiply), by a given plain number constant expression, an unknown `n` number, or polynomial expression with a combination of powered `n` values. Anytime you swipe left/right, the mathematical operation presented on the card will applied to the expression, resulting in some kind of result. You are supposed to track the result (often roughly) in your head because....

...whenever the expression will result in a constant due to the unknown `n` number being canceled away by a card showing a particular operation, you should swipe the card RIGHT in order to anticipate a "stop" at the next location (which is also known as a 'constant "station" stop'), and will be given a chance to guess the value of the constant with 2 left/right choices and minimal penalty if you accidentally chose the wrong value. If the expression still has an unknown `n` variable inside it, then you should continue swiping LEFT to move the train along continually. If you missed a station stop (ie. didn't swipe right when you should), you will incur a penalty delay and be  forced to play a higher/lower guessing game at the given station stop (to guess the constant) before you can set off again. After stopping at any given station stop and setting off again, a value of `n` is always added to the existing constant expression.  

If you SWIPE right but the value of the expression doesn't result in a constant  value, then you will incur some penalty delay as well before you can start swiping again.

Mathmatical operators are:
	
- `*` Multiply
- `/` Divide
- `+` Plus
- `-` Minus
- `\` Divide to get quotient only (ie. ignore remainder)
- `(d?/dn)` Deriative 

### Current gameplay state:

Admittingly, the game as of now is rather boring, since there's little risk/reward mechanic contrast that goes along with it. As of now (until some possible gameplay enhancements are done to make the game more fun with more player-agency, management, and danger), the current way to play the game is to simply challenge your friend with the same main deck of platform cards, and see who finishes the race first with the background scene train moving forward to it's end destination (however, that it still pretty boring and only adds a competition aspect to the game). Some memory, speed,  guessing work and calculated-risk taking is done to minimise missing stops and also determine when it's deemed "safe" to speed ahead (ie. keep swiping left) if you know the  polynomial expression is bound to be complex and unlikely to be reduced down to a constant.
