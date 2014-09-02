package phantom.core.animation
{
	/**
	 * 改写starling的 animation包 , 未完善,参考官方继续修改. 
	 * @author liphantomjia@gmail.com
	 * 
	 */
    public class Tween
    {
        private var _target:Object;
        private var _transitionFunc:Function;
        private var _transitionName:String;
        
        private var _properties:Vector.<String>;
        private var _startValues:Vector.<Number>;
        private var _endValues:Vector.<Number>;

        private var _onStart:Function;
        private var _onStartParams:Array;
        
        private var _onUpdate:Function;
        private var _onUpdateParams:Array;
        
        private var _onRepeat:Function;
        private var _onRepeatParams:Array;
        
        private var _onComplete:Function;  
        private var _onCompleteParams:Array;
        
        private var _totalTime:Number;
        private var _currentTime:Number;
        private var _progress:Number;
        private var _delay:Number;
        private var _roundToInt:Boolean;
        private var _nextTween:Tween;
        private var _repeatCount:int;
        private var _repeatDelay:Number;
        private var _reverse:Boolean;
        private var _currentCycle:int;
        private var _isDisposed:Boolean;
        private var _couldTick:Boolean;
        
        public function Tween(target:Object, time:Number, transition:Object="linear")        
        {
             reset(target, time, transition);
        }

        public function reset(target:Object, time:Number, transition:Object="linear"):Tween
        {
            _target = target;
            _currentTime = 0.0;
            _totalTime = Math.max(0.0001, time);
            _progress = 0.0;
            _delay = _repeatDelay = 0.0;
            _onStart = _onUpdate = _onComplete = null;
            _onStartParams = _onUpdateParams = _onCompleteParams = null;
            _roundToInt = _reverse = false;
            _repeatCount = 1;
            _currentCycle = -1;
            
            if (transition is String)
            {
                this.transition = transition as String;
            }
            else if (transition is Function)
            {
                this.transitionFunc = transition as Function;
            }
            else 
            {
                throw new ArgumentError("Transition must be either a string or a function");
            }
            
            if (_properties)  _properties.length  = 0; else _properties  = new <String>[];
            if (_startValues) _startValues.length = 0; else _startValues = new <Number>[];
            if (_endValues)   _endValues.length   = 0; else _endValues   = new <Number>[];
            
            _couldTick = true;
            _isDisposed = false;
            
            return this;
        }
        
        public function animate(property:String, endValue:Number):void
        {
            if (_target == null) return; // tweening null just does nothing.
                   
            _properties.push(property);
            _startValues.push(Number.NaN);
            _endValues.push(endValue);
        }
        
        public function scaleTo(factor:Number):void
        {
            animate("scaleX", factor);
            animate("scaleY", factor);
        }
        
        public function moveTo(x:Number, y:Number):void
        {
            animate("x", x);
            animate("y", y);
        }
        
        public function fadeTo(alpha:Number):void
        {
            animate("alpha", alpha);
        }
        
        public function tick(delta:Number):void
        {
            if (delta == 0 || (_repeatCount == 1 && _currentTime == _totalTime))
            {
                return;
            }
            
            var i:int;
            var previousTime:Number = _currentTime;
            var restTime:Number = _totalTime - _currentTime;
            var carryOverTime:Number = delta > restTime ? delta - restTime : 0.0;
            
            _currentTime = Math.min(_totalTime, _currentTime + delta);
            
            if (_currentTime <= 0)
            {
                return; // the delay is not over yet
            }

            if (_currentCycle < 0 && previousTime <= 0 && _currentTime > 0)
            {
                _currentCycle++;
                if (_onStart != null)
                {
                    _onStart.apply(null, _onStartParams);
                }
            }

            var ratio:Number = _currentTime / _totalTime;
            var reversed:Boolean = _reverse && (_currentCycle % 2 == 1);
            var numProperties:int = _startValues.length;
            _progress = reversed ? _transitionFunc(1.0 - ratio) : _transitionFunc(ratio);

            var startValue:Number;
            var endValue:Number;
            var currentValue:Number;
            for (i=0; i<numProperties; ++i)
            {                
                if (isNaN(_startValues[i])) 
                {
                    _startValues[i] = _target[_properties[i]] as Number;
                }
                
                startValue = _startValues[i];
                endValue = _endValues[i];
                currentValue = getPropProgressValue(startValue, endValue, _progress, i);
                
                if (_roundToInt)
                {
                    currentValue = Math.round(currentValue);
                }
                _target[_properties[i]] = currentValue;
            }

            if (_onUpdate != null) 
            {
                _onUpdate.apply(null, _onUpdateParams);
            }
            
            if (previousTime < _totalTime && _currentTime >= _totalTime)
            {
                if (_repeatCount == 0 || _repeatCount > 1)
                {
                    _currentTime = -_repeatDelay;
                    _currentCycle++;
                    if (_repeatCount > 1)
                    {
                        _repeatCount--;
                    }
                    if (_onRepeat != null)
                    {
                        _onRepeat.apply(null, _onRepeatParams);
                    }
                }
                else
                {
                    var onComplete:Function = _onComplete;
                    var onCompleteArgs:Array = _onCompleteParams;
                    
                    if (onComplete != null)
                    {
                        onComplete.apply(null, onCompleteArgs);
                    }
                    
                    dispose();
                }
            }
            
            if (carryOverTime) 
            {
                tick(carryOverTime);
            }
        }
        
        protected function getPropProgressValue(start:Number, end:Number, progress:Number, propertIndex:uint):Number
        {
            var result : Number;
            result = (1-progress)*start + progress*end;
            return result;
        }
        
        public function getEndValue(property:String):Number
        {
            var index:int = _properties.indexOf(property);
            if (index == -1) throw new ArgumentError("The property '" + property + "' is not animated");
            else return _endValues[index] as Number;
        }
        
        public function dispose():void
        {
            if(_isDisposed == false)
            {
                _isDisposed = true;
                _couldTick = false;
                _startValues = null;
                _endValues = null;
                _properties = null;
                _target = null;
                _transitionFunc = null;
                _onComplete = null;
                _onCompleteParams = null;
                _onRepeat = null;
                _onRepeatParams = null;
                _onStart = null;
                _onStartParams = null;
                _onUpdate = null;
                _onUpdateParams = null;
            }
        }
        
        public function get isComplete():Boolean 
        { 
            return _currentTime >= _totalTime && _repeatCount == 1; 
        }        
        
        public function get target():Object { return _target; }
        
        public function get transition():String { return _transitionName; }
        public function set transition(value:String):void 
        { 
            _transitionName = value;
            _transitionFunc = Transitions.getTransition(value);
            
            if (_transitionFunc == null)
                throw new ArgumentError("Invalid transiton: " + value);
        }
        
        public function get transitionFunc():Function { return _transitionFunc; }
        public function set transitionFunc(value:Function):void
        {
            _transitionName = "custom";
            _transitionFunc = value;
        }
        
        public function get totalTime():Number { return _totalTime; }
        
        public function get currentTime():Number { return _currentTime; }
        
        public function get progress():Number { return _progress; } 
        
        public function get delay():Number { return _delay; }
        public function set delay(value:Number):void 
        { 
            _currentTime = _currentTime + _delay - value;
            _delay = value;
        }
        
        public function get repeatCount():int { return _repeatCount; }
        public function set repeatCount(value:int):void { _repeatCount = value; }
        
        public function get repeatDelay():Number { return _repeatDelay; }
        public function set repeatDelay(value:Number):void { _repeatDelay = value; }
        
        public function get reverse():Boolean { return _reverse; }
        public function set reverse(value:Boolean):void { _reverse = value; }
        
        public function get roundToInt():Boolean { return _roundToInt; }
        public function set roundToInt(value:Boolean):void { _roundToInt = value; }        
        
        public function get onStart():Function { return _onStart; }
        public function set onStart(value:Function):void { _onStart = value; }
        
        public function get onUpdate():Function { return _onUpdate; }
        public function set onUpdate(value:Function):void { _onUpdate = value; }
        
        public function get onRepeat():Function { return _onRepeat; }
        public function set onRepeat(value:Function):void { _onRepeat = value; }
        
        public function get onComplete():Function { return _onComplete; }
        public function set onComplete(value:Function):void { _onComplete = value; }
        
        public function get onStartArgs():Array { return _onStartParams; }
        public function set onStartArgs(value:Array):void { _onStartParams = value; }
        
        public function get onUpdateArgs():Array { return _onUpdateParams; }
        public function set onUpdateArgs(value:Array):void { _onUpdateParams = value; }
        
        public function get onRepeatArgs():Array { return _onRepeatParams; }
        public function set onRepeatArgs(value:Array):void { _onRepeatParams = value; }
        
        public function get onCompleteArgs():Array { return _onCompleteParams; }
        public function set onCompleteArgs(value:Array):void { _onCompleteParams = value; }
        
        public function get nextTween():Tween { return _nextTween; }
        public function set nextTween(value:Tween):void { _nextTween = value; }
        
        public function get couldTick():Boolean
        {
            return _couldTick;
        }
        
        public function get isDisposed():Boolean
        {
            return _isDisposed;
        }
        
        public function pause():void
        {
            _couldTick = false;
        }
        
        public function resume():void
        {
            if(_isDisposed == false)
            {
                _couldTick = true;
            }
        }
    }
}
