package editorlib.components.tiledMapClasses
{
	import mx.collections.ArrayList;
	
	public class LayerList extends ArrayList
	{
		private var tiledMapData:TiledMapData;

		public function LayerList(tiledMapData:TiledMapData)
		{
			super();
			
			this.tiledMapData = tiledMapData;
		}
		
		public function readXML(xmlList:XMLList):void
		{
			var source:Array = [];
			for each(var layerXML:XML in xmlList)
			{
				var layer:TLayer = new TLayer(tiledMapData);
				layer.readXML(layerXML);
				source.push(layer);
			}
			this.source = source;
		}
		
		public function writeXML():XMLList
		{
			return null;
		}
	}
}