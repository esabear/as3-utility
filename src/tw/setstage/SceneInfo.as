package tw.setstage 
{
	import flash.display.Sprite;
	import flash.utils.ByteArray;
	import caurina.transitions.Tweener;
	/******************************************************\
	 * 2009.01.06
	 * 保存場景物件的各種變數
	 * 狀態: 棄用 (改用Dictionary)
	 * @author Bear
	\******************************************************/
	public class SceneInfo extends Sprite 
	{
		private var _variablesKey:Array = new Array();
		private var _variablesValue:Array = new Array();
		private var _propertyKey:Array = new Array();
		private var _propertyValue:Array = new Array();
		
		public function SceneInfo() {
		}
		
		public function setVariable(key:Object, value:Object):Boolean {
			return add_to_Array(key, value, _variablesKey, _variablesValue);
		}
		
		public function getVariable(key:Object):Object {
			return get_from_Array(key, _variablesKey, _variablesValue);
		}
		
		public function presetProperty(key:Object, value:Object):Boolean {
			return add_to_Array(key, value, _propertyKey, _propertyValue);
		}
		
		public function getProperty(key:Object):Object {
			return get_from_Array(key, _propertyKey, _propertyValue);
		}
		
		public function applyInstantProperty(value:Object, target:Object, refferObject:Object = null, onComplete = null):void {
			var ref:Object = (refferObject == null) ? target : refferObject;
			
			var buffer:ByteArray = new ByteArray();
			buffer.writeObject(value);
			buffer.position = 0;
			var prop:Object = buffer.readObject();

			if (prop.hasOwnProperty ("shiftX") ) {
				prop.x = ref.x + prop.shiftX;
				delete prop.shiftX;
			}
			if (prop.hasOwnProperty ("shiftY") ) {
				prop.y = ref.y + prop.shiftX;
				delete prop.shiftY;
			}
			if (onComplete != null)
				prop.onComplete = onComplete;
			
			Tweener.addTween(target, prop);
		}
		
		public function applyProperty(key:Object, target:Object, refferObject:Object = null, onComplete = null):void {
			var prop:Object = getProperty(key)
			applyInstantProperty(prop, target, refferObject, onComplete);
		}
		
		private function add_to_Array(key:Object, value:Object, keyArray:Array, valueArray, fOverride:Boolean = true):Boolean {
			var i = keyArray.indexOf(key);
			if (fOverride && (i != -1)) { // key值已存在 => 覆蓋
				valueArray[i] = value;
				return false;
			}
			keyArray.push(key);
			valueArray.push(value);
			return true; // true:表示新增了一筆
		}
		
		private function get_from_Array(key:Object, keyArray:Array, valueArray:Array):Object {
			return valueArray[keyArray.indexOf(key)];
		}
		
		public function clear():void {
			_variablesKey.length = 0;
			_variablesValue.length = 0;
		}
	}
}