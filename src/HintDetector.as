package  
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author G
	 */
	public class HintDetector 
	{
		
		private var hints:Dictionary = new Dictionary();
		private var byteArray:ByteArray;
		private var largestNumber:Number = 0;
		
		public function HintDetector(byteArray:ByteArray) 
		{
			this.byteArray  = byteArray;
			initHints();
		}
		
		private function initHints():void {
			hints["%PDF"] = "application/pdf";
			hints["BM"] = "image/bmp";
			hints["BZ"] = "application/bz2";
			hints["MZ"] = "application/exe";
			hints["GIF8"] = "image/gif";
			hints["\xFF\xD8"] = "image/jpeg";
			hints["\x89PNG"] = "image/png";
			hints["\x1F\x8B"] = "application/x-gzip";
			hints["7Z\xBC\xAF\x27\x1C"] = "application/7zip";
			
			detectLargest();
		}
		
		private function detectLargest():void {
			for each(var s:String in hints) {
				if (s.length > largestNumber) {
					largestNumber = s.length;
				}
			}
		}
		
		public function detect():String {
			var detected:String = null;
			
			byteArray.position = 0;
			
			var currentHeader:String = "";

			for (var i:Number = 0; i < largestNumber && byteArray.bytesAvailable; i++)
			{
				currentHeader += String.fromCharCode(byteArray.readByte());
				var matching:Object = hints[currentHeader];
				if (matching != null) {
					detected = matching as String;
					break;
				}
			}
			
			return detected;
		}
		
	}

}