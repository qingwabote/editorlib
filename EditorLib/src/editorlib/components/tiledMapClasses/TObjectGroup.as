package editorlib.components.tiledMapClasses
{
	import mx.collections.ArrayList;
	
	public class TObjectGroup extends ArrayList
	{
		public var name:String;
		
		public function TObjectGroup(source:Array=null)
		{
			super(source);
		}
		
		public function readXML(xml:XML):void
		{
			name = xml.@name;
			
			var source:Array = [];
			var objectList:XMLList = xml.object;
			for each(var objectXML:XML in objectList)
			{
				var object:TObject = new TObject;
				object.readXML(objectXML);
				source.push(object);
			}
			this.source = source;
		}
		
		public function writeXML():XML
		{
			return null;
		}
	}
}