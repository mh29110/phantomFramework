package phantom.ui.flash
{
    public class UIAssetLinker 
    {
        private var _uiAssetDefine:Vector.<String>;
        private var _uiMediatorName:Vector.<String>;
        private var _uiAssetNodeList:Vector.<UIAssetNode>;
        private var _commonAssetNode:UIAssetNode;
        private var _tipsAssetNode:UIAssetNode;
        
        public function UIAssetLinker()
        {
            _uiAssetDefine = new Vector.<String>();
            _uiMediatorName = new Vector.<String>();
            _uiAssetNodeList = new Vector.<UIAssetNode>();
        }
        
        
        public function addUI(uiDefine:String, controllerDefine:Class, uiMedaitorName:String):void
        {
            var index:int = _uiAssetDefine.indexOf(uiDefine);
            var node:UIAssetNode;
            if(index<0)
            {
                _uiAssetDefine.push(uiDefine);
                _uiMediatorName.push(uiMedaitorName);
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
