// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "DissolveWorldPos"
{
	Properties
	{
		_MainTex("MainTex", 2D) = "white" {}
		_GoblinPo("GoblinPo", Vector) = (0.001,0.001,0,0)
		_StartPosition("StartPosition", Vector) = (0,0,0,0)
		_Radius("Radius", Float) = 1
		_SmoothEdge("SmoothEdge", Float) = 0
		_Texture0("Texture 0", 2D) = "white" {}
		_SmootedgeB("SmootedgeB", Float) = -2.59
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
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
			float2 uv_texcoord;
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
		};

		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform float _SmoothEdge;
		uniform float _SmootedgeB;
		uniform float _Radius;
		uniform float3 _StartPosition;
		uniform sampler2D _Texture0;
		uniform float2 _GoblinPo;


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
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float4 tex2DNode9 = tex2D( _MainTex, uv_MainTex );
			float4 temp_cast_0 = (_SmoothEdge).xxxx;
			float4 temp_cast_1 = (_SmootedgeB).xxxx;
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float3 objToWorld41 = mul( unity_ObjectToWorld, float4( ase_vertex3Pos, 1 ) ).xyz;
			float clampResult48 = clamp( ( ( _Radius - 0.0 ) - distance( _StartPosition , objToWorld41 ) ) , 0.0 , 1.0 );
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float4 triplanar4 = TriplanarSamplingSF( _Texture0, ase_worldPos, ase_worldNormal, 1.0, _GoblinPo, 1.0, 0 );
			float4 temp_output_52_0 = ( 1.0 - ( (-0.06 + (( 1.0 - clampResult48 ) - 0.0) * (1.0 - -0.06) / (1.0 - 0.0)) + triplanar4 ) );
			float4 smoothstepResult59 = smoothstep( temp_cast_0 , temp_cast_1 , temp_output_52_0);
			float4 temp_cast_2 = (( _SmoothEdge * 1.36 )).xxxx;
			float4 temp_cast_3 = (_SmootedgeB).xxxx;
			float4 smoothstepResult68 = smoothstep( temp_cast_2 , temp_cast_3 , temp_output_52_0);
			float4 temp_output_76_0 = ( 1.0 - ( smoothstepResult59 * ( 1.0 - smoothstepResult68 ) ) );
			o.Emission = ( tex2DNode9 * ( temp_output_76_0 * temp_output_76_0 * temp_output_76_0 * temp_output_76_0 ) ).rgb;
			o.Alpha = ( tex2DNode9.a * saturate( smoothstepResult68 ) ).x;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard alpha:fade keepalpha fullforwardshadows 

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
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float4 tSpace0 : TEXCOORD2;
				float4 tSpace1 : TEXCOORD3;
				float4 tSpace2 : TEXCOORD4;
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
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
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
				surfIN.uv_texcoord = IN.customPack1.xy;
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
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17000
0;498;1366;561;-2788.851;1740.505;2.077149;True;False
Node;AmplifyShaderEditor.PosVertexDataNode;40;1114.863,-1601.298;Float;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;46;1686.114,-1772.595;Float;False;Constant;_Float7;Float 7;4;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;43;1469.229,-1769.313;Float;False;Property;_StartPosition;StartPosition;2;0;Create;True;0;0;False;0;0,0,0;-31.64,-30,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TransformPositionNode;41;1383.466,-1610.669;Float;False;Object;World;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;45;1676.114,-1857.487;Float;False;Property;_Radius;Radius;3;0;Create;True;0;0;False;0;1;5.44;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;42;1695.092,-1630.309;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;47;1832.818,-1797.911;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;44;1992.983,-1700.53;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;48;2235.8,-1671.442;Float;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;49;2612.713,-1608.817;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;7;2369.273,-1121.984;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector2Node;8;2443.272,-986.9836;Float;False;Property;_GoblinPo;GoblinPo;1;0;Create;True;0;0;False;0;0.001,0.001;0.15,0.15;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TexturePropertyNode;61;2423.511,-1330.674;Float;True;Property;_Texture0;Texture 0;5;0;Create;True;0;0;False;0;None;cd460ee4ac5c1e746b7a734cc7cc64dd;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.TFHCRemapNode;50;2895.417,-1499.506;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-0.06;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TriplanarNode;4;2690.772,-1166.984;Float;True;Spherical;World;False;Top Texture 0;_TopTexture0;white;0;None;Mid Texture 0;_MidTexture0;white;-1;None;Bot Texture 0;_BotTexture0;white;-1;None;Triplanar Sampler;False;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT2;1,1;False;4;FLOAT;1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;51;3166.366,-1287.807;Float;False;2;2;0;FLOAT;0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;56;3328.717,-988.5457;Float;False;Property;_SmoothEdge;SmoothEdge;4;0;Create;True;0;0;False;0;0;0.22;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;70;3403.281,-1372.242;Float;False;Constant;_Float0;Float 0;7;0;Create;True;0;0;False;0;1.36;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;52;3361.965,-1284.754;Float;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;69;3499.492,-1476.82;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;60;3367.887,-903.6923;Float;False;Property;_SmootedgeB;SmootedgeB;6;0;Create;True;0;0;False;0;-2.59;-0.09;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;68;3745.374,-1010.801;Float;True;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT4;1,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.OneMinusNode;73;3966.915,-1427.213;Float;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SmoothstepOpNode;59;3778.771,-1270.185;Float;True;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT4;1,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;66;4104.789,-1437.516;Float;True;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.OneMinusNode;76;4345.523,-1423.294;Float;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SamplerNode;9;4443.453,-1697.06;Float;True;Property;_MainTex;MainTex;0;0;Create;True;0;0;False;0;None;368e7c0ec3559db49828b483eb113c1e;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;83;4517.731,-1444.609;Float;True;4;4;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT4;0,0,0,0;False;3;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SaturateNode;65;4561.254,-1144.139;Float;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;77;4790.621,-1457.094;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;84;4915.852,-1005.194;Float;False;2;2;0;FLOAT;0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;5062.143,-1378.117;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;DissolveWorldPos;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;41;0;40;0
WireConnection;42;0;43;0
WireConnection;42;1;41;0
WireConnection;47;0;45;0
WireConnection;47;1;46;0
WireConnection;44;0;47;0
WireConnection;44;1;42;0
WireConnection;48;0;44;0
WireConnection;49;0;48;0
WireConnection;50;0;49;0
WireConnection;4;0;61;0
WireConnection;4;9;7;0
WireConnection;4;3;8;0
WireConnection;51;0;50;0
WireConnection;51;1;4;0
WireConnection;52;0;51;0
WireConnection;69;0;56;0
WireConnection;69;1;70;0
WireConnection;68;0;52;0
WireConnection;68;1;69;0
WireConnection;68;2;60;0
WireConnection;73;0;68;0
WireConnection;59;0;52;0
WireConnection;59;1;56;0
WireConnection;59;2;60;0
WireConnection;66;0;59;0
WireConnection;66;1;73;0
WireConnection;76;0;66;0
WireConnection;83;0;76;0
WireConnection;83;1;76;0
WireConnection;83;2;76;0
WireConnection;83;3;76;0
WireConnection;65;0;68;0
WireConnection;77;0;9;0
WireConnection;77;1;83;0
WireConnection;84;0;9;4
WireConnection;84;1;65;0
WireConnection;0;2;77;0
WireConnection;0;9;84;0
ASEEND*/
//CHKSM=25C3EC7A5F2259A80F96E40F1A14AA99AD79D6B4