package tw.services
{	
	/******************************************************\
	 * ASP版ServiceProxy
	 * Date:2010/02/24
	 * Author: Bear
	\******************************************************/
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	public class ServiceProxyASP
	{
		public function ServiceProxyASP() {
			trace("ServiceProxyASP 不需要初始化");
		}
		
		public static function register(url:String, data:Object = null, callback:Function = null, callback_fail:Function = null):void {
			var requestVars:URLVariables = new URLVariables();
			for (var prop in data) {
				requestVars[prop] = data[prop];
			}
			var request:URLRequest = new URLRequest(url);
				request.method = URLRequestMethod.POST;
				request.data = requestVars;
			
			var urlLoader:URLLoader = new URLLoader();
				urlLoader.addEventListener(Event.COMPLETE, completeHandler);
				urlLoader.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
				urlLoader.load(request);
			
			function completeHandler(e:Event):void {
				urlLoader.removeEventListener(Event.COMPLETE, completeHandler);
				urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler);
				if (callback != null) callback(urlLoader.data);
			}
			function errorHandler(e:IOErrorEvent):void {
				urlLoader.removeEventListener(Event.COMPLETE, completeHandler);
				urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler);
				if (callback_fail != null) callback_fail();
			}
		}
	}
	
}