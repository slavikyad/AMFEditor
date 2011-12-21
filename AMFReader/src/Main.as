package {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getQualifiedClassName;
	import turbosqel.net.Alias;
	import turbosqel.net.serialization.AMFLoader;
	import turbosqel.net.serialization.AMFLoaderEvent;
	import turbosqel.net.serialization.Serial;
	import turbosqel.net.serialization.SerialAMFLoader;
	
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
		
		public var field:TextField = new TextField()
		
		public function Main():void  {
			
			/// field for display result :
			addChild(field);
			field.width = field.height = 500;
			field.border = true;
			////////////////////////////////////////////////////////////////////////////////////
			////////////////////////////////////////////////////////////////////////////////////
			
			//<--- .amf3
			
			///
			///  Before parsing files , always register class alias
			///  For tests , here i add Point and Rectangle class , because i expect this classes in exampleData.amf3 file
			///  If You dont want to add each alias , use turbosqel.net.serialization.Serial class ( .samf3 )
			///
			
			Alias.addClass(Point , Rectangle);
			
			///
			/// load exampleData.amf3 and listen for over :
			///
			
			var loadData:AMFLoader = new AMFLoader("exampleData.amf3");
			loadData.addEventListener(AMFLoaderEvent.RESULT , loadedData);
			loadData.addEventListener(AMFLoaderEvent.ERROR , loadError);
			
			
			////////////////////////////////////////////////////////////////////////////////////
			////////////////////////////////////////////////////////////////////////////////////
			
			//<--- .samf3
			
			///
			/// load exampleData.samf3 and listen for over :
			/// add only classes that instances Your object use as subitems
			///
			
			var loadSerial:SerialAMFLoader = new SerialAMFLoader("exampleData.samf3");
			loadSerial.addEventListener(AMFLoaderEvent.RESULT , loadedSerial);
			loadSerial.addEventListener(AMFLoaderEvent.ERROR , loadError);
			
		};
		
		///
		/// always handle error stuff , even if You are more than sure ...
		/// for AMFLoaderEvent.ERROR  event.data is catched error
		///
		private function loadError(e:AMFLoaderEvent):void {
			trace(e.data);
		}
		
		///
		/// after amf3 load :
		///
		private function loadedData(e:AMFLoaderEvent):void {
			field.appendText("\n load " + e.target.url + " result:\n");
			/// loop for loaded object params :
			for (var name:String in e.data) {
				field.appendText(name + " :  [" + type(e.data[name]) + "]  " + e.data[name] + "\n");
			}
			///
		};
		
		
		///
		/// after samf3 load :
		///
		private function loadedSerial(e:AMFLoaderEvent):void {
			field.appendText("\n load " + e.target.url + " result:\n");
			/// loop for loaded object params :
			var result:Serial = e.data;
			for (var name:String in result.data) {
				field.appendText(name + " :  [" + type(result.data[name]) + "]  " + result.data[name] + "\n");
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