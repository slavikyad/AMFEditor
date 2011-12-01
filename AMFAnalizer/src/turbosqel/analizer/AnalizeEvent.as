package turbosqel.analizer
{
	import flash.events.Event;
	
	public class AnalizeEvent extends Event{
		
		
		public static const INVALIDATE:String = "redrawTree";
		
		
		public function AnalizeEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false){
			super(type, bubbles, cancelable);
		}
	}
}