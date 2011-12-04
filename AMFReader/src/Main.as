package {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.utils.getQualifiedClassName;
	import turbosqel.net.serialization.AMFLoader;
	import turbosqel.net.serialization.AMFLoaderEvent;
	
	/**
	 * ////////////////////////////////////////////////////////////////////////////////////
	 * ////////////////////////////////////////////////////////////////////////////////////
	 * ...
	 * @author Gerard Sławiński || turbosqel
	 * ...
	 * 
	 * Test project for loading amf3 data from file .
	 * 
	 * 
	 * 
	 * ////////////////////////////////////////////////////////////////////////////////////
	 * ////////////////////////////////////////////////////////////////////////////////////
	 */
	public class Main extends Sprite {
		
		public function Main():void  {
			////////////////////////////////////////////////////////////////////////////////////
			////////////////////////////////////////////////////////////////////////////////////
			
			///
			///  Before parsing files , always register class alias
			///  For tests , here i add Point and Rectangle class , because i expect this classes in exampleData.amf3 file
			///  If You dont want to add each alias , use turbosqel.net.serialization.Serial class ( .samf3 )
			///
			
			AMFLoader.addClasses(Point , Rectangle);
			
			///
			/// load exampleData.amf3 and listen for over :
			///
			
			var loadData:AMFLoader = new AMFLoader("exampleData.amf3");
			loadData.addEventListener(AMFLoaderEvent.RESULT , loadedData);
			loadData.addEventListener(AMFLoaderEvent.ERROR , loadError);
			
		};
		
		///
		/// always handle error stuff , even if You more than sure ...
		/// for AMFLoaderEvent.ERROR  event.data is catched error
		///
		private function loadError(e:AMFLoaderEvent):void {
			trace(e.data);
		}
		
		///
		/// after data load :
		///
		private function loadedData(e:AMFLoaderEvent):void {
			/// field for display result :
			var field:TextField = addChild(new TextField) as TextField;
			field.width = field.height = 500;
			field.border = true;
			field.text = "load " + e.target.url + " result:\n"
			/// loop for loaded object params :
			for (var name:String in e.data) {
				field.appendText(name + " :  [" + type(e.data[name]) + "]  " + e.data[name] + "\n");
			}
			///
		}
		
		
		///
		/// quick string parse :
		///
		private function type(value:*):String {
			return value != null ? getQualifiedClassName(value) : " null ";
		};
		
	}
	
}