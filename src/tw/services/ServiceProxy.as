package tw.services
{	
	/******************************************************\
	 * 更便利使用SendGateway
	 * Date:2009/12/18
	 * Author: Bear
	\******************************************************/
	public class ServiceProxy
	{
		public static var gateway:String = "";
		
		public function ServiceProxy() {
			trace("ServiceProxy 不需要初始化");
		}
		
		public static function register(service:String, data:Object=null, callback:Function = null, callback_fail:Function = null):void {
			var sg:SendGateway = gateway ? new SendGateway(gateway) : new SendGateway();
				sg.addEventListener("RESULT", resultHandler);
				sg.addEventListener("FAIL", failHandler);
				sg.sendData(service, data);
				
			function resultHandler(e):void {
				sg.removeEventListener("RESULT", resultHandler);
				sg.removeEventListener("FAIL", failHandler);
				
				if (callback != null) callback(sg.result);
			}
			
			function failHandler(e):void {
				if (callback_fail != null) callback_fail();
			}
		}
	}
	
}