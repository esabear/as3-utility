package 
{
	import flash.events.MouseEvent;
	
	import tw.utils.EventManager;
	
	/**
	 * Global values and actions
	 * @author Bear
	 */
	public class Global
	{
		//----------------------------------------------------------------
		public static const 發行 = "";
		public static const 作者 = "";
		public static const LINK_PUBLISHER = "";
		public static const LINK_MAIN = "";
		
		//----------------------------------------------------------------
		public static const FLASH_W = 1000;
		public static const FLASH_H = 600;
		
		//----------------------------------------------------------------
		public static var ref:*;
		public static var isOnline:Boolean = false;
		public static var isDebug:Boolean = false;
		public static var date:String;
		
		//----------------------------------------------------------------
		public static function init($ref:*):void {
			ref = $ref;
			var p = ref.root.loaderInfo.parameters;
			
			if (p.isOnline) isOnline = true;
			if (p.isDebug) isDebug = true;
			if (p.date) date = p.date;
		}
		
		public static function open_publisher(e:* = null):void {
			getURL(LINK_PUBLISHER, "_blank");
		}
		
		// Global.GA("'product_btn','click','OO推薦'");
		// Global.GA("{'page': '/product_page','title':'產品頁面'}", "pageview");
		public static function GA(gaCode:String, type:String='event'):void {
			// ga('send', 'event', 'category', 'action', 'label', value); //value不要填
			// ga('send', 'event', 'produc_btn', 'click', 'OO推薦');
			// ga('send', 'pageview', {'page': '/product_page','title':'產品頁面'});
			if (gaCode)
				exec_javascript("ga('send', '" + type + "', " + gaCode + ")");
		}
		
		// Global.make_link_button(btn,'http://xyz.net/',"'bloggerlink_btn','click','xyz'");
		public static function make_link_button(target, url:String, gaCode:String=null):void {
			EventManager.add(target, MouseEvent.CLICK, Global.open_link_out, [url, gaCode]);
		}
		
		// Global.make_event_button(btn, Events.CLICK_PRO,"'product_btn','click','pro'");
		public static function make_event_button(target, eventString:String, gaCode:String=null):void {
			EventManager.add(target, MouseEvent.CLICK, Global.open_event, [eventString, gaCode]);
		}
		
		public static function open_event(eventString:String, gaCode:String=null):void {
			if (eventString) Events.say(eventString);
			if (gaCode) Global.GA(gaCode);
		}
		
		public static function open_link_out(url:String, gaCode:String=null):void {
			getURL(url, "_blank");
			if (gaCode) Global.GA(gaCode);
		}
		
		public static function push_facebook(id:String = ""):void {
			exec_javascript("push_facebook(" + id + ")");
			//Tracer.Trace(Global.PAGE_TRACE["facebook" + (gameIndex ? "-"+gameIndex : "")]);
		}
		public static function push_plurk(id:String = ""):void {
			exec_javascript("push_plurk(" + id + ")");
		}
		public static function push_twitter(id:String = ""):void {
			exec_javascript("push_twitter(" + id + ")");
		}
		
		// example: Global.exec_javascript("winopen('TARGET.html','newwin',180,50)");
		public static function exec_javascript(jscommand:String):void {
			var url:String = "javascript:" + jscommand + "; void(0);";
			if (Global.isOnline) getURL(url, "_self");
			trace("javascript: " + jscommand);
		}
	}
	
}