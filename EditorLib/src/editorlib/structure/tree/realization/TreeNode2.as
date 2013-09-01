package editorlib.structure.tree.realization
{
	import mx.collections.ArrayCollection;
	
	import editorlib.structure.tree.ITreeNode2;
	
	public class TreeNode2 extends ArrayCollection implements ITreeNode2
	{	
		private var _parent:ITreeNode2;
		public function get parent():ITreeNode2
		{
			return _parent;
		}
		
		public function get children():ITreeNode2
		{
			return this;
		}
		
		public function TreeNode2()
		{
			super();
		}
		
		public function getRoot():ITreeNode2
		{
			if(_parent)
				return _parent.getRoot();
			return this;
		}
		
		override public function addItemAt(item:Object, index:int):void
		{			
			super.addItemAt(item, index);
			TreeNode2(item).setParent(this);
		}
		
		internal function setParent(parent:TreeNode2):void
		{
			doSetParent(parent);
		}
		
		protected function doSetParent(parent:TreeNode2):void
		{
			_parent=parent;
		}
	}
}