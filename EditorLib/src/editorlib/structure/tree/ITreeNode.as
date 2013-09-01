package editorlib.structure.tree
{
	import mx.collections.IList;
	
	public interface ITreeNode extends IList
	{
		function get root():ITreeNode;
		function get parent():ITreeNode;
		function get children():ITreeNode;		
	}
}