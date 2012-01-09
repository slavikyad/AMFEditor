package turbosqel.analizer {
	import flash.utils.getQualifiedClassName;
	
	import turbosqel.data.LVar;
	
	/**
	 * ...
	 * @author Gerard Sławiński || turbosqel
	 * 
	 * base analize element
	 */
	public class ValueType implements IAnalize {
		
		////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////
		
		// <-------------------------- PARAMS
		
		/// lvar to target value
		protected var content:LVar;
		/// access mode
		protected var paramAccess:String;
		/// constructor name
		protected var paramType:String;
		/// strong typed
		internal var isStrong:Boolean;
		/// analize root
		internal var _root:Analize;
		/// this parent object
		internal var _parent:IAnalizeParent;
		
		////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////
		
		// <-------------------------- INIT
		
		/**
		 * value base analize
		 * @param	parent			parent analize object
		 * @param	target			target value
		 * @param	access			access mode
		 * @param	forceType		force value type
		 */
		public function ValueType(parent:IAnalizeParent , target:LVar , access:String = null , forceType:String = null):void {
			_parent = parent;
			_root = parent.root;
			content = target;
			paramAccess = access || AnalizeType.READWRITE;
			paramType = forceType;
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////
		
		// <-------------------------- GETTERS / SETTERS
		
		// <---------- TARGET VALUE
		
		/**
		 * return target value
		 */
		public function get target():* {
			if ( access == AnalizeType.READWRITE || access == AnalizeType.READ){
				return content.value;
			};
		};
		/**
		 * set target value and dispatch invalidate on root
		 */
		public function set target(v:*):void {
			if ( access == AnalizeType.READWRITE || access == AnalizeType.WRITE){
				content.value = v;
			};
			invalidate();
		};
		
		
		// <---------- INTERFACE GETTERS
		
		/**
		 * access mode
		 */
		public function get access():String {
			return paramAccess;
		};
		
		/**
		 * root Analize object
		 */
		public function get root():Analize {
			return _root;
		};
		
		/**
		 * depth from root object
		 */
		public function get depth():int {
			return parent.depth + 1;
		};
		
		/**
		 * parent analize object
		 */
		public function get parent():IAnalizeParent {
			return _parent;
		}
		
		/**
		 * set strong typed value
		 */
		public function set strong(val:Boolean):void {
			isStrong = val;
		};
		/**
		 * is strong typed value
		 */
		public function get strong():Boolean {
			return isStrong;
		};
		
		/**
		 * return label formated string
		 */
		public function get label():String {
			return Analize.makeLabel(this);
		};
		
		/**
		 * parent key to target object / param name
		 */
		public function get name():String {
			return String(content.key);
		};
		
		/**
		 * value type
		 */
		public function get type():String {
			return paramType || getQualifiedClassName(content.value);
		};
		
		/**
		 * analize class
		 */
		public function get analizeType():Class {
			return this["constructor"];
		};
		
		/**
		 * path to value from root object
		 */
		public function get path():String {
			var pr:IAnalize = parent;
			var dig:String =  name;
			while (pr != _root) {
				dig = pr.name + "." + dig;
				pr = pr.parent;
			};
			
			return dig;
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////
		
		// <-------------------------- FUNCTIONS
		
		/**
		 * invalidate
		 */
		public function invalidate():void {
			root.invalidate();
		};
		
		/**
		 * formated string value
		 * @return		info
		 */
		public function toString():String {
			return "[ IAnalize:" + content.key + " , access :" + paramAccess + ",type:"+type+" ]" ;
		};
		
		////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////
		
		// <-------------------------- REMOVE
		
		/**
		 * remove and release objects
		 */
		public function remove():void {
			_root = null;
			_parent = null;
			content.remove();
			content = null;
		}
		
	}

}