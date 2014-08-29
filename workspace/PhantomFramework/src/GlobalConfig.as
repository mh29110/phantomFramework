package {
	
	/**全局配置*/
	public class GlobalConfig {
		//------------------静态配置------------------		
		/**游戏帧率*/
		public static var GAME_FPS:int = 60;
		/**动画默认播放间隔*/
		public static var MOVIE_INTERVAL:int = 100;
		//------------------动态配置------------------

		public static var uiPath:String = "";
		
		public static var resPath:String = "";	
		
		/**鼠标提示延迟(毫秒)*/
		public static var tipDelay:int = 200;
		/**提示是否跟随鼠标移动*/
		public static var tipFollowMove:Boolean = true;
		/**是否开启触摸*/
		public static var touchScrollEnable:Boolean = true;
		/**是否支持鼠标滚轴滚动*/
		public static var mouseWheelEnable:Boolean = true;
		
		public static const host:String = "192.168.10.101";
		public static const port:int = 6881;

		/**
		 * 双击检查延迟
		 * 这个值太小就影响双击成功率，太大就影响单机的响应时间
		 */        
		public static const DOUBLE_CLICK_CHECK_DELAY:Number = 0.25;
	}
}