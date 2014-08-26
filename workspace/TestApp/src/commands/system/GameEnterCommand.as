package commands.system
{
	import commands.consts.CommandListSystem;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class GameEnterCommand extends SimpleCommand
	{
		public function GameEnterCommand()
		{
			super();
		}
		override public function execute(notification:INotification):void
		{
			
//			var majorScreen:ScreenAdapterMediator = new ScreenAdapterMediator("majorscreen");
//			facade.registerMediator(majorScreen);
			
			facade.sendNotification(CommandListSystem.OPEN_SCREEN, ["majorscreen"]);
			
			/*var serv:Service = Service.instance;
			
			var busyIndicate:BusyIndicateService = serv.getService(ServiceGuids.BUSY_INDICATE_SERVICE) as BusyIndicateService;
			busyIndicate.switchToInGameMode();
			
			var stageServ:StageService = serv.getService(ServiceGuids.STAGE_SERVICE) as StageService;
			stageServ.currentStage.dispatchEvent(new SystemEvent(SystemEvent.GAME_CONTENT_INITIALIZED, true,true));
			
			var gdm:GameDataModule = serv.getService(ServiceGuids.GAME_DATA_MODULE_SERVICE) as GameDataModule;
			var networkServ:NetworkService = serv.getService(ServiceGuids.NETWORK_SERVICE) as NetworkService;
			var configServ:ConfigService = serv.getService(ServiceGuids.CONFIG_SERVICE) as ConfigService;
			var autoPathingServ:AutoPathingService = serv.getService(ServiceGuids.AUTO_PATHING_SERVICE) as AutoPathingService;
			
			var activityInfo:ISystemActivityInfo = gdm
			var tickBuff : TickBuffService = new TickBuffService(activityInfo.activityList, networkServ);
			Service.instance.addService(ServiceGuids.BUFF_TICK_SERVICE, tickBuff);
			Facade.getInstance().registerMediator(tickBuff);
			
			if(configServ.isBattlePlayerMode)
			{
				var params:Array = [];
				params[0] = configServ.replayBattleReportIds;
				if(configServ.replayBattleReportRounds)
				{
					params[1] = configServ.replayBattleReportRounds;
				}
				sendNotification(CommandGameOrder.SWITCH_GAME_SCENE, params,  GameModuleConsts.SCENE_BATTLE_PLAYER);
				return;
			}
			
			if(autoPathingServ)
			{
				facade.registerMediator(autoPathingServ);
			}
			
        	var majorScreen:MajorScreenControllerMediator = facade.retrieveMediator(UIScreenDefineConsts.MAJOR_SCREEN) as MajorScreenControllerMediator;
            if(majorScreen == null)
            {
                majorScreen = new MajorScreenControllerMediator();;
                facade.registerMediator(majorScreen);
            }
            sendNotification(CommandSystemOrder.OPEN_SCREEN, [UIScreenDefineConsts.WORLD_MAP_SCREEN]);
            sendNotification(CommandUIEffectOrder.FADE_OUT_COMPLETE);
			return;
			
			sendNotification(CommandGameOrder.BACK_TO_CITY, [false]);*/
			
		}
	}
}