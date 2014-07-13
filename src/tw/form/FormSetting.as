package tw.form
{
	/******************************************************\
	 * 設置表單欄位
	 * Date: 2009/02/09
	 * Last modified: 2009/09/02 增強記憶體回收機制
	 * Author: Bear
	\******************************************************/
	import fl.controls.*;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.EventDispatcher;
	
	import tw.form.DateSelect;
	import tw.form.AddrSelect;
	
	public class FormSetting extends EventDispatcher
	{
		public static const FIELD_ERROR:String = "FIELD_ERROR";
		
		private const T_CHECKBOX = "t_checkbox";
		private const T_TEXTINPUT = "t_textinput";
		private const T_GENDER = "t_gender";
		private const T_EMAIL = "t_email";
		private const T_MOBILE = "t_mobile";
		private const T_BIRTHDAY = "t_birthday";
		private const T_DATE = "t_date";
		private const T_ADDRESS = "t_addr";
		private const T_COMBOBOX = "t_combobox";
		private const T_INVOICE = "t_invoice"; // 發票欄位
		
		private var _muteMode:Boolean; // 是否輸出訊息
		
		private var _field_tabIndex:uint = 1;
		private var _field_list:Array = new Array(); // 欄位列表: [實體名,變數名,輸出中文,必要性,type]
		
		private var _field_list_skip:Array = new Array(); // 登入過不必填的欄位
		private var _field_list_focus:Array = new Array(); // 登入過的必填欄位 (optional)
		private var _field_group_unique:Array = new Array(); // 不得重複的欄位群
		
		public var error_field = null;
		public var error_output:String = "";
		public var error_desc:String = "";
		
		public var enabled_alpha:Number = 1;
		public var disabled_alpha:Number = .2;
		
/**************************************************************************************************\
 * 可用函式
 * getValue () // 取得所有值
 * addComboBox(f:ComboBox, str:String, output:String, necessary:Boolean=true) // 通用
 * addTextInput(f:TextInput, str:String, output:String="文字欄位", necessary:Boolean=true, max:uint=50, limit:String=null, type=T_TEXTINPUT) // 通用
 * addInvoice(f:TextInput, str:String="invoice", output:String="發票", necessary:Boolean=true, max:uint=10, limit:String="a-zA-Z0-9")
 * addGender(m:RadioButton, f:RadioButton, str:String="gender", output:String="性別", necessary:Boolean=true)
 * addDate(y:ComboBox, m:ComboBox, d:ComboBox, str:String="birthday", output:String="生日", necessary:Boolean=true, isBirthday:Boolean=true)
 * addMobile(f:TextInput, str:String="mobile", output:String="手機", necessary:Boolean=true, max:uint=10, limit:String="0-9")
 * addEmail(f:TextInput, str:String="email", output:String="信箱", necessary:Boolean=true)
 * addAddress(z:TextInput, c:ComboBox, a:ComboBox, s:TextInput, str:String="address", output:String="地址", necessary:Boolean=true)
 * addSkiper (c:CheckBox, list:Array, str:String="registered", output:String="", necessary:Boolean=false) // 已登入欄位的開關
 * addGender(m:RadioButton, f:RadioButton) // 設定性別欄位
 * addUniqueGroup (ary:Array) // 設定不得重複的文字欄位
 * addSkiper (c:CheckBox, list:Array) // 已登入欄位的開關
 * clearTexts (s:Array) // 清除重填
 *
 * 附屬工具
 * valid_email (str:String):Boolean
 * valid_invoice (str:String):Boolean
 * in_array (key, array:Array):Boolean
 * makeDigitLength (number, len:uint)
 * setFocusOn (f) // 聚焦於f欄位
 *
 * 自發事件
 * FIELD_ERROR 欄位填寫錯誤
\**************************************************************************************************/
		
		public function formSetting(muteMode = false)
		{
			_muteMode = muteMode;
			say ("初始化...");
		}
		
		// 取得所有值 --------------------------------------------------------------------------
		public function getValue ():Object {
			
			var result_field = valid_all ();
			if (!result_field) return null;
			
			var datas:Object = new Object();
			
			for (var i = 0; i < result_field.length; i++) {
				
				var field = result_field[i][0];
				var variable = result_field[i][1];
				var type = result_field[i][2];
				
				var fieldValue;
				
				switch (type) {
					case T_CHECKBOX:
						fieldValue = field.selected ? 1 : 0;
						break;
						
					case T_GENDER:
						fieldValue = field.selectedData;
						break;
						
					case T_MOBILE:
					case T_EMAIL:
					case T_TEXTINPUT:
						fieldValue = field.text;
						break;
						
					case T_INVOICE:
						fieldValue = field.text.toUpperCase();
						break;
					
					case T_BIRTHDAY:
					case T_DATE:
					case T_ADDRESS:
						fieldValue = field.data;
						break;
						
					case T_COMBOBOX:
						fieldValue = field.value;
						break;
				}
				
				if (variable != null)
					datas[variable] = fieldValue;
			}
			return datas;
		}
		
		// 欄位設定 ---------------------------------------------------------------------------
		public function addComboBox(f:ComboBox, str:String, output:String, necessary:Boolean=true):void {
			f.tabIndex = _field_tabIndex++;
			
			_field_list.push ([f, str, output, necessary, T_COMBOBOX]);
		}
		
		public function addTextInput(f:TextInput, str:String, output:String="文字欄位", necessary:Boolean=true, max:uint=50, limit:String=null, type=T_TEXTINPUT):void {
			f.maxChars = max;
			f.restrict = limit;
			f.tabIndex = _field_tabIndex++;
			
			_field_list.push ([f, str, output, necessary, type]);
		}
		
		public function addInvoice(f:TextInput, str:String="invoice", output:String="發票", necessary:Boolean=true, max:uint=10, limit:String="a-zA-Z0-9"):void {
			addTextInput (f, str, output, necessary, max, limit, T_INVOICE);
		}
		
		public function addMobile(f:TextInput, str:String="mobile", output:String="手機", necessary:Boolean=true, max:uint=10, limit:String="0-9"):void {
			addTextInput (f, str, output, necessary, max, limit, T_MOBILE);
		}
		
		// 設定性別欄位
		public function addGender(m:RadioButton, f:RadioButton, str:String="gender", output:String="性別", necessary:Boolean=true):void {
			var rbg:RadioButtonGroup = new RadioButtonGroup("groupSex");
				rbg.addRadioButton(m);
				rbg.addRadioButton(f);
			m.value = "M"; // m for male
			f.value = "F"; // f for female
			f.selected = true;
			f.tabIndex = _field_tabIndex++;
			
			_field_list.push ([rbg, str, output, necessary, T_GENDER]);
		}
		
		public function addDate(y:ComboBox, m:ComboBox, d:ComboBox, str:String="birthday", output:String="生日", necessary:Boolean=true, isBirthday:Boolean=true) {
			var date:DateSelect = new DateSelect(y, m, d);
			
			y.tabIndex = _field_tabIndex++;
			m.tabIndex = _field_tabIndex++;
			d.tabIndex = _field_tabIndex++;
			
			_field_list.push ([date, str, output, necessary, (isBirthday ? T_BIRTHDAY : T_DATE)]);
		}
		
		public function addEmail(f:TextInput, str:String="email", output:String="信箱", necessary:Boolean=true):void {
			f.maxChars = 50;
			f.tabIndex = _field_tabIndex++;
			
			_field_list.push ([f, str, output, necessary, T_EMAIL]);
		}
		
		public function addAddress(z:TextInput, c:ComboBox, a:ComboBox, s:TextInput, str:String="address", output:String="地址", necessary:Boolean=true, path:String=""):void {
			var address:AddrSelect;
			address = path ? new AddrSelect(z,c,a,s,path) : new AddrSelect(z,c,a,s); //zip, city, area, address);
			
			c.tabIndex = _field_tabIndex++;
			a.tabIndex = _field_tabIndex++;
			s.tabIndex = _field_tabIndex++;
			
			_field_list.push ([address, str, output, necessary, T_ADDRESS]);
		}
		
		public function addUniqueGroup (ary:Array):void {
			_field_group_unique.push (ary);
		}
		
		// 已登入欄位的開關 ---------------------------------------------------
		public function addSkiper (c:CheckBox, list:Array, focus:Array=null, str:String="registered", output:String="", necessary:Boolean=false):void {
			_field_list_skip = list;
			if (focus) _field_list_focus = focus;
			
			c.useHandCursor = true; // 顯現手指
			c.addEventListener (Event.CHANGE, check_skip_field);
			c.addEventListener (Event.REMOVED_FROM_STAGE, destroy_this);
			c.tabIndex = _field_tabIndex++;
			
			check_skip_field ({target:c});
			
			_field_list.push ([c, str, output, necessary, T_CHECKBOX]);
		}
		
		private function check_skip_field (e:Object=null):void {
			var enable:Boolean;
			var alpha:Number;
			
			if (e.target.selected) {
				enable = false;
				alpha = disabled_alpha;
			} else {
				enable = true;
				alpha = enabled_alpha;
			}
			
			for (var i = 0; i < _field_list_skip.length; i++) {
				_field_list_skip[i].enabled = enable;
				_field_list_skip[i].alpha = alpha;
			}
			
			for (i = 0; i < _field_list_focus.length; i++) {
				_field_list_focus[i].drawFocus(!enable);
				
				if (!i && !enable) _field_list_focus[i].setFocus ();
			}
		}
		
		// 清除重填 -----------------------------------------------------------
		public static function clearTexts (s:Array) {
			for (var i = 0; i < s.length; i++) {
				s[i].text = "";
			}
		}
		// form 格式檢查 ------------------------------------------------------
		private function valid_all ():Array {
			
			var result_field:Array = new Array();
			
			for (var i = 0; i < _field_list.length; i++) {
				
				var field = _field_list[i][0];
				var variable = _field_list[i][1];
				var output = _field_list[i][2];
				var necessary = _field_list[i][3];
				var type = _field_list[i][4];
				
				switch (type) {
					case T_INVOICE:
						if (!valid_invoice(field.text) && field.enabled && necessary) {
							error (field, output, "格式錯誤");
							return null;
						}
						break;
						
					case T_TEXTINPUT:
						if (!field.text && field.enabled && necessary) {
							error (field, output, "未填寫");
							return null;
						}
						break;
						
					case T_CHECKBOX:
						if (!field.selected && field.enabled && necessary) {
							error (field, output, "未勾選");
							return null;
						}
						break;
						
					case T_MOBILE:
						if (!valid_mobile(field.text) && field.enabled && necessary) {
							error (field, output, "格式錯誤");
							return null;
						}
						break;
						
					case T_EMAIL:
						if (!valid_email(field.text) && field.enabled && necessary) {
							error (field, output, "格式錯誤");
							return null;
						}
						break;
						
					case T_BIRTHDAY: // 檢查是否超出目前時間
						var nowtime:Date = new Date();
						var choosetime:Date = field.date;//new Date(Number(cbYear.value), Number(cbMonth.value), Number(cbDay.value));
						if ((choosetime.getTime() > nowtime.getTime()) && field.year_cb.enabled && necessary) {
							error (field.year_cb, output, "時間錯誤");
							return null;
						}
						break;
						
					case T_ADDRESS:
						if (!field.textInput.text && field.textInput.enabled && necessary) {
							error (field.textInput, output, "未填寫");
							return null;
						}
						break;
					
					case T_GENDER:
						if (field.selectedData == null) {
							error (field.getRadioButtonAt(0), output, "未選擇");
							return null;
						}
						break;
						
					case T_DATE:
					case T_COMBOBOX:
					default:
						// do nothing
						break;
				}
				
				result_field.push ([field, variable, type]);
			}
			
			// 檢查是否重複
			for (i = 0; i < _field_group_unique.length; i++)
				if (!valid_unique_group(_field_group_unique[i]))
					return null;
			
			return result_field;
		}
		
		// 檢查email格式
		public static function valid_email (str:String):Boolean {
			var emailExpression:RegExp = /[\w\.-]+@{1}\w[\w\.-]+\.[\w\.-]*[\w]$/i;
			return emailExpression.test(str);
		}
		// 檢查手機格式
		public static function valid_mobile (str:String):Boolean {
			var mobileExpression:RegExp = /09[0-9]{8}/i;
			return mobileExpression.test(str);
		}
		// 檢查發票
		public static function valid_invoice (str:String):Boolean {
			if (str.length != 10) return false;
			var receiptExpression:RegExp = /^[a-zA-Z]{2}[0-9]{8}/i;
			return receiptExpression.test(str);
		}
		// 檢查是否有重複
		public function valid_unique_group (ary:Array):Boolean {
			for (var i = 0; i < ary.length; i ++)
				for (var j = i+1; j < ary.length; j++)
					if (ary[i].text && (ary[i].text == ary[j].text)) {
						error (ary[j], "填寫內容", "E-mail重覆");
						return false;
					}
			return true;
		}
		
		// 工具 ---------------------------------------------------------------
		// 找出陣列中是否存在某值
		public static function in_array (key, array:Array):Boolean {
			for (var i = 0; i < array.length; i++)
				if (array[i] == key)
					return true;
			return false;
		}
		
		// 加長數字的長度 如:1,2,3 => 01,02,03
		public static function makeDigitLength (number, len:uint):String {
			var str:String = "";
			for (var i = 0; i < (len - number.toString().length); i++)
				str = "0" + str;
			str += number.toString();
			return str;
		}
		
		public static function setFocusOn (f):void {
			if (!f) return;
			f.setFocus();
			f.drawFocus(true);
			
			if (f is TextInput) {
				f.setSelection(0, f.text.length);
			}
		}
		
		// class 自身結構 ------------------------------------------------------
		private function say (str:String):void {
			if (!_muteMode)
				trace ("formSetting: " + str);
		}
		
		private function error (target, output:String, desc:String):void {
			setFocusOn (target);
			
			error_field = target;
			error_output = output;
			error_desc = desc;
			
			this.dispatchEvent (new Event(FIELD_ERROR));
		}
		
		private function destroy_this(e:*= null) {
			e.target.removeEventListener(Event.CHANGE, check_skip_field);
			e.target.removeEventListener(Event.REMOVED_FROM_STAGE, destroy_this);
		}
		
		public function destroy(e:*= null) {
			_field_list = null;
			_field_list_skip = null;
			_field_list_focus = null;
			_field_group_unique = null;
			error_field = null;
		}
	}
	
}