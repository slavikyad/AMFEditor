package turbosqel.analizer {
	import turbosqel.data.LVar;
	import turbosqel.utils.UArray;
	import turbosqel.utils.UString;
	
	/**
	 * ...
	 * @author Gerard Sławiński || turbosqel
	 */
	public class FunctionType extends ValueType {
		////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////
		
		/// return param type
		public var returnType:String;
		/// params informations
		public var params:Array;
		
		////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////
		/**
		 * Create function analize
		 * @param	parent			parent analize
		 * @param	target			target function
		 * @param	access			access mode
		 * @param	forceType		function
		 */
		public function FunctionType(parent:IAnalizeParent, target:LVar, access:String=null, forceType:String=null):void {
			super(parent, target, access, Analize.FUNCTION);
		};
		
		/**
		 * label creator
		 */
		public override function get label():String {
			return Analize.makeFunctionLabel(this);
		};
		
		/**
		 * informations about function parameters
		 */
		internal function get paramsInfo():String {
			if(params){
				var str:String = "(";
				
				for (var i:int ; i < params.length ; i++) {
					str += params[i].type + " , ";
				};
				return UString.sliceStr(str, null , ",").concat(")");
			}
			return "()"
		};
		
		
		/**
		 * call target function
		 * @param	... args		additional params
		 */
		public function call(... args):void {
			target.apply(null , args);
		};
		
		/**
		 * number of function params
		 */
		public function get length():int {
			return target.length();
		};
		
		////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////
		
		override public function remove():void {
			UArray.remove(params);
			super.remove();
		}
		
	}

}