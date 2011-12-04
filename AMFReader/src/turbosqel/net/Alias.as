package turbosqel.net {
	import flash.net.getClassByAlias;
	import flash.net.registerClassAlias;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	
	/**
	 * ////////////////////////////////////////////////////////
	 * @author Gerard Sławiński || turbosqel
	 * 
	 * 
	 * util class for serialization
	 * 
	 * Register alias by class , namespace or object .
	 * Return class by namespace or alias
	 * ////////////////////////////////////////////////////////
	 */
	
	public class Alias {
		
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * register aliases of arguments objects/classes
		 * @param	... args
		 */
		public static function addClass(... args):void {
			for(var i:int ; i < args.length ; i ++){
				registerClassAlias(getQualifiedClassName(args[i]) , args[i]);
			};
		};
		
		/**
		 * register class alias
		 * @param	alias			alias string
		 * @param	targetClass		target class
		 */
		public static function addClassAlias(alias:String , targetClass:Class):void {
			registerClassAlias(alias,targetClass);
		};
		
		/**
		 * register class under alias
		 * @param	alias	class alias
		 */
		public static function addType(alias:String):void {
			addClassAlias(alias , getDefinitionByName(alias) as Class);
		}
		
		/**
		 * register class and return alias
		 * @param	target		target Class
		 * @return				class alias
		 */
		public static function addDefinition(target:Class):String {
			var alias:String = getQualifiedClassName(target);
			addClassAlias(alias , target );
			return alias;
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		 /**
		  * try to read class from namespace , if fail search for registered alias .
		  * @param	name				class name/alias
		  * @param	returnObject		true - return Object if class not found , false - return null
		  * @return						return constructor
		  */
		public static function getClassType(name:String , returnObject:Boolean = true):Class {
			try {
				var cl:Class = getDefinitionByName(name) as Class;
			} catch (e:ReferenceError) {};
			if(!cl){
				try{
					cl = getClassByAlias(name);
				}catch(e:Error){};
			};
			return cl || ( returnObject ? Object : null );
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
	}
}