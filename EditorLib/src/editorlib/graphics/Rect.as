package editorlib.graphics
{
	import flash.events.EventDispatcher;
		
	[Bindable]
	public class Rect extends EventDispatcher implements IRect
	{
		private var _x:int;

		public function get x():int
		{
			return _x;
		}

		public function set x(value:int):void
		{
			_x = value;
		}

		private var _y:int;

		public function get y():int
		{
			return _y;
		}

		public function set y(value:int):void
		{
			_y = value;
		}
		
		private var _width:int;

		public function get width():int
		{
			return _width;
		}

		public function set width(value:int):void
		{
			_width = value;
		}
		
		private var _height:int;

		public function get height():int
		{
			return _height;
		}

		public function set height(value:int):void
		{
			_height = value;
		}

		public function Rect(x:int=0,y:int=0,width:uint=100,height:uint=100)
		{
			super();
			_x=x;
			_y=y;
			_width=width;
			_height=height;
		}
	}
}