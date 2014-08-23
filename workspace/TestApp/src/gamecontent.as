package
{
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.events.UncaughtErrorEvent;
    import flash.external.ExternalInterface;
    import flash.system.Security;
    
    import commands.network.GetPlayerInfoCommand;
    import commands.system.GameAssetPrepareCommand;
    import commands.system.GameInitializeCommand;
    import commands.system.GameReadyCommand;
    
    import consts.CommandServerOrder;
    import consts.CommandSystemOrder;
    import consts.GameModuleConsts;
    
    import events.SystemEvent;
    import events.services.NetworkServiceEvent;
    
    import game.GameWorldMediator;
    
    import interfaces.ITickable;
    
    import org.puremvc.as3.interfaces.IFacade;
    import org.puremvc.as3.patterns.facade.Facade;
    
    import serverData.GameDataModule;
    
    import services.ActiveEventsService;
    import services.AssetsBufferService;
    import services.DebuggerService;
    import services.LanguageService;
    import services.NetworkService;
    import services.PrepareAssetsService;
    import services.Service;
    import services.ServiceGuids;
    import services.SharedObjectService;
    import services.SoundService;
    import services.viewContainerService.SubMenuService;
    import services.TickBuffService;
    import services.ViewContainerManagerService;
    import services.viewContainerService.PopupService;
    
    import struct.SystemAlertData;
    
    import utils.VersionSprite;
    
    public class gamecontent extends VersionSprite implements ITickable
    {
        protected var _couldTick:Boolean;
        
        public function gamecontent()
        {
            if(stage)
            {
                initialize()
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
            
            stage.frameRate = 30;
            
            stage.addEventListener(MouseEvent.MOUSE_UP, onClickStage);
            
            
            var shareOjbectService : SharedObjectService = Service.instance.getService(ServiceGuids.SHARED_OBJECT_SERVICE) as SharedObjectService;
            shareOjbectService.initAttributes(true);
            shareOjbectService.initSettingData();
            
            var prepareAssetServ:PrepareAssetsService = new PrepareAssetsService();
            Facade.getInstance().registerMediator(prepareAssetServ);
            Service.instance.addService(ServiceGuids.PREPARE_ASSETS_SERVICE, prepareAssetServ);
            prepareAssetServ.addEventListener(SystemEvent.PREPARE_ASSETS_SERV_READY, initServices);
            prepareAssetServ.initialize();
            
            addLanderListener();
        }
        
        private function addLanderListener() : void
        {
            if(ExternalInterface.available)
            {
                ExternalInterface.addCallback("fnOpenSound", turnSound);
                ExternalInterface.addCallback("fnShowFlashplayerController", Security.showSettings);
            }
        }
        
        private function turnSound(isOpen:int) : void
        {
            Facade.getInstance().sendNotification(CommandSystemOrder.SOUND_BGM_OFF);
        }
        
        protected function onClickStage(e:MouseEvent):void
        {
            Facade.getInstance().sendNotification(CommandSystemOrder.CLICK_STAGE);
        }
        
        private function onResize(e:Event = null):void
        {
            var viewContainerServ:ViewContainerManagerService = Service.instance.getService(ServiceGuids.VIEW_CONTAINER_MANAGER_SERVICE) as ViewContainerManagerService;
            if(viewContainerServ)
            {
                viewContainerServ.onResize();
            }
        }
        
        private function initServices(e:Event):void
        {
            e.currentTarget.removeEventListener(SystemEvent.PREPARE_ASSETS_SERV_READY, initServices);
            
            stage.addEventListener(Event.RESIZE, onResize);
            onResize();
            
            var facade:IFacade = Facade.getInstance();
            facade.registerCommand(CommandSystemOrder.GAME_READY, GameReadyCommand);
            facade.registerCommand(CommandSystemOrder.START_UP, GameInitializeCommand);
            facade.registerCommand(CommandServerOrder.GET_PLAYER_INFO, GetPlayerInfoCommand);
            facade.registerCommand(CommandSystemOrder.ON_PLAYER_INFO_INITIALIZED, GameAssetPrepareCommand);
            
            var networkServ:NetworkService = Service.instance.getService(ServiceGuids.NETWORK_SERVICE) as NetworkService;
            networkServ.addEventListener(NetworkServiceEvent.SERVER_DISCONNECTED, onServerDisconnected);
            
            //启动项目
            facade.sendNotification( CommandSystemOrder.START_UP, this);
            facade.sendNotification(CommandServerOrder.GET_PLAYER_INFO, this);
            
            /*战斗资源缓存*/
            var assetsBuffer:AssetsBufferService = new AssetsBufferService();
            facade.registerMediator(assetsBuffer);
            Service.instance.addService(ServiceGuids.ASSETS_BUFFER_SERVICE, assetsBuffer);
            
            _couldTick = true;
        }
        
        private function onServerDisconnected(e:Event):void
        {
            var serv:Service = Service.instance;
            var viewContainerServ:ViewContainerManagerService = serv.getService(ServiceGuids.VIEW_CONTAINER_MANAGER_SERVICE) as ViewContainerManagerService;
            var popupServ:PopupService = serv.getService(ServiceGuids.POPUP_SERVICE) as PopupService;
            
            var viewServices:Vector.<Sprite> = viewContainerServ.viewContainers;
            var view:Sprite;
            var len:int = viewServices.length;
            
            for(var i:int = 0; i<len; i++)
            {
                view = viewServices[i];
                if(view && view != popupServ)
                {
                    view.mouseEnabled = false;
                    view.mouseChildren = false;
                }
            }
            var languageServ:LanguageService=Service.instance.getService(ServiceGuids.LANGUAGE_SERVICE) as LanguageService;
            var alertData:SystemAlertData = new SystemAlertData();
            alertData.notice = languageServ.getLanguageText("loseConnectRefresh");
            alertData.confirmCallback = tryToRefreshPage;
            
            Facade.getInstance().sendNotification(CommandSystemOrder.SHOW_ALERT, alertData);
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
            var debuggerServ:DebuggerService = Service.instance.getService(ServiceGuids.DEBUGGER_SERVICE) as DebuggerService;
            if(debuggerServ)
            {
                debuggerServ.serverLog("[ERROR] Gamecontent catch uncaught error:"+ event.toString(), 1);
            }
        }
        
        public function tick(delta:Number):void
        {
            var facade:IFacade = Facade.getInstance();
            var gameWorldMediator:GameWorldMediator = facade.retrieveMediator(GameModuleConsts.GAME_WORLD_MEDIATOR) as GameWorldMediator;
            if(gameWorldMediator && gameWorldMediator.couldTick)
            {
                gameWorldMediator.tick(delta);
            }
            
            var serv:Service = Service.instance;
            var prepareAssetsServ:PrepareAssetsService = serv.getService(ServiceGuids.PREPARE_ASSETS_SERVICE) as PrepareAssetsService;
            if(prepareAssetsServ && prepareAssetsServ.couldTick)
            {
                prepareAssetsServ.tick(delta);
            }
            
            var soundServ:SoundService = serv.getService(ServiceGuids.SOUND_SERVICE) as SoundService;
            if(soundServ&&soundServ.couldTick)
            {
                soundServ.tick(delta);
            }
            
            var viewContainerManagerServ:ViewContainerManagerService = serv.getService(ServiceGuids.VIEW_CONTAINER_MANAGER_SERVICE) as ViewContainerManagerService;
            if(viewContainerManagerServ && viewContainerManagerServ.couldTick)
            {
                viewContainerManagerServ.tick(delta);
            }
            
            var activeEventsServ:ActiveEventsService = serv.getService(ServiceGuids.ACTIVE_EVENTS_SERVICE) as ActiveEventsService;
            if(activeEventsServ && activeEventsServ.couldTick)
            {
                activeEventsServ.tick(delta);
            }
            
            var subMenuServ:SubMenuService = serv.getService(ServiceGuids.SUB_MENU_SERVICE) as SubMenuService
            if(subMenuServ && subMenuServ.couldTick)
            {
                subMenuServ.tick(delta);
            }
            
            var gameDataModule:GameDataModule = serv.getService(ServiceGuids.GAME_DATA_MODULE_SERVICE) as GameDataModule;
            if(gameDataModule && gameDataModule.couldTick)
            {
                gameDataModule.tick(delta);
            }
            
            var buffTick : TickBuffService = serv.getService(ServiceGuids.BUFF_TICK_SERVICE) as TickBuffService;
            if(buffTick)
            {
                buffTick.tick(delta);
            }
        }
        
        public function get couldTick():Boolean
        {
            return _couldTick;
        }
        
    }
}