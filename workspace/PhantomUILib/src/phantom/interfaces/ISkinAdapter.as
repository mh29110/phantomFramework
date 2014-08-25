package phantom.interfaces
{
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.geom.Point;
    
    import phantom.core.interfaces.IDispose;
    

    public interface ISkinAdapter extends IDispose
    {
        /**
         * 从父级对象中移除
         */        
        function removeFromParent():void;
        /**
         * 添加到父级
         * @param parent        父级对象 
         */        
        function addToParent(parent:*):void;
        
        /**
         * 重绘对象
         */		
        function invalidate():void
        
        /**
         * 取得全局坐标
         * @param target  目标点, <b>默认为0,0点</b>
         */        
        function getGlobalPos(target:Point = null):Point;
        
        /**
         * 皮肤
         */        
        function get view():DisplayObject
        
        /**
         * 宽
         */
        function set width(value:Number):void;
        function get width():Number;
        
        /**
         * 高
         */
        function set height(value:Number):void;
        function get height():Number;
        
        /**
         * 视图鼠标x轴坐标
         */        
        function get mouseX():Number;
        
        /**
         * 视图鼠标y轴坐标
         */        
        function get mouseY():Number;
        
        /**
         * x轴坐标
         */
        function set x(value:Number):void;
        function get x():Number;
        
        /**
         * y轴坐标
         */
        function set y(value:Number):void;
        function get y():Number;
        
        /**
         * 水平缩放比例
         */
        function set scaleX(value:Number):void;
        function get scaleX():Number;
        
        /**
         * 垂直缩放比例
         */
        function set scaleY(value:Number):void;
        function get scaleY():Number;
        
        /**
         * 是否启用鼠标
         */
        function set mouseEnabled(value:Boolean):void;
        function get mouseEnabled():Boolean;
        
        /**
         * 透明度
         */
        function set alpha(value:Number):void;
        function get alpha():Number;
        
        /**
         * 是否可见
         */
        function set visible(value:Boolean):void;
        function get visible():Boolean;
        
        /**
         * 元件名称
         */
        function get name():String;
        
        /**
         * 父级显示对象
         */        
        function get parent():DisplayObjectContainer;
        
        /**
         * 使用手形
         */        
        function get useHandCursor():Boolean;
        function set useHandCursor(value:Boolean):void;
        
        /**
         * 使用按钮模式
         */        
        function get buttonMode():Boolean;
        function set buttonMode(value:Boolean):void;
        
        /**
         * 应用滤镜
         */        
        function get filters():Array
        function set filters(v:Array):void
                                   
    }
}