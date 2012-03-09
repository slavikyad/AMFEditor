package turbosqel.amfedit {
	import com.bit101.components.Label;
	import com.bit101.components.PushButton;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.ByteArray;
	import turbosqel.analizer.Analize;
	import turbosqel.analizerVisual.AnalizeTree;
	import turbosqel.firefly.Element;
	import turbosqel.firefly.FireCore;
	import turbosqel.firefly.MovieClipElement;
	import turbosqel.global.LocalObject;
	import turbosqel.net.bytes.ManageFile;
	
	/**
	 * ...
	 * @author Gerard Sławiński || turbosqel
	 */
	public class AMFEditLiteBrowser extends Sprite {
		
		
		public static const Default:Object = { someArray:["value1" , "value2"], someObject: { value1:"v1" , value2:"v2" }, someParam:"someParam" };
		
		public var tree:AnalizeTree = new AnalizeTree();
		public var info:Label;
		
		public function AMFEditLiteBrowser():void {
			super();
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.addEventListener(Event.RESIZE , resize);
			
			addChild(tree);
			tree.y = 22;
			tree.analize = Analize.parse("local", Default);
			loadlocalData();
			resize();
			
			
			new PushButton(this, 0, 0, "New Array" , newArray);
			new PushButton(this, 100, 0, "New Object" , newObject);
			
			new PushButton(this, 220, 0, "Load local" , loadlocalData);
			new PushButton(this, 320, 0, "Save local" , savelocalData);
			
			new PushButton(this, 440, 0, "Load file" , loadData);
			new PushButton(this, 540, 0, "Save file" , saveData);
			
			info = new Label(this, 470, 0);
		};
		
		public function loadlocalData(e:MouseEvent = null):void {
			var result:Object = LocalObject.load("amfel").data || Default;
			tree.analize.remove();
			tree.analize = Analize.parse(tree.analize.name,result);
		}
		
		public function savelocalData(e:MouseEvent = null):void {
			LocalObject.save("amfel","data",tree.analize.target);
		}
		
		public function set message(value:String):void {
			info.text = value;
		}
		
		public function saveData(e:MouseEvent):void {
			var ba:ByteArray = new ByteArray();
			ba.writeObject(tree.analize.target);
			ba.position = 0;
			ba.compress();
			ManageFile.save(ba, tree.analize.name);
			message = "file saved";
		}
		
		public function loadData(e:MouseEvent):void {
			new ManageFile().addEventListener(Event.COMPLETE , parseData);
		};
		protected function parseData(e:Event):void {
			var file:ManageFile = e.target as ManageFile;
			try {
				file.data.uncompress();
				var result:Object = file.data.readObject();
				tree.analize.remove();
				tree.analize = Analize.parse(file.name,result);
				message = "file loaded"
			}catch (e:Error) {
				message = "Invalid data";
				traceStack();
				newObject();
			};
		};
		
		public function newArray(e:MouseEvent = null):void {
			tree.analize = Analize.parse("instance", []);
		}
		public function newObject(e:MouseEvent = null):void {
			tree.analize = Analize.parse("instance",{});
		}
		
		public function resize(e:Event = null):void {
			tree.width = stage.stageWidth;
			tree.height = stage.stageHeight - 22;
		};
		
	};
	
};