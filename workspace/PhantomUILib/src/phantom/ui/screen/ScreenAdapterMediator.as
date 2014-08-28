package phantom.ui.screen
{
    import flash.display.DisplayObject;
    
    import org.puremvc.as3.patterns.mediator.Mediator;
    
    import phantom.core.consts.ManagerName;
    import phantom.core.managers.LoaderManager;
    import phantom.core.managers.render.LayerManager;
    import phantom.core.managers.render.StageManager;
    import phantom.interfaces.IScreenAdapater;
    import phantom.interfaces.IScreenAdapterMediator;
    import phantom.ui.flash.UIAssetLinker;
    import phantom.ui.flash.UIAssetNode;
    
    public class ScreenAdapterMediator extends Mediator implements IScreenAdapterMediator
    {
        private var _screenDefineId:String;
        private var _isDisposed:Boolean;
        private var _initialized:Boolean;
        private var _screenAdapter:IScreenAdapater;
        private var _isMajorScreen:Boolean;
        private var _onInitScreenAssets:Boolean;
        /**
         * 构造
         * @param name        
         * @param controller
         */        
        public function ScreenAdapterMediator(name:String, controller:*=null)
        {
            mediatorName = name;
            prepareScreenAsset(name, controller);
        }
        
		/**
		 * 一种直接创建mediator的方式,一般采用@see OpenScreenCommand 的方式,避免这种直接创建.
		 * @param screenDefineId
		 * @param controller
		 * 
		 */
        protected function prepareScreenAsset(screenDefineId:String = null, adapter:*=null):void
        {
            _screenDefineId = screenDefineId;
            if(adapter != null)
            {
                _screenAdapter = adapter;
                viewComponent = _screenAdapter;// from mediator's content
                initDataAndShow();
            }
        }
        
		/**
		 * @step 1 : when facade.registerMediator ,called . 
		 * 
		 */
        override public function onRegister():void
        {
            super.onRegister();
            getScreenAssets();
        }
        
        
 
        //---------------------------------step one ,prepare assets and load into assetManager.
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
                

				onScreenDependsAssetsLoaded(1);
            }
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
				viewComponent = _screenAdapter;// from mediator's content
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
		
		/**
		 * 所有资源已就位 
		 * 在子类中覆写此方法进行初始化操作.
		 */
        protected function initialize():void
        {
			var app:AppCenter = AppCenter.instance;
            var stageManager:StageManager = app.getManager(ManagerName.STAGE) as StageManager;
			var layer:LayerManager = app.getManager(ManagerName.LAYER) as LayerManager;
			layer.addToLayerAt(adapter.view,LayerManager.SCREEN_LAYER);
        }
        
		/**
		 * step 2  :   
		 * when real open this screen .init with the arguments
		 * @param arg
		 * @see OpenScreenCommand
		 * 
		 */
		public function initMediator(...arg):void
		{
			trace("ScreenAdapterMediator.initMediator(arg)");
		}
		
		public function closeScreen():void
		{
			
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

		protected function destruct():void
		{
			//            if(_screenController)
			//            {
			//                _screenController.dispose();
			//            }
			//            facade.removeMediator(getMediatorName());
		}
		
		public function dispose():void
		{
			if( _isDisposed == false )
			{
				_isDisposed = true;
				destruct();
			}
		}
		
		
        public function get isMajorScreen():Boolean
        {
            return _isMajorScreen;
        }
        
		public function get adapter():ScreenAdapter
		{	
			return _screenAdapter as ScreenAdapter;
		}
        
        public function get isDisposed():Boolean
        {
            return _isDisposed;
        }
        
        public function get onInitScreenAssets():Boolean
        {
            return _onInitScreenAssets;
        }
        
        public function get initialized():Boolean
        {
            return _initialized;
        }
    }
}