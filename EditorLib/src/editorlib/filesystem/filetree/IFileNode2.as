package editorlib.filesystem.filetree
{
	import flash.filesystem.File;
	
	import editorlib.structure.tree.ITreeNode2;
		
	public interface IFileNode2 extends ITreeNode2
	{
		//function get file():File;
		
		function get fileName():String;
		
		function get isDirectory():Boolean;
		
		function get data():Object;
		function set data(value:Object):void;
		
		function getFile():File;
		
		//function fileNameTest():Boolean;
		
		//function moveFile(parent:IFileNode2):Boolean;
		
		function renameFile(value:String):void;
		
		function deleteFile():void;
	}
}