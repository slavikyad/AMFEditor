package turbosqel.analizer 
{
	import turbosqel.data.LVar;
	/**
	 * ...
	 * @author Gerard Sławiński || turbosqel
	 */
	public class NullType extends ValueType {
		
		/**
		 * create null param child
		 * @param	parent			parent analize
		 * @param	target			target value
		 * @param	access			access mode
		 * @param	forceType		null
		 */
		public function NullType(parent:IAnalizeParent , target:LVar , access:String = "readwrite" , forceType:String = null ):void {
			super(parent , target , access , "null");
		};
		
		
		
		
	};

};