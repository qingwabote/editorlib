package editorlib.components.tiledMapClasses
{
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.filesystem.File;
	
	import mx.collections.ArrayList;
	import mx.collections.IList;
	
	public class TiledMapData extends EventDispatcher
	{
		private var _tileSetList:TileSetList;
		[Bindable("propertyChange")]
		public function get tileSetList():TileSetList
		{
			return _tileSetList;
		}
		
		public var layerList:IList;
		
		private var _objectGroupList:IList = new ArrayList;
        [Bindable("propertyChange")]
		public function get objectGroupList():IList
		{
			return _objectGroupList;
		}

		private var _resourceProvider:IResourceProvider;

		public function get resourceProvider():IResourceProvider
		{
			return _resourceProvider;
		}

		private var xml:XML;
		
		public function TiledMapData(resource:Object)
		{
			super(this);
						
			if(resource is IResourceProvider)
				_resourceProvider = resource as IResourceProvider;
			else if(resource is File)
				_resourceProvider = new FileResourceProvider(resource as File);
			
			_tileSetList = new TileSetList(this);
		}
		
		public function readXML(xml:XML):void
		{
			this.xml = xml;

			_tileSetList.readXML(xml.tileset);
			_tileSetList.addEventListener(Event.COMPLETE,completeHandler);
			_tileSetList.load();
		}
		
		public function writeXML():XML
		{
			return null;
		}
		
		private function readObjectGroupXML(xmlList:XMLList):void
		{
			var source:Array = [];
			
			for each(var objectGroupXML:XML in xmlList)
			{
				var objectGroup:TObjectGroup = new TObjectGroup(this);
				objectGroup.readXML(objectGroupXML);
				source.push(objectGroup);
			}
			ArrayList(_objectGroupList).source = source;
		}
		
		private function completeHandler(event:Event):void
		{
			_tileSetList.removeEventListener(Event.COMPLETE,completeHandler);

			readObjectGroupXML(xml.objectgroup);
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