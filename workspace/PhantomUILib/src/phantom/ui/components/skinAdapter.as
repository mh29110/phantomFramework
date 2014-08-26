package phantom.ui.components
{
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.display.InteractiveObject;
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.geom.Point;
    import flash.system.ApplicationDomain;
    import flash.text.AntiAliasType;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.utils.getQualifiedClassName;
    
    import phantom.core.interfaces.IDispose;
    import phantom.core.ns.PhantomInternalNamespace;
    import phantom.consts.DefaultFontConfig;
    
    
	use namespace PhantomInternalNamespace;
    public class skinAdapter extends EventDispatcher implements IDispose
	{
        private var _eventList:Vector.<String>;
        private var _eventFunctionList:Vector.<Function>;
        private var _eventUseCaptureList:Vector.<Boolean>;
        private var _view:MovieClip;
        private var _invalidate:Boolean;
        private var _couldTick:Boolean;
        private var _isDisposed:Boolean;
        private var _domain:ApplicationDomain;
        
        public function skinAdapter(skin:*)
        {
            _eventList = new Vector.<String>();
            _eventFunctionList = new Vector.<Function>();
            _eventUseCaptureList = new Vector.<Boolean>();
            
            super(this);
            if(skin)
            {
                initialize(skin);
            }
        }
        
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
         * 重绘对象
         */		
        public function invalidate():void
        {
            _invalidate = true;
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
        
        /**
         * 时间推进
         * @param delta 更新的时间差
         */        
        public function tick(delta:Number):void
        {
            checkInvalidate();
        }
        
        public function dispose():void
        {
            if(_isDisposed == false)
            {
                _isDisposed = true;
                destruct();
            }
        }
        override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0,useWeakReference:Boolean = false):void
        {
            if(useWeakReference == true)
            {
                super.addEventListener(type,listener,useCapture,priority,useWeakReference);
                return;
            }
            
            var index:int = getEventListenerIndex(type, listener, useCapture);
            if(index < 0)
            {
                super.addEventListener(type,listener,useCapture,priority,useWeakReference);
                _eventList.push(type);
                _eventFunctionList.push(listener);
                _eventUseCaptureList.push(useCapture);
            }
        }
        
        override public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
        {
            var index:int = getEventListenerIndex(type, listener, useCapture);
            if(index < 0)
            {
                return;
            }
            
            super.removeEventListener(type,listener,useCapture);
            
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
            _couldTick = true;
            dispatchEvent(new Event(Event.INIT));
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
            _couldTick = false;
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
         * 渲染
         */        
        protected function render():void
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
        protected function excuteCallback(callback:Function, ...args):*
        {
            if(callback != null)
            {
                args.length = callback.length
                return callback.apply(null, args);
            }
        }
        
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
         * 检查是否需要重绘 
         */        
        protected function checkInvalidate():void
        {
            if(_invalidate)
            {
                _invalidate = false;
                render();
                dispatchEvent(new Event(Event.RENDER));
            }
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
        
        /**
         * 可以被时间推动 
         */
        public function get couldTick():Boolean
        {
            return _couldTick;
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