package turbosqel.analizer {
	import avmplus.Describe;
	
	import turbosqel.data.LVar;
	import turbosqel.utils.UArray;
	import turbosqel.utils.UObject;
	
	
	/**
	 * ...
	 * @author Gerard Sławiński || turbosqel
	 */
	public class ComplexType extends ValueType implements IAnalizeParent {
		////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////
		
		// <-------------------------- GETTERS :

		/**
		 * target class type
		 */
		public override function get type():String {
			return result ? result.name : paramType ;
		}
		
		
		/**
		 * target is dynamic
		 */
		public function get isDynamic():Boolean {
			return result.isDynamic;
		};
		/**
		 * target is final
		 */
		public function get isFinal():Boolean {
			return result.isFinal;
		};
		/**
		 * target is static
		 */
		public function get isStatic():Boolean {
			return result.isStatic;
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////
		
		// <-------------------------- INIT
		
		
		/**
		 * complex type analize , for other than toplevel classes
		 * @param	parent			parent analize
		 * @param	target			target object
		 * @param	access			access mode
		 * @param	forceType		force class type
		 */
		public function ComplexType(parent:IAnalizeParent , target:LVar , access:String = "readwrite" , forceType:String = null):void{
			super(parent , target, access, forceType);
		}
		
		
		
		

		////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////
		
		// <-------------------------- PARSING ELEMENTS / CHILD ANALIZE
		
		/// parameters & functions array
		protected var params:Array;
		/// Describe result
		protected var result:Object;
		
		/**
		 * return array with IAnalize objects of children
		 */
		public function get children():Array {
			return params || parseChildren();
		};
		
		
		////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * parsing elements and create IAnalize objects
		 * @return		Array with IAnalize objects
		 */
		public function parseChildren():Array {
			/// if already exist , clear old Array and remove children IAnalize
			if (params) {
				UArray.executeAndRemove(params , "remove");
			};
			/// check if target value is null
			if (content.value == null) {
				params = null;
				return null;
			};
			//////////////////////////////
			//<-------- described params :
			
			// enums values :
			params = new Array();
			for (var item:* in content.value ) {
				params.push(Analize.getType(this , new LVar(content.value , item)));
			};
			
			
			// describe class
			result = Describe.typeJSON(content.value);
			
			// read accessors:
			
			var subArray:Array = result.traits.accessors;
			if(subArray){
				var length:int =  subArray.length;
				for (var i:int ; i < length ; i++) {
					var paramInfo:Object = subArray[i];
					params.push(Analize.getType(this , new LVar(target , paramInfo.name ) , paramInfo.access , paramInfo.type));
				};
			}
			// read params:
			subArray = result.traits.variables;
			if(subArray){
				length =  subArray.length;
				for (i = 0 ; i < length ; i++) {
					paramInfo = subArray[i];
					var ian:IAnalize = Analize.getType(this , new LVar(target , paramInfo.name ) , paramInfo.access , paramInfo.type);
					ian.strong = true;
					params.push(ian);
				};
			}
			// read functions :
			subArray = result.traits.methods;
			if (Analize.showFunctions && subArray) {
				length = subArray.length;
				for (i = 0; i < length ; i ++) {
					paramInfo = subArray[i];
					var funcType:FunctionType = Analize.getType(this , new LVar(target , paramInfo.name), null , Analize.FUNCTION) as FunctionType;
					funcType.strong = true;
					funcType.returnType = paramInfo.returnType;
					/// take params object
					funcType.params = subArray[i].parameters;
					delete subArray[i].parameters;
					params.push(funcType);
				};
			};
			
			
			// return params array
			return params;
		};
		////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////
		
		
		/**
		 * invalidate all children and request redraw of tree
		 */
		public function invalidateChildren():void {
			parseChildren();
			root.invalidate();
		};
		
		
		////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////
		
		override public function remove():void {
			if (params) {
				UArray.executeAndRemove(params , "remove");
			};
			UObject.deepRemove(result);
			result = null;
			super.remove();
		}
		
		
		
		
	}

}