package editorlib.serialization
{	
	import flash.net.getClassByAlias;
	import flash.utils.getQualifiedClassName;
	
	import mx.collections.IList;
	
	import editorlib.utils.describetype.DescribeType;

	/**@author qingwabote*/
	public class Serialization
	{
		public static const I_SERIALIZER_QUALIFIED_NAME:String=DescribeType.describeType(ISerializer).@name;

		/**The property of output object that define a alias.*/
		public static const PROP_ALIAS:String="Serializer_alias";
		
		private static var propsCache:Object={};
		
		public static function getSerializableProps(QCName:String):Vector.<XML>
		{
			if(QCName in propsCache)
				return propsCache[QCName] as Vector.<XML>;
			else
			{
				var typeDescription:XML=DescribeType.describeType(QCName);
				var alias:String=typeDescription.@alias;
				if(!alias)
					throw new Error("You must register alias for "+QCName);	
				
				var properties:Vector.<XML>=new Vector.<XML>;
				for each(var item:XML in typeDescription.factory.accessor)
				{
					if(omitProp(item))
						continue;
					
					properties.push(item);
				}
				propsCache[QCName]=properties;
				return properties;
			}
		}
		
		public static function deserialize(input:Object):Object
		{
			if(input==null||DescribeType.isPrimitive(input))
				return input;
			
			if(input is Array)
				return deserializeList(input as Array);
			
			//handle complex type
			var alias:String=input[Serialization.PROP_ALIAS];
			var cls:Class=getClassByAlias(alias);
			var description:XML=DescribeType.describeType(cls);
			   //handle ISerializer
			if(description.factory.implementsInterface.(@type==I_SERIALIZER_QUALIFIED_NAME).length()!=0)
			{
				var serializer:ISerializer=ISerializer(new cls);
				serializer.readObject(input);
				return serializer;
			}
			//if...
			
			throw new Error("Can't handle class type : "+description.@type);
		}
		
		public static function serialize(input:Object):Object
		{
			//handle primitive
			if(input==null||DescribeType.isPrimitive(input))
				return input;
			
			//handle ISerializer
			if(input is ISerializer)
				return (ISerializer(input).writeObject());			
			
			//handle the others
			if(input is IList)
				return serializeList(input as IList);
			
			//if...
			
			throw new Error("Can't handle class type : "+getQualifiedClassName(input));			
		}
		
		public static function deserializeList(array:Array):IList
		{
			var alias:String=array[Serialization.PROP_ALIAS];
			var cls:Class=getClassByAlias(alias);
			var list:IList=new cls as IList;
			for(var i:int=0;i<array.length;i++)
			{
				list.addItem(deserialize(array[i]));
			}
			
			return list;
		}
		
		public static function serializeList(list:IList):Array
		{
			var array:Array=[];
			array[Serialization.PROP_ALIAS]=DescribeType.describeType(list).@alias;
			for(var i:int=0;i<list.length;i++)
			{
				array.push(serialize(list.getItemAt(i)));
			}
			return array;
		}
		
		private static function omitProp(prop:XML):Boolean
		{
			var declaredQCName:String=prop.@declaredBy;
			var typeDescription:XML=DescribeType.describeType(declaredQCName);
			
			if(typeDescription.factory.implementsInterface.(@type==I_SERIALIZER_QUALIFIED_NAME).length()==0)
				return true;
			if(prop.metadata.(@name=="Transient").length()!=0)
				return true;
			if(prop.@access!="readwrite")
				return true;
			
			return false;
		}
		
		public function Serialization()
		{
		}
	}
}