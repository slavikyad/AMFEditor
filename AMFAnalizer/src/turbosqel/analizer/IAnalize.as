package turbosqel.analizer{
	import turbosqel.data.LVar;
	public interface IAnalize {
		
		function get target():*;
		function set target(v:*):void;
		
		function get analizeType():Class;
		
		function get access():String;
		function get label():String;
		function get name():String;
		function get type():String;
		
		function get root():Analize;
		function invalidate():void;
		
		function remove():void;
	};
}