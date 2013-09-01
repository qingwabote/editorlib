package editorlib.filesystem.filetree
{
	import flash.filesystem.File;
	
	import editorlib.structure.tree.ITreeNode;
	
	public interface IFileNode extends ITreeNode
	{
		function get fileName():String;
		function set fileName(value:String):void;
		
		function get file():File;
		function get isDirectory():Boolean;
		
		function deleteFile():void;
		
		function readFile():void;
		function writeFile():void;
	}
}