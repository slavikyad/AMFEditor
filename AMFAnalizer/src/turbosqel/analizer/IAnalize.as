package turbosqel.analizer{
	import turbosqel.data.LVar;
	public interface IAnalize {
		
		/**
		 * get analize target
		 */
		function get target():*;
		/**
		 * set object to analize target and dispatch parseChildren on parent IAnalizeParent
		 */
		function set target(v:*):void;
		
		/**
		 * Analize type class
		 */
		function get analizeType():Class;
		
		/**
		 * path from root object to this value
		 */
		function get path():String;
		
		/**
		 * return parent analize object
		 */
		function get parent():IAnalizeParent;
		
		/**
		 * is strong typed
		 */
		function get strong():Boolean;
		function set strong(value:Boolean):void;
		/**
		 * access mode
		 */
		function get access():String;
		/**
		 * return formated by Analize.makeLabel string;
		 */
		function get label():String;
		/**
		 * param name
		 */
		function get name():String;
		/**
		 * target class name
		 */
		function get type():String;
		/**
		 * root Analize object
		 */
		function get root():Analize;
		/**
		 * dispatch info about label change
		 */
		function invalidate():void;
		/**
		 * remove IAnalize object
		 */
		function remove():void;
	};
}