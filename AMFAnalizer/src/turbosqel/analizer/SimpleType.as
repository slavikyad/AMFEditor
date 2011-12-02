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
		
		/**
		 * create new SimpleType IAnalize object for String int Number ...
		 * @param	parent			parent object IAnalizeParent
		 * @param	target			target object to analize
		 * @param	access			access mode
		 * @param	forceType		force class alias
		 */
		public function SimpleType(parent:IAnalizeParent , target:LVar , access:String = "readwrite" , forceType:String = null):void {
			super(parent, target, access, forceType);
		};
	}

}