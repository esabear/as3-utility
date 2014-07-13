package tw.form
{
	import fl.controls.*;
	import tw.form.PopUp;
	import tw.services.SendGetway;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author Jones Yu
	 */
	public class Friendsetting extends SendGetway
	{   
		private var _txtName:TextInput;
		private var _txtMail:TextInput;
		private var _limit:Number;
		private var form:Object = new Object();
		private var _list:Object = new Object();
		public function Friendsetting() 
		{
			
		}
		public function fastset(list:Object, limit:Number) {
			_limit = limit;
			if (_list.Friend1    ) {setFriend(_list.Friend1)};
		    if (_list.Mail1      ) {setMail  (_list.Mail1)  };
			if (_list.Friend2    ) {setFriend(_list.Friend2)};
		    if (_list.Mail2      ) {setMail  (_list.Mail2)  };
			if (_list.Friend3    ) {setFriend(_list.Friend3)};
		    if (_list.Mail3      ) {setMail  (_list.Mail3)  };
			if (_list.Friend4    ) {setFriend(_list.Friend4)};
		    if (_list.Mail4      ) {setMail  (_list.Mail4)  };
			if (_list.Friend5    ) {setFriend(_list.Friend5)};
		    if (_list.Mail5      ) {setMail  (_list.Mail5)  };
			if (_list.Button     ) {setButton(_list.Button[0],_list.Button[1])};	
		}
		public function setFriend(txtName:TextInput) {
			_txtName = txtName;
			txtName.maxChars = 12;
		}
		public function setMail(txtMail:TextInput) {
			_txtMail = txtMail;
			txtMail.maxChars = 30;
		}
		public function setButton(send_btn:Button, reset_btn:Button) {
			send_btn.addEventListener(MouseEvent.MOUSE_DOWN, checkform);
			reset_btn.addEventListener(MouseEvent.MOUSE_DOWN,resetform);
		}
		public function setmsg(pop_mc:MovieClip, typeNum:Number) {
			_pop = new PopUp(pop_mc,typeNum);
			}
		private function checkform(e:MouseEvent) {
			var msg:String;
			var cnt = 0;
			//確認填寫資料是否有誤
			if (_list.Name1     ) { msg  =     chkFriend(_list.Name1, _list.Mail1)};
			if (_list.Name2     ) { msg +="&&"+chkFriend(_list.Name2, _list.Mail2)};
			if (_list.Name3     ) { msg +="&&"+chkFriend(_list.Name3, _list.Mail3)};
			if (_list.Name4     ) { msg +="&&"+chkFriend(_list.Name4, _list.Mail4)};
			if (_list.Name5     ) { msg +="&&"+chkFriend(_list.Name5, _list.Mail5)};
			
		   	var msgAry:Array = msg.split("&&");
			msg = "ok";
			//先判斷欄位數目
			if (msgAry.length != _limit) { msg = "您尚為填寫欄位!!"; }
			//再判斷欄位內容格式
			for (var i = 0; i < msgAry.length; i++ ) {
				if (msgAry[i] != "ok") {
					if (msg == "ok") {
						msg = msgAry[i] + "\n"
					}else {
						msg += msgAry[i] + "\n"	
					}	
				}
			}
				//判斷是否為OK若是則取得直否則秀訊息
			if (msg == "ok") {
				getFormInfo();
				var sendform:SendGetway = new SendGetway();
				var sender = sendform.SendDate("MemberService.add", form);//---------------------------------php變數設定
			}else {
				_pop.showmsg(msg);
			}
		}
		private function chkFriend(txtName:TextInput, txtMail:TextInput) {
			var m:Number = txtMail.text.indexOf("@");
			var n:Number = txtMail.text.indexOf(".", n);
			if (txtName.length == 0) {
				return "您尚未填寫朋友姓名!";
			}else if(txtMail.length==0){
				return "您尚未填寫朋友電子郵件";
			}else if (n <= 0||n-m<=1) {
				return "您的好友電子郵件有誤!";
			}else {
				return "ok";
				}
		}
		//----------------------------取得值---------------------------------------------------------
		private function getFormInfo() {
			if (_list.Name1) {
				form.Name1      =  _txtName1.text;
				form.Mail1      =  _txtMail1.text;
			}
		    if (_list.Name2) {
				form.Name2      =  _txtName2.text;
				form.Mail2      =  _txtMail2.text;
			}
			if (_list.Name3) {
				form.Name3      =  _txtName3.text;
				form.Mail3      =  _txtMail3.text;
			}
			if (_list.Name4) {
				form.Name4     =  _txtName4.text;
				form.Mail4     =  _txtMail4.text;
			}
			if (_list.Name5) {
				form.Name5      =  _txtName5.text;
				form.Mail5      =  _txtMail5.text;
			}
		}
	}
	
}