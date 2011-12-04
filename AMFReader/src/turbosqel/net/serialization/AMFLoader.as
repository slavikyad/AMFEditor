package turbosqel.net.serialization {
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.registerClassAlias;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.getQualifiedClassName;
	import flash.utils.setTimeout;
	
	/**
	 * ...
	 * @author Gerard Sławiński || turbosqel
	 */
	 
	public class AMFLoader extends URLLoader {
		
		
		///////////////////////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////////////
		//
		//<---------------- PARAMS
		
		/// loaded result :
		public var result:*;
		
		/// file url :
		public var url:String;
		
		///////////////////////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////////////
		//
		//<---------------- INIT
		/**
		 * create new loader/parser
		 * @param	url		target file
		 */
		public function AMFLoader(url:String = null):void {
			addEventListener(Event.COMPLETE , complete);
			addEventListener(IOErrorEvent.IO_ERROR , error);
			addEventListener(SecurityErrorEvent.SECURITY_ERROR , error);
			dataFormat = URLLoaderDataFormat.BINARY;
			if (url) {
				setTimeout(load , 0 , new URLRequest(url));
			}
		};
		
		///////////////////////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////////////
		//
		//<---------------- LOADING / PUBLIC
		
		/**
		 * load file by URLRequest
		 * @param	request
		 */
		override public function load(request:URLRequest):void {
			try {
				this.url = request.url;
				super.load(request);
			} catch (e:Error) {
				dispatchEvent(new AMFLoaderEvent(AMFLoaderEvent.ERROR , e ));
				remove();
			};
		};
		
		/**
		 * load file by string
		 * @param	url		file url link
		 */
		public function loadURL(url:String):void {
			load(new URLRequest(url));
		};
		
		
		///////////////////////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////////////
		//
		//<---------------- ERROR & COMPLETE/PARSER  / PROTECTED
		
		/**
		 * loading error
		 * @param	e		error event
		 */
		protected function error(e:Event):void {
			dispatchEvent(new AMFLoaderEvent(AMFLoaderEvent.ERROR , e ));
			remove();
		};
		
		
		/**
		 * loading operation complete , parse loaded data and dispatch end Event
		 * @param	e		complete event
		 */
		protected function complete(e:Event):void {
			e.target.removeEventListener(e.type , arguments.callee);
			////////////////////////////////////////////////////////
			try {
				////////////////////////////
				var bytes:ByteArray = data;
				bytes.uncompress();
				bytes.position = 0;
				result = bytes.readObject();
				////////////////////////////
				dispatchEvent(new AMFLoaderEvent(AMFLoaderEvent.RESULT , result ));
				
			} catch (e:Error) {
				dispatchEvent(new AMFLoaderEvent(AMFLoaderEvent.ERROR , e ));
				remove();
			};
		};
		
		///////////////////////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////////////
		//
		//<---------------- REMOVE
		
		public function remove():void {
			if(hasEventListener(IOErrorEvent.IO_ERROR){
				removeEventListener(Event.COMPLETE , complete);
				removeEventListener(IOErrorEvent.IO_ERROR , error);
				removeEventListener(SecurityErrorEvent.SECURITY_ERROR , error);
			}
			result = null;
			
		}
		
		
	}

}