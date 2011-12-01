package turbosqel.analizer 
{
	import flash.utils.getQualifiedClassName;
	
	import turbosqel.console.Console;
	import turbosqel.data.LVar;
	import turbosqel.utils.UArray;
	/**
	 * ...
	 * @author Gerard Sławiński
	 */
	public class DynamicType extends ValueType implements IAnalizeParent {
		
		
		
		public function get isDynamic():Boolean {
			return true;
		};
		public function get isFinal():Boolean {
			return false;
		};
		public function get isStatic():Boolean {
			return false;
		};
		
		
		
		public function DynamicType(parent:IAnalizeParent , target:LVar , access:String = "readwrite" , forceType:String = null):void {
			super(parent , target, access, forceType);
		};
		
		
		
		protected var params:Array;
		
		public function get children():Array {
			return params || parseChildren();
		};
		
		public function parseChildren():Array {
			if (params) {
				UArray.executeAndRemove(params , "remove");
			}
			if (content.value == null) {
				return params = null;
			}
			var arr:Array = new Array();
			for (var item:String in content.value ) {
				arr.push(Analize.getType(this , new LVar(content.value , item)));
			};
			
			return params = arr;
		}
		
		
		public function invalidateChildren():void {
			parseChildren();
			root.invalidate();
		};
		
		
		
	}

}