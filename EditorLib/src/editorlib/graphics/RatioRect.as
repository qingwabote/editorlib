package editorlib.graphics
{
	import flash.events.EventDispatcher;
	
	import mx.events.PropertyChangeEvent;

	[Event(name="propertyChange", type="mx.events.PropertyChangeEvent")]
	
	[Bindable]
	public class RatioRect extends EventDispatcher implements IRect
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
		[Bindable("propertyChange")]
		public function get width():int
		{
			return _width;
		}
		
		private var _height:int;
		[Bindable("propertyChange")]
		public function get height():int
		{
			return _height;
		}
		
		private var _widthRatio:uint;
		[Bindable("propertyChange")]
		public function get widthRatio():uint
		{
			return _widthRatio;
		}
		
		private var _heightRatio:uint;
		[Bindable("propertyChange")]
		public function get heightRatio():uint
		{
			return _heightRatio;
		}
		
		private var _aspectRatio:String;
		
		public function get aspectRatio():String
		{
			return _aspectRatio;
		}
		
		public function set aspectRatio(value:String):void
		{
			_aspectRatio = value;
			
			var wh:Array = _aspectRatio.split(":");
			
			var oldwidthRatio:uint = _widthRatio;
			_widthRatio = wh[0];
			
			var oldHeightRatio:uint = _heightRatio;
			_heightRatio = wh[1];
			
			updateWH(_widthRatio,_heightRatio,_multiple);

			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"widthRatio",oldwidthRatio,_widthRatio));
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"heightRatio",oldHeightRatio,_heightRatio));
		}
		
		private var _multiple:uint;

		public function get multiple():uint
		{
			return _multiple;
		}

		public function set multiple(value:uint):void
		{
			_multiple = value;
			
			updateWH(_widthRatio,_heightRatio,_multiple);
		}

		public function RatioRect(x:int=0, y:int=0, aspectRatio:String="1:1", multiple:uint=10)
		{
			super();
			this.aspectRatio = aspectRatio;
			this.multiple = multiple;
		}
		
		private function updateWH(widthRatio:uint, heightRatio:uint, multiple:uint):void
		{
			var oldWidth:int = _width;
			_width = widthRatio * multiple;
			
			var oldHeight:int = _height;
			_height = heightRatio * multiple;
			
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"width",oldWidth,_width));
			dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"height",oldHeight,_height));
		}
	}
}