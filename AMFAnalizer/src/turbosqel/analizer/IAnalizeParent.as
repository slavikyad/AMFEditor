package turbosqel.analizer {
	
	/**
	 * ...
	 * @author Gerard Sławiński || turbosqel
	 */
	public interface IAnalizeParent extends IAnalize {
		
		/**
		 * function for parsing children params and methods , return new IAnalize objects Array
		 * @return		Array with IAnalize objects
		 */
		function parseChildren():Array;
		
		function get children():Array;
		
		
		/**
		 * create new label
		 */
		function invalidateChildren():void;
		
		
		///// elements from Describe
		
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
	};
	
}