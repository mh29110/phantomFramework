package com.core.network
{
	import flash.utils.ByteArray;

	public final class StringUtils
	{
		
		/**
		 * 填充字符
		 * <pre>
		 * FillString( "ffcc", 6, "0", false );//00ffcc
		 * FillString( "ffcc", 6, "0", true )://ffcc00
		 * </pre>
		 * @param str 原字符串
		 * @param len 将str填充到指定的长度
		 * @param fillStr 填充的字符
		 * @param fillAfter 是否填充在原字符串的最后，否则填充在前端
		 * 
		 * @return 
		 */
		public static function FillString( str:String, len:int, fillStr:String, fillAfter:Boolean=false ):String {
			var cnt:int = len-str.length;
			for( var i:int=0; i<cnt; i++ ) {
				if( fillAfter ) {
					str += fillStr;
				} else {
					str = fillStr + str;
				}
			}
			return str;
		}
		/**
		 * 按照字节长度截取字符串
		 * 如果bytesLen为3,val为两个中文，则会截取第一个中文返回
		 * 截取的字符串长度不会超过bytesLen
		 * <pre>
		 * 	CutString( "my name is abc.", 13, true ); //"my name is";
		 * 	CutString( "my name is abc.", 13, false );//"my name is ab";
		 * </pre>
		 * @param val 字符串
		 * @param bytesLen 字节长度
		 * @param wordIntact 是否保存完整单词。<br/>
		 * 	在英文之类的拉丁字母语言中，按照空格分隔单词，如果单词超过字节长度，则整个单词不保留。<br/>
		 * @return 
		 */
		public static function CutString( val:String, bytesLen:int, wordIntact:Boolean=false ):String {
			var bytes:ByteArray = new ByteArray();
			bytes.writeMultiByte(val, "gbk");
			var cnt:int = bytes.length-bytesLen;
			if( cnt>0 ) {
				var arr:Array = val.split(" ");
				if( wordIntact && arr.length>1 ) {
					arr.pop();
					return CutString( arr.join(" "), bytesLen );
				} else {
					if( val.length==bytes.length ) {
						//全单字节的内容
						val = val.substr( 0, val.length-cnt);
					} else {
						var len:int = Math.ceil(cnt * 0.5);
						return CutString( val.substr(0, val.length-len), bytesLen );
					}
				}
			}
			return val;
		}
	}
}