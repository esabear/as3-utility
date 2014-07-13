package tw.display 
{
	import flash.display.*;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.events.Event;
	/**
	 * MovieClip捲動
	 * @author Jones 
	 */
	public class Roll extends MovieClip
	{
		
		
		public  function Roll(direct:String, speed:Number) 
		{
			_direct = direct;
			_speed = speed;
			//addEventListener(Event.ADDED_TO_STAGE,init);
		}
		public function init(e:Event):void {
			
			/*var bmd:BitmapData = new BitmapData(2*_roll_mc.width,_roll_mc.height, true, 0x000000);
			bmd.draw(_roll_mc);
			bmd.copyPixels(bmd,new Rectangle(_roll_mc.x,_roll_mc.y,_roll_mc.width,_roll_mc.height),new Point(_roll_mc.x+_roll_mc.width,_roll_mc.y));
			var btm:Bitmap=new Bitmap(bmd);
			btm.x= _roll_mc.x;
			btm.y= _roll_mc.y;*/
			//_roll_mc.x += 50;		
			trace("n")
			/*stage.addChild(btm);
			stage.setChildIndex(btm, n);
			stage.removeChild(_roll_mc);
			btm.addEventListener(Event.ENTER_FRAME, enterframe);*/
		}
		public function enterframe(e:Event) {
			e.target.x-=_speed;
		}
		
	}
	
}