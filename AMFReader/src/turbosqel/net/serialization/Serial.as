package turbosqel.net.serialization{
	
	import flash.net.getClassByAlias;
	import flash.net.registerClassAlias;
	import flash.utils.ByteArray;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import turbosqel.net.Alias;
	
	
	
	
	
	/**
	 * SerialAMF3
	 * 
	 * @author Gerard Sławiński || turbosqel
	 * 
	 * 
	 * Serial object for compress single/multiple objects with saving its aliases
	 * 
	 *  !!! All classes must be registered !!!
	 *  !!! So dont forget about any alias !!!
	 *  !!!  before writting and reading   !!!
	 * 
	 * 
	 * @usage sample :
		 * 
		 * Serial.init();								// setup class alias
		 * 
		 * var serial:Serial = new Serial(); 			// create instance
		 * serial.addItem(object1);						// add data , access to this will be serial.data[0];
		 * serial.addItem(object2);						// add data , access serial.data[1];
		 * serial.addItem(object3 , "object3");			// add data with key , access serial.data["object3"];
		 * 
		 * serial.addAliasToList("object2.subObject");	// add additional alias for instance we have in one of
		 * 												// out objects . addItem automatically add alias .
		 * 
		 * serial.compressed(true);						// not neccessary , but if You have lot of objects
		 * 												// You can split compressing all objects and end object
		 * 
		 * var bytes:ByteArray = serial.save();			// return compressed bytes , now You can save it as file !
		 * 
		 * var recreate:Serial = Serial.load(bytes);	// and serial instance is back
		 * recreate.compressed(false);					// uncompress items
		 * 
		 * for(var key:String in recreate.data){
		 * 		trace(key + ":" + recreate.data[key]);	// loop for read deserialized data
		 * }
		 * 
	 * 
	 * ////////////////////////////////////////////////////////
	 */
	
	
	
	

	public class Serial{
		/// Serial
		//////////////////////////////////////////////////////////////////////////////
		//////////////////////////////////////////////////////////////////////////////
		
		// <----------------------- STATIC INIT -- REGISTER NECESSARY CLASSES
		
		
		/**
		 * static init , register class aliases
		 * @return
		 */
		public static function init():void {
			Alias.addClass(Serial,ByteArray);
		};
		
		//////////////////////////////////////////////////////////////////////////////
		//////////////////////////////////////////////////////////////////////////////
		
		// <----------------------- PARSE BYTES TO SERIAL OBJECT
		
		/**
		 * load Serial object from bytes
		 * @param	bytes		target ByteArray
		 * @return				Serial or null
		 */
		public static function load(bytes:ByteArray):Serial {
			try {
				bytes.position = 0;
				bytes.uncompress();
				return bytes.readObject();
			}catch(e:Error){trace(Serial , e , "")};
			return null;
		};
		
		//////////////////////////////////////////////////////////////////////////////
		//////////////////////////////////////////////////////////////////////////////
		//////////////////////////////////////////////////////////////////////////////
		//////////////////////////////////////////////////////////////////////////////
		//////////////////////////////////////////////////////////////////////////////
		
		// <----------------------- PARAMS
		
		/// data handling information , if false - data is Array of objects and allow
		/// add multiple items
		public var singleObject:Boolean;
		/// aliases necessary to serialize data objects
		public var aliasList:Array;
		/// target object or Array of objects ( array with number indexes ( 0,1,2 ) and string keys ( data["param"] ))
		public var data:*;
		/// status infromation
		public var isCompressed:Boolean;
		
		//////////////////////////////////////////////////////////////////////////////
		//////////////////////////////////////////////////////////////////////////////
		
		// <----------------------- INIT
		
		/**
		 * create new Serial object
		 * @param	singleObject	if true , data will be added object , if false , data is Array with int and string keys
		 */
		public function Serial(singleObject:Boolean = false):void {
			// information about Serial data storage
			this.singleObject = singleObject;
			if (!singleObject) {
				/// if multiple objects , create array
				data = new Array();
			};
			/// aliases list
			aliasList = new Array();
		};
		
		//////////////////////////////////////////////////////////////////////////////
		//////////////////////////////////////////////////////////////////////////////
		
		// <----------------------- COMPRESS / DECOMPRESS
		
		/**
		 * set data state , compress to ByteArray or uncompress to AMF data
		 */
		public function compressed(value:Boolean):void {
			//////////////////////////
			//////////////////////////
			
			if(isCompressed == value){
				return;
			};
			//////////////////////////
			//////////////////////////
			registerAliasList();
			isCompressed = !isCompressed;
			//////////////////////////
			//////////////////////////
			switch(int(isCompressed) + int(singleObject) * 2 ) {
				/// uncompress multiple
				case 0:
					for (name in data) {
						bytes = data[name];
						bytes.position = 0;
						data[name] = bytes.readObject();
					};
					return;
				/// compress multiple
				case 1:
					for(var name:String in data){
						var bytes:ByteArray = new ByteArray();
						bytes.writeObject(data[name]);
						bytes.position = 0;
						data[name] = bytes;
					};
					return;
				/// uncompress single
				case 2:
					bytes = data;
					bytes.position = 0;
					data = bytes.readObject();
					return;
				case 3:
					/// compress single
					bytes = new ByteArray();
					bytes.writeObject(data);
					bytes.position = 0;
					data = bytes;
					return;
				///
			};
		};
		
		//////////////////////////////////////////////////////////////////////////////
		//////////////////////////////////////////////////////////////////////////////
		
		// <----------------------- ALIASES
		
		/**
		 * register alias list
		 */
		public function registerAliasList():void {
			for (var i:int ; i < aliasList.length ; i++) {
				try{ Alias.addType(aliasList[i]);
				} catch (e:Error) { throw "missing class:" + aliasList[i] };
			};
		};
		
		/**
		 * add alias to list
		 * @param	alias		class alias
		 */
		public function addAliasToList(alias:String):void {
			if (aliasList.indexOf(alias) == -1) {
				Alias.addType(alias);
				aliasList.push(alias);
			};
		};
		
		//////////////////////////////////////////////////////////////////////////////
		//////////////////////////////////////////////////////////////////////////////
		
		// <----------------------- OBJECTS
		
		/**
		 * Add item data .
		 * If singleObjects is set to true , function will set/overwrite new data .
		 * For multiple data objects , if itemAlias is null target is pushed to data Array but with
		 * itemAlias name data is linked to array by key   data[itemAlias] = target
		 * 
		 * 
		 * 
		 * @param	target			target object
		 * @param	itemAlias		Array key to data :: data[itemAlias] = target
		 */
		public function addItem(target:Object , itemAlias:String = null):void {
			////////////////////////
			/// add and register alias
			addAliasToList(getQualifiedClassName(target));
			////////////////////////
			var result:* = target;
			
			/// check fror Serial actual compression state :
			if(isCompressed){
				var bytes:ByteArray = new ByteArray();
				bytes.writeObject(target);
				result = bytes;
			};
			
			/// check for mode , if single - set/overwrite data
			if(singleObject){
				data = result;
				return
			}
			/// for multiple mode , push or add by key to Array
			if(itemAlias){
				data[itemAlias] = result;
			}else {
				data.push(result);
			};
				
		};
		
		
		//////////////////////////////////////////////////////////////////////////////
		//////////////////////////////////////////////////////////////////////////////
		
		// <----------------------- SAVE
		
		/**
		 * compress and write to ByteArray Serial object
		 * @return		serialized and compressed Serial object in bytes
		 */
		public function save():ByteArray {
			registerAliasList();
			var bytes:ByteArray = new ByteArray();
			compressed(true);
			bytes.writeObject(this);
			bytes.position = 0;
			bytes.compress();
			return bytes;
		}
		
		//////////////////////////////////////////////////////////////////////////////
		//////////////////////////////////////////////////////////////////////////////
		
		// <----------------------- REMOVE
		
		/**
		 * remove and release all instances
		 */
		public function remove():void {
			if (singleObject) {
				data = null;
			}else {
				for (var key:String in data) {
					delete data[key];
				};
			};
			data = null;
			
			if (aliasList) {
				for (key in aliasList) {
					delete aliasList[key];
				};
				aliasList = null;
			};
		};
		
		//////////////////////////////////////////////////////////////////////////////
		//////////////////////////////////////////////////////////////////////////////
		
	}
}