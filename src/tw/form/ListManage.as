package tw.form
{
	/******************************************************\
	 * List加強: 上移/下移/刪除按鈕
	 * Date:2009/02/23
	 * Author: Bear
	\******************************************************/
	import fl.controls.List;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class ListManage extends Sprite {
		
		private var _list:List;
		private var _btnUP:MovieClip = null;
		private var _btnDOWN:MovieClip = null;
		private var _btnDEL:MovieClip = null;
		
		private var _Label_disable:String = "_disable_";
		private var _Label_normal:String = "_normal_";
		
		public function ListManage (list:List) {
			_list = list;
			_list.addEventListener (Event.CHANGE, updateListeners);
		}
		
		public function addButtons (up:MovieClip=null, down:MovieClip=null, del:MovieClip=null, normalLabel:String="_normal_", disableLabel:String="_disable_"):void {
			if (up) _btnUP = up;
			if (down) _btnDOWN = down;
			if (del) _btnDEL = del;
			_Label_disable = disableLabel;
			_Label_normal = normalLabel;
			updateListeners ();
		}
		
		public function putItems (items:Array):void {
			for (var i = 0; i < items.length; i++) {
				_list.dataProvider.addItem ({label:items[i][1], data:items[i][0]});
			}
			updateListeners ();
		}
		
		public function updateListeners (e:Event=null):void {
			switch (_list.selectedIndex) {
				case -1:
					enableButton (false, _btnDEL, Remove);
					enableButton (false, _btnUP, MoveUP);
					enableButton (false, _btnDOWN, MoveDOWN);
					break;
				case (_list.length - 1):
					enableButton (true, _btnDEL, Remove);
					enableButton (true, _btnUP, MoveUP);
					enableButton (false, _btnDOWN, MoveDOWN);
					break;
				case 0:
					enableButton (true, _btnDEL, Remove);
					enableButton (false, _btnUP, MoveUP);
					enableButton (true, _btnDOWN, MoveDOWN);
					break;
				default:
					enableButton (true, _btnDEL, Remove);
					enableButton (true, _btnUP, MoveUP);
					enableButton (true, _btnDOWN, MoveDOWN);
					break;
			}
		}
		
		private function enableButton (flag, target, eventCall):void {
			if (!target) return;
			if (flag) {
				target.buttonMode = true;
				target.gotoAndStop (_Label_normal);
				target.addEventListener (MouseEvent.CLICK, eventCall);
			} else {
				target.buttonMode = false;
				target.gotoAndStop (_Label_disable);
				target.removeEventListener (MouseEvent.CLICK, eventCall);
			}
		}
		
		private function MoveUP (e:MouseEvent):void {
			if (_list.selectedIndex == -1) return;
			var index = _list.selectedIndex;
			var temp:Object = _list.dataProvider.removeItemAt (index);
			_list.dataProvider.addItemAt (temp, index-1);
			_list.selectedIndex = index-1;
			updateListeners ();
		}

		private function MoveDOWN (e:MouseEvent):void {
			if (_list.selectedIndex == -1) return;
			var index = _list.selectedIndex;
			var temp:Object = _list.dataProvider.removeItemAt (index);
			_list.dataProvider.addItemAt (temp, index+1);
			_list.selectedIndex = index+1;
			updateListeners ();
		}

		private function Remove (e:MouseEvent):void {
			if (_list.selectedIndex == -1) return;
			var index = _list.selectedIndex;
			_list.dataProvider.removeItemAt (index);
			_list.selectedIndex = -1;
			updateListeners ();
		}
	}
}