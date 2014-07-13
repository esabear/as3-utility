package tw.trace {
	/*************************************************************************\
	 * Author: 熊
	 * Date: 2010/08/11
	 * Trace模組 - Tommy改版
	 * 使用方式: (將 1000 置換為不同的ID值)
	 
	import tw.trace.Tracer;
	Tracer.Trace (1000);
	
	\*************************************************************************/
	import flash.net.LocalConnection;
	import flash.net.URLRequest;
	import flash.net.sendToURL;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	public class Tracer {
		
		private static const DELAY_TIME:Number = 30 * 1000; // keep alive的時間間隔
		private static const MAX_ALIVE:uint = 120; // 同一ID keep alive的最大計次
		private static const SERVICE_URL:String = "http://trk.pxx.com.tw/pv.php?ID=";
		private static const CLICK_URL:String = "http://trk.pxx.com.tw/ck.php?ID=";
		
		private static var _isOnline:Boolean;
		private static var _timerId:uint;
		private static var _timerCounter:uint; // 同一ID的alive計次
		private static var _curId:String;
		private static var _service:String;
		
		public function Tracer () {
			trace ("Tracer: 不需要初始化");
		}
		
		public static function Trace (id, service = SERVICE_URL)
		{
			if (Global.isDebug) return; // debug模式
			if (!id) { trace("Tracer: 無效的空id"); return; }
			if (!_isOnline) { // 檢查是否置於線上
				var conn:LocalConnection = new LocalConnection();
				if (conn.domain != "localhost") _isOnline = true;
				else { trace("(開發中可忽略)trace id=" + id); return; }
			}
			
			clearTimeout(_timerId);
			
			if (_curId != id) _timerCounter = 0;
			
			_curId = id;
			_service = service;
			
			do_a_trigger();
		}
		
		public static function GetLink (id, service = CLICK_URL):String
		{
			return service + id;
		}
		
		private static function do_a_trigger():void
		{
			try {
				sendToURL(new URLRequest(_service + _curId));
				//trace("Tracer: trace發動=" + _curId);
			} catch (e:Error) { }
			
			if (++_timerCounter > MAX_ALIVE) return;
			
			_timerId = setTimeout(do_a_trigger, DELAY_TIME);
		}
	}
}