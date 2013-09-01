package editorlib.components.tiledMapClasses
{
	public class TObject
	{
		private var _GID:int;

		public function get GID():int
		{
			return _GID;
		}

		private var _x:Number;

		public function get x():Number
		{
			return _x;
		}

		public function set x(value:Number):void
		{
			_x = value;
		}

		private var _y:Number;

		public function get y():Number
		{
			return _y;
		}

		public function set y(value:Number):void
		{
			_y = value;
		}
		
		public function TObject()
		{
		}
		
		public function readXML(xml:XML):void
		{
			_GID = xml.@gid;
			x = xml.@x;
			y = xml.@y;
		}
		
		public function writeXML():XML
		{
			return null;
		}
	}
}