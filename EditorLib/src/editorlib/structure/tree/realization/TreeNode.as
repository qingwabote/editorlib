package editorlib.structure.tree.realization
{	
	import mx.collections.ArrayCollection;
	
	import editorlib.structure.tree.ITreeNode;
	import editorlib.structure.tree.tree_treenode;
	
	use namespace tree_treenode;
		
	public class TreeNode extends ArrayCollection implements ITreeNode
	{
		private var _root:TreeNode;
		
		public function get root():ITreeNode
		{
			return _root;
		}
		
		private var _parent:TreeNode;
		
		public function get parent():ITreeNode
		{
			return _parent;
		}
		
		public function get children():ITreeNode
		{
			return this;
		}
		
		public function TreeNode(isRoot:Boolean=false)
		{
			super();
			if(isRoot)
				_root=this;
		}
		
		override public function addItemAt(item:Object, index:int):void
		{
			super.addItemAt(item, index);
			var child:TreeNode=item as TreeNode;
			child.setParent(this);
			if(_root)
				child.setRoot(_root);
		}
		
		override public function removeItemAt(index:int):Object
		{
			var child:TreeNode=super.removeItemAt(index) as TreeNode;
			child.deleteParent(this);
			if(_root)
				child.deleteRoot(_root);
			return child;
		}
		
		tree_treenode function setParent(parent:TreeNode):void
		{
			_parent=parent;
		}
		
		tree_treenode function deleteParent(parent:TreeNode):void
		{
			_parent=null;
		}
		
		tree_treenode function setRoot(root:TreeNode):void
		{
			_root=root;
			for(var i:int=0;i<length;i++)
			{
				var child:TreeNode=getItemAt(i) as TreeNode;
				child.setRoot(root);
			}
		}
		
		tree_treenode function deleteRoot(root:TreeNode):void
		{
			_root=null;
			for(var i:int=0;i<length;i++)
			{
				var child:TreeNode=getItemAt(i) as TreeNode;
				child.deleteRoot(root);
			}
		}		
	}
}