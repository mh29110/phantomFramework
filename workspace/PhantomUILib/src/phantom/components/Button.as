package phantom.components
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import phantom.core.handlers.Handler;
	import phantom.core.managers.render.Styles;
	
	
	/**selected属性变化时调度*/
	[Event(name="change",type="flash.events.Event")]
	
	/**按钮类，可以是单态，两态和三态，默认三态(up,over,down)*/
	public class Button extends ComponentAdapter 
	{
		protected static var stateMap:Object = {"rollOver": 2, "rollOut": 1, "mouseDown": 3, "mouseUp": 2, "selected": 3};
		protected var _clickHandler:Handler;
		protected var _state:int;
		protected var _toggle:Boolean;
		protected var _selected:Boolean;
		protected var _skin:String;
		protected var _stateNum:int = Styles.buttonStateNum;
		
		protected var _btnClip:Clip ;
		protected var _btnLabel:Label;
		
		public function Button(skin:*) 
		{
			super(skin);
		}
		
		override protected function initializeSkin(skin:*):void 
		{
			_btnClip = new Clip(skin);
			
			if(skin is  MovieClip)
			{	//尝试获取按钮文本
				_btnLabel = new Label(skin.getChildByName("txt_label"));
			}

			_btnClip.addEventListener(MouseEvent.ROLL_OVER, onMouse);
			_btnClip.addEventListener(MouseEvent.ROLL_OUT, onMouse);
			_btnClip.addEventListener(MouseEvent.MOUSE_DOWN, onMouse);
			_btnClip.addEventListener(MouseEvent.MOUSE_UP, onMouse);
			_btnClip.addEventListener(MouseEvent.CLICK, onMouse);
		}
		
		protected function onMouse(e:MouseEvent):void 
		{
			if ((_toggle == false && _selected) || _disabled) {
				return;
			}
			if (e.type == MouseEvent.CLICK) {
				if (_toggle) {
					selected = !_selected;
				}
				if (_clickHandler) {
					_clickHandler.execute();
				}
				return;
			}
			if (_selected == false) {
				state = stateMap[e.type];
			}
		}
		
		/**按钮标签*/
		public function get label():String 
		{
			return _btnLabel.text;
		}
		
		public function set label(value:String):void 
		{
			if (_btnLabel.text != value) {
				_btnLabel.text = value;
				callLater(changeState);
			}
		}
		
		/**是否是选择状态*/
		public function get selected():Boolean 
		{
			return _selected;
		}
		
		public function set selected(value:Boolean):void 
		{
			if (_selected != value) {
				_selected = value;
				state = _selected ? stateMap["selected"] : stateMap["rollOut"];
				sendEvent(Event.CHANGE);
				//兼容老版本
				sendEvent(Event.SELECT);
			}
		}
		
		protected function get state():int 
		{
			return _state;
		}
		
		protected function set state(value:int):void 
		{
			_state = value;
			callLater(changeState);
		}
		/**皮肤的状态数，支持单态，两态和三态按钮，分别对应1,2,3值，默认是三态*/
		public function get stateNum():int 
		{
			return _stateNum;
		}
		
		public function set stateNum(value:int):void 
		{
			if (_stateNum != value) {
				_stateNum = value < 1 ? 1 : value > 3 ? 3 : value;
			}
		}
		protected function changeState():void 
		{
			var index:int = _state;
			if (_stateNum == 2) {
				index = index < 2 ? index : 1;
			} else if (_stateNum == 1) {
				index = 0;
			}
			_btnClip.gotoAndStop(index);
		}
		
		/**是否是切换状态*/
		public function get toggle():Boolean 
		{
			return _toggle;
		}
		
		public function set toggle(value:Boolean):void 
		{
			_toggle = value;
		}
		
		override public function set disabled(value:Boolean):void 
		{
			if (_disabled != value) 
			{
				state = _selected ? stateMap["selected"] : stateMap["rollOut"];
				super.disabled = value;
			}
		}
		
		
		/**按钮标签描边(格式:color,alpha,blurX,blurY,strength,quality)*/
		public function get labelStroke():String 
		{
			return _btnLabel.stroke;
		}
		
		public function set labelStroke(value:String):void 
		{
			_btnLabel.stroke = value;
		}
		
		/**点击处理器(无默认参数)*/
		public function get clickHandler():Handler 
		{
			return _clickHandler;
		}
		
		public function set clickHandler(value:Handler):void 
		{
			_clickHandler = value;
		}
		
		/**按钮标签控件*/
		public function get btnLabel():Label 
		{
			return _btnLabel;
		}
		
	
	}
}