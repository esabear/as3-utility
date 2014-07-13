package tw.form
{
	import fl.controls.ComboBox;
	import fl.controls.TextInput;
	import fl.data.DataProvider;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	/**
	 * 住址選擇
	 * @author Jones Yu
	 * @updated by Bear 2009
	 */
	public class AddrSelect 
	{
		private var _zip:TextInput;
		private var _city:ComboBox;
		private var _area:ComboBox;
		private var _address:TextInput;
		private var _xmlPath:String;
		private var _twzip_xml:XML;
		
		public function AddrSelect (txtZip:TextInput, comboCity:ComboBox, comboArea:ComboBox, txtDetail:TextInput = null, path = "resource/twzip.xml") 
		{
			_zip = txtZip;
			_city = comboCity;
			_area = comboArea;
			_address = txtDetail;
			_xmlPath = path;
			init();
		}
		
		// 回傳完整地址
		public function get data ():String {
			var address:Array = new Array();
				address.push(_city.value);
				address.push(_zip.text);
				address.push(_area.value);
			if (_address)
				address.push(_address.text);
			return address.join(" "); // 回傳以空格隔開的完整位址
		}
		
		public function get textInput ():TextInput {
			return _address;
		}
		
		// private -------------------------------------------------------------------------
		private function init () {
			loadTwZip();
			_zip.editable = false;
			_city.addEventListener(Event.CHANGE , eventCity);
			_area.addEventListener(Event.CHANGE , eventArea);
		}
		
		private function loadTwZip ():void {
			var loader:URLLoader = new URLLoader();
			loader.addEventListener (Event.COMPLETE,onCompleteTwZip);
			loader.addEventListener (IOErrorEvent.IO_ERROR, ioErrorHandler);
			loader.load (new URLRequest(_xmlPath));
		}
		
		private function onCompleteTwZip (event:Event):void {
			_twzip_xml = new XML(event.target.data);
			getCity();
			getArea(0);
		}
		
		private function eventCity (event:Event):void {
			getArea(_city.selectedIndex);
		}
		
		private function eventArea (event:Event):void {
			_zip.text = _twzip_xml.city[_city.selectedIndex].area[_area.selectedIndex].@zip;
		}
		
		private function getCity ():void { //取得縣市
			var dp : DataProvider = new DataProvider();
			var len:int = _twzip_xml.city.length();
			
			for (var i:int = 0; i < len; i++) {
				dp.addItem( { label: _twzip_xml.city[i].@name } );
			}
			_city.dataProvider = dp;
			_city.selectedIndex = 0;
		}
		
		private function getArea (num):void { //取得區域
			var dp : DataProvider = new DataProvider();
			var len:int = _twzip_xml.city[num].area.length();
			
			for (var i:int = 0; i < len; i++) {
				dp.addItem( { label: _twzip_xml.city[num].area[i].@name } );
			}
			_area.dataProvider = dp;
			_area.selectedIndex = 0;
			_zip.text = _twzip_xml.city[num].area[0].@zip;
		}
		
		private function ioErrorHandler (e):void {
			trace ("AddrSelect : "+ _xmlPath +" 路徑或檔名不存在。");
		}
	}
}