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
		
		private var tileSet:TileSet;
		
		private var tiledMapData:TiledMapData;
		
		public function Tile(tileSet:TileSet)
		{
			this.tileSet = tileSet;
			tiledMapData = tileSet.tiledMapData;
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
			
			_globalID = tileSet.firstGID + _ID;
			
			var rowIndex:int = _ID < tileSet.column ? 0 : Math.floor(_ID / tileSet.column);
			var colIndex:int = _ID < tileSet.column ? _ID : ID % tileSet.column;
					
			var dest:Point = new Point(colIndex * tileSet.tileWidth, rowIndex * tileSet.tileHeight);
			var rect:Rectangle = new Rectangle(dest.x, dest.y, tileSet.tileWidth, tileSet.tileHeight);
			var bitmapData:BitmapData = new BitmapData(rect.width, rect.height);
			bitmapData.copyPixels(tileSet.bitmapData, rect, new Point, null, null, false);
			
			_bitmapData = bitmapData;
			
			tiledMapData.tileSetList.tiles[_globalID] = this;
			
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"ID",null,_ID));
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"globalID",null,_globalID));
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"bitmapData",null,_bitmapData));
		}
		
		public function writeXML():XML
		{
			return null;
		}
	}
}