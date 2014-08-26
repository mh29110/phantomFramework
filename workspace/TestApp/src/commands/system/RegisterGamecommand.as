package commands.system
{
	import commands.consts.CommandListSystem;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import phantom.ui.screen.CloseScreenCommand;
	import phantom.ui.screen.OpenScreenCommand;
	
	public class RegisterGamecommand extends SimpleCommand
	{
		public function RegisterGamecommand()
		{
			super();
		}
		override public function execute(notification:INotification):void
		{
			facade.registerCommand(CommandListSystem.OPEN_SCREEN, OpenScreenCommand);
			facade.registerCommand(CommandListSystem.CLOSE_SCREEN, CloseScreenCommand);
//			facade.registerCommand(CommandListSystem.BACK_TO_CITY, BackToCityCommand);
//			facade.registerCommand(CommandListSystem.SWITCH_GAME_SCENE, SwitchWorldSceneCommand);
		}
	}
}