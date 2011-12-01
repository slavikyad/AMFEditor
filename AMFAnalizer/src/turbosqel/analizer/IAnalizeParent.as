package turbosqel.analizer 
{
	
	/**
	 * ...
	 * @author Gerard Sławiński || turbosqel
	 */
	public interface IAnalizeParent extends IAnalize {
		function parseChildren():Array;
		
		function invalidateChildren():void;
		
		
		function get isDynamic():Boolean;
		function get isFinal():Boolean;
		function get isStatic():Boolean;
	};
	
}