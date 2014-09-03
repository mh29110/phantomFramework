package phantom.core.animation
{
    public class DelayedCall implements IAnimatable
    {
        private var _currentTime:Number;
        private var _totalTime:Number;
        private var _callback:Function;
        private var _callArgs:Array;
        private var _repeatCount:int;
        private var _isDisposed:Boolean;
        private var _couldTick:Boolean;
		/** A DelayedCall allows you to execute a method after a certain time has passed. Since it 
		 *  implements the IAnimatable interface, it can be added to a juggler. In most cases, you 
		 *  do not have to use this class directly; the juggler class contains a method to delay
		 *  calls directly. 
		 * 
		 *  <p>DelayedCall dispatches an Event of type 'Event.REMOVE_FROM_JUGGLER' when it is finished,
		 *  so that the juggler automatically removes it when its no longer needed.</p>
		 * 
		 *  @see Juggler
		 */ 
        public function DelayedCall(call:Function, delay:Number, args:Array=null)
        {
            reset(call, delay, args);
        }
        
        public function reset(call:Function, delay:Number, args:Array=null):DelayedCall
        {
            _currentTime = 0;
            _totalTime = Math.max(delay, 0.0001);
            _callback = call;
            _callArgs = args;
            _repeatCount = 1;
            _couldTick = true;
            return this;
        }
        
        public function tick(time:Number):void
        {
            var previousTime:Number = _currentTime;
            _currentTime = Math.min(_totalTime, _currentTime + time);
            
            if (previousTime < _totalTime && _currentTime >= _totalTime)
            {           
                if(_callback)
                {
                    _callback.apply(null, _callArgs);
                }
                if (_repeatCount == 0 || _repeatCount > 1)
                {
                    if (_repeatCount > 0) _repeatCount -= 1;
                    _currentTime = 0;
                    tick((previousTime + time) - _totalTime);
                }
                else
                {
                    dispose();
                }
            }
        }
        
        public function dispose():void
        {
            if(_isDisposed == false)
            {
                _isDisposed = true;
                _callback = null;
                _callArgs = null;
            }
        }
        
        public function get totalTime():Number 
        { 
            return _totalTime; 
        }
        
        public function get currentTime():Number 
        {
            return _currentTime; 
        }
        
        public function get repeatCount():int 
        { 
            return _repeatCount; 
        }
        public function set repeatCount(value:int):void 
        {
            _repeatCount = value; 
        }
        
        public function get isDisposed():Boolean
        {
            return _isDisposed;
        }
        
        public function get couldTick():Boolean
        {
            return _couldTick;
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