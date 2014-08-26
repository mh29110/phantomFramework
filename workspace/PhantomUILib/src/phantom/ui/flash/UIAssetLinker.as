package phantom.ui.flash
{
	import phantom.core.interfaces.IManager;

	/**
	 * 链接flash资源与适配器 
	 * @author liphantomjia@gmail.com
	 * 
	 */
    public class UIAssetLinker implements IManager
    {
        private var _uiAssetDefine:Vector.<String>;
        private var _uiAssetNodeList:Vector.<UIAssetNode>;
		private var _uiMediatorDefine:Vector.<Class>;
        
        public function UIAssetLinker()
        {
            _uiAssetDefine = new Vector.<String>();
            _uiAssetNodeList = new Vector.<UIAssetNode>();
			_uiMediatorDefine = new Vector.<Class>();
        }
        
        
        public function addUI(uiDefine:String, controllerDefine:Class , mediatorDefine:Class):void
        {
            var index:int = _uiAssetDefine.indexOf(uiDefine);
            var node:UIAssetNode;
            if(index<0)
            {
                _uiAssetDefine.push(uiDefine);
                node = new UIAssetNode(uiDefine);
                node.defaultControllerDefine = controllerDefine;
                _uiAssetNodeList.push(node);
				_uiMediatorDefine.push(mediatorDefine);
            }
        }
        
        public function getUI(uiDefine:String, callback:Function):void
        {
            var node:UIAssetNode;
            var index:int = _uiAssetDefine.indexOf(uiDefine);
            if(index>=0)
            {
                node = _uiAssetNodeList[index];
                node.appendCallback(callback);
                node.startLoad();
            }
        }
		
		public function getMediatorDefineByName(uiDefine:String):Class
		{
			var index:int = _uiAssetDefine.indexOf(uiDefine);	
			if(index>=0)
			{
				return _uiMediatorDefine[index];
			}
			return null;
		}
    }
}
