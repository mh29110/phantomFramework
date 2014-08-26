package phantom.ui.flash  
{
    import flash.display.MovieClip;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.system.ApplicationDomain;
    import flash.utils.getDefinitionByName;
    
    import phantom.core.handlers.Handler;
    import phantom.interfaces.IContainer;
    import phantom.ui.components.containerBase;
    import phantom.ui.screen.ScreenAdapter;
    
    
    [Event(name="complete", type="flash.events.Event")]
    public class UIAssetNode extends EventDispatcher
    {
        private var _uiDefine:String;
        private var _callbacks:Vector.<Function>;
        private var _complete:Boolean;
        private var _defaultControllerDefine:Class;
        
        public function UIAssetNode(index:String)
        {
            _uiDefine = index;
            _callbacks = new Vector.<Function>(); 
        }
        
        public function startLoad():void
        {
		AppCenter.instance.loader.loadSWF("assets/"+_uiDefine+".swf",new Handler(onAssetLoaded));
		//AppCenter.instance.loader.loadSWF("../assets/"+_uiDefine+".swf",new Handler(onAssetLoaded));
        }
        
        public function appendCallback(f:Function):void
        {
            if(!_complete)
            {
                if(f != null && _callbacks.indexOf(f) < 0 )
                {
                    _callbacks.push(f);
                }
            }
            else
            {
                excuteCallback(f);
            }
        }
        
        private function onAssetLoaded(content:*):void
        {
            while(_callbacks.length)
            {
                excuteCallback(_callbacks.pop());
            }
            dispatchEvent(new Event(Event.COMPLETE));
        }
        
        public function getUIController(uiDefine:String = null, controllerDefine:Class = null):IContainer
        {
            if(!uiDefine)
            {
                uiDefine = "screen.view." + _uiDefine;
            }
            
            _defaultControllerDefine = ScreenAdapter;
            if(!controllerDefine)
            {
                controllerDefine = _defaultControllerDefine;
            }
            
            if(ApplicationDomain.currentDomain.hasDefinition(uiDefine))
            {
                var skinClass:Class = getDefinitionByName(uiDefine) as Class;
                var skin:MovieClip = new skinClass() as MovieClip;
                var adapter:containerBase = new controllerDefine() as containerBase;

                if(skin && adapter)
                {
					adapter.initialize(skin);
                    return adapter;
                }
            }
            return null;
        }
		
        private function excuteCallback(callback:Function):void
        {
            callback.apply(null,[this]);
        }
        
        public function get uiDefine():String
        { 
            return _uiDefine;
        }
        
        internal function set defaultControllerDefine(c:Class):void
        {
            _defaultControllerDefine = c;
        }
        
    }
}

