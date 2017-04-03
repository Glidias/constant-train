const gulp = require('gulp');
const postcss  = require('gulp-postcss');
const modules   = require('postcss-modules');
const autoprefixer  = require('autoprefixer');
const path  = require('path');
const fs  = require('fs');
const argv = require('yargs').argv;
const stringHash = require('string-hash');
const camelize = require('camelize');
const mkdirp = require('mkdirp');
const getDirName = require('path').dirname;

gulp.task('cssmodules', function() {
	var src = argv["src"];
	var dest = argv["dest"];
	
	function getJSONFromCssModules(cssFileName, json) {
	  const cssName       = path.basename(cssFileName, '.css');
	  const jsonFileName  = path.resolve(dest, `${ cssName.split(".")[0] }.json`);
	
	  json = camelize(json);
	   mkdirp(getDirName(jsonFileName), function (err) {
		if (err) return cb(err);
		 fs.writeFileSync(jsonFileName, JSON.stringify(json));
	  });
	}
	
	return gulp.src(src)
    .pipe(postcss([
      modules({ 
		  getJSON: getJSONFromCssModules,
		  generateScopedName: function(name, filename, css) {
		
			// customise this as you see fit...
			filename = filename.split(".")[0];
			filename = filename.split("\\").pop();
			  var hash = stringHash(filename).toString(36).substr(0, 5);
			  return  filename.split("_").pop() +"_" + hash + '_' + name;
		  }
			  //'[name]__[local]___[hash:base64:5]',
	  }),
	  
    ]))
	.pipe(gulp.dest(dest));
});

gulp.task('default', ['cssmodules']);