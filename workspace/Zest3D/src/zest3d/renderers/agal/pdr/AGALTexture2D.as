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
package zest3d.renderers.agal.pdr 
{
	import flash.display3D.Context3D;
	import flash.display3D.textures.Texture;
	import io.plugin.core.interfaces.IDisposable;
	import zest3d.renderers.agal.AGALMapping;
	import zest3d.renderers.agal.AGALRenderer;
	import zest3d.renderers.interfaces.ITexture2D;
	import zest3d.renderers.Renderer;
	import zest3d.resources.enum.BufferLockingType;
	import zest3d.resources.enum.TextureFormat;
	import zest3d.resources.Texture2D;
	
	/**
	 * ...
	 * @author Gary Paluk
	 */
	public class AGALTexture2D implements ITexture2D, IDisposable
	{
		
		private var _renderer: AGALRenderer;
		private var _texture: Texture2D;
		private var _textureFormat: TextureFormat;
		private var _context: Context3D;
		private var _gpuTexture: Texture;
		
		public function AGALTexture2D( renderer: AGALRenderer, texture: Texture2D )
		{
			_renderer = renderer;
			_context = _renderer.data.context;
			
			_texture = texture;
			_textureFormat = texture.format;
			
			var format: String = AGALMapping.textureFormat[ _textureFormat.index ];
			
			//TODO pass a param for optimize RTT
			_gpuTexture = _context.createTexture( _texture.width, _texture.height, format, false, 0 );
			
			switch( _textureFormat )
			{
				case TextureFormat.DXT1:
				case TextureFormat.DXT5:
				case TextureFormat.ETC1:
				case TextureFormat.PVRTC:
				case TextureFormat.RGBA:
						_gpuTexture.uploadCompressedTextureFromByteArray( _texture.data, 0 );
					break;
				case TextureFormat.RGBA8888:
				case TextureFormat.RGB888:
				case TextureFormat.RGB565:
				case TextureFormat.RGBA4444:
						_gpuTexture.uploadFromByteArray( _texture.data, 0, 0 );
					break;
				default:
						throw new Error( "Unknown texture format." );
					break;
			}
		}
		
		public function dispose(): void
		{
			_gpuTexture.dispose();
		}
		
		public function enable( renderer: Renderer, textureUnit: int ): void
		{
			_context.setTextureAt( textureUnit, _gpuTexture );
		}
		
		public function disable( renderer: Renderer, textureUnit: int ): void
		{
			_context.setTextureAt( textureUnit, null );
		}
		
		public function lock( level: int, mode: BufferLockingType ): void
		{
		}
		
		public function unlock( level: int ): void
		{
		}
		
		public function get texture():Texture
		{
			return _gpuTexture;
		}
		
	}

}