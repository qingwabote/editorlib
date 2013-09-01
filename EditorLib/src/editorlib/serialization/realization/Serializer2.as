package editorlib.serialization.realization
{
	import flash.utils.IExternalizable;
	import flash.utils.getQualifiedClassName;
	
	import editorlib.serialization.ISerializer;
	import editorlib.serialization.Serialization;
	import editorlib.utils.describetype.DescribeType;
	
	public class Serializer2 implements ISerializer
	{
		[Transient]
		public var overwrite:Boolean=true;
		
		protected var target:ISerializer;
		
		protected var serializableProps:Vector.<XML>;
		
		private var alias:String;
		
		public function Serializer2(target:ISerializer=null)
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
			var value:Object=target[propName];
			var input:Object=input[propName];
			if(value)
			{
				if(value is ISerializer)
					ISerializer(value).readObject(input);
				else if(DescribeType.isPrimitive(value))
				{
					if(overwrite==false)
						return;
					target[propName]=input;
				}
			}
			else
			{
				if(input)
					target[propName]=Serialization.deserialize(input);
			}
		}
		
		protected function writeProp(prop:XML,output:Object):void
		{
			var propName:String=prop.@name;
			var propValue:Object=target[propName];
			/*if(propValue)
				output[propName]=write(propValue);*/IExternalizable
		}
	}
}