package phantom.ui.screen
{
    import flash.display.DisplayObjectContainer;
    import flash.display.MovieClip;
    
    import phantom.core.consts.ManagerName;
    import phantom.core.managers.StageManager;
    import phantom.interfaces.IScreenAdapater;
    import phantom.interfaces.IScreenAdapterMediator;
    import phantom.ui.components.containerBase;
    
    public class ScreenAdapter extends containerBase implements IScreenAdapater
    {
        private var _mediator:IScreenAdapterMediator
        private var _onCloseHandle:Function;
        
        public function ScreenAdapter(skin:MovieClip = null)
        {
            super(skin);
        }
        
        protected function moveChildToCenter(child:*, baseOnStage:Boolean = true, xOffset:int=0, yOffset:int=0):void
        {
            if(baseOnStage)
            {
                var stageServ:StageManager = AppCenter.instance.getManager(ManagerName.STAGE) as StageManager;
                if(!stageServ)
                {
                    moveChildToCenter(child, false);
                    return;
                }
                
                var tx:int = (stageServ.defaultScreenWidth - child.width)>>1;
                var ty:int = (stageServ.defaultScreenHeight - child.height)>>1;
                if(child!=view)
                {
                    var p:DisplayObjectContainer = view.parent;
                    while(p)
                    {
                        tx -= p.x;
                        ty -= p.y;
                        p = p.parent;
                        if(p==view)
                        {
                            break;
                        }
                    }
                }
                
                child.x = stageServ.gameScreenOffsetX + tx + xOffset;
                child.y = stageServ.gameScreenOffsetY + ty + yOffset;
            }
            else
            {
                if(view)
                {
                    child.x = xOffset + ((view.width-child.width)>>1);
                    child.y = yOffset + ((view.height-child.height)>>1);
                }
            }
            
        }
        
        override protected function destruct():void
        {
            super.destruct();
            if(_mediator)
            {
//                _mediator.dispose();
            }
        }
        
        override public function tick(delta:Number):void
        {
//            super.tick(delta);
//            if(_mediator && _mediator.couldTick)
//            {
//                _mediator.tick(delta);
//            }
        }
        
//        override protected function closeWindow():void
//        {
//            if(_mediator)
//            {
//                _mediator.closeScreen();
//            }
//            excuteCallback(getCloseHandle(), this);
//        }
        
        public function setMediator(mediator:IScreenAdapterMediator):void
        {
            _mediator = mediator;
        }
        
        public function get screenMediator():IScreenAdapterMediator
        {
            return _mediator;
        }
        
        public function onResize():void
        {
            
        }
	}
}