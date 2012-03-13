package turbosqel {
	import com.bit101.components.Label;
	import com.bit101.components.PushButton;
	import com.bit101.components.Window;
	import flash.desktop.ClipboardFormats;
	import flash.desktop.NativeApplication;
	import flash.desktop.NativeDragManager;
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NativeDragEvent;
	import flash.filesystem.File;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import turbosqel.analizer.Analize;
	import turbosqel.analizerVisual.AnalizeTree;
	import turbosqel.net.FileData;
	
	/**
	 * ...
	 * @author Gerard Sławiński || turbosqel
	 */
	public class AMFEditorLite extends Sprite {
		
		////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////
		
		// <-------------------------- STATIC VALUES
		
		public static var analizeTree:AnalizeTree = new AnalizeTree();
		
		private static var _file:FileData;
		static public function get file():FileData {
			return _file;
		};
		
		static public function set file(value:FileData):void {
			if (_file) {
				_file.remove();
			};
			_file = value;
		};
		
		public var aboutWindow:Window;
		
		////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////
		
		// <-------------------------- APP START
		
		public function AMFEditorLite():void {
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			setupNativeMenu();
			addChild(analizeTree);
			onResize();
			stage.addEventListener(Event.RESIZE , onResize);
			addEventListener(NativeDragEvent.NATIVE_DRAG_ENTER , nativeFile);
			addEventListener(NativeDragEvent.NATIVE_DRAG_DROP , nativeFileDrop);
			createAboutWindow();
		};
		
		////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////
		
		// <-------------------------- ABOUT WINDOW
		
		private function createAboutWindow():void {
			aboutWindow = new Window(null , 100, 100);
			aboutWindow.setSize(300, 230);
			new PushButton(aboutWindow, 190, 180, "close", closeWindow);
			new PushButton(aboutWindow, 10, 180, "github", UFunction.delegateEvent(function():void {navigateToURL(new URLRequest("https://github.com/turbosqel/AMFEditor"))}));
			new Label(aboutWindow , 10, 10,"AMFEditor lite for AIR.\n\nCreated by Gerard Sławinski || turbosqel.pl \n\nApplication allow to edit simple AMF data types , save/load/create files.\nFor more detiles check github project page." );
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////
		
		// <-------------------------- NATIVE DRAG
		
		private function nativeFile(e:NativeDragEvent):void {
			NativeDragManager.acceptDragDrop(this);	
			trace("accept");
		};
		private function nativeFileDrop(e:NativeDragEvent):void {
			var dragFile:File = e.clipboard.getData(ClipboardFormats.FILE_LIST_FORMAT)[0];
			if (dragFile) {
				file = new FileData(dragFile.url);
			};
		};
		
		////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////
		
		// <-------------------------- STAGE RESIZE
		
		private function onResize(e:Event = null):void {
			analizeTree.width = stage.stageWidth;
			analizeTree.height = stage.stageHeight;
		};
		
		////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////
		
		// <-------------------------- NATIVE MENU SETUP
		
		public function setupNativeMenu():void {
			var menu:NativeMenu = new NativeMenu();
			var file:NativeMenu = new NativeMenu();
			var newMenu:NativeMenu = new NativeMenu();
			newMenu.addItem(new NativeMenuItem("Object"));
			newMenu.addItem(new NativeMenuItem("Array"));
			file.addSubmenu(newMenu,"New");
			file.addItem(new NativeMenuItem("Load"));
			file.addItem(new NativeMenuItem("Save"));
			file.addItem(new NativeMenuItem("",true));
			file.addItem(new NativeMenuItem("Exit"));
			menu.addSubmenu(file, "File");
			menu.addItem(new NativeMenuItem("About"));
			menu.addEventListener(Event.SELECT, fileMenuSelect);
			stage.nativeWindow.menu = menu;
		};
		
		
		private function fileMenuSelect(e:Event):void {
			switch(e.target["label"]) {
				case "Object":
					analizeTree.analize = Analize.parse("newObject", new Object() );
					file = new FileData();
					return;
				case "Array" :
					analizeTree.analize = Analize.parse("newArray", new Array() );
					file = new FileData();
					return;
				case "Load":
					file = new FileData();
					file.browseForOpen("Choose AMF file");
					return;
				case "Save":
					file.saveFile();
					return;
				case "Exit":
					NativeApplication.nativeApplication.exit();
					return;
				case "About" :
					addChild(aboutWindow);
					aboutWindow.x = 100;
					aboutWindow.y = 100;
					return;
			}
		};
		
		private function closeWindow(e:MouseEvent):void {
			removeChild(aboutWindow);
		};
		
		////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////
		
		// <-------------------------- 
		
	}

}