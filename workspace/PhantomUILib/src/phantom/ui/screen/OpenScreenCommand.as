package phantom.ui.screen
{    
    import flash.ui.Mouse;
    import flash.ui.MouseCursor;
    
    import org.puremvc.as3.interfaces.INotification;
    import org.puremvc.as3.patterns.command.SimpleCommand;
    
    import phantom.core.consts.ManagerName;
    import phantom.ui.flash.UIAssetLinker;
    
    public class OpenScreenCommand extends SimpleCommand
    {
        override public function execute(notification:INotification):void
        {
            var openScreenParams:Array = notification.getBody() as Array;
            var screenId:String = openScreenParams.shift();
            var screenMediator:*;
            
            if(facade.hasMediator(screenId) == true)
            {
                screenMediator = facade.retrieveMediator(screenId);
                
             	return;
            }
            
//            sendNotification(CommandSystemOrder.CLOSE_POPUP);
			
			var linker:UIAssetLinker = AppCenter.instance.getManager(ManagerName.UIASSET_LINKER) as UIAssetLinker;
			var mediatorClass:Class = linker.getMediatorDefineByName(screenId);
			screenMediator = new mediatorClass(screenId);	
            
            if(screenMediator == null)
            {
                return;
            }
            
            if(openScreenParams.length>0)
            {
                screenMediator.initMediator.apply(null,openScreenParams);
            }
            
            Mouse.cursor = MouseCursor.ARROW;
            Mouse.cursor = MouseCursor.AUTO;
            facade.registerMediator(screenMediator);
        }
    }
}