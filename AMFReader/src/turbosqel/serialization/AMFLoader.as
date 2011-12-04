package turbosqel.serialization 
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.registerClassAlias;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * ...
	 * @author Gerard Sławiński || turbosqel
	 */
	 
	public class AMFLoader extends URLLoader {
		
		public static const LOADING:String = "loading";
		public static const PARSING:String = "parsing";
		
		
		
		public static function addClasses(... args):void {
			for (var i:int = 0; i < args.length; i++) {
				registerClassAlias(getQualifiedClassName(args[i]),args[i]);
			};
		}
		
		
		
		public var result:*;
		
		public function AMFLoader(url:String = null):void {
			addEventListener(Event.COMPLETE , complete);
			addEventListener(IOErrorEvent.IO_ERROR , error);
			addEventListener(SecurityErrorEvent.SECURITY_ERROR , error);
			dataFormat = URLLoaderDataFormat.BINARY;
			if (url) {
				load(new URLRequest(url));
			}
		};
		
		protected function error(e:Event):void {
			dispatchEvent(new AMFLoaderEvent(AMFLoaderEvent.ERROR , e ));
		};
		
		protected function complete(e:Event):void {
			e.target.removeEventListener(e.type , arguments.callee);
			////////////////////////////////////////////////////////
			try {
				var bytes:ByteArray = data;
				bytes.uncompress();
				bytes.position = 0;
				result = bytes.readObject();
				dispatchEvent(new AMFLoaderEvent(AMFLoaderEvent.RESULT , result ));
			} catch (e:Error) {
				dispatchEvent(new AMFLoaderEvent(AMFLoaderEvent.ERROR , e ));
			};
		}
		
		
		
	}

}