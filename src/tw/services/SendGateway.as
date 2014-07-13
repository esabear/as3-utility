package tw.services {
	/******************************************************\
	 * 傳送至amfphp的PHP端services
	 * Date:2009/02/10
	 * Author: Bear
	\******************************************************/
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.net.NetConnection;
	import flash.net.Responder;
	
	public class SendGateway extends Sprite {
		public static const DEFAULT_GATEWAY = "./flashservices/gateway.php";
		
		private var _gateway:String;
		private var _connection:NetConnection;
		private var _responder:Responder;
		
		private var _isMute:Boolean;
		private var _last_result:Object;
		
		/* 事件
		 * "RESULT" 回傳
		 * "FAULT" 錯誤
		 */
		
		public function SendGateway (url:String=DEFAULT_GATEWAY, isMute:Boolean=true) {
			_isMute = isMute;
			if (!_isMute) trace ("SendGateway: 初始化... Gateway="+ url);
			
			locateGateway (url);
			
			_connection = new NetConnection();
			_responder = new Responder(onResult, onFault)
		}
		
		// 重新指定 gateway 位置
		public function locateGateway (url:String) {
			_gateway = url;
		}
		
		// 傳送資料data 至 service (如:MemberService.add)
		public function sendData (service:String, data) {
			try {
				_connection.connect(_gateway);
				_connection.call(service, _responder, data);
			} catch (e:ArgumentError) {
				trace("(開發中可忽略) SendGateway: 目前無法作用, 可能是路徑錯誤("+ _gateway +")或未放置於伺服器");
			}
		}
		
		public function get result ():Object {
			return _last_result;
		}
		
		// --------------------------------------------------------------------
		protected function onResult(result:Object):void {
			_last_result = result;
			this.dispatchEvent (new Event("RESULT"));
			
			if (!_isMute) trace ("SendGateway: 收到資料");
		}
		
		protected function onFault(result:Object):void {
			_last_result = result;
			this.dispatchEvent (new Event("FAULT"));
			
			if (!_isMute) trace ("SendGateway: 發生錯誤");
		}
	}
}