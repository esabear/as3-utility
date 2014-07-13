package 
{
	
	/**
	 * more Strings functions
	 * @author Bear
	 */
	public class Str
	{
		public function Str() {
			trace("Str: no need to be initialized");
		}
		
		public static function ord(str:String, index:int=0):Number {
			return str.charCodeAt(index);
		}
		
		public static function chr(code:int):String {
			return String.fromCharCode(code);
		}
		
		public static function trim(str:String, charList:String = " \t\n\r"):String {
			return rtrim(ltrim(str, charList), charList);
		}
		
		public static function ltrim(str:String, charList:String=" \t\n\r"):String {
			var str_len:int = str.length;
			var i:int;
			for (; i < str_len; i++) {
				if (charList.search(str.charAt(i)) == -1)
					return str.substring(i);
			}
			return "";
		}
		
		public static function rtrim(str:String, charList:String=" \t\n\r"):String {
			var str_len:int = str.length;
			var i:int = str_len - 1;
			for (; i >= 0; i--) {
				if (charList.search(str.charAt(i)) == -1) 
					return str.substring(0, i + 1);
			}
			return "";
		}
		
		public static function appendChar(digi:*, toLen:uint, elem:String="0", toHead:Boolean=true):String {
			var str_digi:String = digi.toString();
			var diff_len:int = toLen - str_digi.length;
			var append_str:String = "";
			while (diff_len-- > 0) {
				append_str += elem;
			}
			return toHead ? append_str + str_digi : str_digi + append_str;
		}
		
		public static function stripTags(myString:String, tagStart:String = "<", tagEnd:String = ">"):String {
			var istart:int;
			while ((istart=myString.indexOf(tagStart)) != -1) {
				myString = myString.split(myString.substr(istart, myString.indexOf(tagEnd)-istart+1)).join("");
			}
			return myString;
		}
	}
	
}