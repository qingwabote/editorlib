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

		private var tiledMapData:TiledMapData;
		
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
		
		internal function setFirstGID(GID:int):void
		{
			_firstGID = GID;
		}
				
		public function readXML(xml:XML):void
		{			
			this.xml =xml;
			
			setFirstGID(xml.@firstgid);
			name = xml.@name;
			tileWidth = xml.@tilewidth;
			tileHeight = xml.@tileheight;
			imageSource = xml.image.@source;
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
		
		private function completeHandler(event:Event):void
		{
			var info:LoaderInfo = event.target as LoaderInfo;
			info.removeEventListener(Event.COMPLETE,completeHandler);

			_bitmapData = Bitmap(info.content).bitmapData;
			
			_sourceWidth = _bitmapData.width;
			_sourceHeight = _bitmapData.height;
			
			_row = Math.round(_sourceWidth / _tileWidth);
			_column = Math.round(_sourceHeight / _tileHeight);
			
			readTiles(xml.tile)
			
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"bitmapData",null,_bitmapData));

			dispatchEvent(event);
		}
		
	}
}