package phantom.core.animation
{
    public class BezierTween extends Tween
    {
        private static const PROPERTY_LENGTH : String = "length";
        private static const PROPERTY_X : String = "x";
        private static const PROPERTY_Y : String = "y";
        /**
         * 属性锚点集
         */
        private var _propertAnchor : Vector.<Vector.<Number>>;
        
        public function BezierTween(target:Object, time:Number, transition:Object="linear")
        {
            super(target, time, transition);
        }
        
        override public function reset(target:Object, time:Number, transition:Object="linear"):Tween
        {
                _propertAnchor = new Vector.<Vector.<Number>>();
                return super.reset(target, time, transition);
        }
        
        override public function animate(property:String, endValue:Number):void
        {
            super.animate(property, endValue);
            _propertAnchor.push(null);
        }
        
        /**
         * @param property 变化的属性名称
         * @param endValue 目标值
         * @param anchors 路径锚点，可以是Arry或Vector
         * 
         */
        public function bezierAnimate(property:String, endValue:Number, anchors : Object):void
        {
            super.animate(property, endValue);
            _propertAnchor.push(getVector(anchors));
        }
        
        /**
         * 曲线路径运动
         * @param endX 终点X坐标
         * @param endY 终点Y坐标
         * @param anchors 锚点集，可以是Arry或Vector； 其中的元素可以是{x:0,y:0}，也可以是连续的值且奇数项为x，偶数项为y
         * @param throughAnchors 路径是否经过锚点
         * 
         */
        public function bezierMoveTo(endX:Number, endY:Number, anchors:Object, throughAnchors:Boolean=false):void
        {
            if(!anchors.hasOwnProperty(PROPERTY_LENGTH))
            {
                return;
            }
            var anchorsX : Vector.<Number> = new Vector.<Number>();
            var anchorsY : Vector.<Number> = new Vector.<Number>();
            
            var index : uint;
            var len : uint = anchors[PROPERTY_LENGTH];
            var item : Object = anchors[0];
            if(item.hasOwnProperty(PROPERTY_X) && item.hasOwnProperty(PROPERTY_Y))
            {
                for(index=0; index<len; index++)
                {
                    item = anchors[index];
                    anchorsX[index] = item[PROPERTY_X];
                    anchorsY[index] = item[PROPERTY_Y];
                }
            }
            else
            {
                for(index=0; index<len; index+=2)
                {
                    anchorsX.push(anchors[index]);
                    anchorsY.push(anchors[index+1]);
                }
            }
            
            if(throughAnchors)
            {
                var centerX : Number = (target[PROPERTY_X]+endX)*0.5;
                var centerY : Number = (target[PROPERTY_Y]+endY)*0.5;
                
                len = anchorsX.length;
                for(index=0; index<len; index++)
                {
                    anchorsX[index] = anchorsX[index]*2 - centerX;
                    anchorsY[index] = anchorsY[index]*2 - centerY;
                }
            }
            
            bezierAnimate(PROPERTY_X, endX, anchorsX);
            bezierAnimate(PROPERTY_Y, endY, anchorsY);
        }
        
        private function getVector(data : Object) : Vector.<Number>
        {
            var result : Vector.<Number>;
            if(data.hasOwnProperty(PROPERTY_LENGTH))
            {
                var len : uint = data[PROPERTY_LENGTH];
                result = new Vector.<Number>(len);
                for (var index:uint=0; index<len; index++)
                {
                    result[index] = data[index];
                }
            }
            return result;
        }
        
        override protected function getPropProgressValue(start:Number, end:Number, progress:Number, propertIndex:uint):Number
        {
            var result : Number;
            
            var anchorList : Vector.<Number> = _propertAnchor[propertIndex];
            if(anchorList && anchorList.length)
            {
                result = getBezierValueBetter(start, end, progress, anchorList);
            }
            else
            {
                result = super.getPropProgressValue(start, end, progress, propertIndex);
            }
            return result
        }
        
        /**
         * 优化算法
         */
        private function getBezierValueBetter(start:Number, end:Number, progress:Number, anchorList:Vector.<Number>):Number
        {
            var progressOpp : Number = 1-progress;
            var pointList : Vector.<Number>;
            var progressList : Vector.<Number>;
            var choseList : Vector.<uint>;
            
            pointList= new <Number>[start];
            pointList = pointList.concat(anchorList);
            pointList.push(end);
            
            var index : uint;
            var choseTot : uint = anchorList.length+1;
            var len : uint = choseTot+1;
            var progressItem : Number = Math.pow(progressOpp, choseTot);
            progressList = new <Number>[progressItem];
            for(index=1; index<len; index++)
            {
                progressItem *= progress/progressOpp;
                progressList[index] = progressItem;
            }
            
            var choseItem : uint = 1;
            choseList = new Vector.<uint>(len);
            choseList[0] = choseItem;
            choseList[choseTot] = choseItem;
            var choseLen : uint = len/2;
            for(index=1; index<=choseLen; index++)
            {
                choseItem *= (len-index)/index;
                choseList[index] = choseItem;
                choseList[choseTot-index] = choseItem;
            }
            if(choseTot%2 == 0)
            {
                index++;
                choseList[index] = choseItem*(len-index)/index;
            }
            
            var result : Number = 0;
            for(index=0; index<len; index++)
            {
                result += choseList[index]*progressList[index]*pointList[index];
            }
            return result;
        }
        
//        private function getBezierValue(start:Number, end:Number, progress:Number, anchorList:Vector.<Number>):Number
//        {
//            var result : Number;
//            
//            var progressOpp : Number = 1-progress;
//            var anchorNum : uint = anchorList.length;
//            var totNum : uint = anchorNum + 2;
//            var powValue : uint = anchorNum+1;
//            result = Math.pow(progressOpp, powValue)*start + Math.pow(progress, powValue)*end;
//            
//            var targetNum : uint;
//            for(var index:uint=0; index<anchorNum; index++)
//            {
//                targetNum = index+1;
//                result += choseNum(targetNum, powValue) * Math.pow(progressOpp, powValue-targetNum) * Math.pow(progress, targetNum) * anchorList[index];
//            }
//            
//            return result;
//        }
//        
//        /**
//         * 组合方式(不包含target为0的情况)
//         */
//        private function choseNum(target:uint, total:uint):uint
//        {
//            if(target+target>total)
//            {
//                target = total-target;
//            }
//            var result : uint;
//            
//            result = mul(total-target+1, total)/mul(1, target);
//            
//            return result;
//        }
//        
//        /**
//         * 从a乘到b（a<b）
//         */
//        private function mul(a:uint, b:uint):uint
//        {
//            var result : uint = a;
//            for(var value : uint=a+1; value<=b; value++)
//            {
//                result*=value;
//            }
//            return result;
//        }
    }
}