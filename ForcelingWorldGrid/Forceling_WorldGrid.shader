// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Forceling/World Grid"
{
	Properties
	{
		_GridScaleFactor("Grid Scale Factor", Float) = 1
		[Toggle]_Use10m("Use 10m", Float) = 1
		[Toggle]_Use100m("Use 100m", Float) = 1
		[Toggle]_Use1km("Use 1km", Float) = 1
		_1mGrid("1m Grid", 2D) = "gray" {}
		_10mGrid("10m Grid", 2D) = "white" {}
		_100mGrid("100m Grid", 2D) = "white" {}
		_1kmGrid("1km Grid", 2D) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Off
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#define ASE_TEXTURE_PARAMS(textureName) textureName

		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
		};

		uniform sampler2D _1mGrid;
		uniform float _GridScaleFactor;
		uniform float _Use10m;
		uniform sampler2D _10mGrid;
		uniform float _Use100m;
		uniform sampler2D _100mGrid;
		uniform float _Use1km;
		uniform sampler2D _1kmGrid;


		inline float4 TriplanarSamplingSF( sampler2D topTexMap, float3 worldPos, float3 worldNormal, float falloff, float2 tiling, float3 normalScale, float3 index )
		{
			float3 projNormal = ( pow( abs( worldNormal ), falloff ) );
			projNormal /= ( projNormal.x + projNormal.y + projNormal.z ) + 0.00001;
			float3 nsign = sign( worldNormal );
			half4 xNorm; half4 yNorm; half4 zNorm;
			xNorm = ( tex2D( ASE_TEXTURE_PARAMS( topTexMap ), tiling * worldPos.zy * float2( nsign.x, 1.0 ) ) );
			yNorm = ( tex2D( ASE_TEXTURE_PARAMS( topTexMap ), tiling * worldPos.xz * float2( nsign.y, 1.0 ) ) );
			zNorm = ( tex2D( ASE_TEXTURE_PARAMS( topTexMap ), tiling * worldPos.xy * float2( -nsign.z, 1.0 ) ) );
			return xNorm * projNormal.x + yNorm * projNormal.y + zNorm * projNormal.z;
		}


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			o.Normal = float3(0,0,1);
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float4 triplanar10 = TriplanarSamplingSF( _1mGrid, ase_worldPos, ase_worldNormal, 1.0, ( 0.5 / _GridScaleFactor ), 1.0, 0 );
			float4 triplanar13 = TriplanarSamplingSF( _10mGrid, ase_worldPos, ase_worldNormal, 1.0, ( 0.05 / _GridScaleFactor ), 1.0, 0 );
			float4 blendOpSrc17 = triplanar10;
			float4 blendOpDest17 = triplanar13;
			float temp_output_36_0 = distance( ase_worldPos , _WorldSpaceCameraPos );
			float4 lerpResult33 = lerp( triplanar10 , lerp(triplanar10,( saturate( (( blendOpDest17 > 0.5 ) ? ( 1.0 - 2.0 * ( 1.0 - blendOpDest17 ) * ( 1.0 - blendOpSrc17 ) ) : ( 2.0 * blendOpDest17 * blendOpSrc17 ) ) )),_Use10m) , saturate( pow( ( temp_output_36_0 / 13.0 ) , 15.0 ) ));
			float4 triplanar19 = TriplanarSamplingSF( _100mGrid, ase_worldPos, ase_worldNormal, 1.0, ( 0.005 / _GridScaleFactor ), 1.0, 0 );
			float4 blendOpSrc31 = triplanar10;
			float4 blendOpDest31 = triplanar19;
			float4 lerpResult42 = lerp( lerpResult33 , lerp(lerp(triplanar10,( saturate( (( blendOpDest17 > 0.5 ) ? ( 1.0 - 2.0 * ( 1.0 - blendOpDest17 ) * ( 1.0 - blendOpSrc17 ) ) : ( 2.0 * blendOpDest17 * blendOpSrc17 ) ) )),_Use10m),( saturate( (( blendOpDest31 > 0.5 ) ? ( 1.0 - 2.0 * ( 1.0 - blendOpDest31 ) * ( 1.0 - blendOpSrc31 ) ) : ( 2.0 * blendOpDest31 * blendOpSrc31 ) ) )),_Use100m) , saturate( pow( ( temp_output_36_0 / 80.0 ) , 10.0 ) ));
			float4 triplanar46 = TriplanarSamplingSF( _1kmGrid, ase_worldPos, ase_worldNormal, 1.0, ( 0.0005 / _GridScaleFactor ), 1.0, 0 );
			float4 blendOpSrc43 = triplanar10;
			float4 blendOpDest43 = triplanar46;
			float4 lerpResult47 = lerp( lerpResult42 , lerp(lerp(triplanar10,( saturate( (( blendOpDest17 > 0.5 ) ? ( 1.0 - 2.0 * ( 1.0 - blendOpDest17 ) * ( 1.0 - blendOpSrc17 ) ) : ( 2.0 * blendOpDest17 * blendOpSrc17 ) ) )),_Use10m),( saturate( (( blendOpDest43 > 0.5 ) ? ( 1.0 - 2.0 * ( 1.0 - blendOpDest43 ) * ( 1.0 - blendOpSrc43 ) ) : ( 2.0 * blendOpDest43 * blendOpSrc43 ) ) )),_Use1km) , saturate( pow( ( temp_output_36_0 / 800.0 ) , 10.0 ) ));
			o.Albedo = lerpResult47.xyz;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float4 tSpace0 : TEXCOORD1;
				float4 tSpace1 : TEXCOORD2;
				float4 tSpace2 : TEXCOORD3;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
}
