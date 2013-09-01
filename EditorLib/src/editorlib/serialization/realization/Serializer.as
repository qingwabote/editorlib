package editorlib.serialization.realization
{
	import flash.net.getClassByAlias;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import mx.collections.IList;
	import mx.utils.ObjectProxy;
	
	import editorlib.serialization.ISerializer;
	import editorlib.serialization.Serialization;
	import editorlib.utils.describetype.DescribeType;

	/**
	 * This class is designed to help serialize static class,and only public properties can be handle.
	 * It's dynamic subclasses can't be support.
	 * 
	 * Please use metadata tag "[RemoteClass]" to register a alias in the subclasses,because the alias is more stable than qualified class name.
	 * 
	 * If you want to handle dynamic class,private properties or implement IList,you should add additional processing both in readObject and writeObject function of your class.
	 * Although your custom class itself can't be IList or dynamic but you can aggregate one instead.
	 * Please use ObjectProxy instead of Object as a map.
	 * 
	 * Note that custom class can't refer to itself on its public property,it will cause an infinite recursive loop.  
	 * 
	 * @author qingwabote
	 * */
	public class Serializer implements ISerializer
	{			
		protected var target:ISerializer;
				
		protected var serializableProps:Vector.<XML>;
		
		private var alias:String;
		
		/**@param target This parameter is used when "Serializer" instance is aggregated by a class that implements ISerializer.*/
		public function Serializer(target:ISerializer=null)
		{
			if(target)
				this.target=target;
			else
				this.target=this;
			
			var typeDescription:XML=DescribeType.describeType(this.target);
			alias=typeDescription.@alias;
		
			serializableProps=Serialization.getSerializableProps(getQualifiedClassName(this.target));
		}
		
		public function readObject(input:Object):void
		{			
			if(input[Serialization.PROP_ALIAS]!=alias)
				throw new Error("alias \""+input[Serialization.PROP_ALIAS]+"\" is different from \""+alias+"\"");
			
			for each(var prop:XML in serializableProps)
			{
				readProp(prop,input);
			}
		}
		
		public function writeObject():Object
		{
			var output:Object={};
			output[Serialization.PROP_ALIAS]=alias;
			
			for each(var prop:XML in serializableProps)
			{
				writeProp(prop,output);
			}
			
			return output;
		}
		
		protected function readProp(prop:XML,input:Object):void
		{
			var propName:String=prop.@name;
			var propValue:Object=input[propName];
			if(propValue)
				target[propName]=read(propValue);
		}
		
		protected function writeProp(prop:XML,output:Object):void
		{
			var propName:String=prop.@name;
			var propValue:Object=target[propName];
			if(propValue)
				output[propName]=write(propValue);
		}
		
		public function readList(source:Object,list:IList):IList
		{						
			var array:Array=source as Array;
			var length:uint=array.length;
			for(var i:int=0;i<length;i++)
			{
				var input:Object=array[i];
				list.addItem(read(input));
			}
			return list;
		}
		
		public function writeList(list:IList):Object
		{			
			var array:Array=[];
			var length:int=list.length;
			for(var i:int=0;i<length;i++)
			{
				var item:Object=list.getItemAt(i);
				array.push(write(item));
			}			
			return array;
		}
		
		public function readProxy(source:Object,proxy:ObjectProxy):ObjectProxy
		{
			for(var key:String in source)
			{
				if(key==Serialization.PROP_ALIAS)
					continue;
				proxy[key]=read(source[key]);
			}
			return proxy;
		}
		
		public function writeProxy(proxy:ObjectProxy):Object
		{
			var obj:Object={};
			for(var key:String in proxy)
			{
				obj[key]=write(proxy[key]);
			}
			return obj;
		}
		
		protected function read(value:Object):Object
		{
			//handle primitive
			if(value==null||DescribeType.isPrimitive(value))
				return value;
			
			var alias:String=value[Serialization.PROP_ALIAS];
			var cls:Class=getClassByAlias(alias);
			var instance:Object=new cls;
			//handle ISerializer
			if(instance is ISerializer)
			{
				var serializer:ISerializer=instance as ISerializer;
				serializer.readObject(value);
				return serializer;
			}
			//handle the others
			if(instance is IList)
				return readList(value,instance as IList);	
			if(instance is ObjectProxy)
				return readProxy(value,instance as ObjectProxy);
			
			throw new Error("Can't handle class type : "+getQualifiedClassName(instance));
		}
		
		protected function write(value:Object):Object
		{
			//handle primitive
			if(value==null||DescribeType.isPrimitive(value))
				return value;
			
			//handle ISerializer
			if(value is ISerializer)
				return (ISerializer(value).writeObject());			
			
			//handle the others
			var obj:Object;
			if(value is IList)
				obj=writeList(value as IList);
			else if(value is ObjectProxy)
				obj=writeProxy(value as ObjectProxy);
			else
				throw new Error("Can't handle class type : "+getQualifiedClassName(value));
			
			obj[Serialization.PROP_ALIAS]=DescribeType.describeType(value).@alias;
			return obj;
		}						
	}
}