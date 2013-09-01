package editorlib.graphics
{
	[Bindable]
	public interface IRect
	{
		function get x():int;
		function set x(value:int):void;
		
		function get y():int;
		function set y(value:int):void;
		
		function get width():int;
		
		function get height():int;
	}
}