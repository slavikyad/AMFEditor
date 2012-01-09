package turbosqel.analizerVisual {
	import com.bit101.components.ScrollBar;
	import com.bit101.components.VScrollBar;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import turbosqel.analizer.Analize;
	import turbosqel.analizer.AnalizeEvent;
	import turbosqel.console.Console;
	import turbosqel.display.SpriteShape;
	
	/**
	 * @author Gerard Sławiński || turbosqel
	 * analize tree (pure as3 + bit101 components)
	 */
	public class AnalizeTree extends Sprite {
		
		
		public var sc:VScrollBar;
		public var content:Sprite = new Sprite();
		public var masker:SpriteShape = SpriteShape.rectangle();
		public var background:SpriteShape = SpriteShape.rectangle(0,0,100,100,0xF1F1F1);
		
		
		
		
		public function AnalizeTree():void {
			///
			/// content
			///
			addChild(content);
			//content.addChild(SpriteShape.rectangle(0,0,180,800,0x123456,0.1));
			addChild(masker);
			content.mask = masker;
			
			///
			/// scroll
			///
			sc = new VScrollBar(this , 180 , 0 , scroll);
			sc.setSliderParams(0 , 1 , 0);
			sc.width = 20;
			sc.height = 200;
			sc.autoHide = false;
			sc.lineSize = 10;
			sc.pageSize = 1;
			sc.setThumbPercent(0.3);
			addChild(sc);
			
			resizeContent();
			
			Console.Trace(this , x , y , width , height );
			Console.Trace(this , sc.width , sc.height );
			
			// back
			addChildAt(background , 0);
			
			
			addEventListener(MouseEvent.MOUSE_WHEEL , scrolled);
		};
		
		
		
		public function set analize(analize:Analize):void {
			analize.addEventListener(AnalizeEvent.INVALIDATE , UFunction.delegateEvent(draw));
			slots.push(new AnalizeItem(this ,null, analize.analize));
			draw();
		};
		
		public function addAt(item:AnalizeItem , at:int):void {
			slots.splice(at , 0 , item);
			draw();
		};
		
		public function show(item:AnalizeItem):void {
			var add:Array = new Array();
			for (var i:int ; i < item.target["children"].length; i++ ) {
				add.push(new AnalizeItem(this , item, item.target["children"][i]));
			};
			slots.splice.apply(null , [item.id + 1, 0].concat(add));
			draw();
		};
		
		public function hide(item:AnalizeItem):void {
			var depth:int = item.depth;
			for (var i:int = item.id + 1 ; i < slots.length ; i ++ ) {
				if (slots[i].depth <= depth) {
					break;
				};
			};
			UArray.executeAndRemove(slots.splice(item.id +1 , i - item.id -1),"remove");
			draw();
		};
		
		protected var slots:UArray = new UArray();
		public function draw():void {
			for (var i:int ; i < slots.length ; i++ ) {
				if (slots[i].invalidate()) {
					slots[i].y = 25 * i;
					slots[i].id = i;
					content.addChild(slots[i]);
				}else{
					slots.splice(i, 1);
					i--;
				};
			};
			resizeContent();
		};
		
		
		
		
		
		
		
		
		
		
		
		public function scrolled(e:MouseEvent):void {
			if(sc.enabled){
				sc.value -= e.delta / content.height * 10 ;
				scroll();
			}
		};
		
		public function scroll(e:Event = null):void {
			content.y = - sc.value * (content.height - masker.height + 10);
		};
		
		override public function get height():Number {
			return super.height;
		};
		
		override public function set height(value:Number):void {
			masker.height = value;
			sc.height = value;
			background.height = value;
			resizeContent();
		};
		
		override public function get width():Number {
			return super.width;
		};
		
		override public function set width(value:Number):void {
			masker.width = value - sc.width;
			sc.x = value - sc.width;
			background.width = value;
			resizeContent();
		};
		
		
		
		public function resizeContent():void {
			if (content.width > masker.width) {
				
			};
			if (content.height > masker.height) {
				sc.enabled = true;
			} else {
				sc.enabled = false;
			};
			scroll();
		};
		
	}

}