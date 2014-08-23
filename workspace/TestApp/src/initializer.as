package 
{
    import flash.display.Loader;
    import flash.display.Sprite;
    import flash.display.Stage;
    import flash.events.Event;
    import flash.system.Security;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.utils.getTimer;
    
    import phantom.core.consts.ManagerName;
    import phantom.core.managers.StageManager;
    import phantom.core.socket.NetworkManager;
    import phantom.core.socket.conn.ConnectionType;
    import phantom.core.socket.dataPackets.SocketPacket;
    
    import splash.CGMediaPlayer;
    import splash.VersionSprite;
    
    [SWF(width="1248", height="648", frameRate="60", backgroundColor="0x0")]
    public class initializer extends VersionSprite
    {
        /**
         * 上一帧渲染的时间戳
         */        
        private var _lastRenderTimeStamp:Number;
        private var _lastRenderTimeStampLocal:Number;
        
        private var _couldTick:Boolean;

        private var _logoLoader:Loader;
        
        private var _cgPlayer:CGMediaPlayer;
        /**
         * 构造
         */        
        public function initializer()
        {
            initialize();
        }
          /**
         * 初始化 
         * @param e     事件
         */        
        private function initialize():void
        {  
            Security.allowDomain("*");
            Security.allowInsecureDomain("*");
            
            
            //注册服务
            var app:AppCenter = AppCenter.instance;
            
//            var loadServ:LoadService = app.getService(ServiceGuids.LOAD_SERVICE) as LoadService;
//            
//            app.addService(ServiceGuids.RESOURCE_SERVICE, new ResourceService());
//            
//            var networkServ:NetworkService = new NetworkService();
//            networkServ.addEventListener(NetworkServiceEvent.SERVER_DISCONNECTED, onServerDisconnected);
//            app.addService(ServiceGuids.NETWORK_SERVICE, networkServ);
//            
//			app.addService(ServiceGuids.UI_ASSET_MANAGER, new UIAssetManager());
//            
//			app.addService(ServiceGuids.LANGUAGE_SERVICE, new LanguageService());
//			app.addService(ServiceGuids.UTILS_SERVICE, new UtilsService());
//            app.addService(ServiceGuids.SORT_UTIL_SERVICE, new SortUtilsService());
//            app.addService(ServiceGuids.SYSTEM_WORD_SERVICE, new SystemWordService());
//            app.addService(ServiceGuids.STATISTICS_SERVICE, new StatisticsService());
//            
//            _busyIndicateServ = new BusyIndicateService();
//            app.addService(ServiceGuids.BUSY_INDICATE_SERVICE, _busyIndicateServ);
            
            var stageServ:StageManager = app.getManager(ManagerName.STAGE) as StageManager;
            var stage:Stage = stageServ.stage;
            stage.addEventListener(Event.ENTER_FRAME, onTickHandle);
            stage.addEventListener(Event.RESIZE, onResize, false, int.MAX_VALUE);
            onResize();
            
            //初始化舞台事件
            _lastRenderTimeStamp = new Date().time;
            _lastRenderTimeStampLocal = getTimer();
			
			// network init
			prepareNetworkServ();
		
			//create character
			
			//load config and assets for real game content 
			
			
			
			
			
			
			app.timer.doOnce(1000,function():void
			{
        		   	dispatchEvent( new Event("initialize.readyToShow"));//必须延时调用,否则preLoader接受不到.
			});
			
			test();
			
        }
		
		private function test():void
		{
			var btnFrame:Sprite = new Sprite();
			btnFrame.graphics.beginFill(0);
			btnFrame.graphics.drawRect(0,0,100,25);
			btnFrame.graphics.beginFill(0xfff000);
			btnFrame.graphics.drawRect(0,0,98,23);
			btnFrame.graphics.endFill();
			
			var label:TextField = new TextField();
			label.text = "登录|Login";
			label.textColor = 0x000022;
			label.autoSize = TextFieldAutoSize.LEFT;
			label.x = 20;
			label.y = 2;
			btnFrame.addChild(label);
			addChild(btnFrame);			
				
		}
		
		protected function onTickHandle(event:Event):void
		{
			
		}        

        private function prepareNetworkServ():void
        {
                //initGameContent();  战报模式
			
		     var app:AppCenter = AppCenter.instance;		
	         var network:NetworkManager = new NetworkManager();                
			 app.addManager(network,ManagerName.NETWORK);
			network.createSocket(ConnectionType.GAME,GlobalConfig.host,GlobalConfig.port);
			
			//when connected then do this ...>
			var packet:SocketPacket = new SocketPacket();
			network.send(packet);
			
        }
 
        
        private function onServerConnected(e:Event):void
        {
            var serv:AppCenter = AppCenter.instance;
     
            var globalParams:Object = topGlobal
            var needFCM:String = globalParams.needFCM;
            var loginName:String = globalParams.loginName;
            var loginSource:String = globalParams.source;
            var loginPlatformId:String = globalParams.platform;
            var registerStat:String = globalParams.registerStat;
            var serverId:String = globalParams.serverId;
            
			//login todo 
        }
     
        /**
         * 播放开场动画，回调创建人物界面 
         * 
         */
        private function playCG():void
        {
            _cgPlayer = new CGMediaPlayer(null, "test");
            _cgPlayer.addEventListener(CGMediaPlayer.CG_SCROLL_LOAEDED, onCGScrollLoaded);
        }
        
        private function onCGScrollLoaded(event:Event):void
        {
            if(_logoLoader)
            {
                if(_logoLoader.parent)
                {
                    _logoLoader.parent.removeChild(_logoLoader);
                }
                _logoLoader.unloadAndStop();
                _logoLoader = null;
            }
            
            _cgPlayer.removeEventListener(CGMediaPlayer.CG_SCROLL_LOAEDED, onCGScrollLoaded);
            addChild(_cgPlayer);
        }
        
        
   
		private function onResize(e:Event = null):void
        {
            var stageServ:StageManager = AppCenter.instance.getManager(ManagerName.STAGE) as StageManager;
            
            if(stageServ == null)
            {
                return;
            }
            
            stageServ.computeStats();
            
            var tx:int = Math.max(0, stageServ.gameScreenOffsetX);
            var ty:int = Math.max(0, stageServ.gameScreenOffsetY);
            this.x = tx;
            this.y = ty;
            
//            if(_copyInfo)
//            {
//                _copyInfo.x = tx + int((stageServ.gameScreenWidth-_copyInfo.textWidth)*0.5);
//                _copyInfo.y = ty + stageServ.gameScreenHeight+8;
//            }
        }
    }
}
