package turbosqel.analizer
{
	import flash.events.Event;
	
	public class AnalizeEvent extends Event{
		
		/// infromation about tree changes
		public static const INVALIDATE:String = "redrawTree";
		
		/**
		 * Analize Event
		 * @param	type	event name
		 */
		public function AnalizeEvent(type:String){
			super(type);
		}
	}
}