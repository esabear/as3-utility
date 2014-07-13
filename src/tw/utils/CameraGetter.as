package tw.utils
{
	import flash.events.StatusEvent;
	import flash.media.Camera;
	import flash.media.Video;
	import flash.system.Security;
	
	/**
	 * CameraGetter
	 * @author Bear
	 * TODO: 2nd mute handler
	 */
	public class CameraGetter
	{
		//----------------------------------------------------------------
		public static var cam:Camera;
		public static var vid:Video;
		
		//----------------------------------------------------------------
		public static function stop(autoRemoveVid:Boolean=true):void {
			if (vid && vid.parent && autoRemoveVid) vid.parent.removeChild(vid);
			if (vid) {
				vid.attachCamera(null);
				vid = null;
			}
		}
		public static function start($width:Number, $height:Number, $fps:Number, callback:Function = null, callback_fail:Function = null):void {
			
			if (vid && vid.parent) vid.parent.removeChild(vid);
			if (vid) {
				vid.attachCamera(null);
				vid = null;
			}
			
			if (cam && cam.muted) {
				Security.showSettings();
				return;
			} else if (cam && !cam.muted) {
			} else
				cam = Camera.getCamera();
			
			if (cam != null)
			{
				cam.setMode($width, $height, $fps);
				cam.addEventListener(StatusEvent.STATUS, statusHandler);
			
				vid = new Video($width, $height);
				vid.attachCamera(cam);
				
			} else {
				if (callback_fail != null) callback_fail();
			}
			
			function statusHandler(e:StatusEvent):void {
				switch(e.code) {
					case "Camera.Muted" :
						if (vid) {
							vid.clear();
							vid = null;
						}
						if (callback_fail != null) callback_fail();
					break;
					case "Camera.Unmuted" :
						if (!vid) {
							vid = new Video($width, $height);
							vid.attachCamera(cam);
						}
						if (callback != null) callback();
					break;
				}
			}
		}
	}
	
}