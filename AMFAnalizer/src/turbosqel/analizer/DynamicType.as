package turbosqel.analizer {
	import turbosqel.data.LVar;
	import turbosqel.utils.UArray;
	
	/**
	 * ...
	 * @author Gerard Sławiński
	 */
	public class DynamicType extends ValueType implements IAnalizeParent {
		
		////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////
		
		// <-------------------------- INTERFACE GETTERS
		
		/**
		 * is object dynamic
		 */
		public function get isDynamic():Boolean {
			return true;
		};
		/**
		 * is object final
		 */
		public function get isFinal():Boolean {
			return false;
		};
		/**
		 * is object static
		 */
		public function get isStatic():Boolean {
			return false;
		};
		
		////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////
		
		// <-------------------------- INIT
		
		/**
		 * create analize for Object or Array
		 * @param	parent			parent IAnalize
		 * @param	target			target value
		 * @param	access			access mode
		 * @param	forceType		force data type
		 */
		public function DynamicType(parent:IAnalizeParent , target:LVar , access:String = "readwrite" , forceType:String = null):void {
			super(parent , target, access, forceType);
		};
		
		
		////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////
		
		// <-------------------------- CHILDREN FUNCTIONS
		
		/// target params
		protected var params:Array;
		
		/**
		 * return array of IAnalize objects
		 */
		public function get children():Array {
			return params || parseChildren();
		};
		
		
		/**
		 * parse children and return new Array of IAnalize objects
		 * @return		params Array
		 */
		public function parseChildren():Array {
			if (params) {
				UArray.executeAndRemove(params , "remove");
			};
			if (content.value == null) {
				return params = null;
			};
			var arr:Array = new Array();
			for (var item:String in content.value ) {
				arr.push(Analize.getType(this , new LVar(content.value , item)));
			};
			return params = arr;
		}
		
		/**
		 *  create new children list and dispatch redraw event
		 */
		public function invalidateChildren():void {
			parseChildren();
			root.invalidate();
		};
		
		////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////
		
		// <-------------------------- REMOVE
		
		/**
		 * remove and release objects
		 */
		override public function remove():void {
			if (params) {
				UArray.executeAndRemove(params , "remove");
				params = null;
			}
			super.remove();
		}
		
		
	}

}