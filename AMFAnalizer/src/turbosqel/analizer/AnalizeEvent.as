package turbosqel.analizer
{
	import flash.events.Event;
	
	public class AnalizeEvent extends Event{
		
		/// infromation about tree changes
		public static const INVALIDATE:String = "redrawTree";
		
		/// infromation about tree changes
		public static const CHOOSE:String = "choosed";
		
		
		
		
		
		
		public var item:IAnalize;
		
		/**
		 * Analize Event
		 * @param	type	event name
		 * @param	item	analize element
		 */
		public function AnalizeEvent(type:String , item:IAnalize = null):void{
			super(type);
			this.item = item;
		}
	}
}