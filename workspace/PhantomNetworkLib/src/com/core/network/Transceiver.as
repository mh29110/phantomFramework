﻿package com.core.network
{
    import com.hurlant.crypto.hash.MD5;
    import com.hurlant.crypto.symmetric.AESKey;
    import com.hurlant.crypto.symmetric.CBCMode;
    import com.hurlant.util.Hex;
    
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.IOErrorEvent;
    import flash.events.ProgressEvent;
    import flash.events.SecurityErrorEvent;
    import flash.net.Socket;
    import flash.utils.ByteArray;
    import flash.utils.Dictionary;
    import flash.utils.Endian;
    import flash.utils.clearInterval;
    import flash.utils.clearTimeout;
    import flash.utils.describeType;
    import flash.utils.getTimer;
    import flash.utils.setInterval;
    import flash.utils.setTimeout;

    /**
     * 通讯接口<br/>
     * Socket连接事件: SOCKET_CONNECT,SOCKET_DISCONNECT,SOCKET_ERROR,SOCKET_RETRY
     * <br/>
     * 监听服务端数据包:<br />
     * TransceiverInstance.addEventListener( packetID.toString(), callbackFunction );<br/>
     * packetID由服务端提供，为 int 类型.
     */
    public final class Transceiver extends EventDispatcher
    {
        public static var INSTANCE_INDEX:int = 0;
        
        public static const DEBUG:int = 3;
        public static const ERROR:int = 2;
        /**
         * 服务器人满
         */
        public static const GATE_FULL:int = 2;
        /**
         * 服务器断开
         */
        public static const GATE_OFFLINE:int = 1;
        /**
         * 服务器正常，可连接
         */
        public static const GATE_OK:int = 0;

        public static const INFO:int = 1;
        
        /**
         * 是否发送心跳包
         * @default
         */
        public static const KEEP_ALIVE:uint = 0;
        /**
         * 心跳包ID
         * @default
         */
        public static const KEEP_ALIVE_ACK:uint = 4;
        
        public static const PACKET_BUFF:int = 13;
        
        public static const GATE_STATE:int = 2112;
        /**
         * 加密包头大小
         */
        public static const PACKET_HEADER_SIZE: uint = 4;
        /**
         * 非加密包头大小
         * @default
         */
        public static const PACKET_HEADER_SIZE_NOSAVE:int = 8;
        public static const PACKET_RECV:int = 12;

        public static const PACKET_SEND:int = 11;
        /**
         * 请求超时
         */
        public static const REQUEST_TIMEOUT:int = 10000;
        
        private static const SOCKET_BASE:uint = 0xFF000000;
        /**
         * Socket已连接
         */
        public static const SOCKET_CONNECT:uint=SOCKET_BASE + 0;
        /**
         * Socket断开连接
         */
        public static const SOCKET_DISCONNECT:uint=SOCKET_BASE + 1;
        /**
         * Socket出错
         */
        public static const SOCKET_ERROR:uint=SOCKET_BASE + 2;
        /**
         * Socket连接重试中
         */
        public static const SOCKET_RETRY:uint=SOCKET_BASE + 3;
        /**
         * 已连接
         * @default
         */
        public static const STATE_CONNECTED: int = 2;
        /**
         * 连接中
         * @default
         */
        public static const STATE_CONNECTING: int = 1;
        /**
         * 未连接
         * @default
         */
        public static const STATE_DISCONNECTED: int = 0;
        /**
         * 连接失败
         * @default
         */
        public static const STATE_FAILED: int = 3;
        
        /**
         * 间隔多久发送心跳包
         */
        private const PING_INTERVAL:int=15000;
        
        /**
         * 记录调试信息的方法，将传递两个参数，function(msg:String, type:int=0)
         * @default
         */
        public var Logger:Function = function( msg:String, type:int = 0 ):void{};
        
        /**连接前的验证tick*/
//        public var Tick:String;
        
        /**
         * 断线自动重连
         * @default
         */
        public var AutoRetry:Boolean = true;
        /**
         *
         * @default
         */
        public var Code:int = 0;
        /**是否加密数据包*/
        public var Encrypt:Boolean=true;

        /**
         * 是否保持长连接，保持长连接将隔一段时间发送心跳包
         */
        public var KeepAlive:Boolean=true;

        public var ProcessDataFunc:Function = dispatchEvent;
        /**
         * 服务端连接状态
         */
        public var State:int;

        private var _BuffList:Array = [];
        private var _ConnectTimeoutID:uint;

        private var _FocusOutTimes:int = 0;
        private var _GateState:int = -2;
        private var _Host:String;
        private var _IsProcess:Boolean = false;
        
        /**
         * 长连接心跳包
         */
        private var _KeepAlivePacket:DataBlock;
        private var _LastPing:int;

        private var _LastReceive:int;
        /**
         * 包ID/命令ID
         */
        private var _PacketID:int;
        private var _PacketInfoMap:Dictionary = new Dictionary();
        private var _PingID:int;
        private var _PingTick:int=-1;
        private var _PortIdx:int = 0;
        private var _Ports:Array = [];
        private var _ProcessTimeID:int;
        private var _ProxyKey:String;
        private var _RecvCbc:CBCMode;
        private var _RecvKey:String;

        private var _RetryCount:int=0;
        private var _SendCbc:CBCMode;
        private var _SendKey:String;
        /**
         * socket
         */
        private var _Socket:Socket;
        private var _Time:int=1;

        //---- Public Methods --------------------------------------------------
        /**
         * 连接到服务器
         */
        private var _TryPort:int = 0;
        
        private var _InstanceIndex:int;
        
        private var _Preask:int;
        
        private var _inProcessPreask:Boolean;
        
        private var GateIsReady:Boolean;
        /**
         * 通讯类.
         * @param host 服务端地址
         * @param ports 服务端端口列表(第二个端口开始为备用端口，如果第一个连接不了会重试下一个)
         * @param encrypt 发包是否加密
         * @param sendKey 发包加密key
         * @param recvKey 收包加密key,如果为null，则跟发包相同
         * @param proxyKey 代理加密key，如果为空，则表示不使用代理
         */
        public function Transceiver( host:String, ports:Array, encrypt:Boolean, sendKey:String, recvKey:String = null, proxyKey:String = null, preask:int = 0)
        {
            super();
            
            
            _InstanceIndex = ++INSTANCE_INDEX;
            
            _PacketInfoMap[KEEP_ALIVE]="KEEP_ALIVE";
            _PacketInfoMap[KEEP_ALIVE_ACK]="KEEP_ALIVE_ACK";
            _PacketInfoMap[GATE_STATE]="GATE_STATE";
            _Preask = preask;
            
            Encrypt = encrypt;
//            Tick = tickCode;
            _SendKey = sendKey;
            _RecvKey = recvKey;
            _ProxyKey = proxyKey;
            
            if ( ports.length==1 )
            {
                ports.push( ports[ 0 ]);
            }
            _Host = host;
            _Ports = ports;
            
            _Socket=new Socket();
            _Socket.endian=Endian.LITTLE_ENDIAN;
            
            _KeepAlivePacket=new DataBlock( KEEP_ALIVE );
            this.addEventListener( KEEP_ALIVE_ACK.toString(), Socket_OnKeepAliveAck );
            State=STATE_DISCONNECTED;
            
            this.Connect();
        }
        
        /**
         * 连接服务器
         */
        public function Connect():void
        {
            switch ( State )
            {
                case STATE_DISCONNECTED:
                case STATE_FAILED:
                {
                    _Socket.addEventListener( Event.CONNECT, Socket_OnConnect );
                    _Socket.addEventListener( Event.CLOSE, Socket_OnClose );
                    _Socket.addEventListener( IOErrorEvent.IO_ERROR, Socket_OnIOError );
                    _Socket.addEventListener( SecurityErrorEvent.SECURITY_ERROR, Socket_OnSecurityError );
                    _Socket.addEventListener( ProgressEvent.SOCKET_DATA, Socket_OnReceivedData );

                    _TryPort = ServerPort;
                    Logger( "[Connect]"+ServerHost+":"+_TryPort, INFO );
                    _Socket.connect( ServerHost, _TryPort );

                    State=STATE_CONNECTING;
                    break;
                }
            }
        }

        /**
         * 断开服务器连接
         */
        public function Disconnect():void
        {
            if ( State==STATE_DISCONNECTED )
            {
                return;
            }

            try
            {
                flash.utils.clearInterval( _PingID );
                _Socket.close();
                Socket_OnClose( null );
            }
            catch ( E:Error )
            {

            }

            State=STATE_DISCONNECTED;
        }

        /**
         * 网关状态
         * @return
         */
        public function get GateState():int
        {
            return _GateState;
        }

        /**
         * 获取下一个服务器端口
         */
        public function NextServerPort():void
        {
            _PortIdx ++;
        }

        /**
         * 设置包ID常量的类。设置后在调试模式中可以看到发包，收包的信息。
         * 例如：
         * <code>
         * Transceiver.Instance.PacketTypes = PacketIDConst;
         *
         * Transceiver.Instance.Send( packet );//调试窗口显示[Send]Packet ID:xxx, Packet Name:...
         * PacketID是PacketIDConst中的常量值，PacketName是常量名
         * </code>
         * @param packetType
         */
        public function set PacketTypes( packetType:* ):void
        {
            var str:String = "unknow";
            var typeInfo:XML = describeType( packetType );
            var properties:XMLList = typeInfo.constant;

            for each ( var propertyInfo:XML in properties )
            {
                var prop:String = propertyInfo.@name;
                _PacketInfoMap[ packetType[prop] ] = prop;
            }
            properties = null;
            typeInfo = null;
        }

        /**
         * 发送心跳包
         */
        public function Ping():void
        {
            if ( State != STATE_CONNECTED )
            {
                return;
            }
            Send( _KeepAlivePacket, true );

            _LastPing=getTimer();
        }

        /**
         * @return 网络延迟时间
         */
        public function get PingTick():int
        {
            return _PingTick;
        }

        /**
         * @return 网关是否可使用
         */
        public function get Ready():Boolean
        {
            return _SendCbc!=null;
        }

        /**
         * 发送数据
         * @param packet 数据包
         */
        public function Send( packet:DataBlock, ignore:Boolean = false ):void
        {

            if ( State != STATE_CONNECTED || int( packet.Ident )<0 )
            {
                return;
            }

            Logger( "[Send]"+GetPacketInfo( packet.Ident )+",Header:"+packet.Ident+","+packet.Data.length, PACKET_SEND );

            if ( Encrypt )
            {
                SendSave( packet, _SendCbc );
            }
            else
            {
                _Socket.writeUnsignedInt( packet.Data.length+PACKET_HEADER_SIZE_NOSAVE );
                _Socket.writeUnsignedInt( packet.Ident );

                if ( packet.Data.length != 0 )
                {
                    _Socket.writeBytes( packet.Data );
                }
            }
            _Socket.flush();
        }

        /**
         * @return 当前连接的服务器地址
         */
        public function get ServerHost():String
        {
            return _Host;
        }

        /**
         * @return 当前连接的服务器端口
         */
        public function get ServerPort():int
        {
            var port:int = 80;

            if ( _PortIdx>=_Ports.length )
            {
                _PortIdx = 0;
            }

            if ( _Ports.length>0 )
            {
                port = int( _Ports[ _PortIdx ]);
            }
            return port;
        }

        /**
         * 设置加密tick
         * @param tick
         */
        public function set ServerTick( tick:String ):void
        {
            if ( tick.length>32 )
            {
                tick = tick.substr( 0, 32 );
            }
            else if ( tick.length<32 )
            {
                tick = StringUtils.FillString( tick, 32, "a", true );
            }
            var buff:ByteArray = new ByteArray();
            buff.endian = Endian.LITTLE_ENDIAN;
            buff.writeUTFBytes( tick );
            _SendCbc = new CBCMode( new AESKey( buff ));

            if ( _RecvKey )
            {
                tick = _RecvKey;
            }
            buff = new ByteArray();
            buff.endian = Endian.LITTLE_ENDIAN;
            buff.writeUTFBytes( tick );
            _RecvCbc = new CBCMode( new AESKey( buff ));
            clearInterval( _PingID );

            _PingID = setInterval( Ping, PING_INTERVAL );
        }

        private function CheckBuff( buff:ByteArray, len:int, rollbackPos:int = 0 ):Boolean
        {
            while ( buff.bytesAvailable < len )
            {
                if ( _BuffList.length==0 )
                {
                    this.UnshiftBuff( buff, rollbackPos );
                    _IsProcess = false;
                    return false;
                }
                _BuffList.splice( 0, 1 )[0].readBytes( buff, buff.length );
            }
            return true;
        }

        private function ConnectTimeout():void
        {
//            
            this.Disconnect();
        }

        private function GetGateState( e:DataBlock = null ):void
        {
            if ( e!=null )
            {
                var ret:int = e.Data.readShort();

                if ( ret!=0 )
                {
                    return;
                }
            }
            
            _GateState = -1;
            State = STATE_CONNECTED;
            
            var ba:ByteArray = new ByteArray();
            ba.endian = Endian.LITTLE_ENDIAN;
            if(_Preask)
            {
                _inProcessPreask = true;
                // SOCKS4a //////////////////////////////////////
                // http://zh.wikipedia.org/wiki/SOCKS#SOCKS4a
                // +——+——+——+——+——+——+——+——+——+——+....+——+——+——+....+——+
                // | VN | CD | DSTPORT | DSTIP 0.0.0.x     | USERID       |NULL| HOSTNAME     |NULL|
                // +——+——+——+——+——+——+——+——+——+——+....+——+——+——+....+——+
                //   1    1      2              4           variable       1    variable       1
                ba.writeByte(4); //VN是SOCK版本，应该是4
                ba.writeByte(1); //CD是SOCK的命令码，1表示CONNECT请求，2表示BIND请求
                ba.writeShort(_TryPort); //DSTPORT表示目的主机的端口
                
                // DSTIP指目的主机的IP地址
                // 使用4a协议的服务器必须检查请求包里的DSTIP字段，如果表示地址0.0.0.x，x是非零结尾，
                // 那么服务器就得读取客户端所发包中的域名字段，然后服务器就得解析这个域名，可以的话，对目的主机进行连接。
                // 写入0.0.0.127
                ba.writeByte(0);
                ba.writeByte(0);
                ba.writeByte(0);
                ba.writeByte(127);
                
                ba.writeByte(0); //结束符NULL
                ba.writeUTFBytes(_Host);
                ba.writeByte(0);
                _Socket.writeBytes( ba );
            }
            
            Logger( "[Tick]CONNECT_TYPE_PC_VERSION", INFO );
            _Socket.writeInt( 0x1 );
            _Socket.flush();
            ba.clear();
            _ConnectTimeoutID = setTimeout( ConnectTimeout, 20000 );
            this.dispatchEvent( new DataBlock( SOCKET_CONNECT ));
        }

        private function GetPacketInfo( packetId:int ):String
        {
            return "Packet ID: "+packetId + ", Packet Name:" + _PacketInfoMap[packetId];
        }

        private function ProcessBuff():void
        {
            if ( _IsProcess )
            {
                return;
            }
            _IsProcess = true;
            
            if ( _BuffList.length>0 )
            {
                var buff:ByteArray = _BuffList.splice( 0, 1 )[0];
                var infos:Dictionary = new Dictionary();

                if(_inProcessPreask)
                {
                    _inProcessPreask = false;
                    _IsProcess = false;
                    // +——+——+——+——+——+——+——+——+
                    // | VN | CD | DSTPORT |      DSTIP        |
                    // +——+——+——+——+——+——+——+——+
                    //   1    1      2              4
                    // VN是回应码的版本，应该是0
                    var vn:int = buff.readByte() // 0;
                    // CD是代理服务器答复，有几种可能
                    var cd:int = buff.readByte();
                    switch(cd)
                    {
                        case 90: // 请求得到允许；
                        {
                            break;
                        }
                        case 91: // 请求被拒绝或失败；
                        case 92: // 由于SOCKS服务器无法连接到客户端的identd（一个验证身份的进程），请求被拒绝；
                        case 93: // 由于客户端程序与identd报告的用户身份不同，连接被拒绝。
                        {
                            Socket_OnIOError();
                            return;
                        }
                    }
                    var DSTPORT:int = buff.readShort();
                    var DSTIP:String = buff.readUnsignedByte() + "." + 
                                       buff.readUnsignedByte() + "." +
                                       buff.readUnsignedByte() + "." +
                                       buff.readUnsignedByte();
                    Logger("[PREASK CONNECT SUCCESS]", DEBUG);
                    Logger("[DSTIP:" + DSTIP +", DSTPORT:"+DSTPORT+"]", DEBUG);
                    return;
                }
                
                while ( true )
                {
                    var rollbackPos:int = 0; //buff.position;
                    var len:int = 0;

                    if ( GateState<0 )
                    {
                        switch ( GateState )
                        {
                            case -2: //未通过验证
                                if ( !CheckBuff( buff, 12 ))
                                {
                                    return;
                                }
                                break;
                            case -1: //已通过验证
                            default:
                                if ( !CheckBuff( buff, 8 ))
                                {
                                    return;
                                }
                                break;
                        }
                        len=buff.readInt() - 8;
                        _PacketID=buff.readUnsignedInt();
                        rollbackPos = 8;
                    }
                    else
                    {
                        if ( !CheckBuff( buff, PACKET_HEADER_SIZE ))
                        {
                            return;
                        }
                        len=buff.readInt() - PACKET_HEADER_SIZE;
                        rollbackPos = PACKET_HEADER_SIZE;
                    }

                    if ( !CheckBuff( buff, len, rollbackPos ))
                    {
                        return;
                    }
                    var data:DataBlock = Socket_ReceivePacketData( buff, len );

                    if ( data!=null )
                    {
                        Logger( "[Process]"+GetPacketInfo( data.Ident )+", PacketLen: "+len, PACKET_BUFF )
                        switch ( GateState )
                        {
                            case -1: //已通过验证
                                Socket_OnGateState( data );
                                break;
                            case -2: //未通过验证
                                GetGateState( data );
                                break;
                            default:
                                ProcessDataFunc( data );
                                break;
                        }
                    }
                }
            }
            _IsProcess = false;

            if ( _BuffList.length>0 )
            {
                clearTimeout( _ProcessTimeID );
                _ProcessTimeID = setTimeout( ProcessBuffDelay, 100 );
            }
        }

        private function ProcessBuffDelay():void
        {
            clearTimeout( _ProcessTimeID );
            _ProcessTimeID = 0;
            ProcessBuff();
        }

        private function Retry():Boolean
        {
            var cnt:int = _Ports.length*2;
            Logger( "connect retry ["+_RetryCount+"/"+cnt+"]", ERROR );

            if ( _RetryCount < cnt )
            {
                _RetryCount++
                NextServerPort();
                Logger( "connect retry...", ERROR );
                this.dispatchEvent( new DataBlock( SOCKET_RETRY ));
                setTimeout( Connect, 100 );
                return true;
            }
            return false;
        }

        private function SendSave( packet:DataBlock, aes:CBCMode, hash:Boolean = true ):void
        {
            var buff:ByteArray = new ByteArray();
            buff.endian = Endian.LITTLE_ENDIAN;
            buff.writeUnsignedInt( packet.Ident );

            if ( packet.Data.length != 0 )
            {
                buff.writeBytes( packet.Data );
            }
            var crypto:ByteArray = new ByteArray();
            crypto.endian = Endian.LITTLE_ENDIAN;

            if ( hash )
            {
                var md5:ByteArray = new MD5().hash( buff );
                md5.endian = Endian.LITTLE_ENDIAN;
                md5.position = 0;
                crypto.writeInt( _Time++ );
                crypto.writeBytes( md5 );
            }
            crypto.writeBytes( buff );

            var iv:uint = uint( crypto.length/16 )+1;
            var hex:String = iv.toString( 16 );
            var ivStr:String = "";

            for ( var k:int=0; k<hex.length; k++ )
            {
                ivStr += "0" + hex;
            }
            ivStr = StringUtils.FillString( ivStr, 128, "0" );
            aes.IV = Hex.toArray( ivStr );
            aes.encrypt( crypto );
            _Socket.writeUnsignedInt( crypto.length+4 );
            _Socket.writeBytes( crypto );
        }

        /**
         * Socket连接关闭事件
         */
        private function Socket_OnClose( e:Event ):void
        {
            clearInterval( _PingID );
            clearTimeout( _ProcessTimeID );
            clearTimeout( _ConnectTimeoutID );
            Logger( "Socket Disconnected.", INFO );

            State=STATE_DISCONNECTED;

            _Socket.removeEventListener( Event.CONNECT, Socket_OnConnect );
            _Socket.removeEventListener( Event.CLOSE, Socket_OnClose );
            _Socket.removeEventListener( IOErrorEvent.IO_ERROR, Socket_OnIOError );
            _Socket.removeEventListener( SecurityErrorEvent.SECURITY_ERROR, Socket_OnSecurityError );
            _Socket.removeEventListener( ProgressEvent.SOCKET_DATA, Socket_OnReceivedData );

            Code = 0;
            _PingTick = -1;
            _IsProcess = false;
            _SendCbc = null;
            _RecvCbc = null;
            _GateState = -2;
            _BuffList = [];
            
            if (!GateIsReady && AutoRetry )
            {
                Retry();
            }
            else
            {
                this.dispatchEvent( new DataBlock( SOCKET_DISCONNECT ));
            }
        }

        /**
         * Socket连接事件
         */
        private function Socket_OnConnect( CurrentEvent:Event ):void
        {
            Logger( "Socket Connected.", INFO );

            State=STATE_CONNECTED;
            Code = 1;

            if ( _ProxyKey )
            {
                Code = 1001;
                var tick:String = _ProxyKey;
                var buff:ByteArray = new ByteArray();
                buff.endian = Endian.LITTLE_ENDIAN;
                buff.writeUTFBytes( tick );
                var aes:CBCMode = new CBCMode( new AESKey( buff ));
                
                var packet:DataBlock = new DataBlock( 6 );
                packet.Data.writeUTF( ServerHost+":"+ServerPort );
                _Socket.writeShort( 1 );
                SendSave( packet, aes, false );
                
                _Socket.flush();
            }
            else
            {
                GetGateState();
            }
        }

        private function Socket_OnGateState( e:DataBlock ):void
        {
            clearTimeout( _ConnectTimeoutID );
            Code = 2;

            try
            {
                e.Data.position = 0;
                _GateState = e.Data.readByte();

                var digits:Array = e.Data.readInt64ToBit();

                var uuid:String = _SendKey;
                var tick:String = "";

                for ( var i:int=0; i<digits.length; i++ )
                {
                    if ( digits[i]==1 )
                    {
                        tick += uuid.charAt( i );
                    }
                }
                ServerTick = tick;

                Logger( "Gate State:"+_GateState, INFO );

                if ( _GateState!=0 )
                {
                    Logger( "Gate not ready.", INFO );

                    if ( Retry())
                    {
                        return;
                    }
                }
                Logger( "Gate is ready.", INFO );
                GateIsReady = true;
                Ping();
            }
            catch ( e:Error )
            {
                Logger( e.message, ERROR );
                Code = 3;
            }
        }

        /**
         * Socket连接出错事件
         */
        private function Socket_OnIOError( evt:IOErrorEvent = null ):void
        {
            if(evt)
            {
                Logger( "Socket IO Error: " + evt.text, ERROR );
            }
            State=STATE_FAILED;
            
            if ( Retry())
            {
                return;
            }
            
            this.dispatchEvent( new DataBlock( SOCKET_ERROR, new MyByteArray() ));
        }

        /**
         * 接收到心跳包响应
         */
        private function Socket_OnKeepAliveAck( packet:DataBlock ):void
        {
            if ( _PingTick==-1 )
            {
                Code = 0;
                this.dispatchEvent( new Event( "OnGateState" ));
            }
            _PingTick = _LastReceive - _LastPing;
            Logger( "[Ping:"+_PingTick+"]Send:"+_LastPing+",LaseReceive:"+_LastReceive+",Curr:"+getTimer(), INFO );
        }

        /**
         * Socket接收数据事件
         */
        private function Socket_OnReceivedData( e:ProgressEvent ):void
        {
            _LastReceive = getTimer();

            var bytes:ByteArray = new ByteArray();
            bytes.endian = Endian.LITTLE_ENDIAN;
            _Socket.readBytes( bytes );
            Logger( "[Recevie]Buff Len:"+bytes.length, PACKET_RECV );

            bytes.position = 0;
            _BuffList.push( bytes );

            if ( !_IsProcess && _ProcessTimeID==0 )
            {
                _ProcessTimeID = setTimeout( ProcessBuffDelay, 50 );
            }
        }

        /**
         * Socket连接安全出错事件
         */
        private function Socket_OnSecurityError( e:SecurityErrorEvent ):void
        {
            Logger( "Socket Security Error."+e.text, ERROR );

            if ( State != STATE_DISCONNECTED )
            {
                State=STATE_FAILED;

                if ( Retry())
                {
                    return;
                }

                var dat:MyByteArray = new MyByteArray();
                this.dispatchEvent( new DataBlock( SOCKET_ERROR, dat ));
            }
        }

        /**
         * 读取包数据内容
         */
        private function Socket_ReceivePacketData( buff:ByteArray, len:int ):DataBlock
        {
            if ( buff.bytesAvailable >= len )
            {

                var data:MyByteArray;

                if ( len != 0 )
                {
                    data=new MyByteArray();
                    data.endian=Endian.LITTLE_ENDIAN;

                    if ( !Encrypt||!Ready )
                    {
                        buff.readBytes( data, 0, len );
                    }
                    else
                    {
                        var crypto:MyByteArray=new MyByteArray();
                        crypto.endian=Endian.LITTLE_ENDIAN;

                        buff.readBytes( crypto, 0, len );

                        var iv:uint = uint(( len-PACKET_HEADER_SIZE )/16 )+1;
                        var hex:String = iv.toString( 16 );
                        var ivStr:String = "";

                        for ( var k:int=0; k<hex.length; k++ )
                        {
                            ivStr += "0" + hex;
                        }
                        ivStr = StringUtils.FillString( ivStr, 128, "0" );
                        _RecvCbc.IV = Hex.toArray( ivStr );

                        _RecvCbc.decrypt( crypto );
                        crypto.position = 0;

                        _PacketID=crypto.readUnsignedInt();


                        crypto.readBytes( data );

                        crypto = null;
                    }
                }

                if ( State!=STATE_CONNECTED )
                {
                    return null;
                }

                return new DataBlock( _PacketID, data );

            }
            Logger( "Data Length Not Enough: ID["+_PacketID+"],Length:["+len+"],Available["+buff.bytesAvailable+"]", ERROR );
            return null;
        }

        private function UnshiftBuff( buff:ByteArray, rollbackPos:int ):void
        {
            if ( buff!=null )
            {
                var leftBuff:ByteArray = new ByteArray();
                leftBuff.endian = Endian.LITTLE_ENDIAN;
                buff.position -= rollbackPos;
                buff.readBytes( leftBuff );
                _BuffList.unshift( leftBuff );
            }
            _IsProcess = false;
        }
    }
}
