package tw.services
{
	import flash.external.ExternalInterface;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	
	public class URLHelper {
		
		public static function getHref():String {
			return String(ExternalInterface.call("location.href.toString"));
		} // end of getHref
		
		
		public static function getTitle():String {
			return String(ExternalInterface.call("document.title.toString"));
		} // end of getTitle
	
	
		public static function getBaseURL():String {
			var href:String = URLHelper.getHref();
			var index:Number = href.indexOf('?');
			var baseURL:String = '';
			if (index > -1) {
				baseURL = href.substring(0, index);
			} else {
				baseURL = href;
			}
			return baseURL;
		} // end of getBaseURL
	
	
		public static function getArg():String {
			return String(ExternalInterface.call("location.search.substring", "1"));
		} // end of getArg
	
	
		public static function getParam(param:String):String {
			var arg:String = URLHelper.getArg();
			if (arg) {
				var params:Array = arg.split('&');
				var p:Array;
				var i:Number = params.length;
				while(i--) {
					p = params[i].split('=');
					if (p[0] == param) {
						return p[1];
					}
				}
			}
			return '';
		} // end of getParam
		
		
		public static function sendMail(email:String, subject:String, body:String):void {
			var str:String = "";
			str += email + "?";
			if (subject) str += "subject=" + subject;
			if (body) str += "&body=" + body;
			navigateToURL(new URLRequest("mailto:" + str));
		} // end of sendMail
		
	} // end of class
} // end of package