package turbosqel.analizer 
{
	import flash.utils.getQualifiedClassName;
	
	import turbosqel.console.Console;
	import turbosqel.data.LVar;
	/**
	 * ...
	 * @author Gerard Sławiński || turbosqel
	 */
	public class ValueType implements IAnalize {
		
		
		public var parent:IAnalizeParent;
		protected var content:LVar;
		protected var paramAccess:String;
		protected var paramType:String;
		internal var _root:Analize;
		
		
		public function ValueType(parent:IAnalizeParent , target:LVar , access:String = null , forceType:String = null):void {
			this.parent = parent;
			_root = parent.root;
			content = target;
			paramAccess = access || AnalizeType.READWRITE;
			paramType = forceType;
		}
		
		
		public function get access():String {
			return paramAccess;
		}
		
		
		public function set target(v:*):void {
			if ( access == AnalizeType.READWRITE || access == AnalizeType.WRITE){
				content.value = v;
			};
			invalidate();
		};
		
		public function get target():* {
			if ( access == AnalizeType.READWRITE || access == AnalizeType.READ){
				return content.value;
			}
		}
		
		
		public function get root():Analize {
			return _root;
		};
		
		
		public function invalidate():void {
			root.invalidate();
		};
		
		public function get label():String {
			return Analize.makeLabel(this);
		};
		
		public function toString():String {
			return label;
		};
		
		public function get name():String {
			return String(content.key);
		};
		
		public function get type():String {
			return paramType || getQualifiedClassName(content.value);
		};
		
		public function get analizeType():Class {
			return this["constructor"];
		}
		
		public function remove():void {
			parent = null;
			content.remove();
			content = null;
		}
		
	}

}