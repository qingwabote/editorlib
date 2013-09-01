package editorlib.components.tiledMapClasses
{	
	import mx.collections.ArrayList;

	public class TileSet extends ArrayList
	{
		private var _firstGID:int;

		public function get firstGID():int
		{
			return _firstGID;
		}
		
		private var _name:String;

		public function get name():String
		{
			return _name;
		}

		public function set name(value:String):void
		{
			_name = value;
		}
		
		private var _tileWidth:Number;

		public function get tileWidth():Number
		{
			return _tileWidth;
		}

		public function set tileWidth(value:Number):void
		{
			_tileWidth = value;
		}

		private var _tileHeight:Number;

		public function get tileHeight():Number
		{
			return _tileHeight;
		}

		public function set tileHeight(value:Number):void
		{
			_tileHeight = value;
		}

		private var _imageSource:String;

		public function get imageSource():String
		{
			return _imageSource;
		}

		public function set imageSource(value:String):void
		{
			_imageSource = value;
		}

		/*private var _sourceWidth:Number;

		public function get sourceWidth():Number
		{
			return _sourceWidth;
		}
		
		private var _sourceHeight:Number;

		public function get sourceHeight():Number
		{
			return _sourceHeight;
		}

		private var _imageData:ByteArray;

		public function get imageData():ByteArray
		{
			return _imageData;
		}

		private var resourceProvider:IResourceProvider;*/
		
		public function TileSet(firstGID:int = 0, name:String = null)
		{
			super();
		    _firstGID = firstGID;
			_name = name;
		}
		
		public function readXML(tilesetXML:XML):void
		{			
			_firstGID = tilesetXML.@firstgid;
			_name = tilesetXML.@name;
			_tileWidth = tilesetXML.@tilewidth;
			_tileHeight = tilesetXML.@tileheight;
			_imageSource = tilesetXML.image.@source;
			
			var sourceInput:Array = [];

			var tileList:XMLList = tilesetXML.tile;
			for each(var tileXML:XML in tileList)
			{
				var tile:Tile = new Tile;
				tile.readXML(tileXML);
				sourceInput.push(tile);
			}
			
			this.source = sourceInput;
		}
		
		public function writeXML():XML
		{
			return null;
		}
		
		/*internal function initialize(resourceProvider:IResourceProvider):void
		{
			this.resourceProvider = resourceProvider;
		}*/
	}
}