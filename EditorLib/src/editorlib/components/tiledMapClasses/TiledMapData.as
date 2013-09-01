package editorlib.components.tiledMapClasses
{
	import flash.errors.IllegalOperationError;
	import flash.events.EventDispatcher;
	import flash.filesystem.File;
	
	import mx.collections.ArrayList;
	import mx.collections.IList;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	
	public class TiledMapData extends EventDispatcher
	{
		private var _tileSetList:IList = new ArrayList;
		
		public function get tileSetList():IList
		{
			return _tileSetList;
		}
		
		public var layerList:IList;
		
		private var _objectGroupList:IList = new ArrayList;

		public function get objectGroupList():IList
		{
			return _objectGroupList;
		}

		private var resourceProvider:IResourceProvider;
		
		public function TiledMapData(resource:Object)
		{
			super(this);
			
			if(resource is IResourceProvider)
				resourceProvider = resource as IResourceProvider;
			else if(resource is File)
				resourceProvider = new FileResourceProvider(resource as File);
			
			_tileSetList.addEventListener(CollectionEvent.COLLECTION_CHANGE,tileSetListCollectionChangeHandler);
		}
		
		public function readXML(xml:XML):void
		{
			readTileSetXML(xml.tileset);
		}
		
		public function writeXML():XML
		{
			return null;
		}
		
		private function readTileSetXML(xmlList:XMLList):void
		{
			var source:Array = [];
			
			for each(var tilesetXML:XML in xmlList)
			{
				var tileSet:TileSet = new TileSet();
				tileSet.readXML(tilesetXML);
				source.push(tileSet);
			}
			ArrayList(_tileSetList).source = source;
		}
		
		private function readObjectGroupXML(xmlList:XMLList):void
		{
			var source:Array = [];
			
			for each(var objectGroupXML:XML in xmlList)
			{
				var objectGroup:TObjectGroup = new TObjectGroup;
				objectGroup.readXML(objectGroupXML);
				source.push(objectGroup);
			}
			ArrayList(_objectGroupList).source = source;
		}
		
		private function tileSetListCollectionChangeHandler(event:CollectionEvent):void
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

import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.utils.ByteArray;

import editorlib.components.tiledMapClasses.IResourceProvider;

class FileResourceProvider implements IResourceProvider
{
	private var directory:File;
	
	public function FileResourceProvider(file:File)
	{
		if(file.isDirectory == false)
			throw new Error;
		
		directory = file;
	}
	
	public function getResource(path:String):Object
	{
		var byteArray:ByteArray = new ByteArray;
		
		var file:File = directory.resolvePath(path);
		
		var stream:FileStream = new FileStream;
		stream.open(file, FileMode.READ);
		stream.readBytes(byteArray);
		stream.close();
		
		return byteArray;
	}
}