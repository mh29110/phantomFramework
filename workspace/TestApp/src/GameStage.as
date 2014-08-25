package
{
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.events.UncaughtErrorEvent;
    import flash.external.ExternalInterface;
    import flash.system.Security;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.utils.getQualifiedClassName;
    
    import commands.consts.CommandListSystem;
    import commands.system.GameEnterCommand;
    import commands.system.GameStartupCommand;
    
    import org.puremvc.as3.interfaces.IFacade;
    import org.puremvc.as3.patterns.facade.Facade;
    
    import splash.VersionSprite;
    
    public class GameStage extends VersionSprite
    {
        protected var _couldTick:Boolean;
        
        public function GameStage()
        {
            if(stage)
            {
                initialize();
            }
            else
            {
                addEventListener(Event.ADDED_TO_STAGE, initialize);
            }
        }
        
        private function initialize(e:Event = null):void
        {
            //初始化舞台配置
            loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onUnCaughtErrorEventHandle);
            removeEventListener(Event.ADDED_TO_STAGE, initialize);
            
            stage.addEventListener(MouseEvent.MOUSE_UP, onClickStage);
            
            // sharedObject  process
			
			//load ui assets ,flash modules if necessary ,(e.g open by level ,open when beginning ).
//            var prepareAssetServ:PrepareAssetsService = new PrepareAssetsService();
//            Facade.getInstance().registerMediator(prepareAssetServ);
//            prepareAssetServ.addEventListener(SystemEvent.PREPARE_ASSETS_SERV_READY, initServices);
//            prepareAssetServ.initialize();

			initServices(null);

            addLanderListener();
			
			visible = true; // :important  . 加载时为false,当准备好呈现的时候才设置可显.
			test();
        }

		private function test():void
		{
			visible = true;
			var btnFrame:Sprite = new Sprite();
			btnFrame.graphics.beginFill(0);
			btnFrame.graphics.drawRect(0,0,100,25);
			btnFrame.graphics.beginFill(0xfff000);
			btnFrame.graphics.drawRect(0,0,98,23);
			btnFrame.graphics.endFill();
			
			btnFrame.x = 200;
			addChild(btnFrame);			
			
		}
        
	
        
        protected function onClickStage(e:MouseEvent):void
        {
//            Facade.getInstance().sendNotification(CommandSystemOrder.CLICK_STAGE);
        }
        
        private function onResize(e:Event = null):void
        {
			//自适应
        }
        
        private function initServices(e:Event):void
        {
//            e.currentTarget.removeEventListener(SystemEvent.PREPARE_ASSETS_SERV_READY, initServices);
            
            stage.addEventListener(Event.RESIZE, onResize);
            onResize();
            
            var facade:IFacade = Facade.getInstance();
            facade.registerCommand(CommandListSystem.START_UP, GameStartupCommand);
            facade.registerCommand(CommandListSystem.ENTER_GAME, GameEnterCommand);
//            facade.registerCommand(CommandServerOrder.GET_PLAYER_INFO, GetPlayerInfoCommand);
//            facade.registerCommand(CommandSystemOrder.ON_PLAYER_INFO_INITIALIZED, GameAssetPrepareCommand);
            
//            var networkServ:NetworkService = Service.instance.getService(ServiceGuids.NETWORK_SERVICE) as NetworkService;
//            networkServ.addEventListener(NetworkServiceEvent.SERVER_DISCONNECTED, onServerDisconnected);
            
            //启动项目
            facade.sendNotification( CommandListSystem.START_UP, this);
			facade.sendNotification( CommandListSystem.ENTER_GAME);
			
//            facade.sendNotification(CommandServerOrder.GET_PLAYER_INFO, this);
            
            /*战斗资源缓存*/
//            var assetsBuffer:AssetsBufferService = new AssetsBufferService();
//            facade.registerMediator(assetsBuffer);
//            Service.instance.addService(ServiceGuids.ASSETS_BUFFER_SERVICE, assetsBuffer);
            
            _couldTick = true;
        }
        
        private function onServerDisconnected(e:Event):void
        {
			// stop the game. and @tryToRefreshPage()
        }
        
        private function tryToRefreshPage():void
        {
            if(ExternalInterface.available)
            {
                ExternalInterface.call("onDisconnectedHandle");
            }
        }
        
        private function onUnCaughtErrorEventHandle(event:UncaughtErrorEvent):void
        {
			trace("gamecontent.onUnCaughtErrorEventHandle(event)");
        }
        
		/**
		 * tick by game initializer ,with gameTimeLine.
		 * @param delta
		 * 
		 */
        public function tick(delta:Number):void
        {
//            var facade:IFacade = Facade.getInstance();
//            var gameWorldMediator:GameWorldMediator = facade.retrieveMediator(GameModuleConsts.GAME_WORLD_MEDIATOR) as GameWorldMediator;
//            if(gameWorldMediator && gameWorldMediator.couldTick)
//            {
//                gameWorldMediator.tick(delta);
//            }
//            
//            var serv:Service = Service.instance;
//            var prepareAssetsServ:PrepareAssetsService = serv.getService(ServiceGuids.PREPARE_ASSETS_SERVICE) as PrepareAssetsService;
//            if(prepareAssetsServ && prepareAssetsServ.couldTick)
//            {
//                prepareAssetsServ.tick(delta);
//            }
//            
//            var soundServ:SoundService = serv.getService(ServiceGuids.SOUND_SERVICE) as SoundService;
//            if(soundServ&&soundServ.couldTick)
//            {
//                soundServ.tick(delta);
//            }
//            
//            var viewContainerManagerServ:ViewContainerManagerService = serv.getService(ServiceGuids.VIEW_CONTAINER_MANAGER_SERVICE) as ViewContainerManagerService;
//            if(viewContainerManagerServ && viewContainerManagerServ.couldTick)
//            {
//                viewContainerManagerServ.tick(delta);
//            }
//            
//            var activeEventsServ:ActiveEventsService = serv.getService(ServiceGuids.ACTIVE_EVENTS_SERVICE) as ActiveEventsService;
//            if(activeEventsServ && activeEventsServ.couldTick)
//            {
//                activeEventsServ.tick(delta);
//            }
//            
//            var subMenuServ:SubMenuService = serv.getService(ServiceGuids.SUB_MENU_SERVICE) as SubMenuService
//            if(subMenuServ && subMenuServ.couldTick)
//            {
//                subMenuServ.tick(delta);
//            }
//            
//            var gameDataModule:GameDataModule = serv.getService(ServiceGuids.GAME_DATA_MODULE_SERVICE) as GameDataModule;
//            if(gameDataModule && gameDataModule.couldTick)
//            {
//                gameDataModule.tick(delta);
//            }
//            
//            var buffTick : TickBuffService = serv.getService(ServiceGuids.BUFF_TICK_SERVICE) as TickBuffService;
//            if(buffTick)
//            {
//                buffTick.tick(delta);
//            }
        }
        
        public function get couldTick():Boolean
        {
            return _couldTick;
        }

        private function turnSound(isOpen:int) : void
        {
//            Facade.getInstance().sendNotification(CommandSystemOrder.SOUND_BGM_OFF);
        }
        
		/**
		 * communicate with web-js. 
		 * 
		 */
        private function addLanderListener() : void
        {
            if(ExternalInterface.available)
            {
                ExternalInterface.addCallback("fnOpenSound", turnSound);
                ExternalInterface.addCallback("fnShowFlashplayerController", Security.showSettings);
            }
        }
    }
}