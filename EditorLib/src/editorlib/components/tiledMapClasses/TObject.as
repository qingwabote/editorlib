package editorlib.components.tiledMapClasses
{
	public class TObject
	{
		private var _GID:int;

		public function get GID():int
		{
			return _GID;
		}

		private var _x:Number;
		[Bindable]
		public function get x():Number
		{
			return _x;
		}

		public function set x(value:Number):void
		{
			_x = value;
		}
		
		private var _y:Number;
		[Bindable]
		public function get y():Number
		{
			return _y;
		}

		public function set y(value:Number):void
		{
			_y = value;
		}

		private var _tile:Tile;
		[Bindable]
		public function get tile():Tile
		{
			return _tile;
		}

		public function set tile(value:Tile):void
		{
			_tile = value;
		}

		private var _tiledMapData:TiledMapData;
		
		public function get tiledMapData():TiledMapData
		{
			return _tiledMapData;
		}
		
		public function TObject(tiledMapData:TiledMapData)
		{
			_tiledMapData = tiledMapData;
		}
		
		public function readXML(xml:XML):void
		{
			_GID = xml.@gid;
			x = xml.@x;
			y = xml.@y;
			
			tile = _tiledMapData.tileSetList.tiles[_GID] as Tile;
		}
		
		public function writeXML():XML
		{
			return null;
		}
	}
}