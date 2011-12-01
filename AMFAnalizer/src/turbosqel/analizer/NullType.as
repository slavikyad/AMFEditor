package turbosqel.analizer 
{
	import turbosqel.data.LVar;
	/**
	 * ...
	 * @author Gerard Sławiński || turbosqel
	 */
	public class NullType extends ValueType {
		
		public function NullType(parent:IAnalizeParent , target:LVar , access:String = "readwrite" , forceType:String = null ):void {
			super(parent , target , access , forceType);
		}
		
		public override function get type():String {
			return "null";
		}
		
		
	}

}