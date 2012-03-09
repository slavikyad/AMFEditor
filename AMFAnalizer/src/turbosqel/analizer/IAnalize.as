package turbosqel.analizer{
	import turbosqel.data.LVar;
	public interface IAnalize {
		
		////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////
		
		// <-------------------------- VALUE INFORMATIONS
		
		/**
		 * get analize target
		 */
		function get target():*;
		/**
		 * set object to analize target and dispatch parseChildren on parent IAnalizeParent
		 */
		function set target(v:*):void;
		
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
		
		/**
		 * access mode
		 */
		function get access():String;
		
		/**
		 * param name
		 */
		function get name():String;
		
		/**
		 * target class name
		 */
		function get type():String;
		
		////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////
		
		// <-------------------------- ANALIZE INFORMATIONS
		
		/**
		 * Analize type class
		 */
		function get analizeType():Class;
		
		
		/**
		 * value depth from root object
		 */
		function get depth():int;
		
		/**
		 * return formated by Analize.makeLabel string;
		 */
		function get label():String;
		
		/**
		 * root Analize object
		 */
		function get root():Analize;
		
		
		////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////
		
		// <-------------------------- OPERATIONS
		
		/**
		 * rename (if param isnt dynamic) value key , override if something exist under new name
		 * @param		newName		new param key
		 */
		function rename(newName:String):Boolean;
		
		/**
		 * delete this target value and remove analize child
		 */
		function deleteValue():Boolean;
		
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