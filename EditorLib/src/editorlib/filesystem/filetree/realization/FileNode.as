package editorlib.filesystem.filetree.realization
{
	import flash.filesystem.File;
	
	import editorlib.filesystem.filetree.IFileNode;
	import editorlib.structure.tree.ITreeNode;
	import editorlib.structure.tree.tree_treenode;
	import editorlib.structure.tree.realization.TreeNode;
	
	use namespace tree_treenode;
	
	[Bindable]
	/**Please call "writeFile" method after modifying.If not,naming and moving,etc,will not take effect.*/
	public class FileNode extends TreeNode implements IFileNode
	{		
		private var _fileName:String;
		
		public function get fileName():String
		{
			return _fileName;
		}
		
		public function set fileName(value:String):void
		{
			_fileName=value;
		}
		
		private var _file:File;
		
		public function get file():File
		{
			return _file;
		}
		
		private var _isDirectory:Boolean;
		
		public function get isDirectory():Boolean
		{
			return _isDirectory;
		}
		
		override public function get children():ITreeNode
		{
			return _isDirectory?super.children:null;
		}
		
		/**@param file If file is not null,param "isDirectory" will be ignored.*/
		public function FileNode(isDirectory:Boolean=false,file:File=null/*,isRoot:Boolean=false*/)
		{
			super(/*isRoot*/);
			_file=file;
			if(_file)
			{
				_fileName=_file.name;
				_isDirectory=_file.isDirectory;
				if(_isDirectory)
					generateChildren(_file);
			}
			else
				_isDirectory=isDirectory
		}		
		
		public function deleteFile():void
		{
			if(file.exists)
			{
				if(file.isDirectory)
					file.deleteDirectory(true);
				else
					file.deleteFile();
			}
			parent.removeItemAt(parent.getItemIndex(this));
		}					
		
		public function readFile():void
		{
			if(isDirectory)
			{
				for(var i:int=0;i<length;i++)
				{
					var child:FileNode=getItemAt(i) as FileNode;
					child.readFile();
				}
			}
		}
		
		/**Save file.If file is directory,children's writeFile will be call.*/
		public function writeFile():void
		{
			/*if(root!=this)
				relocateFile();*/
			if(parent)
				relocateFile();
			
			if(isDirectory)
			{
				for(var i:int=0;i<length;i++)
				{
					var child:FileNode=getItemAt(i) as FileNode;
					child.writeFile();
				}
			}
		}
		
		override tree_treenode function setParent(parent:TreeNode):void
		{
			super.setParent(parent);
			if(!_fileName)//If the node is a new FileNode,name it according to its index.
			{
				var index:int=parent.getItemIndex(this);
				var type:String=_isDirectory?"folder":"file";
				_fileName="new_"+type+"_"+index;
			}
		}
		
		override public function addItemAt(item:Object, index:int):void
		{
			var fileNode:FileNode=item as FileNode;
			if(hasNameClashes(fileNode.fileName))
				fileNode.fileName=getUniqueName(fileNode.fileName);
			
			super.addItemAt(item, index);
		}
		
		private function hasNameClashes(fileName:String):Boolean
		{
			for(var i:int=0;i<length;i++)
			{
				var fileNode:FileNode=getItemAt(i) as FileNode;
				if(fileNode.fileName==fileName)
					return true;
			}
			return false;
		}
		
		private function getUniqueName(oldName:String):String
		{
			var newName:String;
			var pattern:RegExp=/\((\d+)\)$/;
			var result:Array=pattern.exec(oldName);
			if(result)
			{
				var num:uint=uint(result[1]);
				num++;
				newName=oldName.replace(pattern,"("+num+")");
			}
			else
			{
				newName=oldName+"(1)";
			}
			
			if(hasNameClashes(newName))
				newName=getUniqueName(newName);
			
			return newName;
		}
		
		/*override tree_treenode function setRoot(root:TreeNode):void
		{
			relocateFile();    //Relocate the file when the node is added to root.
			super.setRoot(root);
		}*/		
		
		/**Subclass must override this function,define the type and initial state of new node.*/
		protected function generateChildren(directory:File):void
		{
			var fileList:Array=directory.getDirectoryListing();
			for(var i:int=0;i<fileList.length;i++)
			{
				addItem(new FileNode(false,fileList[i] as File));
			}
		}
		
		private function relocateFile():void
		{
			var destination:File=FileNode(parent).file.resolvePath(_fileName);
			if(_file&&_file.exists)
			{
				if(_file.nativePath!=destination.nativePath)
					_file.moveTo(destination)
			}
			_file=destination;
		}
	}
}