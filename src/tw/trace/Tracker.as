package tw.trace {
	/*************************************************************************\
	 * Author: 熊
	 * Date: 2009/11/09
	 * 穿透力Tracker模組(for Google Analytics)
	 * 使用方式: (將 /myPage 置換為不同的ID值)
	 * 須搭配component使用
	 
	import tw.trace.Tracker;
	Tracker.Track ("/myPage");
	
	\*************************************************************************/
	import com.google.analytics.GATracker; 
	
	public class Tracker {
		
		private static var _tracker:GATracker;
		
		public function Tracker () {
			trace ("Tracker: 不需要初始化");
		}
		
		public static function init(ref:*):void {
			if (_tracker) return;
			try {
				_tracker = new GATracker( ref, "window.pageTracker", "Bridge", false );
			} catch (e) { }
		}
		
		public static function Track (path:String):void {
			if (!_tracker) {
				trace("(開發中可忽略) 嘗試記錄"+ path +"...目前無法使用Tracker, 請先執行init()並置於包含ga.js的網頁中");
				return;
			}
			_tracker.trackPageview(path); 
		}
		
		public static function TrackEvent (category:String, action:String, label:String = null, value=null):void {
			if (!_tracker) {
				trace("(開發中可忽略) 嘗試記錄"+ path +"...目前無法使用Tracker, 請先執行init()並置於包含ga.js的網頁中");
				return;
			}
			_tracker.trackEvent(category, action, label, value); 
		}
	}
}