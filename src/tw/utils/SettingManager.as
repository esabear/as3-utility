package tw.utils 
{
	/*************************************************************************\
	 * read settings form xml-file
	 * @author Bear
	 * @Date: 2009/11/24
	 * @example:

<?xml version="1.0" encoding="utf-8"?>
<setting>
<param key="photo_path"><![CDATA[images/]]></param>
<param key="photo_num">42</param>
</setting>

	\*************************************************************************/
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	
	public class SettingManager 
	{
		
		public function SettingManager() {
			trace ("SettingManager : 不需要被初始化");
		}
		
		public static function read(path:String, params:Array, callback:Function):void {
			var myLoader:URLLoader = new URLLoader();
				
			EventManager.add(myLoader, Event.COMPLETE, callback_agent, [myLoader, params, callback]);
			EventManager.add(myLoader, IOErrorEvent.IO_ERROR, errorHandler);
			EventManager.add(myLoader, SecurityErrorEvent.SECURITY_ERROR, errorHandler);
			
			try {
				myLoader.load(new URLRequest(path));
			} catch (e) { trace(e); }
		}
		
		private static function callback_agent(loader:URLLoader, params:Array, callback:Function):void {
			EventManager.remove(loader);
			
			var settingXML:XML = new XML(loader.data);
			var callParams:Array = [];
			var len_params:uint = params.length;
			for (var i:uint = 0; i < len_params; i++) {
				callParams.push(settingXML.param.(@key==params[i]));
			}
			callback.apply(null, callParams);
		}
		
		private static function errorHandler(e:Event):void {
			EventManager.remove(e.target);
			trace(e);
		}
	}
	
}