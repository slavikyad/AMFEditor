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