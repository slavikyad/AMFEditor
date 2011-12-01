package turbosqel.analizer{
	import avmplus.Describe;
	
	import flash.utils.getQualifiedClassName;
	
	import turbosqel.console.Console;
	import turbosqel.data.LVar;
	import turbosqel.events.SoftEventDispatcher;
	import turbosqel.utils.UArray;
	import turbosqel.utils.UObject;

	public class Analize extends SoftEventDispatcher implements IAnalizeParent {
		
		////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////
		
		// <-------------------------- GLOBAL INDEX
		
		internal static var analizeIndex:Array = new Array();
		internal static function addAnalize(analize:Analize):void {
			analizeIndex.push(analize);
		};
		internal static function removeAnalize(analize:Analize):void {
			UArray.searchAndSlice(analizeIndex , analize);
		};
		
		public static function getByName(name:String):Analize {
			return UArray.searchValues(analizeIndex , "name" , name);
		};
		
		////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////
		
		// <-------------------------- MAIN STATIC PARSE FUNCTION
		
		
		public static function parse(name:String , object:*):Analize {
			return new Analize(name , object);
		};
		
		
		////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////
		
		// <-------------------------- STATIC PARAMS
		
		
		public static var showFunctions:Boolean = true;
		public static var representLength:int = 100;
		
		
		public static const PREFIX:String = "analize.";
		
		public static const NULL:String = "null";
		
		public static const STRING:String = "String";
		public static const BOOLEAN:String = "Boolean";
		public static const NUMBER:String = "Number";
		public static const INT:String = "int";
		public static const UINT:String = "uint";
		public static const FUNCTION:String = "Function";
		
		public static const OBJECT:String = "Object";
		public static const ARRAY:String = "Array";
		
		
		internal static const VIOD:int = 0;
		internal static const DELEGATE:int = 1;
		internal static const SIMPLE:int = 2;
		internal static const DYNAMIC:int = 3;
		internal static const COMPLEX:int = 4;
		
		
		////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////
		
		// <-------------------------- TYPE FUNCTIONS
		
		internal static function typeId(value:* , getClassName:Boolean = true):int {
			
			switch(getClassName ? getQualifiedClassName(value):String(value)) {
				// null
				case NULL:
					return VIOD;
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
		
		
		
		internal static function getType(parent:IAnalizeParent , target:LVar , access:String = null , forceType:String = null ):IAnalize {
			switch(typeId((forceType ? forceType : target.value ), !Boolean(forceType) )) {
				case VIOD:
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
			Console.ThrowError("Analize.getType:" , new Error("unknown target type"));
			return new NullType(parent , target);
		}
		
		
		
		
		
		
		
		
		////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////
		
		// <-------------------------- LABEL FUNCTION
		
		public static var labelFunction:Function = normalLabel;
		
		internal static function makeLabel(target:IAnalize):String {
			return labelFunction(target);
		};
		
		
		protected static function normalLabel(target:IAnalize):String {
			try {
				var represent:String = String(target.target);
			} catch (e:Error) {
				Console.ThrowError("Analize.makeLabel error " ,e);
				represent = " cannot parse this value "
			}
			represent = represent.length > Analize.representLength ? represent.substr(0, Analize.representLength) : represent;
			if (target.access == AnalizeType.WRITE) {
				return target.name + "[" + target.type + "] ";
			}
			return  target.name+ "[" + target.type + "] " +" = " + represent;
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////
		
		// <-------------------------- PARAMS AND INFO
		
		// <---------------- GETTERS
		
		public function get label():String {
			return name + ":[Analize]";
		}
		
		public function get type():String {
			return typeName(contentType);
		}
		
		public function get name():String {
			return _name;
		};
		
		public function get contentType():int {
			return 0;
		};
		
		public function get contentAlias():String {
			return content.value ? getQualifiedClassName(content.value) : "null";
		}
		
		public function get access():String {
			return AnalizeType.READWRITE;
		}
		
		public function get analizeType():Class {
			return Analize;
		}
		
		public function get root():Analize {
			return this;
		}
		
		public function get isDynamic():Boolean {
			return false;
		}
		public function get isFinal():Boolean {
			return false;
		}
		public function get isStatic():Boolean {
			return false;
		}
		
		//<--------------------------- PARAMS
		
		protected var _name:String;
		protected var content:LVar;
		protected var container:Object;
		public var analize:IAnalize;
		
		////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////
		
		// <-------------------------- INIT
		
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
		
		public function invalidate():void {
			dispatchEvent(new AnalizeEvent(AnalizeEvent.INVALIDATE));
		};
		
		public function invalidateChildren():void {
			parseChildren();
			dispatchEvent(new AnalizeEvent(AnalizeEvent.INVALIDATE));
		};
		
		
		
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
		
		public function set target(v:*):void {
			content.value = v;
		}
		
		public function get target():* {
			return content.value;
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////
		
		// <-------------------------- REMOVE
		
		public function remove():void {
			removeAnalize(this);
			analize.remove();
			analize = null;
			target.remove();
			target = null;
		}
		
		
	}
}