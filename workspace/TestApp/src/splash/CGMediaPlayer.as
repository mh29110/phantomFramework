package splash
{
    import flash.display.Bitmap;
    import flash.display.DisplayObject;
    import flash.display.Loader;
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.MouseEvent;
    import flash.events.NetStatusEvent;
    import flash.events.SecurityErrorEvent;
    import flash.media.Video;
    import flash.net.NetConnection;
    import flash.net.NetStream;
    import flash.utils.clearTimeout;
    import flash.utils.setTimeout;
    
    import phantom.core.handlers.Handler;
    
    public class CGMediaPlayer extends Sprite
    {
        public static const CG_SCROLL_LOAEDED:String = "cg scroll loaded";
        
        private const LEGEND_DURATION:Number = 2000;
        private const WIDTH:int = 1248;
        private const HEIGHT:int = 648;
        private const WIDTH_VIDEO:int = 1000;
        private const HEIGHT_VIDEO:int = 520;
        
        private var _callFunc:Function;
        private var _tempNewName:String;
        private var _scrollLoader:Loader;
        private var _imgBg:Bitmap;
        private var _skipBtn:Sprite;
        private var _legendLabelLoader:Loader;
        private var _netstream:NetStream;
        private var _video:Video;
        private var _setTimeOutID:uint;
        
        private var _isStop:Boolean;
        
        public function CGMediaPlayer(callBack:Function,name:String)
        {
            _callFunc = callBack;
            _tempNewName = name;
            loadImageBg();
            prepareScrollAnimation();
        }
        
        private function loadImageBg():void
        {
            graphics.beginFill(0x000000);
            graphics.drawRect(0, 0, WIDTH, HEIGHT);
            graphics.endFill();
            
            _imgBg = new Bitmap()
            addChildAt(_imgBg, 0);
            _imgBg.visible = false;
            
			AppCenter.instance.loader.loadBMD( "cgbg.png", new Handler(onImageBgLoaded));
        }
        
        private function onImageBgLoaded(bmd:*):void
        {
            if(_imgBg)
            {
                _imgBg.bitmapData = bmd;
            }
        }
        
        private function prepareScrollAnimation():void
        {
            _scrollLoader = new Loader();
            addChild(_scrollLoader);
			AppCenter.instance.loader.loadDB( "scrollAnimation.swf", new Handler(onScrollAnimationLoaded));
        }
        
        private function onScrollAnimationLoaded(data:*):void
        {
            _scrollLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,onScrollAnimationParseComplete);
            _scrollLoader.loadBytes(data);
        }
        
        private function onScrollAnimationParseComplete(e:Event):void
        {
            dispatchEvent(new Event(CG_SCROLL_LOAEDED));
            (e.currentTarget.loader.content as MovieClip).addEventListener(Event.ENTER_FRAME,onCheckEnded);
            loadingVideo();
            loadSkipImg();
        }
        
        private function onCheckEnded(e:Event):void
        {
            if (e.currentTarget.currentFrame ==e.currentTarget.totalFrames ) 
            {
                if(_scrollLoader)
                {
                    removeFromParent(_scrollLoader);
                    _scrollLoader.unloadAndStop(true);
                    _scrollLoader = null;
                }
                
                _imgBg.visible = true;
                
                _video.visible = true;
                _video.alpha = 0;
                _video.addEventListener(Event.ENTER_FRAME, onVideoFadeIn);
            }
        }
        private function onVideoFadeIn(event:Event):void
        {
            _video.alpha += 0.02;
            if(_video.alpha > 0.95)
            {
                _video.removeEventListener(Event.ENTER_FRAME,onVideoFadeIn);
                _video.alpha = 1;
                playVideo();
            }
        }
        
        private function playVideo():void
        {
            _netstream.resume();
        }
        
        private function loadSkipImg():void
        {
            _skipBtn = new Sprite();
            _skipBtn.x = 1012;
            _skipBtn.y = 535;
            addChild(_skipBtn);
            _skipBtn.addEventListener(MouseEvent.CLICK,onSkipCGHandler);
            
			AppCenter.instance.loader.loadBMD( "skip.png", new Handler(onSkipImageLoaded));
        }
        
        private function onSkipCGHandler(e:MouseEvent):void
        {
            _skipBtn.removeEventListener(MouseEvent.CLICK,onSkipCGHandler);
            gotoCreateCharacter(); 
        }
        
        private function onSkipImageLoaded(data:*):void
        {
            if(_skipBtn)
            {
                _skipBtn.addChild(new Bitmap(data));
            }
        }
        
        private function loadingVideo():void
        {
            _video = new Video();
            _video.width = WIDTH_VIDEO;
            _video.height = HEIGHT_VIDEO;
            _video.x = 138;
            _video.y = 63;
            _video.visible = false;
            addChild(_video);
            
            var client:Object = new Object( );
            client.onMetaData = function(infoObject:Object):void {};
            
            var nc:NetConnection = new NetConnection();
            nc.connect(null);
            
            _netstream = new NetStream(nc);
            _netstream.client = client;
            _netstream.addEventListener(NetStatusEvent.NET_STATUS,statusHandler);
            _netstream.bufferTime = 1;
            _video.attachNetStream(_netstream);
            
            var paths:Vector.<String> = new Vector.<String>(3);//视频流的备用地址列表
            _netstream.play(paths[0]);
            _netstream.addEventListener(IOErrorEvent.IO_ERROR, streamErrorHandle);
            _netstream.addEventListener(SecurityErrorEvent.SECURITY_ERROR, streamErrorHandle);
            
            function streamErrorHandle(e:Event):void
            {
                if(paths.length > 0)
                {
                    _netstream.play(paths.shift());
                }
            }
            
            _netstream.pause();
        }
        
        private function statusHandler(event:NetStatusEvent):void
        {
            switch(event.info.code)
            {
                case "NetStream.Play.Stop":
                {
                    showLegend();
                    _isStop = true;
                    break;  
                }
            }
        }
        
        private function onCGLoaded():void
        {
            
        }
        
        private function clearMediaPlayer():void
        {
            if(_setTimeOutID != 0)
            {
                clearTimeout(_setTimeOutID);
            }
            
            if(this.hasEventListener(Event.ENTER_FRAME))
            {
                this.removeEventListener(Event.ENTER_FRAME,onAllFadeOut);
            }
            if(_scrollLoader)
            {
                removeFromParent(_scrollLoader)
                _scrollLoader.unloadAndStop();
                _scrollLoader = null;
            }
            
            if(_netstream)
            {
                _netstream.close();
                _netstream.removeEventListener(NetStatusEvent.NET_STATUS,statusHandler);
                _netstream = null;
            }
            
            if(_imgBg)
            {
                removeFromParent(_imgBg);
                if(_imgBg.bitmapData)
                {
                    _imgBg.bitmapData.dispose();
                }
                _imgBg = null;
            }
            
            if(_video)
            {
                removeFromParent(_video);
                if(_video.hasEventListener(Event.ENTER_FRAME))
                {
                    _video.removeEventListener(Event.ENTER_FRAME, onVideoFadeIn);
                }
                _video = null;
            }
            if(_legendLabelLoader)
            {
                removeFromParent(_legendLabelLoader);
                _legendLabelLoader.unloadAndStop();
                _legendLabelLoader = null;
            }
            
            if(_skipBtn)
            {
                removeFromParent(_skipBtn);
                _skipBtn = null;
            }
        }
        
        private function removeFromParent(target:DisplayObject):void
        {
            if(target.parent)
            {
                target.parent.removeChild(target);
            }
        }
        
        private function showLegend():void
        {
			AppCenter.instance.loader.loadBMD( "legend.png", new Handler(onLegendLabelLoaded));
        }
        
        private function onLegendLabelLoaded(data:*):void
        {
            _legendLabelLoader = new Loader();
            _legendLabelLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLegendParseComplete);
            _legendLabelLoader.loadBytes(data);
            addChild(_legendLabelLoader);
            
            _setTimeOutID = setTimeout(allFadeOut,LEGEND_DURATION);//
        }
        
        private function onLegendParseComplete(e:Event):void
        {
            _legendLabelLoader.x = (WIDTH-_legendLabelLoader.width)>>1;
            _legendLabelLoader.y = (HEIGHT-_legendLabelLoader.height)>>1;
            
        }
        
        private function allFadeOut():void
        {
            _setTimeOutID = 0;
            this.addEventListener(Event.ENTER_FRAME,onAllFadeOut);
        }
        
        private function onAllFadeOut(event:Event):void
        {
            _legendLabelLoader.alpha -= 0.02;
            _imgBg.alpha -= 0.02;
            
            if(_imgBg.alpha < 0.01)
            {
                removeEventListener(Event.ENTER_FRAME,onAllFadeOut);
                gotoCreateCharacter(); 
            }
        }
        
        private function gotoCreateCharacter():void
        {
            clearMediaPlayer();
            _callFunc(_tempNewName);   
        }
        
    }
}