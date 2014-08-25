package commands.system
{
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class RegisterGamecommand extends SimpleCommand
	{
		public function RegisterGamecommand()
		{
			super();
		}
		override public function execute(notification:INotification):void
		{
//			facade.registerCommand(CommandSystemOrder.OPEN_SCREEN, OpenScreenCommand);
//			facade.registerCommand(CommandSystemOrder.CLOSE_SCREEN, CloseScreenCommand);
//			facade.registerCommand(CommandGameOrder.BACK_TO_CITY, BackToCityCommand);
//			facade.registerCommand(CommandGameOrder.SWITCH_GAME_SCENE, SwitchWorldSceneCommand);
		}
	}
}