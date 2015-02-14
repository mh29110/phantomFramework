package plugin.net.parsers.max3ds 
{
	import flash.utils.ByteArray;
	import io.plugin.core.graphics.Color;
	import io.plugin.math.algebra.APoint;
	import io.plugin.math.algebra.AVector;
	import plugin.net.parsers.max3ds.types.Camera3DS;
	import plugin.net.parsers.max3ds.types.Color3DS;
	import plugin.net.parsers.max3ds.types.Face3DS;
	import plugin.net.parsers.max3ds.types.Light3DS;
	import plugin.net.parsers.max3ds.types.Material3DS;
	import plugin.net.parsers.max3ds.types.Mesh3DS;
	import plugin.net.parsers.max3ds.types.Scene3DS;
	import plugin.net.parsers.max3ds.types.TexCoords3DS;
	import plugin.net.parsers.max3ds.types.Vertex3DS;
	import zest3d.resources.enum.AttributeType;
	import zest3d.resources.enum.AttributeUsageType;
	import zest3d.resources.enum.BufferUsageType;
	import zest3d.resources.IndexBuffer;
	import zest3d.resources.Texture2D;
	import zest3d.resources.VertexBuffer;
	import zest3d.resources.VertexBufferAccessor;
	import zest3d.resources.VertexFormat;
	import zest3d.scenegraph.Camera;
	import zest3d.scenegraph.enum.UpdateType;
	import zest3d.scenegraph.Light;
	import zest3d.scenegraph.Material;
	import zest3d.scenegraph.TriMesh;
	
	/**
	 * ...
	 * @author Gary Paluk
	 */
	public class ParserAdapter3DS 
	{
		private var _parser: ParserMax3DS;
		
		//TODO get elements by name
		
		// private var _scene: Node;
		
		private var _textureList: Vector.<Texture2D>;
		private var _materialList: Vector.<Material>;
		
		private var _meshList: Vector.<TriMesh>;
		private var _cameraList: Vector.<Camera>;
		private var _lightList: Vector.<Light>;
		
		private var _useMaterials: Boolean = true;
		
		private var _useTexCoords:Boolean;
		private var _useNormals:Boolean;
		private var _useBinormals:Boolean;
		private var _useTangents:Boolean;
		
		public function ParserAdapter3DS( data: ByteArray, useTexCoords:Boolean = true, useNormals:Boolean = false, useBinormals:Boolean = false, useTangents:Boolean = false )
		{
			_useTexCoords = useTexCoords;
			_useNormals = useNormals;
			_useBinormals = useBinormals;
			_useTangents = useTangents;
			_parser = new ParserMax3DS( data );
		}
		
		public function parse(): void
		{
			_parser.parse();
			
			parseCameras();
			parseLights();
			parseMaterials();
			parseMeshes();
		}
		
		public function getTextureAt( index: int ): Texture2D
		{
			if ( 0 <= index && index < _textureList.length )
			{
				return _textureList[ index ];
			}
			else
			{
				throw new RangeError( "Out of range" );
			}
		}
		
		[Inline]
		public final function get textures(): Vector.<Texture2D>
		{
			return _textureList;
		}
		
		public function getCameraAt( index: int ): Camera
		{
			if ( 0 <= index && index < _cameraList.length )
			{
				return _cameraList[ index ];
			}
			else
			{
				throw new RangeError( "Out of range" );
			}
		}
		
		[Inline]
		public final function get cameras(): Vector.<Camera>
		{
			return _cameraList;
		}
		
		public function getMaterialAt( index: int ): Material
		{
			if ( 0 <= index && index < _materialList.length )
			{
				return _materialList[ index ];
			}
			else
			{
				throw new RangeError( "Out of range" );
			}
		}
		
		[Inline]
		public final function get materials(): Vector.<Material>
		{
			return _materialList;
		}
		
		public function getLightAt( index: int ): Light
		{
			if ( 0 <= index && index < _lightList.length )
			{
				return _lightList[ index ];
			}
			else
			{
				throw new RangeError( "Out of range" );
			}
		}
		
		[Inline]
		public final function get lights(): Vector.<Light>
		{
			return _lightList;
		}
		
		public function getMeshAt( index: int ): TriMesh
		{
			if ( 0 <= index && index < _meshList.length )
			{
				return _meshList[ index ];
			}
			else
			{
				throw new RangeError( "Out of range" );
			}
		}
		
		[Inline]
		public final function get meshes(): Vector.<TriMesh>
		{
			return _meshList;
		}
		
		
		private function parseMeshes(): void
		{
			_meshList = new Vector.<TriMesh>();
			
			var scene3DS: Scene3DS = _parser.scene;
			
			for ( var i: int = 0; i < scene3DS.numMeshes; ++i )
			{
				var mesh3DS: Mesh3DS = scene3DS.getMeshAt( i );
				
				// TODO add materials
				
				
				var numAttributes: int = 0;
				var offset: int = 0;
				var attributeIndex: int = 0;
				
				var hasPosition: Boolean = mesh3DS.vertices.length > 0 ? true : false;
				var hasTexCoords: Boolean  = mesh3DS.texCoords.length > 0 ? true : false;
				
				hasPosition == true ? numAttributes++ : null;
				hasTexCoords == true ? numAttributes++ : null;
				
				_useBinormals == true ? numAttributes++ : null;
				_useTangents == true ? numAttributes++ : null;
				
				var vFormat: VertexFormat = new VertexFormat( numAttributes + 1 );
				if ( hasPosition > 0 )
				{
					vFormat.setAttribute( attributeIndex++, 0, offset, AttributeUsageType.POSITION, AttributeType.FLOAT3, 0 );
					offset += 12;
				}
				
				if ( _useTexCoords && !hasTexCoords )
				{
					throw new Error( "Texture coordinates are not available." );
				}
				
				if ( hasTexCoords > 0 && _useTexCoords )
				{
					vFormat.setAttribute( attributeIndex++, 0, offset, AttributeUsageType.TEXCOORD, AttributeType.FLOAT2, 0);
					offset += 8;
				}
				
				if ( _useNormals )
				{
					vFormat.setAttribute( attributeIndex++, 0, offset, AttributeUsageType.NORMAL, AttributeType.FLOAT3, 0);
					offset += 12;
				}
				
				if ( _useBinormals )
				{
					vFormat.setAttribute( attributeIndex++, 0, offset, AttributeUsageType.BINORMAL, AttributeType.FLOAT3, 0);
					offset += 12;
				}
				
				if ( _useTangents )
				{
					vFormat.setAttribute( attributeIndex++, 0, offset, AttributeUsageType.TANGENT, AttributeType.FLOAT3, 0);
					offset += 12;
				}
				
				/*
				var mat: Material3DS;
				var fmat: FaceMaterial3DS;
				for ( var j: int = 0; j < mesh.faceMaterials; ++j )
				{
					
					fmat = mesh.faceMaterials[ j ];
					
					try
					{
						faceMat3ds = _materialList( fmat.matIndex );
					} catch ( e: Error )
					{
						faceMat3ds = null;
					}
					
					if ( _useMaterials )
					{
						if ( mat != null )
						{
							var mat: Material = new Material
						}
					}
					
				}
				*/
				
				vFormat.stride = offset;
				
				var vBuffer: VertexBuffer = new VertexBuffer( mesh3DS.numVertices, vFormat.stride, BufferUsageType.STATIC );
				
				var iBuffer: IndexBuffer = new IndexBuffer( mesh3DS.numIndices, 2, BufferUsageType.STATIC );
				
				var vba: VertexBufferAccessor = new VertexBufferAccessor( vFormat, vBuffer );
				
				for ( var vIndex: int = 0; vIndex < mesh3DS.numVertices; ++vIndex )
				{
					if ( hasPosition )
					{
						var vertex3DS: Vertex3DS = mesh3DS.vertices[ vIndex ];
						vba.setPositionAt( vIndex,  [ vertex3DS.x, vertex3DS.y, vertex3DS.z ] );
					}
					if ( hasTexCoords )
					{
						var tCoord: TexCoords3DS = mesh3DS.texCoords[ vIndex ];
						vba.setTCoordAt( 0, vIndex, [ tCoord.u, 1 - tCoord.v ] );
					}
				}
				
				var iPointer: int = 0;
				for ( var iIndex: int = 0; iIndex < mesh3DS.numFaces; ++iIndex )
				{
					var face: Face3DS = mesh3DS.faces[ iIndex ];
					iBuffer.setIndexAt( iPointer++, face.p0 );
					iBuffer.setIndexAt( iPointer++, face.p1 );
					iBuffer.setIndexAt( iPointer++, face.p2 );
				}
				
				var mesh: TriMesh = new TriMesh( vFormat, vBuffer, iBuffer );
				if ( _useNormals )
				{
					mesh.updateModelSpace( UpdateType.NORMALS );
				}
				
				if ( (_useBinormals || _useTangents) && _useTexCoords )
				{
					mesh.updateModelSpace( UpdateType.USE_TCOORD_CHANNEL );
				}
				else if ( _useBinormals || _useTangents )
				{
					mesh.updateModelSpace( UpdateType.USE_GEOMETRY );
				}
				
				_meshList.push( mesh );
			}
		}
		
		private function parseCameras(): void
		{
			
			_cameraList = new Vector.<Camera>();
			
			var scene3ds: Scene3DS = _parser.scene;
			for ( var i: int = 0; i < scene3ds.numCameras; ++i )
			{
				
				var camera3ds: Camera3DS = scene3ds.getCameraAt( i );
				
				var cam: Camera = new Camera();
				//TODO set camera name
				
				cam.position = new APoint( camera3ds.position.x,
										   camera3ds.position.y,
										   camera3ds.position.z );
				
				var dVector: AVector = new AVector( camera3ds.target.x,
													camera3ds.target.y,
													camera3ds.target.z );
				
				var uVector: AVector = AVector.UNIT_Y;
				var rVector: AVector = dVector.crossProduct( uVector );
				
				cam.setAxes( dVector, uVector, rVector);
				
				// TODO roll the camera
				// TODO create lookAt
				
				_cameraList.push( cam );
			}
		}
		
		private function parseLights(): void
		{
			
			_lightList = new Vector.<Light>();
			
			var scene3ds: Scene3DS = _parser.scene;
			for ( var i: int = 0; i < scene3ds.numLights; ++i )
			{
				var light3ds: Light3DS = scene3ds.getLightAt( i );
				
				var light: Light = new Light();
				// TODO add light name
				
				light.position = new APoint( light3ds.position.x,
											 light3ds.position.y,
											 light3ds.position.z );
				// TODO create lookAt
				light.direction = new AVector( light3ds.target.x,
											   light3ds.target.y,
											   light3ds.target.z );
				
				light.diffuse = new Color( light3ds.color.red,
										   light3ds.color.green,
										   light3ds.color.blue );
				
				_lightList.push( light );
			}
		}
		
		private function parseMaterials(): void
		{
			_materialList = new Vector.<Material>();
			//_textureList = new Vector.<Texture2D>();
			
			var scene3ds: Scene3DS = _parser.scene;
			
			// materials
			var matPrev: Material;
			for ( var i: int = 0; i < scene3ds.numMaterials; ++i )
			{
				var mat3ds: Material3DS = scene3ds.getMaterialAt( i );
				var ambient: Color3DS = mat3ds.ambient;
				var diffuse: Color3DS = mat3ds.diffuse;
				var specular: Color3DS = mat3ds.specular;
				
				var mat: Material = new Material();
				mat.ambient = new Color( ambient.red, ambient.green, ambient.blue, 1 );
				mat.diffuse = new Color( diffuse.red, diffuse.green, diffuse.blue, mat3ds.transparency );
				mat.specular = new Color( specular.red, specular.green, specular.blue, 1 );
				
				// TODO set texture material name
				
				if ( mat3ds.mapName.length > 0 )
				{
					// TODO load the texture
				}
				
				matPrev = mat;
				_materialList.push( mat );
			}
			
		}
		
		
	}

}