package editorlib.serialization
{
	public interface ISerializer
	{		
		function readObject(input:Object):void;
		function writeObject():Object;
	}
}