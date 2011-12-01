package turbosqel.analizer 
{
	import avmplus.Describe;
	
	import flash.utils.getQualifiedClassName;
	
	import turbosqel.console.Console;
	import turbosqel.data.LVar;
	import turbosqel.utils.UArray;
	import turbosqel.utils.UObject;
	/**
	 * ...
	 * @author Gerard Sławiński || turbosqel
	 */
	public class ComplexType extends ValueType implements IAnalizeParent {
		

		

		
		public function ComplexType(parent:IAnalizeParent , target:LVar , access:String = "readwrite" , forceType:String = null):void{
			super(parent , target, access, forceType);
		}
		
		
		
		

		public override function get type():String {
			return result ? result.name : paramType ;//getQualifiedClassName(content.value);
		}
		
		
		
		public function get isDynamic():Boolean {
			return result.isDynamic;
		}
		public function get isFinal():Boolean {
			return result.isFinal;
		}
		public function get isStatic():Boolean {
			return result.isStatic;
		}
		
		
		
		protected var params:Array;
		protected var result:Object;
		
		public function get children():Array {
			return params || parseChildren();
		};
		
		public function parseChildren():Array {
			if (params) {
				UArray.executeAndRemove(params , "remove");
			}
			if (content.value == null) {
				params = null;
				return null;
			}
			// described params :
			result = Describe.typeJSON(content.value);
			// enums values :
			params = new Array();
			for (var item:* in content.value ) {
				params.push(Analize.getType(this , new LVar(content.value , item)));
			};
			
			
			// rest params
			
			
			
			var subArray:Array = result.traits.accessors;
			var length:int =  subArray.length;
			for (var i:int ; i < length ; i++) {
				var paramInfo:Object = subArray[i];
				params.push(Analize.getType(this , new LVar(target , paramInfo.name ) , paramInfo.access , paramInfo.type));
			};
			
			
			if (Analize.showFunctions) {
				subArray = result.traits.methods;
				length = subArray.length;
				for (i = 0; i < length ; i ++) {
					paramInfo = subArray[i];
					var funcType:FunctionType = Analize.getType(this , new LVar(target , paramInfo.name), null , Analize.FUNCTION) as FunctionType;
					funcType.returnType = paramInfo.returnType;
					funcType.params = subArray[i].parameters;
					delete subArray[i].parameters;
					params.push(funcType);
				}
			}
			
			
			// return params array
			return params;
		};
		
		
		public function invalidateChildren():void {
			parseChildren();
			root.invalidate();
		};
		
		
		////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////
		
		
		
		
		
		
	}

}