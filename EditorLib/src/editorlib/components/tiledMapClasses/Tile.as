package editorlib.components.tiledMapClasses
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.events.PropertyChangeEvent;
	import mx.utils.ObjectProxy;

	/**The class Tile comes from tmx tag "tile".I made it a dynamic class to keep properties corresponded to tag "properties".*/
	public dynamic class Tile extends ObjectProxy
	{
		private var _ID:int;
		[Bindable("propertyChange")]
		public function get ID():int
		{
			return _ID;
		}

		private var _globalID:int;
		[Bindable("propertyChange")]
		public function get globalID():int
		{
			return _globalID;
		}
		
		private var _bitmapData:BitmapData;
		[Bindable("propertyChange")]
		public function get bitmapData():BitmapData
		{
			return _bitmapData;
		}
		
		private var _tileSet:TileSet;
		[Bindable("propertyChange")]
		public function get tileSet():TileSet
		{
			return _tileSet;
		}

		private var tiledMapData:TiledMapData;
		
		public function Tile(tileSet:TileSet)
		{
			_tileSet = tileSet;
			tiledMapData = tileSet.tiledMapData;
		}
		
		public function initialize(ID:int):void
		{
			_ID = ID;
			_globalID = _tileSet.firstGID + _ID;
			
			var rowIndex:int = _ID < _tileSet.column ? 0 : Math.floor(_ID / _tileSet.column);
			var colIndex:int = _ID < _tileSet.column ? _ID : ID % _tileSet.column;
			
			var dest:Point = new Point(colIndex * _tileSet.tileWidth, rowIndex * _tileSet.tileHeight);
			var rect:Rectangle = new Rectangle(dest.x, dest.y, _tileSet.tileWidth, _tileSet.tileHeight);
			var bitmapData:BitmapData = new BitmapData(rect.width, rect.height);
			bitmapData.copyPixels(_tileSet.bitmapData, rect, new Point, null, null, false);
			
			_bitmapData = bitmapData;
			
			tiledMapData.tileSetList.tiles[_globalID] = this;
			
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"ID",null,_ID));
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"globalID",null,_globalID));
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"bitmapData",null,_bitmapData));
		}
		
		public function readXML(xml:XML):void
		{
			for(var key:String in this)
			{
				delete this[key];
			}
						
			var propertyList:XMLList = xml.properties.property;
			for each(var property:XML in propertyList)
			{
				var name:String = property.@name;
				var value:String = property.@value;
				this[name] = value;
			}
			_ID = xml.@id;

			initialize(_ID);
		}
		
		public function writeXML():XML
		{
			return null;
		}
	}
}