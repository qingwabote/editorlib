package editorlib.filesystem.filetree.realization
{
	import flash.filesystem.File;
	
	import mx.events.PropertyChangeEvent;
	
	import editorlib.filesystem.filetree.IFileNode2;
	import editorlib.structure.tree.ITreeNode2;
	import editorlib.structure.tree.realization.TreeNode2;
	
	public class FileNode2 extends TreeNode2 implements IFileNode2
	{	
		private var _fileName:String;
		[Bindable("propertyChange")]
		public function get fileName():String
		{
			return _fileName;
		}
		
		private var _isDirectory:Boolean;
		[Bindable("propertyChange")]
		public function get isDirectory():Boolean
		{
			return _isDirectory;
		}
		
		private var _data:Object;
		[Bindable]
		public function get data():Object
		{
			return _data;
		}

		public function set data(value:Object):void
		{
			_data = value;
		}
		
		override public function get children():ITreeNode2
		{
			return _isDirectory?super.children:null;
		}
		
		private var file:File;
		//private var fileInvalidated:Boolean=false;
		
		public function FileNode2(file:File)
		{
			super();
			this.file=file;
			_fileName=file.name;
			_isDirectory=file.isDirectory;
			if(_isDirectory)
				generateChildren(file);
		}
		
		override public function addItemAt(item:Object, index:int):void
		{
			if(!_isDirectory)
				throw new Error;
			
			//move file			
			var itemFile:File=IFileNode2(item).getFile();
			var destination:File=this.getFile().resolvePath(itemFile.name);
			if(itemFile.nativePath!=destination.nativePath)
			{
				//if(destination.exists)
				if(itemFile.exists)
				{
					itemFile.moveTo(destination);
				}
			}

			super.addItemAt(item, index);
		}
		
		public function getFile():File
		{
			if(parent)
				return IFileNode2(parent).getFile().resolvePath(_fileName);
			return file;
		}
		
		public function renameFile(value:String):void
		{
			var destination:File=IFileNode2(parent).getFile().resolvePath(value);
            this.getFile().moveTo(destination);
			
			var oldName:String=_fileName;
			_fileName=value;
			
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"fileName",oldName,value));
		}
		
		public function deleteFile():void
		{
			var file:File=this.getFile();
			if(file.isDirectory)
				file.deleteDirectory(true);
			else
				file.deleteFile();
			
			var index:int=parent.getItemIndex(this);
			parent.removeItemAt(index);
		}
		
		protected function generateChildren(directory:File):void
		{
			var fileList:Array=directory.getDirectoryListing();
			for(var i:int=0;i<fileList.length;i++)
			{
				addItem(new FileNode2(fileList[i] as File));
			}
		}
	}
}