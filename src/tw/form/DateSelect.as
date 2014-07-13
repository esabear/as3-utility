package tw.form
{
	import fl.controls.ComboBox;
	import fl.data.DataProvider;
	import flash.events.Event; 
	/**
	 * 日期選擇
	 * @author Jones Yu 
	 * @updated by Bear
	 */
	public class DateSelect 
	{
		const YEAR_BEGIN:int = 1900;
		private var _sep:String = "-";
		
		private var _year_cb:ComboBox;
		private var _month_cb:ComboBox;
		private var _day_cb:ComboBox; 
		
		public function DateSelect(year_cb:ComboBox, month_cb:ComboBox, day_cb:ComboBox) 
		{
			_year_cb = year_cb;
			_month_cb = month_cb;
			_day_cb = day_cb;
			
			init();
		}
		
		public function init() { //將"年","月",值丟入下拉選單
			var today:Date = new Date();
			
			var year_arr:Array = new Array();
			for (var iy:Number = YEAR_BEGIN; iy < today.getUTCFullYear() + 1; iy++) {
				year_arr.unshift(iy);
			}
			var dp1:DataProvider = new DataProvider(year_arr);
			_year_cb.dataProvider = dp1;
			
			var month_arr:Array = new Array();
			for (var im:Number = 1; im < 13; im++) {
				month_arr.push(im);
			}
			var dp2:DataProvider = new DataProvider(month_arr);
			_month_cb.dataProvider = dp2;
			
			_year_cb.addEventListener(Event.CHANGE , setDateDP);
			_month_cb.addEventListener(Event.CHANGE , setDateDP);
			
			setSelection();
		}
		
		public function get data ():String {
			var date:Array = new Array();
				date.push(_year_cb.value);
				date.push(to2(_month_cb.value));
				date.push(to2(_day_cb.value));
			return date.join(_sep);
		}
		
		public function get date ():Date {
			return new Date(Number(_year_cb.value), Number(_month_cb.value), Number(_day_cb.value));
		}
		
		// 取得實體 -------------------------------------------------------------------
		public function get year_cb ():ComboBox {
			return _year_cb;
		}
		
		public function get month_cb ():ComboBox {
			return _month_cb;
		}
		
		public function get day_cb ():ComboBox {
			return _day_cb;
		}
		
		// private ---------------------------------------------------------------------
		private function setSelection():void { //重置
			var sel_date:Date = new Date();
			_year_cb.selectedIndex = 0;
			_month_cb.selectedIndex = sel_date.getMonth();
			
			setDateDP();
			_day_cb.selectedIndex = sel_date.getDate() - 1;
		}
		
		private function setDateDP(event:Event=null) { //以目前下拉值作判定日期變換
			var nDate_arr:Array = new Array(31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);
			var date_arr:Array = new Array();
			var iy:Number = Number(_year_cb.value);
			var im:Number = Number(_month_cb.value);

			var nDate = nDate_arr[im-1];
			if ( ( iy % 4 == 0 ) && (im == 2) ) {
				nDate = 29;
			}
			for (var id:Number = 1; id < nDate + 1; id++) {
				date_arr.push(id);
			}

			var selectedDay:uint = ( date_arr.length-1 < _day_cb.selectedIndex ) ? date_arr.length-1 : _day_cb.selectedIndex;
			var dp3:DataProvider = new DataProvider(date_arr);
			_day_cb.dataProvider = dp3;
			_day_cb.selectedIndex = selectedDay;
		} 
		
		private function to2 (num:String):String {
			return (num.length < 2) ? ("0"+num) : num;
		}
	}
}