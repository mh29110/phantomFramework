package phantom.components
{
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.display.InteractiveObject;
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.geom.Point;
    import flash.text.AntiAliasType;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.utils.getQualifiedClassName;
    
    import phantom.consts.DefaultFontConfig;
    import phantom.core.events.UIEvent;
    import phantom.core.interfaces.IDispose;
    import phantom.core.ns.PhantomInternalNamespace;
    import phantom.core.utils.ObjectUtils;
    import phantom.interfaces.IComponent;
    
    
	use namespace PhantomInternalNamespace;
    public class ComponentAdapter implements IComponent,IDispose
	{
        private var _eventList:Vector.<String>;
        private var _eventFunctionList:Vector.<Function>;
        private var _eventUseCaptureList:Vector.<Boolean>;
        private var _view:MovieClip;
        private var _isDisposed:Boolean;
		protected var _toolTip:Object;
		protected var _disabled:Boolean;
		private var _mouseChildren:Boolean;
		protected var _dataSource:Object;
        
        public function ComponentAdapter(skin:*)
        {
            _eventList = new Vector.<String>();
            _eventFunctionList = new Vector.<Function>();
            _eventUseCaptureList = new Vector.<Boolean>();
            
            if(skin)
            {
                initialize(skin);
            }
        }
        
		/**鼠标提示
		 * 可以赋值为文本及函数，以实现自定义样式的鼠标提示和参数携带等
		 * @example 下面例子展示了三种鼠标提示
		 * <listing version="3.0">
		 *	private var _testTips:TestTipsUI = new TestTipsUI();
		 *	private function testTips():void {
		 *		//简单鼠标提示
		 *		btn2.toolTip = "这里是鼠标提示&lt;b&gt;粗体&lt;/b&gt;&lt;br&gt;换行";
		 *		//自定义的鼠标提示
		 *		btn1.toolTip = showTips1;
		 *		//带参数的自定义鼠标提示
		 *		clip.toolTip = new Handler(showTips2, ["clip"]);
		 *	}
		 *	private function showTips1():void {
		 *		_testTips.label.text = "这里是按钮[" + btn1.label + "]";
		 *		App.tip.addChild(_testTips);
		 *	}
		 *	private function showTips2(name:String):void {
		 *		_testTips.label.text = "这里是" + name;
		 *		App.tip.addChild(_testTips);
		 *	}
		 * </listing>*/
		public function get toolTip():Object {
			return _toolTip;
		}
		
		public function set toolTip(value:Object):void {
			if (_toolTip != value) {
				_toolTip = value;
				if (Boolean(value)) {
					_view.addEventListener(MouseEvent.ROLL_OVER, onRollMouse);
					_view.addEventListener(MouseEvent.ROLL_OUT, onRollMouse);
				} else {
					_view.removeEventListener(MouseEvent.ROLL_OVER, onRollMouse);
					_view.removeEventListener(MouseEvent.ROLL_OUT, onRollMouse);
				}
			}
		}
		
		private function onRollMouse(e:MouseEvent):void {
			_view.dispatchEvent(new UIEvent(e.type == MouseEvent.ROLL_OVER ? UIEvent.SHOW_TIP : UIEvent.HIDE_TIP, _toolTip, true));
		}
		
		/**
		 * 重绘对象
		 * 在组件被显示在屏幕之前调用render函数
		 * @see phantom.ui.components.skinAdapter.callLater
		 */		
		public function invalidate():void
		{
			callLater(render);
		}
		
		/**
		 * 渲染
		 */        
		protected function render():void
		{
			
		}
		
		/**延迟调用，在组件被显示在屏幕之前调用*/
		public function callLater(method:Function, args:Array = null):void {
			AppCenter.instance.render.callLater(method, args);
		}
		
		/**立即执行延迟调用*/
		public function exeCallLater(method:Function):void {
			AppCenter.instance.render.exeCallLater(method);
		}
		
		/**派发事件，data为事件携带数据*/
		public function sendEvent(type:String, data:* = null):void {
			if (_view.hasEventListener(type)) {
				_view.dispatchEvent(new UIEvent(type, data));
			}
		}
		
		/**是否禁用*/
		public function get disabled():Boolean {
			return _disabled;
		}
		
		public function set disabled(value:Boolean):void {
			if (_disabled != value) {
				_disabled = value;
				mouseEnabled = !value;
				_view.mouseChildren = value ? false : _mouseChildren;
				ObjectUtils.gray(_view, _disabled);
			}
		}
		
		public function set mouseChildren(value:Boolean):void {
			_mouseChildren = _view.mouseChildren = value;
		}
		
		/**数据赋值，通过对UI赋值来控制UI显示逻辑
		 * 简单赋值会更改组件的默认属性，使用大括号可以指定组件的任意属性进行赋值
		 * @example label1和checkbox1分别为组件实例的name属性
		 * <listing version="3.0">
		 * //默认属性赋值(更改了label1的text属性，更改checkbox1的selected属性)
		 * dataSource = {label1: "改变了label", checkbox1: true}
		 * //任意属性赋值
		 * dataSource = {label2: {text:"改变了label",size:14}, checkbox2: {selected:true,x:10}}
		 * </listing>*/
		public function get dataSource():Object {
			return _dataSource;
		}
		
		public function set dataSource(value:Object):void {
			_dataSource = value;
			for (var prop:String in _dataSource) {
				if (hasOwnProperty(prop)) {
					this[prop] = _dataSource[prop];
				}
			}
		}
//---------------------------------------------------uncheck---------------------------------------------------------------------------------		
        /**
         * 从父级对象中移除
         */        
        public function removeFromParent():void
        {
            if(view && view.parent)
            {
                view.parent.removeChild(view);
            }
        }
        /**
         * 添加到父级
         * @param parent        父级对象 
         */        
        public function addToParent(parent:*):void
        {
            parent.addChild(view);
        }
    
        
        /**
         * 取得全局坐标
         * @param target  目标点, <b>默认为0,0点</b>
         */        
        public function getGlobalPos(target:Point = null):Point
        {
            if(!target)
            {
                target = new Point();
            }
            return view.localToGlobal(target);
        }
      
        
        public function dispose():void
        {
            if(_isDisposed == false)
            {
                _isDisposed = true;
                destruct();
            }
        }
        public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0,useWeakReference:Boolean = false):void
        {
            if(useWeakReference == true)
            {
				_view.addEventListener(type,listener,useCapture,priority,useWeakReference);
                return;
            }
            
            var index:int = getEventListenerIndex(type, listener, useCapture);
            if(index < 0)
            {
				_view.addEventListener(type,listener,useCapture,priority,useWeakReference);
                _eventList.push(type);
                _eventFunctionList.push(listener);
                _eventUseCaptureList.push(useCapture);
            }
        }
        
        public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
        {
            var index:int = getEventListenerIndex(type, listener, useCapture);
            if(index < 0)
            {
                return;
            }
            
			_view.removeEventListener(type,listener,useCapture);
            
            _eventList.splice(index,1);
            _eventFunctionList.splice(index,1);
            _eventUseCaptureList.splice(index,1);
        }
        
        public function initialize(skin:*):void
        {
            if(!skin)
            {
                throw new Error("需要一个显示对象做为视图");
            }
            if(skin is MovieClip)
            {
                _view = skin;
            }
            initializeSkin(skin);
			skin.dispatchEvent(new Event(Event.INIT));
        }
        
        protected function getEventListenerIndex(type:String, listener:Function, useCapture:Boolean = false):int
        {
            var eventIndex:int;
            var listenerIndex:int;
            var useCaptureIndex:int;
            var maxIndex:int;
            
            eventIndex = _eventList.indexOf(type,eventIndex);
            listenerIndex = _eventFunctionList.indexOf(listener,listenerIndex);
            useCaptureIndex = _eventUseCaptureList.indexOf(useCapture,useCaptureIndex);
            if(eventIndex<0||listenerIndex<0||useCaptureIndex<0)
            {
                return Math.min(eventIndex, listenerIndex, useCaptureIndex);
            }
            
            while(eventIndex != listenerIndex && 
                listenerIndex != useCaptureIndex && 
                eventIndex != useCaptureIndex )
            {
                maxIndex = Math.max(eventIndex, listenerIndex, useCaptureIndex);
                eventIndex = maxIndex;
                listenerIndex = maxIndex;
                useCaptureIndex = maxIndex;
                
                maxIndex = Math.max(eventIndex, listenerIndex, useCaptureIndex);
                eventIndex = _eventList.indexOf(type,eventIndex);
                listenerIndex = _eventFunctionList.indexOf(listener,listenerIndex);
                useCaptureIndex = _eventUseCaptureList.indexOf(useCapture,useCaptureIndex);
            }
            
            return eventIndex;
        }
        
        protected function destruct():void
        {
            removeFromParent();
            removeEventListeners();
        }
        
        protected function removeEventListeners():void
        {
            while(_eventList.length>0)
            {
                super.removeEventListener(_eventList.pop(),
                                           _eventFunctionList.pop(),
                                           _eventUseCaptureList.pop());
            }
        }
        
        /**
         * 初始化皮肤
         * @param skin     皮肤 
         * 
         */        
        protected function initializeSkin(skin:*):void
        {
            
        }
        
        
        /**
         * 取得一个影片剪辑对象
         * @param name      剪辑的名字
         * @return 
         */        
        protected function getMovieClip(name:String):MovieClip
        {
            return getDisplayObj(name, _view);
        }
        
        /**
         * 取得一个文本对象 
         * @param name      文本的名字
         * @return 
         */        
        protected function getTextField(name:String):TextField
        {
            return getDisplayObj(name, _view);
        }
        
        /**
         * 通过路径取得一个影片剪辑<br>
         * 使用"."作为路径的分隔符
         * @param path      路径
         * @return 
         */        
        protected function getMcPath(path:String):MovieClip
        {
            var tempArr:Array = path.split(".");
            var mc:MovieClip = _view;
            for(var i:int=0;i<tempArr.length;i++)
            {
                mc= getDisplayObj(tempArr[i], mc);
            }
            
            return mc;
        }
        
        /**
         * 通过路径取得一个文本对象<br>
         * 使用"."作为路径的分隔符
         * @param path      路径
         * @return 
         */ 
        protected function getTextFieldPath(name:String):TextField
        {
            var tempArr:Array = name.split(".");
            var mc:Object = _view;
            for(var i:int=0;i<tempArr.length;i++)
            {
                mc = getDisplayObj(tempArr[i],mc as MovieClip);
            }
            return mc as TextField;
        }
        /**
         * 执行回调
         * @param callback          回调方式
         * @param args              参数
         */        
//        protected function excuteCallback(callback:Function, ...args):*
//        {
//            if(callback != null)
//            {
//                args.length = callback.length
//                return callback.apply(null, args);
//            }
//        }
        
        /**
         * 绑定文本元件字体
         * @param target        目标文本元件
         * @param format        文本格式<br>(default: font="Font_001", size=EmbedFont.size, color=0xffff00, bold=true, align=TextFormatAlign.CENTER, leading=6)
         */        
        protected function bindFont( target:TextField, format:TextFormat = null):void
        {
            if(!format)
            {
                format = new TextFormat();
                format.font = DefaultFontConfig.name;
                format.size = DefaultFontConfig.size;
                format.color = DefaultFontConfig.color;
                format.bold = DefaultFontConfig.bold;
                format.align = DefaultFontConfig.align;
                format.leading = DefaultFontConfig.leading;
            }
            
            target.defaultTextFormat = format;
            target.setTextFormat(format);
            target.antiAliasType = AntiAliasType.ADVANCED;
            target.thickness = 150;
            target.sharpness = 50;
            target.embedFonts = true;
        }
        
        
        /**
         * 取得一个显示对象
         * @param childName     子对象的名字
         * @param container     目标容器
         */        
        private function getDisplayObj(childName:String, container:DisplayObjectContainer =null):*
        {
            if(!container)
            {
                return null;
            }
            return container.getChildByName(childName);
        }
        
        public function get isDisposed():Boolean
        {
            return _isDisposed;
        }
        
        /**
         * 皮肤
         */        
        public function get view():DisplayObject
        {
            return _view;
        }
        
        /**
         * 宽
         */
        public function set width(value:Number):void
        {
            view.width = value;
        }
        public function get width():Number
        {
            return view.width;
        }
        
        /**
         * 高
         */
        public function set height(value:Number):void
        {
            view.height = value;
        }
        public function get height():Number
        {
            return view.height;
        }
        
        /**
         * 视图鼠标x轴坐标
         */        
        public function get mouseX():Number
        {
            return view.mouseX;
        }
        
        /**
         * 视图鼠标y轴坐标
         */        
        public function get mouseY():Number
        {
            return view.mouseY;
        }
        
        /**
         * x轴坐标
         */
        public function set x(value:Number):void
        {
            view.x = value;
        }
        public function get x():Number
        {
            return view.x;
        }
        
        /**
         * y轴坐标
         */
        public function set y(value:Number):void
        {
            view.y = value;
        }
        public function get y():Number
        {
            return view.y;
        }
        
        /**
         * 水平缩放比例
         */
        public function set scaleX(value:Number):void
        {
            view.scaleX = value;
        }
        public function get scaleX():Number
        {
            return view.scaleX;
        }
        
        /**
         * 垂直缩放比例
         */
        public function set scaleY(value:Number):void
        {
            view.scaleY = value;
        }
        public function get scaleY():Number
        {
            return view.scaleY;
        }
        
        /**
         * 是否启用鼠标
         */
        public function set mouseEnabled(value:Boolean):void
        {
            if(view is InteractiveObject)
            {
                (view as InteractiveObject).mouseEnabled = value;
            }
        }
        public function get mouseEnabled():Boolean
        {
            if(view is InteractiveObject)
            {
                return (view as InteractiveObject).mouseEnabled;
            }
            return false;
        }
           
        /**
         * 透明度
         */
        public function set alpha(value:Number):void
        {
            view.alpha = value;
        }
        public function get alpha():Number
        {
            return view.alpha;
        }
        
        /**
         * 是否可见
         */
        public function set visible(value:Boolean):void
        {
            view.visible = value;
        }
        public function get visible():Boolean
        {
            return view.visible;
        }
        
        /**
         * 元件名称
         */
        public function get name():String
        {
            return view.name;
        }
        
        public function get parent():DisplayObjectContainer
        {
            return view.parent;
        }
        
        public function get useHandCursor():Boolean
        {
            if(view is Sprite)
            {
                return (view as Sprite).useHandCursor;
            }
            return false;
        }
        public function set useHandCursor(value:Boolean):void
        {
            if(view is Sprite)
            {
                (view as Sprite).useHandCursor = value;
            }
        }
        
        public function get buttonMode():Boolean
        {
            if(view is Sprite)
            {
                return (view as Sprite).buttonMode;
            }
            return false;
        }
        public function set buttonMode(value:Boolean):void
        {
            if(view is Sprite)
            {
                (view as Sprite).buttonMode = value;
            }
        }
        /**
         * 类名
         */        
        internal function get className():String
        {
            return getQualifiedClassName(this);
        }
        
        public function get filters():Array
        {
            return view.filters;
        }
        public function set filters(v:Array):void
        {
            view.filters = v;
        }
	}
}