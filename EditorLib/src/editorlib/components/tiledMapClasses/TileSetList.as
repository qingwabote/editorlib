package editorlib.components.tiledMapClasses
{
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	
	import mx.collections.ArrayList;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	
	[Event(name="complete", type="flash.events.Event")]
	
	public class TileSetList extends ArrayList
	{
		private var _tiles:Array;

		public function get tiles():Array
		{
			return _tiles;
		}

		private var tiledMapData:TiledMapData;

		public function TileSetList(tiledMapData:TiledMapData)
		{
			super();
			
			this.tiledMapData = tiledMapData;
			
			//addEventListener(CollectionEvent.COLLECTION_CHANGE,collectionChangeHandler);
		}
		
		private var loadingNum:int;
		
		public function load():void
		{
			loadingNum = source.length;
			
			for each(var tileSet:TileSet in source)
			{
				tileSet.addEventListener(Event.COMPLETE,oneCompleteHandler);
				tileSet.load();
			}
			
			if(loadingNum == 0)
				dispatchEvent(new Event(Event.COMPLETE));
		}
		
		public function readXML(xmlList:XMLList):void
		{
			_tiles = [];
			
			var source:Array = [];
			
			for each(var tilesetXML:XML in xmlList)
			{
				var tileSet:TileSet = new TileSet(tiledMapData);
				tileSet.readXML(tilesetXML);
				source.push(tileSet);
			}
			this.source = source;
		}
		
		public function writeXML():XMLList
		{
			return null
		}
		
		private function oneCompleteHandler(event:Event):void
		{
			TileSet(event.currentTarget).removeEventListener(Event.COMPLETE,oneCompleteHandler);
			
			loadingNum --;
			if(loadingNum < 1)
				dispatchEvent(event);
		}
		
		private function collectionChangeHandler(event:CollectionEvent):void
		{
			switch(event.kind)
			{
				case CollectionEventKind.ADD:
					throw new IllegalOperationError;
					break;
				case CollectionEventKind.REMOVE:
					throw new IllegalOperationError;
					break;
				case CollectionEventKind.RESET:
				{
					/*var source:Array = ArrayList(_tileSetList).source;
					for each(var tileSet:TileSet in source)
					{
					tileSet.initialize(resourceProvider);
					}*/
					break;
				}
				default:
					throw new IllegalOperationError;
			}
		}
	}
}