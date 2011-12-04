package turbosqel.serialization 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Gerard Sławiński || turbosqel
	 */
	public class AMFLoaderEvent extends Event {
		
		public static const RESULT:String = "dataParsed";
		public static const ERROR:String = "dataError";
		
		
		public var data:*;
		
		public function AMFLoaderEvent(name:String , data:*):void {
			super(name);
			this.data = data;
		}
		
	}

}