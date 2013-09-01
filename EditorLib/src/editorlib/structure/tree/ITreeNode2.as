package editorlib.structure.tree
{
	import mx.collections.IList;
	
	public interface ITreeNode2 extends IList
	{
		function get parent():ITreeNode2;
		function get children():ITreeNode2;	
		
		function getRoot():ITreeNode2;
	}
}