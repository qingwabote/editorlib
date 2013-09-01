package editorlib.utils.describetype 
{
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	public class DescribeType
	{
		private static var typeCache:Object = {};

		/**@param obj class,instance or qualified class name.*/
		public static function describeType(obj:*):XML
		{
			//Use "$" to separate entries for describeType(Foo) and describeType(myFoo)
			var cacheKey:String;
			if(obj is String)
			{
				cacheKey=obj+"$";
				obj=getDefinitionByName(obj);
			}
			else if(obj is Class)
				cacheKey=getQualifiedClassName(obj)+"$";
			else
				cacheKey=getQualifiedClassName(obj);			
			
			if (cacheKey in typeCache)
				return typeCache[cacheKey];
			
			var typeDescription:XML = flash.utils.describeType(obj);
			typeCache[cacheKey]=typeDescription;
			return typeDescription;
		}		
		
		/*public static function getQualifiedClassNameByClass(cls:Class):String
		{
			return describeType(cls).@type
		}*/
		
		public static function implementsInterface(typeDescription:XML,interfaceQCName:String):Boolean
		{
			var interfaceXMLList:XMLList=typeDescription.factory.implementsInterface;
			for each(var item:XML in interfaceXMLList)
			{
				var type:String=item.@type;
				if(type==interfaceQCName)
					return true;
			}
			return false;
		}
		
		public static function isPrimitive(value:*):Boolean
		{
			if(value is int||
				value is uint||
				value is Number||
				value is String||
				value is Boolean)
				return true;
			
			return false;
		}
	}
}