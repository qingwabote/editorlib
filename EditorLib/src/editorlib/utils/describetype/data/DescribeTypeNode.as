package editorlib.utils.describetype.data
{	
	import editorlib.structure.tree.realization.TreeNode;
	import editorlib.utils.describetype.DescribeType;
	
	public class DescribeTypeNode extends TreeNode
	{
		private var _name:String;

		public function get name():String
		{
			return _name;
		}
		
		private var _type:String;

		public function get type():String
		{
			return _type;
		}
		
		public function DescribeTypeNode(name:String,type:String)
		{
			super();
			_name=name;
			_type=type;
			var typeDescription:XML=DescribeType.describeType(_type);
			if(omitChildren(typeDescription)==false)
			{
				var accessors:XMLList=typeDescription.factory.accessor;
				generateChildren(accessors);
			}
		}
		
		protected function omitChildren(typeDescription:XML):Boolean
		{
			return false;
		}
		
		/**Subclass must override this function,define the type and initial state of new node.*/
		protected function generateChildren(accessors:XMLList):void
		{
			for each(var item:XML in accessors)
			{
				addItem(new DescribeTypeNode(item.@name,item.@type));
			}
		}
	}
}