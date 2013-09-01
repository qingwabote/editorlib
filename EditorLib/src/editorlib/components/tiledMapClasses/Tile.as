package editorlib.components.tiledMapClasses
{
	import mx.utils.ObjectProxy;

	/**The class Tile comes from tmx tag "tile".I made it a dynamic class to keep properties corresponded to tag "properties".*/
	public dynamic class Tile extends ObjectProxy
	{
		private var _ID:int;

		public function get ID():int
		{
			return _ID;
		}

		public function Tile(ID:int = 0)
		{
			_ID = ID;
		}
		
		public function readXML(xml:XML):void
		{
			for(var key:String in this)
			{
				delete this[key];
			}
			
			_ID = xml.@id;
			
			var propertyList:XMLList = xml.properties.property;
			for each(var property:XML in propertyList)
			{
				var name:String = property.@name;
				var value:String = property.@value;
				this[name] = value;
			}
		}
		
		public function writeXML():XML
		{
			return null;
		}
	}
}