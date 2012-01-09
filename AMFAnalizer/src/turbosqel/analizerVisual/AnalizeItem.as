package turbosqel.analizerVisual 
{
	import asset.Append;
	import asset.Expander;
	import asset.TrashButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import turbosqel.analizer.Analize;
	import turbosqel.analizer.DynamicType;
	import turbosqel.analizer.IAnalize;
	import turbosqel.analizer.IAnalizeEdit;
	import turbosqel.analizer.IAnalizeParent;
	import turbosqel.console.Console;
	import turbosqel.data.LVar;
	import turbosqel.display.TextSetter;
	/**
	 * ...
	 * @author Gerard Sławiński || turbosqel
	 */
	public class AnalizeItem extends Sprite {
		
		
		public var id:int;
		
		public var targetName:TextSetter;
		
		public var eqals:TextField;
		
		public var targetValue:TextSetter;
		
		public var target:IAnalize;
		
		public var top:AnalizeTree
		
		public var childOf:AnalizeItem;
		
		public var append:Append;
		public var exp:Expander;
		public var trash:TrashButton;
		
		public var depth:int;
		
		protected var offset:Number
		
		public function AnalizeItem(top:AnalizeTree , childOf:AnalizeItem , target:IAnalize):void {
			this.target = target;
			this.top = top;
			this.childOf = childOf;
			depth= target.depth
			offset = depth * 20;
			if (target is IAnalizeParent) {
				addExpander();
				addName();
				addAppend();
			}else {
				addName();
				addEqals()
				addValue();
			};
			
			addTrash();
			
			
			
		};
		
		protected function addExpander():void {
			exp = new Expander();
			addChild(exp);
			exp.x = offset;
			exp.y = 2;
			exp.addEventListener(MouseEvent.CLICK , msd);
			offset = exp.x + exp.width;
		}
		
		protected function addName():void {
			targetName = new TextSetter(new LVar(this , "valueName"));
			targetName.border = true;
			targetName.width = 100;
			targetName.x = offset;
			offset = targetName.x + targetName.width;
			addChild(targetName);
		};
		
		protected function addEqals():void {
			eqals = new TextField();
			eqals.text = " =";
			UTextField.autoSizeLeft(eqals);
			eqals.x = offset;
			offset = eqals.x + eqals.width;
			addChild(eqals);
		};
		
		protected function addValue():void {
			targetValue = new TextSetter(new LVar(this , "valueTarget"));
			targetValue.border = true;
			targetValue.width = 150;
			targetValue.x = offset + 10;
			offset = targetValue.x + targetValue.width;
			addChild(targetValue);
		};
		
		
		protected function addAppend():void {
			append = new Append();
			append.x = offset + 10;
			offset = append.x + append.width;
			append.y = 2;
			addChild(append);
			append.addEventListener(MouseEvent.CLICK , addParam);
		};
		
		protected function addTrash():void {
			trash = new TrashButton();
			trash.x = offset + 10;
			offset = trash.x + trash.width;
			trash.y = 2;
			addChild(trash);
			trash.addEventListener(MouseEvent.CLICK , deleteValue);
		};
		
		
		
		public var expanded:Boolean;
		protected function msd(e:MouseEvent):void {
			if(!expanded){
				e.currentTarget.play();
				top.show(this);
			}else {
				e.currentTarget.play();
				top.hide(this);
			};
			expanded = !expanded;
		};
		
		protected function addParam(e:MouseEvent):void {
			var name:String = "value";
			var i:int;
			while (target.target[name + i] != undefined) {
				i++;
			};
			(target as DynamicType).addParam(name + i , name + i);
			if(expanded){
				top.hide(this);
				top.show(this);
			};
		};
		
		
		protected function deleteValue(e:MouseEvent):void {
			(target as IAnalizeEdit).deleteValue();
			top.draw();
			remove();
		};
		
		
		
		public function set valueName(value:String):void {
			(target as IAnalizeEdit).rename(value);
		};
		
		public function get valueName():String {
			return target.name;
		};
		
		public function get valueTarget():* {
			return String(target.target);
		};
		
		public function set valueTarget(value:*):void {
			if (!isNaN(value)) {
				target.target = Number(value);
			} else {
				target.target = value;
			};
			
		};
		
		
		
		
		
		public function invalidate():Boolean {
			if (target.parent) {
				targetName.text = valueName;
				if(targetValue){
					targetValue.text = valueTarget;
				}
				return true;
			};
			remove();
			return false;
		};
		
		
		
		
		
		
		
		public function remove():void {
			UDisplay.remove(this);
			UDisplay.removeChildren(this);
		}
		
		
		
		
	}

}