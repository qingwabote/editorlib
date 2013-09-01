package editorlib.containers
{
	import spark.components.BorderContainer;
	import spark.components.Group;
	import spark.components.SkinnableContainer;
	
	import editorlib.containers.ctrlPanelClasses.CtrlPanelSkin;
	
	public class CtrlPanel extends SkinnableContainer
	{
		private var topControlBarInvalidated:Boolean = false;
		private var _topControlBar:Group;

		public function get topControlBar():Group
		{
			return _topControlBar;
		}

		public function set topControlBar(value:Group):void
		{
			_topControlBar = value;
			topControlBarInvalidated = true;
			invalidateProperties();
		}
		
		private var bottomControlBarInvalidated:Boolean = false;
		private var _bottomControlBar:Group;

		public function get bottomControlBar():Group
		{
			return _bottomControlBar;
		}

		public function set bottomControlBar(value:Group):void
		{
			_bottomControlBar = value;
			bottomControlBarInvalidated = true;
			invalidateProperties();
		}
		
		[SkinPart]
		public var topControlBarContainer:BorderContainer;
		
		[SkinPart]
		public var bottomControlBarContainer:BorderContainer;
		
		public function CtrlPanel()
		{
			super();
			setStyle("skinClass",CtrlPanelSkin);
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			if(topControlBarInvalidated)
			{
				topControlBarContainer.removeAllElements();
				topControlBarContainer.addElement(_topControlBar);
				topControlBarInvalidated = false;
			}
			if(bottomControlBarInvalidated)
			{
				bottomControlBarContainer.removeAllElements();
				bottomControlBarContainer.addElement(_bottomControlBar);
				bottomControlBarInvalidated = false;
			}
		}
	}
}