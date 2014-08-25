package phantom.ui.flash
{
	import phantom.core.interfaces.IManager;

    public class UIAssetLinker implements IManager
    {
        private var _uiAssetDefine:Vector.<String>;
        private var _uiAssetNodeList:Vector.<UIAssetNode>;
        
        public function UIAssetLinker()
        {
            _uiAssetDefine = new Vector.<String>();
            _uiAssetNodeList = new Vector.<UIAssetNode>();
        }
        
        
        public function addUI(uiDefine:String, controllerDefine:Class):void
        {
            var index:int = _uiAssetDefine.indexOf(uiDefine);
            var node:UIAssetNode;
            if(index<0)
            {
                _uiAssetDefine.push(uiDefine);
                node = new UIAssetNode(uiDefine);
                node.defaultControllerDefine = controllerDefine;
                _uiAssetNodeList.push(node);
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
    }
}
