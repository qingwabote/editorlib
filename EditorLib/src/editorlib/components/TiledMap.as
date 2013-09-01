package editorlib.components
{
	import mx.core.UIComponent;
	
	import editorlib.components.tiledMapClasses.TiledMapData;
	
	public class TiledMap extends UIComponent
	{
		private var _tiledMapData:TiledMapData;

		public function get tiledMapData():TiledMapData
		{
			return _tiledMapData;
		}

		public function set tiledMapData(value:TiledMapData):void
		{
			_tiledMapData = value;
		}
		
		public function TiledMap()
		{
			super();
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth,unscaledHeight);
		}
	}
}
