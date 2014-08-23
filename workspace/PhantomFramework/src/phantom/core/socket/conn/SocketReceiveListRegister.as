package phantom.core.socket.conn
{
	import flash.utils.Dictionary;
	
	import org.puremvc.as3.patterns.facade.Facade;

/**
 * 协议注册器
 */
public class SocketReceiveListRegister
{
	private static const CMD_SUFFIX:String = "CMD";
	private static var classDic:Dictionary = new Dictionary();
	private static var CommandTypeDic:Dictionary = new Dictionary();
	
	/**初始化协议触发命令*/
	public static function init(facade:Facade):void
	{
		//initProtocol(SC_RQ_Register, "SC_RQ_Register");
//		initProtocol(SC_RQ_Heartbeat, "SC_RQ_Heartbeat");
//		
//		facade.addCommand(initProtocol(SC_RP_Register, "SC_RP_Register"), SC_RP_RegisterCMD);
//		facade.addCommand(initProtocol(SC_RP_Login, "SC_RP_Login"), SC_RP_LoginCMD);
//		facade.addCommand(initProtocol(SC_GetRoleInfo, "SC_GetRoleInfo"), SC_GetRoleInfoCMD);
//		facade.addCommand(initProtocol(SC_RP_ADD_ITEM,"SC_RP_ADD_ITEM"),SC_RP_ADD_ITEMCMD);
//		facade.addCommand(initProtocol(SC_RP_BUY_ITEM,"SC_RP_BUY_ITEM"),SC_RP_BUY_ITEMCMD);
//		facade.addCommand(initProtocol(SC_RP_USE_ITEM,"SC_RP_USE_ITEM"),SC_RP_USE_ITEMCMD);
//		facade.addCommand(initProtocol(SC_RP_Hero_Hire,"SC_RP_Hero_Hire"),SC_RP_Hero_HireCMD);
		
		
	}
	/**
	 * 初始化
	 */
	private static function initProtocol(proto:Class, name:String):String
	{
		var id:uint = proto["___ID___"]();
		classDic[id] = proto;
		CommandTypeDic[id] = name + CMD_SUFFIX;
		return CommandTypeDic[id];
	}
	/**获得协议消息ID对应的class*/
	public static function getDataClassByID(id:uint):Class
	{
		return classDic[id];
	}
	/**获得协议消息ID对应的命令类型*/
	public static function getCommandTypeByID(id:uint):String
	{
		return CommandTypeDic[id];
	}
}
}