/**
 * Plugin.IO - http://www.plugin.io
 * Copyright (c) 2013
 *
 * Geometric Tools, LLC
 * Copyright (c) 1998-2012
 * 
 * Distributed under the Boost Software License, Version 1.0.
 * http://www.boost.org/LICENSE_1_0.txt
 */
package zest3d.scenegraph 
{
	import io.plugin.core.interfaces.IDisposable;
	import zest3d.resources.IndexBuffer;
	import zest3d.resources.VertexBuffer;
	import zest3d.resources.VertexFormat;
	import zest3d.scenegraph.enum.PrimitiveType;
	
	/**
	 * ...
	 * @author Gary Paluk
	 */
	public class TriFan extends Triangles implements IDisposable 
	{
		
		public function TriFan( vFormat: VertexFormat, vBuffer: VertexBuffer, iBuffer: IndexBuffer ) 
		{
			super( PrimitiveType.TRIFAN, vFormat, vBuffer, iBuffer );
		}
		
		override public function get numTriangles():int 
		{
			return _iBuffer.numElements - 2;
		}
		
		override public function getTriangleAt(index:int, data:Array):Boolean 
		{
			if ( 0 <= index && index < numTriangles )
			{
				_iBuffer.data.position = index * _iBuffer.elementSize;
				
				if ( _iBuffer.elementSize == 2 )
				{
					data[ 0 ] = _iBuffer.data.readShort();
					data[ 1 ] = _iBuffer.data.readShort();
					data[ 2 ] = _iBuffer.data.readShort();
				}
				else if( _iBuffer.elementSize == 4 )
				{
					data[ 0 ] = _iBuffer.data.readInt();
					data[ 1 ] = _iBuffer.data.readInt();
					data[ 2 ] = _iBuffer.data.readInt();
				}
				else
				{
					throw new Error( "Unsupported element size." );
				}
				
				return true;
			}
			return false;
		}
	}

}