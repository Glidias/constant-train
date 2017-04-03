package haxevx.vuex.core;

#if macro
import haxe.macro.TypeTools;
import haxe.macro.Expr.Field;
import haxe.io.Path;
import haxe.macro.Context;
import sys.FileSystem;
import sys.io.File;
import haxe.macro.Expr;
import haxe.io.Bytes;
import sys.io.Process;

/**
 * note: this shouldn't be in Core actually. The implementation is particularly specific.
 * @author Glidias
 */
class VCSS
{
	static var CACHE_FOLDER_NAME:String = "processing-styles";
	static var MODULE_FOLDER_NAME:String = "processing-modules";
	
	  public static function json(path : String):Expr {
		var value = sys.io.File.getContent(path);
		var json = haxe.Json.parse(value);
		
		return macro $v{json};
	}
	
	public static macro function buildModuleStyle(writtenContents:String, fileExtension:String, varName:String="STYLE"):Array<Field> {
		var fileName:String = Context.getLocalClass().get().module.split(".").join("_");
		var workingDirectory:String = Sys.getCwd();
		var cacheDir:String =  workingDirectory + CACHE_FOLDER_NAME+"/";
		var moduleDir:String =  workingDirectory + MODULE_FOLDER_NAME+"/";
		if (!FileSystem.exists(cacheDir)) {
			FileSystem.createDirectory(cacheDir);
		}
		var tarFileCach:String = cacheDir + fileName+"." + fileExtension;
		var tarJSONFileCach:String = moduleDir + fileName+".json";
			
		var cached:Bool = false;
		if ( FileSystem.exists(tarFileCach) && FileSystem.exists(tarJSONFileCach)  ) {
			if (File.getBytes(tarFileCach).compare( Bytes.ofString(writtenContents)  )==0 ) {			
				cached = true;
			}
		}
	
		var theFields = Context.getBuildFields();
		if (!cached) {
			File.saveContent( tarFileCach, writtenContents );
			var src:String = "./" + CACHE_FOLDER_NAME +"/"+fileName+"."+fileExtension;
			var dest:String = "./" + MODULE_FOLDER_NAME;
			var p = new Process('gulp cssmodules --src ${src} --dest ${dest}');
			if (p.exitCode() != 0) {
				Context.warning("Critical warning :: Failed to Process CSS Module Styles!", Context.currentPos() );
				return theFields;
			}
		}
		
		var expr =  json(tarJSONFileCach);


		theFields.push( {
			name: varName,
			access: [Access.AStatic, Access.APublic],
			kind: FProp("default", "never", TypeTools.toComplexType( Context.typeof(expr) ), expr),
			pos: Context.currentPos(),
		});

		return theFields;
	}	
}

#end