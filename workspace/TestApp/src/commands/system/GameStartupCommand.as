package commands.system
{
	import org.puremvc.as3.patterns.command.MacroCommand;
	
	public class GameStartupCommand extends MacroCommand
	{
		public function GameStartupCommand()
		{
			addSubCommand(RegisterMediatorCommand);
			addSubCommand(RegisterUIAssetCommand);
			
			//network command 
//			addSubCommand(InitializeServerCommand);
//			addSubCommand(InitializeLongTermServerObserverCommand);

			addSubCommand(RegisterGamecommand);
		}
	}
}