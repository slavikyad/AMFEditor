package turbosqel.net {
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	import turbosqel.AMFEditorLite;
	import turbosqel.analizer.Analize;
	import turbosqel.events.ISoftDispatcher;
	
	/**
	 * ...
	 * @author Gerard Sławiński || turbosqel
	 */
	public class FileData extends File implements ISoftDispatcher {
		
		////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////
		
		// <-------------------------- PARAMS
		
		protected var andSave:Boolean;
		protected var initialized:Boolean;
		
		////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////
		
		// <-------------------------- INIT
		
		public function FileData(target:String = null , andLoad:Boolean = true) {
			addEventListener(Event.SELECT , selectFile);
			addEventListener(Event.COMPLETE , loadComplete);
			if (target) {
				url = target;
				initialized = true;
				if (exists && andLoad) {
					load();
				};
			};
		};
		
		////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////
		
		// <-------------------------- HANDLERS
		
		private function loadComplete(e:Event):void {
			try {
				data.uncompress();
				var result:Object = data.readObject();
				AMFEditorLite.analizeTree.analize = Analize.parse(name , result);
			} catch (er:Error) { };
		};
		
		private function selectFile(e:Event):void {
			initialized = true;
			if (andSave) {
				saveFile();
				andSave = false;
			} else {
				load();
			};
		};
		
		public function saveFile():void {
			if (initialized && url) {
				var fs:FileStream = new FileStream();
				fs.open(this , FileMode.WRITE);
				var bytes:ByteArray = new ByteArray();
				bytes.writeObject(AMFEditorLite.analizeTree.analize.target);
				bytes.compress();
				bytes.position = 0;
				fs.writeBytes(bytes);
				fs.close();
				AMFEditorLite.analizeTree.analize.name = name;
			} else {
				andSave = true;
				browseForSave("Browse for AMF file");
			};
		};
		
		///////////////////////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////////////
		//		ISoftDispatcher
		// soft dispatcher instance : copy block :
		import turbosqel.events.SoftEventDispatcher;
		
		public override function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void{
			SoftEventDispatcher.registerSoftListener(this , type , listener);
			super.addEventListener(type, listener, useCapture, priority , useWeakReference);
		};
		
		public override function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void{
			if(useCapture || SoftEventDispatcher.unregisterSoftListener(this , type , listener)){
				super.removeEventListener(type , listener );
			};
		};
		
		public function removeAllListeners():void {
			SoftEventDispatcher.removeAllListeners(this);
		};
		
		public function numListeners():int {
			return SoftEventDispatcher.numListeners(this);
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////
		
		// <-------------------------- REMOVE
		
		public function remove():void {
			removeAllListeners();
			cancel();
			if (data) {
				data.clear();
			};
			
		};
	}

}