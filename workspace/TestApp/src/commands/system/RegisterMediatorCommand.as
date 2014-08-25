package commands.system
{
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class RegisterMediatorCommand extends SimpleCommand
	{
		public function RegisterMediatorCommand()
		{
			super();
		}
		override public function execute(notification:INotification):void
		{
			
		}
	}
}