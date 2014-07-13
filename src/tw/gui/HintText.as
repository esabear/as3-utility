package tw.gui
{
	import flash.events.FocusEvent;
	import tw.utils.EventManager;
	
	/**
	 * ...
	 * @author Bear
	 */
	public class HintText 
	{
		public static function setup(target, defaultText:String):void {
			EventManager.add(target, FocusEvent.FOCUS_IN, focus_in_target, [target, defaultText]);
			EventManager.add(target, FocusEvent.FOCUS_OUT, focus_out_target, [target, defaultText]);
		}
		
		public static function focus_in_target(target, defaultText):void {
			if (target.text == defaultText)
				target.text = "";
		}
		
		public static function focus_out_target(target, defaultText):void {
			if (target.text == "")
				target.text = defaultText;
		}
	}
	
}