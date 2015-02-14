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
	import flash.display3D.textures.CubeTexture;
	import io.plugin.core.interfaces.IDisposable;
	import zest3d.renderers.agal.AGALMapping;
	import zest3d.renderers.agal.AGALRenderer;
	import zest3d.renderers.interfaces.ITextureCube;
	import zest3d.renderers.Renderer;
	import zest3d.resources.enum.BufferLockingType;
	import zest3d.resources.enum.TextureFormat;
	import zest3d.resources.TextureCube;
	
	/**
	 * ...
	 * @author Gary Paluk
	 */
	public class AGALTextureCube implements ITextureCube, IDisposable 
	{
		
		private var _renderer: AGALRenderer;
		private var _texture: TextureCube;
		private var _textureFormat: TextureFormat;
		private var _context: Context3D;
		
		private var _gpuTexture: CubeTexture;
		
		public function AGALTextureCube( renderer: Renderer, texture: TextureCube ) 
		{
			_renderer = renderer as AGALRenderer;
			_context = _renderer.data.context;
			
			_texture = texture;
			_textureFormat = texture.format;
			
			var format: String = AGALMapping.textureFormat[ _textureFormat.index ];
			_gpuTexture = _context.createCubeTexture( _texture.width, format, false, 0 );
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
						_gpuTexture.uploadFromByteArray( _texture.data, 0, 1 );
						_gpuTexture.uploadFromByteArray( _texture.data, 0, 2 );
						_gpuTexture.uploadFromByteArray( _texture.data, 0, 3 );
						_gpuTexture.uploadFromByteArray( _texture.data, 0, 4 );
						_gpuTexture.uploadFromByteArray( _texture.data, 0, 5 );
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
		
		public function lock( face: int, level: int, mode: BufferLockingType ): void
		{
		}
		
		public function unlock( face: int, level: int ): void
		{
		}
		
	}

}