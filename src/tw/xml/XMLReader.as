package tw.xml
{
	import XML;
	import flash.events.Event;
	import flash.events.IOErrorEvent ;
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.utils.setTimeout;
	/**
	 * 載入XML
	 * @author Bear
	 */
	public class XMLReader 
	{
		
		public function XMLReader() 
		{
			
		}
		
		// path為String或URLRequest,  call_back必須接收1個XML參數
		public static function read(path:*, call_back:Function, failFunc:Function=null, triedTimes:int=0, maxTry:int=5):void {
			if (triedTimes) trace("讀取" + path + "失敗, 第" + triedTimes + "次嘗試, 最大嘗試=" + maxTry);
			if (triedTimes >= maxTry) {
				if (failFunc != null) failFunc();
				return;
			}
			var myLoader:URLLoader = new URLLoader();
				myLoader.addEventListener(Event.COMPLETE, load_complete);
				myLoader.addEventListener(IOErrorEvent.IO_ERROR , io_error_handler);
				myLoader.load(path is URLRequest ? path : new URLRequest(path));
				
			function load_complete(e:Event):void {
				e.target.removeEventListener(Event.COMPLETE, load_complete);
				e.target.removeEventListener(IOErrorEvent.IO_ERROR , io_error_handler);
				if (call_back != null) call_back(new XML(myLoader.data));
				myLoader = null;
			}
			function io_error_handler(e:IOErrorEvent):void {
				setTimeout(read, 1000, path, call_back, failFunc, triedTimes + 1, maxTry);
				e.target.removeEventListener(Event.COMPLETE, load_complete);
				e.target.removeEventListener(IOErrorEvent.IO_ERROR , io_error_handler);
				myLoader = null;
			}
		}
		
	}
	
}