package turbosqel.analizerVisual {
	import asset.*;
	import flash.text.TextFormat;
	import turbosqel.display.Text;
	
	import com.bit101.components.Calendar;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import turbosqel.analizer.Analize;
	import turbosqel.analizer.AnalizeEvent;
	import turbosqel.analizer.DynamicType;
	import turbosqel.analizer.IAnalize;
	import turbosqel.analizer.IAnalizeParent;
	import turbosqel.console.Console;
	import turbosqel.data.LVar;
	import turbosqel.display.SpriteShape;
	import turbosqel.display.TextSetter;
	import turbosqel.net.Alias;

	/**
	 * ...
	 * @author Gerard Sławiński || turbosqel
	 */
	public class AnalizeItem extends Sprite {
		//////////////////////////////////////////////////////////////////////////////////////////////////
		//////////////////////////////////////////////////////////////////////////////////////////////////
		
		//<------------------------------ PARAMS
		
		public static var format:TextFormat = new TextFormat(new AnalizeFont().fontName,12);
		
		public static var borderColor:uint = 0xd1d1d1;
		public static var Yoffset:int = 5;
		public static var YText:int = 1;
		
		public var id:int;
		public var analize:IAnalize;
		public var analizeChildren:Array;
		public var top:AnalizeTree;
		public var childOf:AnalizeItem;
		public var depth:int;
		
		protected var hasChildren:Boolean;
		
		protected var background:SpriteShape = SpriteShape.rectangle(0, 0, 100, 20, 0xe0e0e0 );
		
		protected var offset:Number
		
		
		protected var targetName:TextSetter;
		protected var targetValue:TextSetter;
		
		//////////////////////////////////////////////////////////////////////////////////////////////////
		//////////////////////////////////////////////////////////////////////////////////////////////////
		
		//<------------------------------ INIT
		
		public function AnalizeItem(top:AnalizeTree , childOf:AnalizeItem , target:IAnalize):void {
			
			this.analize = target;
			this.top = top;
			this.childOf = childOf;
			depth= target.depth
			offset = depth * 20;
			if (target is IAnalizeParent) {
				hasChildren = true;
				analizeChildren  = (analize as IAnalizeParent).children;
				addGraphic(Expander , expand).y = Yoffset;
				checkForChildren();
				UIName();
				if (target.target is Array) {
					addGraphic(ArrayUnshift , newArrayShift ,5).y = Yoffset;
					addGraphic(ArrayPush , newParam , 5).y = Yoffset;
				} else {
					addGraphic(Append , newParam , 5).y = Yoffset;
				};
				addGraphic(AddArray , newArray , 5).y = Yoffset;
				addGraphic(AddObject , newObject , 5).y = Yoffset;
			} else {
				UIName();
				UIEqals();
				UIValue();
			};
			addGraphic(TrashButton , deleteValue , 5).y = Yoffset;
			background.height = this.height + 2;
			background.width = offset + 10;
			addChildAt(background, 0);
			
			
			
			
			
			
			addEventListener(MouseEvent.CLICK , selected);
		};
		
		//////////////////////////////////////////////////////////////////////////////////////////////////
		//////////////////////////////////////////////////////////////////////////////////////////////////
		
		//<------------------------------ DISPLAY ELEMENTS
		
		
		protected function addElement(item:DisplayObject , addOffset:int = 0):void {
			addChild(item).x = offset + addOffset;
			offset = item.x + item.width;
		};
		
		protected function addGraphic(type:Class , onClick:Function , offset:int = 0 ):Sprite {
			var item:Sprite = new type();
			addElement(item, offset);
			item.addEventListener(MouseEvent.CLICK , onClick);
			return item;
		}
		
		protected function UIName():void {
			targetName = new TextSetter(new LVar(this , "valueName"));
			targetName.setTextFormat(format);
			targetName.backgroundColor = 0xeeeeee;
			targetName.background = true;
			targetName.defaultTextFormat = format;
			targetName.width = 200;
			targetName.y = YText;
			targetName.borderColor = borderColor;
			targetName.border = true;
			addElement(targetName);
		};
		
		protected function UIEqals():void {
			var item:Text = new Text();
			item.text = " =";
			item.selectable = false;
			UTextField.autoSizeLeft(item);
			addElement(item);
		};
		
		protected function UIValue():void {
			targetValue = new TextSetter(new LVar(this , "valueTarget"));
			targetValue.defaultTextFormat = format;
			targetValue.backgroundColor = 0xeeeeee;
			targetValue.y = YText;
			targetValue.background = true;
			targetValue.width = 150;
			addElement(targetValue , 10);
		};
		
		
		
		
		
		//////////////////////////////////////////////////////////////////////////////////////////////////
		//////////////////////////////////////////////////////////////////////////////////////////////////
		
		//<------------------------------ CONTROLER
		
		public var expanded:Boolean;
		protected function expand(e:MouseEvent):void {
			if(!expanded){
				e.currentTarget.play();
				top.show(this);
			}else {
				e.currentTarget.play();
				top.hide(this);
			};
			expanded = !expanded;
		};
		
		
		protected function selected(e:MouseEvent):void {
			if(analize && analize.root){
				analize.root.dispatchEvent(new AnalizeEvent(AnalizeEvent.CHOOSE, analize));
			};
		};
		
		//<-------- TARGET ELEMENTS MODIFICATION
		
		
		protected function newArrayShift(e:MouseEvent):void {
			analize.target.unshift("");
			redraw(true);
		};
		
		protected function newParam(e:MouseEvent):void {
			addParamToTarget("");
		};
		protected function newArray(e:MouseEvent):void {
			addParamToTarget(new Array());
		};
		protected function newObject(e:MouseEvent):void {
			addParamToTarget(new Object());
		};
		
		protected function addParamToTarget(type:* = ""):void {
			if (analize.target == null) {
				return;
			};
			if (analize.target is Array) {
				var name:String = analize.target.length;
			}else{
				name = "param";
				var i:int;
				while (analize.target[name + i] != undefined) {
					i++;
				};
				name = name + i;
			};
			setupParam(name , type);
		};
		
		
		public function setupParam(key:String , value:* = null):void {
			analize.target[key] = value;
			redraw(true);
		};
		
		public function redraw(andExpand:Boolean = false , redrawTree:Boolean = true):void {
			if(redrawTree && analize is IAnalizeParent){
				(analize as IAnalizeParent).invalidateChildren();
			};
			checkForChildren();
			if(expanded || andExpand){
				top.hide(this , false);
				top.show(this , redrawTree);
				expanded = true;
				UDisplay.getChildByType(this , Expander).gotoAndStop(2);
			};
		};
		
		protected function checkForChildren():void {
			if (analize is IAnalizeParent && (analize as IAnalizeParent).children) {
				if((analize as IAnalizeParent).children.length == 0){
					UDisplay.getChildByType(this , Expander).visible = false;
				}else {
					UDisplay.getChildByType(this , Expander).visible = true;
				}
			};
		};
		
		
		//<-------- TARGET MODIFICATION
		
		protected function deleteValue(e:MouseEvent):void {
			analize.deleteValue();
			childOf.redraw();
			top.draw();
			remove();
		};
		
		public function set valueName(value:String):void {
			analize.rename(value);
		};
		
		public function get valueName():String {
			return analize.name;
		};
		
		public function get valueTarget():* {
			return String(analize.target);
		};
		
		public function set valueTarget(value:*):void {
			if (!isNaN(value)) {
				analize.target = Number(value);
			} else {
				analize.target = value;
			};
			
		};
		
		
		public function invalidate():Boolean {
			if (analize.parent) {
				if(hasChildren && analizeChildren != (analize as IAnalizeParent).children){
					redraw(false , false);
					analizeChildren = (analize as IAnalizeParent).children;
				};
				targetName.text = valueName;
				if(targetValue){
					targetValue.text = valueTarget;
				};
				return true;
			};
			remove();
			return false;
		};
		
		
		
		
		//////////////////////////////////////////////////////////////////////////////////////////////////
		//////////////////////////////////////////////////////////////////////////////////////////////////
		
		//<------------------------------ REMOVE
		
		
		public function remove():void {
			analizeChildren = null;
			for (var i:int = numChildren -1; i < 0 ; i--) {
				getChildAt(i)["remove"]();
			};
			UDisplay.remove(this);
		};
		
		
		
		
	}

}