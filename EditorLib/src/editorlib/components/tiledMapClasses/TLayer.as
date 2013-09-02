package editorlib.components.tiledMapClasses
{
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	import mx.collections.ArrayList;
	import mx.utils.Base64Decoder;

	/**Layer is a collection of tiles that are kept by grid.*/
	[Bindable]
	public class TLayer extends ArrayList
	{
		private var _name:String;

		public function get name():String
		{
			return _name;
		}

		public function set name(value:String):void
		{
			_name = value;
		}

		private var _width:int;

		public function get width():int
		{
			return _width;
		}

		public function set width(value:int):void
		{
			_width = value;
		}
		
		private var _height:int;

		public function get height():int
		{
			return _height;
		}

		public function set height(value:int):void
		{
			_height = value;
		}
		
		private var _bitMapData:BitmapData;

		public function get bitMapData():BitmapData
		{
			return _bitMapData;
		}
		
		private var _tiledMapData:TiledMapData;
		[Bindable("propertyChange")]
		public function get tiledMapData():TiledMapData
		{
			return _tiledMapData;
		}

		public function TLayer(tiledMapData:TiledMapData)
		{
			super();
			
			_tiledMapData = tiledMapData;
		}
		
		public function load():void
		{
			
		}
		
		public function readXML(xml:XML):void
		{
			name = xml.@name;
			width = xml.@width;
			height = xml.@height;
						
			var data:String = xml.data[0];
			var decoder:Base64Decoder = new Base64Decoder;
			decoder.decode(data);
			var byteArray:ByteArray = decoder.toByteArray();
			byteArray.uncompress();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			
			var source:Array = [];
			var map:Array = [], row:Array = [];
			while (byteArray.position < byteArray.length) {
				if (row.length == _width) {
					map.push(row);
					row = [];
				}
				var GID:int = byteArray.readInt();
				row.push(GID);
				source.push(_tiledMapData.tileSetList.tiles[GID]);
			}
			map.push(row);
			this.source = source;
		}
		
		public function writeXML():XML
		{
			return null;
		}
	}
}