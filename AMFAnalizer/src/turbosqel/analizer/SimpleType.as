package turbosqel.analizer 
{
	import flash.utils.getQualifiedClassName;
	import turbosqel.data.LVar;
	import turbosqel.analizer.AnalizeType;
	/**
	 * ...
	 * @author Gerard Sławiński
	 */
	public class SimpleType extends ValueType implements IAnalizeEdit {
		
		/**
		 * create new SimpleType IAnalize object for String int Number ...
		 * @param	parent			parent object IAnalizeParent
		 * @param	target			target object to analize
		 * @param	access			access mode
		 * @param	forceType		force class alias
		 */
		public function SimpleType(parent:IAnalizeParent , target:LVar , access:String = "readwrite" , forceType:String = null):void {
			super(parent, target, access, forceType);
		};
		
		
		////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////
		
		// <-------------------------- EDIT FUNCTIONS
		
		public function rename(newName:String):void {
			var exist:IAnalize = UArray.searchValues(_parent.children , "name" , newName);
			if (exist) {
				exist.remove();
				UArray.searchAndSlice(_parent.children , exist);
			};
			
			content.target[newName] = content.value;
			delete content.target[content.key];
			content.key = newName;
			
			root.invalidate();
		};
		
		public function deleteValue():void {
			content.value = null;
			UArray.searchAndSlice(_parent.children , this);
			root.invalidate();
			remove();
		};
		
		
		
		
		
	}

}