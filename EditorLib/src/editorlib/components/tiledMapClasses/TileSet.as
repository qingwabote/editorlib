package editorlib.components.tiledMapClasses
{	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.utils.ByteArray;
	
	import mx.collections.ArrayList;
	import mx.events.PropertyChangeEvent;

	[Event(name="complete", type="flash.events.Event")]

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
		[Bindable("propertyChange")]
		public function get tileWidth():Number
		{
			return _tileWidth;
		}

		private var _tileHeight:Number;
		[Bindable("propertyChange")]
		public function get tileHeight():Number
		{
			return _tileHeight;
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

		private var _sourceWidth:Number;

		public function get sourceWidth():Number
		{
			return _sourceWidth;
		}
		
		private var _sourceHeight:Number;

		public function get sourceHeight():Number
		{
			return _sourceHeight;
		}
		
		private var _row:int;

		public function get row():int
		{
			return _row;
		}
		
		private var _column:int;

		public function get column():int
		{
			return _column;
		}
		
		private var _bitmapData:BitmapData;
		[Bindable("propertyChange")]
		public function get bitmapData():BitmapData
		{
			return _bitmapData;
		}

		internal var tiledMapData:TiledMapData;
		
		private var xml:XML;
		
		public function TileSet(tiledMapData:TiledMapData)
		{
			super();
			
			this.tiledMapData = tiledMapData;
		}
		
		public function load():void
		{
			var loader:Loader = new Loader;
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,completeHandler);
			loader.loadBytes(tiledMapData.resourceProvider.getResource(_imageSource) as ByteArray);
		}
						
		public function readXML(xml:XML):void
		{			
			this.xml =xml;
			
			_firstGID = xml.@firstgid;
			_tileWidth = xml.@tilewidth;
			_tileHeight = xml.@tileheight;
			
			name = xml.@name;
			imageSource = xml.image.@source;
						
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"tileWidth",null,_tileWidth));
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"tileHeight",null,_tileHeight));
		}
		
		public function writeXML():XML
		{
			return null;
		}
		
		private function readTiles(xmlList:XMLList):void
		{
			var sourceInput:Array = [];
			
			for each(var tileXML:XML in xmlList)
			{
				var tile:Tile = new Tile(this);
				tile.readXML(tileXML);
				sourceInput.push(tile);
			}
			
			this.source = sourceInput;
		}
		
		private function createTiles():void
		{
			var sourceInput:Array = [];
			var num:int = _sourceWidth * _sourceHeight / (_tileWidth * _tileHeight);
			for(var i:int = 0; i < num; i++)
			{
				var tile:Tile = new Tile(this);
				tile.initialize(i);
				source.push(tile);
			}
			this.source = sourceInput;
		}
		
		private function completeHandler(event:Event):void
		{
			var info:LoaderInfo = event.target as LoaderInfo;
			info.removeEventListener(Event.COMPLETE,completeHandler);

			_bitmapData = Bitmap(info.content).bitmapData;
			
			_sourceWidth = _bitmapData.width;
			_sourceHeight = _bitmapData.height;
			
			_row = Math.floor(_sourceHeight / _tileHeight);
			_column = Math.floor(_sourceWidth / _tileWidth);
			
			var tileList:XMLList = xml.tile;
			if(tileList.length() > 0)
				readTiles(tileList);
			else
				createTiles();
			
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"bitmapData",null,_bitmapData));

			dispatchEvent(event);
		}
		
	}
}