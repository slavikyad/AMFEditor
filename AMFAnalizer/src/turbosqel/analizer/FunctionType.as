package turbosqel.analizer 
{
	import turbosqel.console.Console;
	import turbosqel.data.LVar;
	import turbosqel.utils.UObject;
	import turbosqel.utils.UString;
	
	/**
	 * ...
	 * @author Gerard Sławiński || turbosqel
	 */
	public class FunctionType extends ValueType {
		
		
		public var returnType:String;
		public var params:Array;
		
		public function FunctionType(parent:IAnalizeParent, target:LVar, access:String=null, forceType:String=null):void {
			super(parent, target, access, forceType);
		};
		
		public override function get label():String {
			return "[" + type + "] " + name + paramsInfo;
		};
		
		
		protected function get paramsInfo():String {
			if(params){
				var str:String = "(";
				
				for (var i:int ; i < params.length ; i++) {
					str += params[i].type + " , ";
				};
				return UString.sliceStr(str, null , ",").concat(")");
			}
			return "()"
		};
		
		
		public override function get type():String {
			return Analize.FUNCTION;
		};
		
		public function call(... args):void {
			target.apply(null , args);
		};
		
		public function get length():int {
			return target.length();
		};
		
	}

}