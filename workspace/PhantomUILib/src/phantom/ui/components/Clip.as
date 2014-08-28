package phantom.ui.components
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	import phantom.core.events.UIEvent;
	import phantom.core.handlers.Handler;
	
	/**图片加载后触发*/
	[Event(name="imageLoaded",type="morn.core.events.UIEvent")]
	/**当前帧发生变化后触发*/
	[Event(name="frameChanged",type="morn.core.events.UIEvent")]
	
	/**位图剪辑*/
	public class Clip extends ComponentAdapter 
	{
		protected var _autoStopAtRemoved:Boolean = true;
		protected var _clipWidth:Number;
		protected var _clipHeight:Number;
		protected var _autoPlay:Boolean;
		protected var _interval:int = GlobalConfig.MOVIE_INTERVAL;
		protected var _from:int = -1;
		protected var _to:int = -1;
		protected var _complete:Handler;
		protected var _isPlaying:Boolean;
		protected var mc:MovieClip;
		protected var _autoLoop:Boolean;
		
		/**位图切片
		 * @param url 资源类库名或者地址
		 * @param clipX x方向个数
		 * @param clipY y方向个数*/
		public function Clip(skin:*) {
			super(skin);
		}
		
		override protected function initializeSkin(skin:*):void {
			mc = skin as MovieClip;
			mc.gotoAndStop(1);
			if(!mc)
			{
				throw(new Error("mc equal null"));
				return ;
			}
			mc.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			mc.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
		protected function onAddedToStage(e:Event):void {
			if (_autoPlay) {
				play();
			}
		}
		
		protected function onRemovedFromStage(e:Event):void {
			if (_autoStopAtRemoved) {
				stop();
			}
		}
		
		/**从指定的位置播放*/
		public function gotoAndPlay(frame:int):void {
			this.frame = frame;
			play();
		}
		
		/**跳到指定位置并停止*/
		public function gotoAndStop(frame:int):void {
			stop();
			this.frame = frame;
		}
		
		/**当前帧*/
		public function get frame():int {
			return mc.currentFrame;
		}
		
		public function set frame(value:int):void {
			mc.gotoAndStop(value);
			sendEvent(UIEvent.FRAME_CHANGED);
			if (mc.currentFrame == _to) {
				stop();
				_to = -1;
				if (_complete != null) {
					var handler:Handler = _complete;
					_complete = null;
					handler.execute();
				}
			}
		}
		
		/**切片帧的总数*/
		public function get totalFrame():int {
			return mc.totalFrames;
		}
		
		/**从显示列表删除后是否自动停止播放*/
		public function get autoStopAtRemoved():Boolean {
			return _autoStopAtRemoved;
		}
		
		public function set autoStopAtRemoved(value:Boolean):void {
			_autoStopAtRemoved = value;
		}
		
		/**自动播放*/
		public function get autoPlay():Boolean {
			return _autoPlay;
		}
		
		public function set autoPlay(value:Boolean):void {
			if (_autoPlay != value) {
				_autoPlay = value;
				_autoPlay ? play() : stop();
			}
		}
		
		/**动画播放间隔(单位毫秒)*/
		public function get interval():int {
			return _interval;
		}
		
		public function set interval(value:int):void {
			if (_interval != value) {
				_interval = value;
				if (_isPlaying) {
					play();
				}
			}
		}
		
		/**是否正在播放*/
		public function get isPlaying():Boolean {
			return _isPlaying;
		}
		
		public function set isPlaying(value:Boolean):void {
			_isPlaying = value;
		}
		
		/**开始播放*/
		public function play():void {
			_isPlaying = true;
			AppCenter.instance.timer.doLoop(_interval, loop);
		}
		
		protected function loop():void {
			if(frame > totalFrame&&!_autoLoop)
			{
				mc.gotoAndStop(totalFrame);
			}
			else if(_autoLoop)
			{
				mc.gotoAndPlay(1);
			}
			else
			{
				frame++;
			}
		}
		
		/**停止播放*/
		public function stop():void {
			AppCenter.instance.timer.clearTimer(loop);
			_isPlaying = false;
		}
		
		/**从某帧播放到某帧，播放结束发送事件
		 * @param from 开始帧(为-1时默认为第一帧)
		 * @param to 结束帧(为-1时默认为最后一帧) */
		public function playFromTo(from:int = -1, to:int = -1, complete:Handler = null):void {
			_from = from == -1 ? 0 : from;
			_to = to == -1 ? mc.totalFrames:to;
			_complete = complete;
			gotoAndPlay(_from);
		}
		
		/**是否对位图进行平滑处理*/
		public function get smoothing():Boolean {
			return mc.smoothing;
		}
		
		public function set smoothing(value:Boolean):void {
			mc.smoothing = value;
		}
		
		/**销毁资源
		 * @param	clearFromLoader 是否同时删除加载缓存*/
		override public function dispose():void {
			//todo
		}

		public function get autoLoop():Boolean
		{
			return _autoLoop;
		}

		public function set autoLoop(value:Boolean):void
		{
			_autoLoop = value;
		}

	}
}