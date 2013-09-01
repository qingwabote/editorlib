package editorlib.utils.formatters
{
	public class TimeFormatter
	{
		public static function formatSeconds(value:uint):String
		{
			var minutes:uint=value/60;
			var seconds:uint=value-minutes*60;
			return minutes+":"+seconds;
		}
		public function TimeFormatter()
		{
		}
	}
}