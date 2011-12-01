package turbosqel.analizer 
{
	import flash.utils.getQualifiedClassName;
	import turbosqel.data.LVar;
	import turbosqel.analizer.AnalizeType;
	/**
	 * ...
	 * @author Gerard Sławiński
	 */
	public class SimpleType extends ValueType {
		
		
		
		
		
		
		public function SimpleType(parent:IAnalizeParent , target:LVar , access:String = "readwrite" , forceType:String = null):void {
			super(parent, target, access, forceType);
		}
		
		
		
		
		
		
		
		
		
		
	}

}