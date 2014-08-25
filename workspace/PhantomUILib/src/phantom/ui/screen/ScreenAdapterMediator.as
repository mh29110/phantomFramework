package phantom.ui.screen
{
    import org.puremvc.as3.patterns.mediator.Mediator;
    
    import phantom.core.consts.ManagerName;
    import phantom.core.handlers.Handler;
    import phantom.core.managers.LoaderManager;
    import phantom.core.managers.StageManager;
    import phantom.interfaces.IScreenAdapater;
    import phantom.interfaces.IScreenAdapterMediator;
    import phantom.interfaces.ISkinAdapter;
    import phantom.ui.flash.UIAssetLinker;
    import phantom.ui.flash.UIAssetNode;
    
    public class ScreenAdapterMediator extends Mediator implements IScreenAdapterMediator
    {
        private var _screenControllerDefine:Class;
        private var _screenDefineId:String;
        private var _isDisposed:Boolean;
        private var _initialized:Boolean;
        private var _screenAdapter:IScreenAdapater;
        private var _isMajorScreen:Boolean;
        private var _onInitScreenAssets:Boolean;
        private var _isShowing:Boolean;
        
        /**
         * 构造
         * @param screenDefineId        
         * @param controller
         */        
        public function ScreenAdapterMediator(name:String, controller:*=null)
        {
            mediatorName = name;
            prepareScreenAsset(name, controller);
        }
        
        protected function prepareScreenAsset(screenDefineId:String = null, controller:*=null):void
        {
            _screenDefineId = screenDefineId;
            if(controller != null)
            {
                switch(true)
                {
                    default:
                    case controller is Class:
                    {
                        _screenControllerDefine = controller;
                        break;
                    }
                        
                    case controller is ISkinAdapter:
                    {
                        _screenAdapter = controller;
                        viewComponent = _screenAdapter;
                        initDataAndShow();
                        break;
                    }
                }
            }
        }
        
        override public function onRegister():void
        {
            super.onRegister();
            getScreenAssets();
        }
        
        public function activeScreen():void
        {
            _screenAdapter.visible = true;
        }
        
        public function deactiveScreen():void
        {
            
        }
        
        override public function onRemove():void
        {
            if(_screenAdapter != null)
            {
//                sendNotification(CommandSystemOrder.SCREEN_SERVICE_POP, [ _screenController ] );
            }
        }
        
        public function dispose():void
        {
//            sendNotification(CommandSystemOrder.SCREEN_CLOSED, _screenDefineId);
//            sendNotification(CommandSystemOrder.SCREEN_CLOSED+_screenDefineId);
            if( _isDisposed == false )
            {
                _isDisposed = true;
                destruct();
            }
        }
        
        
        public function initMediator(...arg):void
        {
           
        }
        
        public function tick(delta:Number):void
        {
//            if(_onInitScreenAssets && _assetsLoaderQueue) 
//            {
//                var busyIndicateServ:BusyIndicateService = Service.instance.getService(ServiceGuids.BUSY_INDICATE_SERVICE) as BusyIndicateService;
//                busyIndicateServ.updatePercentMe(_assetsLoaderQueue.loadPercent);
//            }
//            if(_isCheckBot)
//            {
//                _botCounter.tick(delta);
//                if(_botCounter.expired)
//                {
//                    checkShadowBot();
//                    
//                    _botCounter.initialize();
//                    _botCounter.reset(ShadowBotConsts.DELAY);
//                }
//            }
        }
        
        public function checkScreenMediatorExist(screenId:String):Boolean
        {
            return Boolean(facade.retrieveMediator(screenId) != null);
        }
        
        public function closeScreen():void
        {
//            sendNotification(CommandSystemOrder.CLOSE_SCREEN, this);
        }
        
        protected function initChildControllerMediator(childController:ScreenAdapter, mediatorClassDefine:Class):*
        {
            var id:String = _screenAdapter.name + "." + childController.name;
            var mediator:ScreenAdapterMediator = new mediatorClassDefine(id, childController);
            facade.registerMediator(mediator);
            return mediator;
        }
        
        protected function getScreenAssets(extAssetRequired:Vector.<String> = null):void
        {
            if(_screenAdapter == null && _screenDefineId)
            {
				var loader:LoaderManager = AppCenter.instance.loader;
				
                
//                sendNotification(CommandSystemOrder.SHOW_BUSY_INDICATE, [CommandSystemOrder.TYPE_LOAD_ASSET]);
//                sendNotification(CommandSystemOrder.UPDATE_BUSY_INDICATE, [0]);
                
//                var assetsList:Vector.<String>;
//                if(resourceServ.getURL(_screenDefineId))
//                {
//                    assetsList = Vector.<String>([_screenDefineId]);
//                }
//                
//                if(extAssetRequired)
//                {
//                    assetsList = assetsList.concat(extAssetRequired);
//                }
                
                _onInitScreenAssets = true;
                
				loader.loadSWF("majorscreen.swf",new Handler(onScreenDependsAssetsLoaded));
            }
        }
        
        protected function destruct():void
        {
//            if(_screenController)
//            {
//                _screenController.dispose();
//            }
//            facade.removeMediator(getMediatorName());
        }
        
        protected function initialize():void
        {
            var stageManager:StageManager = AppCenter.instance.getManager(ManagerName.STAGE) as StageManager;
			controller.addToParent(stageManager.stage);
        }
        
        protected function showScreenView():void
        {
			trace("ScreenAdapterMediator.showScreenView()");
			
//            if(!_isShowing)
//            {
//                _isShowing = true
//                sendNotification( CommandSystemOrder.SCREEN_SERVICE_PUSH, [_screenController]);
//                sendNotification(CommandSystemOrder.SCREEN_SHOW + _screenDefineId);
//                sendNotification(CommandSystemOrder.CHECK_GUIDE);
//            }
        }
        
        private function onScreenDependsAssetsLoaded(content:*):void
        {
            _onInitScreenAssets = false;
//            sendNotification(CommandSystemOrder.HIDE_BUSY_INDICATE);
            
            
            var uam:UIAssetLinker = AppCenter.instance.getManager(ManagerName.UIASSET_LINKER) as UIAssetLinker;
            uam.getUI(_screenDefineId, onScreenControllerPrepared);
        }
        
        private function onScreenControllerPrepared(uiAssetNode:UIAssetNode):void
        {
            if(!_screenAdapter)
            {
                _screenAdapter = uiAssetNode.getUIController() as IScreenAdapater;
                initDataAndShow();
            }
        }
        
        private function initDataAndShow():void
        {
            _screenAdapter.setMediator(this);
            _initialized = true;
//            sendNotification(CommandSystemOrder.SCREEN_INITIANIZED + _screenDefineId);
            initialize();
        }
        
        public function get isMajorScreen():Boolean
        {
            return _isMajorScreen;
        }
        
        public function get controller():IScreenAdapater
        {
            return _screenAdapter;
        }
        
        public function get isDisposed():Boolean
        {
            return _isDisposed;
        }
        
        public function get couldTick():Boolean
        {
            return true;
        }
        
        public function get onInitScreenAssets():Boolean
        {
            return _onInitScreenAssets;
        }
        
        public function get initialized():Boolean
        {
            return _initialized;
        }
        
        protected function setIsMajorScreen(value:Boolean):void
        {
            _isMajorScreen = value;
        }
    }
}