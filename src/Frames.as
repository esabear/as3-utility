package 
{
	import flash.events.Event;
	
	/**
	 * Frames
	 * @author Bear
	 
if you are using flash 10 then there are 7 events per frame:

Event of event type Event.ENTER_FRAME dispatched
Constructor code of children MovieClips is executed
Event of event type Event.FRAME_CONSTRUCTED dispatched
MovieClip frame actions are executed
Frame actions of children MovieClips are executed
Event of event type Event.EXIT_FRAME dispatched
Event of event type Event.RENDER dispatched

	 */
	public class Frames
	{
		public static function ready($func:Function, $this, $args:Array=null):void {
			$this.addEventListener(Event.FRAME_CONSTRUCTED, launchFunction);
			function launchFunction(e:Event):void {
				$this.removeEventListener(Event.FRAME_CONSTRUCTED, launchFunction);
				$func.apply($this, $args);
			}
		}
	}
	
}