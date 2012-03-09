package turbosqel.analizer {
	
	/**
	 * ...
	 * @author Gerard Sławiński || turbosqel
	 */
	public interface IAnalizeParent extends IAnalize {
		
		////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////
		
		// <-------------------------- CHILDREN FUNCTIONS
		
		/**
		 * function for parsing children params and methods , return new IAnalize objects Array
		 * @return		Array with IAnalize objects
		 */
		function parseChildren():Array;
		
		/**
		 * return array of analizes with object elements
		 */
		function get children():Array;
		
		
		/**
		 * create new label
		 */
		function invalidateChildren():void;
		
		////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////
		
		// <-------------------------- INFORMATIONS ABOUT OBJECT
		// ?? => elements from DescribeType
		
		/**
		 * analize target is Dynamic
		 */
		function get isDynamic():Boolean;
		/**
		 * analize class is Final
		 */
		function get isFinal():Boolean;
		/**
		 * analize target is Static
		 */
		function get isStatic():Boolean;
		
		////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////
		
		// <-------------------------- CHILDREN MANIPULATION
		
		/**
		 * remove param under key ( delete this[key] )
		 * @param	key			key to value
		 */
		function deleteParam(key:*):Boolean;
		
		/**
		 * provide operation this[to] = this[from] and clean up .
		 * @param	from		actual key
		 * @param	to			new key
		 */
		function renameParam(from:* , to:*):Boolean;
		
		
	};
	
}