package {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.utils.getQualifiedClassName;
	import turbosqel.serialization.AMFLoader;
	import turbosqel.serialization.AMFLoaderEvent;
	
	/**
	 * ////////////////////////////////////////////////////////////////////////////////////
	 * ////////////////////////////////////////////////////////////////////////////////////
	 * ...
	 * @author Gerard Sławiński || turbosqel
	 * ...
	 * ////////////////////////////////////////////////////////////////////////////////////
	 * ////////////////////////////////////////////////////////////////////////////////////
	 */
	public class Main extends Sprite {
		
		public function Main():void  {
			////////////////////////////////////////////////////////////////////////////////////
			////////////////////////////////////////////////////////////////////////////////////
			AMFLoader.addClasses(Point , Rectangle);
			
			var loadData:AMFLoader = new AMFLoader("exampleData.amf3");
			loadData.addEventListener(AMFLoaderEvent.RESULT , loadedData);
			loadData.addEventListener(AMFLoaderEvent.ERROR , loadError);
		};
		
		private function loadError(e:AMFLoaderEvent):void {
			trace(e.data);
		}
		
		private function loadedData(e:AMFLoaderEvent):void {
			var field:TextField = addChild(new TextField) as TextField;
			field.width = field.height = 500;
			field.border = true;
			for (var name:String in e.data) {
				field.appendText(name + " :  [" + type(e.data[name]) + "]  " + e.data[name] + "\n");
			}
		}
		
		private function type(value:*):String {
			return value != null ? getQualifiedClassName(value) : " null ";
		};
		
	}
	
}