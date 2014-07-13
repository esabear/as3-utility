package tw.trace {
	/*************************************************************************\
	 * Author: 熊
	 * Date: 2009/07/13
	 * Trace模組 - >>> 不需service的版本 <<<
	 * 使用方式: (將 1000 置換為不同的ID值)
	 
	import tw.trace.Tracer2;
	Tracer2.Trace (1000);
	
	\*************************************************************************/
	import flash.net.URLRequest;
	import flash.net.SharedObject;
	import flash.net.URLLoader;
	
	import flash.events.IOErrorEvent;
	import flash.events.Event;
	
	public class Tracer2 {
		
		private static var _sessionId:String;
		
		private static var _id;
		private static var _service:String;
		private static var _debugging:Boolean=false;
		
		public function Tracer2 () {
			trace ("Tracer2: 不需要初始化");
		}
		
		public static function Trace (id, action=null, reference=null, debug:Boolean=false, service="http://beta.pxx.com.tw/Trace_2007/trigger.php") {
			
			_id = id;
			_service = service;
			if (!_sessionId) enableSession ();
			
			var service_path:String = _service + "?traceId=" + _id;
			
			if (action) service_path += "&action=" + action;
			if (reference) service_path += "&reference=" + reference;
			if (_debugging || debug) service_path += "&debug=1";
			if (_sessionId) service_path += "&sessionId=" + _sessionId;
				
			var request = new URLRequest(service_path);
				
			var my_loader:URLLoader = new URLLoader();
				my_loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
				my_loader.addEventListener(Event.COMPLETE, completeHandler);
				my_loader.load (request); // send
		}
		
		public static function enableSession ():void {
			if (_sessionId) return;
			
			var so:SharedObject = SharedObject.getLocal("Tracer");

			if (!so.data.sessionId)
			{
			    so.data.sessionId  = new Date().time;
				so.data.sessionId += "-" + Math.ceil (Math.random() * 1048576);
				so.flush(); // 寫回
			}
			_sessionId = so.data.sessionId; // 讀取變數
		}
		
		public static function set debugMode (flag:Boolean):void {
			_debugging = flag;
		}
		
		// ---- event handler ---------------------------------------------------------------
		private static function completeHandler (e:Event):void {
			trace ("(開發中可忽略) Tracer2 設定成功(id="+_id+",_sessionId="+_sessionId+")");
		}
		private static function ioErrorHandler (e:IOErrorEvent):void {
			trace ("(開發中可忽略) Tracer2 目前無法作用(id="+_id+",_sessionId="+_sessionId+") - 找不到 "+ _service +" 或未放置於伺服器");
		}
	}
}