package 
{
	import flash.events.EventDispatcher;
	import flash.events.Event;
	
	/**
	 * Events
	 * @author Bear
	 */
	public class Events
	{
		public static var talker:EventDispatcher = new EventDispatcher();
		
		public static const CLICK_PRO = "click_product";
		public static const CLICK_INDEX = "click_index";
		public static const GOTO_PRO = "GOTO_product";
		public static const GOTO_INDEX = "GOTO_index";
		//----------------------------------------------------------------
		public static function say(eventString:String, isBubble:Boolean = false ):void {
			trace("say:", eventString);
			talker.dispatchEvent(new Event(eventString, isBubble));
		}
		public static function sayEvent(events:*):void {
			trace("sayEvent:", events);
			talker.dispatchEvent(events);
		}
	}
	
}