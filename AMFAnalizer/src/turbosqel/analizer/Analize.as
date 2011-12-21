package turbosqel.analizer{
	import avmplus.Describe;
	
	import flash.utils.getQualifiedClassName;
	
	import turbosqel.data.LVar;
	import turbosqel.events.SoftEventDispatcher;
	import turbosqel.utils.UArray;
	import turbosqel.utils.UObject;

	
	
	/**
	 * ...
	 * @author Gerard Sławiński || turbosqel
	 * 
	 * 
	 * Analize class for parse and read Objects params , functions , accessorss .
	 * 
	 * to quick use :
	 * var an:Analize = Analize.parse("nameOfAnalize" , object);
	 * 
	 * tree.dataProvider = an.analize;
	 * 
	 * 
	 */
	
	public class Analize extends SoftEventDispatcher implements IAnalizeParent {
		
		////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////
		
		// <-------------------------- GLOBAL INDEX
		
		/// array with Analize objects
		internal static var analizeIndex:Array = new Array();
		
		/**
		 * add analize to index object
		 * @param	analize
		 */
		internal static function addAnalize(analize:Analize):void {
			analizeIndex.push(analize);
		};
		
		/**
		 * remove analize from index array
		 * @param	analize
		 */
		internal static function removeAnalize(analize:Analize):void {
			UArray.searchAndSlice(analizeIndex , analize);
		};
		
		/**
		 * search for analize by name
		 * @param	name		analize name
		 * @return				Analize or null;
		 */
		public static function getByName(name:String):Analize {
			return UArray.searchValues(analizeIndex , "name" , name);
		};
		
		////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////
		
		// <-------------------------- MAIN STATIC PARSE FUNCTION
		
		/**
		 * Function to create Analize . Tree style informations return Analize.analize param , and each
		 * child is IAnalize object . Structure works with Flex Tree component .
		 * @param	name		analize name , support for searching
		 * @param	object		object to analize
		 * @return				new Analize
		 */
		public static function parse(name:String , object:Object):Analize {
			return new Analize(name , object);
		};
		
		
		////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////
		
		// <-------------------------- STATIC PARAMS
		
		/// show functions in list
		public static var showFunctions:Boolean = true;
		/// label string max length
		public static var representLength:int = 100;
		
		/// prefix for ResourceManage .
		public static const PREFIX:String = "analize.";
		
		
		// <--------------------------  VALUE TYPES
		
		/// null value;
		public static const NULL:String = "null";
		
		/// simple nonexpandable types :
		public static const STRING:String = "String";
		public static const BOOLEAN:String = "Boolean";
		public static const NUMBER:String = "Number";
		public static const INT:String = "int";
		public static const UINT:String = "uint";
		public static const FUNCTION:String = "Function";
		
		
		/// simple types with children :
		public static const OBJECT:String = "Object";
		public static const ARRAY:String = "Array";
		
		/// int code types 
		internal static const VOID:int = 0;
		internal static const DELEGATE:int = 1;
		internal static const SIMPLE:int = 2;
		internal static const DYNAMIC:int = 3;
		internal static const COMPLEX:int = 4;
		
		
		////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////
		
		// <-------------------------- TYPE FUNCTIONS
		
		
		/**
		 * return int code of type .
		 * @param	value				object or String with class name / alias
		 * @param	getClassName		if true , function read "value" as object , if false - expect String with class name/alias
		 * @return						int code
		 */
		internal static function typeId(value:* , getClassName:Boolean = true):int {
			
			switch(getClassName ? getQualifiedClassName(value):String(value)) {
				// null
				case NULL:
					return VOID;
				// simple
				case BOOLEAN :
					return SIMPLE;
				case STRING:
					return SIMPLE;
				case NUMBER:
					return SIMPLE;
				case INT:
					return SIMPLE;
				case UINT:
					return SIMPLE;
				// call
				case FUNCTION:
					return DELEGATE;
				// dynamic
				case OBJECT :
					return DYNAMIC;
				case ARRAY :
					return DYNAMIC;
				// complex
				default :
					return COMPLEX;
			};
		};
		
		/**
		 * return type by int code
		 * @param	id		int code
		 * @return			type name
		 */
		internal static function typeName(id:int):String {
			switch(id) {
				case NULL :
					return "null";
				case DELEGATE :
					return "function";
				case SIMPLE :
					return "simple";
				case DYNAMIC :
					return "dynamic";
			}
			return "complex";
		};
		
		////////////////////////////////
		////////////////////////////////
		////////////////////////////////
		/**
		 * create child IAnalize object
		 * @param	parent			parent object
		 * @param	target			target value
		 * @param	access			access type - AnalizeType.READ , AnalizeType.WRITE , AnalizeType.READWRITE
		 * @param	forceType		name/alias of value
		 * @return					child IAnalize object
		 */
		internal static function getType(parent:IAnalizeParent , target:LVar , access:String = null , forceType:String = null ):IAnalize {
			switch(typeId((forceType ? forceType : target.value ), !Boolean(forceType) )) {
				case VOID:
					return new NullType(parent , target , access , forceType );
				case DELEGATE :
					return new FunctionType(parent , target , access , forceType);
				case SIMPLE:
					return new SimpleType(parent , target , access , forceType );
				case DYNAMIC :
					return new DynamicType(parent , target , access , forceType );
				case COMPLEX :
					return new ComplexType(parent , target , access , forceType );
			}
			var e:Error = new Error("unknown target type");
			trace("Analize.getType:" , e , e.getStackTrace());
			return new NullType(parent , target);
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////
		
		// <-------------------------- LABEL FUNCTION
		
		/// label maker function . To create own labelFunction , set here function(target:IAnalize):String;
		/// WARNING : check customObjectLabel function to see where You should use try block .
		/// values can have write-only or read-only modes or return null
		public static var objectLabel:Function = customObjectLabel;
		/// label maker function for Functions
		public static var functionLabel:Function = customFunctionLabel;
		
		/**
		 * create label for IAnalize object
		 * @param	target		target analize
		 * @return				serialized by function string
		 */
		internal static function makeLabel(target:IAnalize):String {
			return objectLabel(target);
		};
		
		/**
		 * create label for FunctionType IAnalize
		 * @param	target		target FunctionType
		 * @return				formated string;
		 */
		internal static function makeFunctionLabel(target:FunctionType):String {
			return functionLabel(target);
		};
		
		
		
		/**
		 * custom label maker
		 * @param	target		analize object
		 * @return				serialized string
		 */
		protected static function customObjectLabel(target:IAnalize):String {
			try {
				var represent:String = String(target.target);
			} catch (e:Error) {
				trace("Analize.makeLabel error " , e , e.getStackTrace());
				represent = " cannot parse this value "
			}
			represent = represent.length > Analize.representLength ? represent.substr(0, Analize.representLength) : represent;
			if (target.access == AnalizeType.WRITE) {
				return target.name + "[" + target.type + "] ";
			}
			return  target.name+ "[" + target.type + "] " +" = " + represent;
		};
		
		
		
		/**
		 * custom label creator for functions
		 * @param	target
		 * @return
		 */
		protected static function customFunctionLabel(target:FunctionType):String {
			return "[" + target.type + "] " + target.name + target.paramsInfo;
		};
		
		
		////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////
		
		// <-------------------------- PARAMS AND INFO
		
		// <---------------- GETTERS
		
		/**
		 * interface function , child read root Analize from parent IAnalize
		 */
		public function get root():Analize {
			return this;
		};
		
		/**
		 * top object return null
		 */
		public function get parent():IAnalizeParent {
			return null;
		};
		
		public function get strong():Boolean {
			return true;
		};
		public function set strong(val:Boolean):void {
		}
		
		public function get path():String {
			return "";
		}
		
		/**
		 * label getter . To create own labels check labelFunction param;
		 */
		public function get label():String {
			return name + ":[Analize]";
		};
		
		
		/**
		 * analize name
		 */
		public function get name():String {
			return _name;
		};
		
		public function set name(value:String):void {
			var target:Object = container[_name];
			delete container[_name];
			_name = value;
			container[_name] = target;
			content.key = _name;
			invalidate();
		}
		
		/**
		 * analized object type
		 */
		public function get contentAlias():String {
			return content.value ? getQualifiedClassName(content.value) : "null";
		};
		
		////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////
		
		// <---------------- INTERFACE FUNCTIONS
		// <---------------- USELESS FOR ANALIZE OBJECT
		
		/**
		 * interface function , useless here;
		 */
		public function get type():String {
			return "Parent";
		};
		
		/**
		 * interface function , useless here;
		 */
		public function get contentType():int {
			return 0;
		};
		
		/**
		 * interface function , useless here;
		 */
		public function get access():String {
			return AnalizeType.READWRITE;
		}
		
		/**
		 * interface function , useless here;
		 */
		public function get analizeType():Class {
			return Analize;
		}
		
		/**
		 * interface function , useless here;
		 */
		public function get isDynamic():Boolean {
			return false;
		}
		
		/**
		 * interface function , useless here;
		 */
		public function get isFinal():Boolean {
			return false;
		}
		
		/**
		 * interface function , useless here;
		 */
		public function get isStatic():Boolean {
			return false;
		}
		
		
		
		////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////
		
		//<--------------------------- PARAMS
		
		/// Analize name
		protected var _name:String;
		/// content target
		protected var content:LVar;
		/// container proxy for create LVar
		protected var container:Object;
		/// Analized object informations
		public var analize:IAnalize;
		/// additional object for editor
		public var debug:*;
		
		////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////
		
		// <-------------------------- INIT
		
		/**
		 * analize name
		 * @param	name		name for indexing
		 * @param	object		target object to analize
		 */
		public function Analize(name:String , object:*):void {
			_name = name;
			addAnalize(this);
			////////////////////////////
			container = new Object();
			container[name] = object;
			content = new LVar(container , name);
			analize = getType(this , content);
		};
		
		
		////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////
		
		// <-------------------------- VALIDATION && CHANGES
		
		/**
		 * dispatch information about single label change .
		 */
		public function invalidate():void {
			dispatchEvent(new AnalizeEvent(AnalizeEvent.INVALIDATE));
		};
		
		/**
		 * dispatch information about IAnalizeParent object children Array change
		 */
		public function invalidateChildren():void {
			parseChildren();
			dispatchEvent(new AnalizeEvent(AnalizeEvent.INVALIDATE));
		};
		
		
		/**
		 * create new target object Analize
		 * @return
		 */
		public function parseChildren():Array {
			if (analize) {
				analize.remove();
			}
			analize = getType(this , content);
			return null;
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////
		
		// <-------------------------- TARGET
		
		/**
		 * setting new analize target is not allowed , create new Analize
		 */
		public function set target(v:*):void {
		}
		
		/**
		 * return Analize target object
		 */
		public function get target():* {
			return content.value;
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////
		
		// <-------------------------- REMOVE
		
		/**
		 * remove analize , references and children children children ...
		 */
		public function remove():void {
			removeAnalize(this);
			debug = null;
			content.remove();
			content = null;
			UObject.remove(container);
			container = null;
			analize.remove();
			analize = null;
			target = null;
		}
		
		
	}
}