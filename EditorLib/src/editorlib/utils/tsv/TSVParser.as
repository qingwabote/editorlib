package editorlib.utils.tsv
{
	public class TSVParser
	{
		public static function parse(text:String):Vector.<Vector.<String>>
		{
			var matrix:Vector.<Vector.<String>>=new Vector.<Vector.<String>>;
			var textRows:Array = text.split("\n"); 
			for(var i:int=0;i<textRows.length;i++)
			{
				matrix[i]=new Vector.<String>;
				var valueArray:Array=textRows[i].split("\t");
				for(var j:int=0;j<valueArray.length;j++)
				{
					var value:String=valueArray[j] as String;
					matrix[i][j]=value;
				}
			}
			return matrix;
		}
		
		public function TSVParser()
		{
		}
	}
}