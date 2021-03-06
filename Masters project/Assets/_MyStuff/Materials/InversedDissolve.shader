// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Inversed dissolve"
{
	Properties
	{
		_MainTex("MainTex", 2D) = "white" {}
		_TopTexture4("Top Texture 4", 2D) = "white" {}
		_GoblinPo("GoblinPo", Vector) = (0.15,0.15,0,0)
		_StartPosition("StartPosition", Vector) = (6.62,0,0,0)
		_TopTexture3("Top Texture 3", 2D) = "white" {}
		_Radius("Radius", Float) = 7.56
		_TopTexture2("Top Texture 2", 2D) = "white" {}
		_SmoothEdge("SmoothEdge", Float) = 0.22
		_Texture0("Texture 0", 2D) = "white" {}
		_SmootedgeB("SmootedgeB", Float) = -0.09
		_TopTexture1("Top Texture 1", 2D) = "white" {}
		_Vector11("Vector 11", Vector) = (0.2,0.2,0,0)
		_Vector9("Vector 9", Vector) = (0.2,0.2,0,0)
		_Vector8("Vector 8", Vector) = (0.2,0.2,0,0)
		_Vector10("Vector 10", Vector) = (0.2,0.2,0,0)
		_TexInfluence("TexInfluence", Float) = 1
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
		uniform sampler2D _TopTexture4;
		uniform float2 _Vector8;
		uniform sampler2D _TopTexture1;
		uniform float2 _Vector10;
		uniform sampler2D _TopTexture2;
		uniform float2 _Vector9;
		uniform float _TexInfluence;
		uniform sampler2D _TopTexture3;
		uniform float2 _Vector11;


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
			float4 tex2DNode38 = tex2D( _MainTex, uv_MainTex );
			float4 temp_cast_0 = (_SmoothEdge).xxxx;
			float4 temp_cast_1 = (_SmootedgeB).xxxx;
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float3 objToWorld5 = mul( unity_ObjectToWorld, float4( ase_vertex3Pos, 1 ) ).xyz;
			float clampResult9 = clamp( ( ( _Radius - 0.0 ) - distance( _StartPosition , objToWorld5 ) ) , 0.0 , 1.0 );
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float4 triplanar15 = TriplanarSamplingSF( _Texture0, ase_worldPos, ase_worldNormal, 1.0, _GoblinPo, 1.0, 0 );
			float4 temp_output_21_0 = ( 1.0 - ( (-0.06 + (( 1.0 - clampResult9 ) - 0.0) * (1.0 - -0.06) / (1.0 - 0.0)) + triplanar15 ) );
			float4 smoothstepResult23 = smoothstep( temp_cast_0 , temp_cast_1 , temp_output_21_0);
			float4 temp_cast_2 = (( _SmoothEdge * 1.36 )).xxxx;
			float4 temp_cast_3 = (_SmootedgeB).xxxx;
			float4 smoothstepResult22 = smoothstep( temp_cast_2 , temp_cast_3 , temp_output_21_0);
			float4 temp_output_34_0 = ( 1.0 - ( smoothstepResult23 * ( 1.0 - smoothstepResult22 ) ) );
			float4 triplanar30 = TriplanarSamplingSF( _TopTexture4, ase_worldPos, ase_worldNormal, 1.0, _Vector8, 1.0, 0 );
			float4 triplanar33 = TriplanarSamplingSF( _TopTexture1, ase_worldPos, ase_worldNormal, 1.0, _Vector10, 1.0, 0 );
			float4 triplanar31 = TriplanarSamplingSF( _TopTexture2, ase_worldPos, ase_worldNormal, 1.0, _Vector9, 1.0, 0 );
			float4 triplanar35 = TriplanarSamplingSF( _TopTexture3, ase_worldPos, ase_worldNormal, 1.0, _Vector11, 1.0, 0 );
			float4 myVarName40 = ( triplanar30.x * triplanar33 * triplanar31 * _TexInfluence * triplanar35 );
			o.Emission = ( ( tex2DNode38 * ( temp_output_34_0 * temp_output_34_0 * temp_output_34_0 * temp_output_34_0 ) ) + myVarName40 ).rgb;
			o.Alpha = ( tex2DNode38.a * ( 1.0 - saturate( smoothstepResult22 ) ) ).x;
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
171;22;1274;635;2349.982;-69.09686;1.845338;True;False
Node;AmplifyShaderEditor.PosVertexDataNode;1;-4341.861,124.3059;Float;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;2;-3780.611,-131.8832;Float;False;Property;_Radius;Radius;5;0;Create;True;0;0;False;0;7.56;7.56;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-3770.611,-46.99114;Float;False;Constant;_Float7;Float 7;4;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TransformPositionNode;5;-4073.259,114.9349;Float;False;Object;World;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector3Node;3;-4167.917,-156.7442;Float;False;Property;_StartPosition;StartPosition;3;0;Create;True;0;0;False;0;6.62,0,0;6.62,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DistanceOpNode;6;-3761.633,95.29487;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;7;-3623.907,-72.30718;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;8;-3463.742,25.0738;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;9;-3220.925,54.16181;Float;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;13;-3013.453,738.6203;Float;False;Property;_GoblinPo;GoblinPo;2;0;Create;True;0;0;False;0;0.15,0.15;0.15,0.15;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TexturePropertyNode;12;-3033.214,394.9299;Float;True;Property;_Texture0;Texture 0;8;0;Create;True;0;0;False;0;cd460ee4ac5c1e746b7a734cc7cc64dd;cd460ee4ac5c1e746b7a734cc7cc64dd;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.WorldPosInputsNode;10;-3087.452,603.6199;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.OneMinusNode;11;-2844.012,116.7868;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TriplanarNode;15;-2765.953,558.6199;Float;True;Spherical;World;False;Top Texture 0;_TopTexture0;white;0;None;Mid Texture 0;_MidTexture0;white;-1;None;Bot Texture 0;_BotTexture0;white;-1;None;Triplanar Sampler;False;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT2;1,1;False;4;FLOAT;1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;14;-2561.308,226.0979;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-0.06;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;18;-2166.899,314.5863;Float;False;Constant;_Float0;Float 0;7;0;Create;True;0;0;False;0;1.36;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-2128.008,737.0582;Float;False;Property;_SmoothEdge;SmoothEdge;7;0;Create;True;0;0;False;0;0.22;0.22;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;16;-2290.359,437.7968;Float;False;2;2;0;FLOAT;0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;-1957.233,248.7839;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-2088.838,821.9116;Float;False;Property;_SmootedgeB;SmootedgeB;9;0;Create;True;0;0;False;0;-0.09;-0.09;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;21;-2094.76,440.8498;Float;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SmoothstepOpNode;22;-1711.351,714.8029;Float;True;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT4;1,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SmoothstepOpNode;23;-1677.954,455.4188;Float;True;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT4;1,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.OneMinusNode;24;-1415.81,468.3908;Float;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.Vector2Node;29;-1606.908,-1428.186;Float;False;Property;_Vector8;Vector 8;13;0;Create;True;0;0;False;0;0.2,0.2;0.002,0.002;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;-1253.329,240.1079;Float;True;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.Vector2Node;26;-1604.383,-1172.269;Float;False;Property;_Vector10;Vector 10;14;0;Create;True;0;0;False;0;0.2,0.2;0.01,0.01;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;27;-1608.383,-916.2692;Float;False;Property;_Vector9;Vector 9;12;0;Create;True;0;0;False;0;0.2,0.2;0.05,0.05;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;28;-1679.596,-468.9022;Float;False;Property;_Vector11;Vector 11;11;0;Create;True;0;0;False;0;0.2,0.2;0.05,0.01;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TriplanarNode;33;-1433.887,-1211.538;Float;True;Spherical;World;False;Top Texture 1;_TopTexture1;white;10;Assets/_MyStuff/Sprites/Noise.png;Mid Texture 1;_MidTexture1;white;-1;None;Bot Texture 1;_BotTexture1;white;-1;None;Triplanar Sampler;False;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT2;1,1;False;4;FLOAT;1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TriplanarNode;31;-1437.887,-955.5382;Float;True;Spherical;World;False;Top Texture 2;_TopTexture2;white;6;Assets/_MyStuff/Sprites/seamless-pattern-with-watercolor-hand-painted-abstract-texture_100956-149.jpg;Mid Texture 2;_MidTexture2;white;-1;None;Bot Texture 2;_BotTexture2;white;-1;None;Triplanar Sampler;False;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT2;1,1;False;4;FLOAT;1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;32;-1283.981,-653.4901;Float;False;Property;_TexInfluence;TexInfluence;15;0;Create;True;0;0;False;0;1;-1.27;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TriplanarNode;30;-1436.412,-1467.456;Float;True;Spherical;World;False;Top Texture 4;_TopTexture4;white;1;Assets/_MyStuff/Sprites/d4hccib-131dd657-3466-4311-b44b-add651ad1c61.jpg;Mid Texture 4;_MidTexture4;white;-1;None;Bot Texture 4;_BotTexture4;white;-1;None;Triplanar Sampler;False;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT2;1,1;False;4;FLOAT;1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;34;-1037.607,247.5168;Float;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TriplanarNode;35;-1417.816,-527.0582;Float;True;Spherical;World;False;Top Texture 3;_TopTexture3;white;4;Assets/AmplifyShaderEditor/Examples/Assets/Textures/Sand/Sand_height.tga;Mid Texture 3;_MidTexture3;white;-1;None;Bot Texture 3;_BotTexture3;white;-1;None;Triplanar Sampler;False;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT2;1,1;False;4;FLOAT;1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;38;-1138.766,-103.2022;Float;True;Property;_MainTex;MainTex;0;0;Create;True;0;0;False;0;368e7c0ec3559db49828b483eb113c1e;368e7c0ec3559db49828b483eb113c1e;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;41;-1031.33,713.9299;Float;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;36;-840.0812,243.6349;Float;True;4;4;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT4;0,0,0,0;False;3;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;37;-940.1352,-1400.903;Float;True;5;5;0;FLOAT;0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT4;0,0,0,0;False;3;FLOAT;0;False;4;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;40;-529.5293,-1220.174;Float;False;myVarName;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.OneMinusNode;44;-685.1406,786.681;Float;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;-600.0885,180.9805;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;42;-428.2926,603.0441;Float;False;2;2;0;FLOAT;0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;43;-216.5785,6.10292;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;Inversed dissolve;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;5;0;1;0
WireConnection;6;0;3;0
WireConnection;6;1;5;0
WireConnection;7;0;2;0
WireConnection;7;1;4;0
WireConnection;8;0;7;0
WireConnection;8;1;6;0
WireConnection;9;0;8;0
WireConnection;11;0;9;0
WireConnection;15;0;12;0
WireConnection;15;9;10;0
WireConnection;15;3;13;0
WireConnection;14;0;11;0
WireConnection;16;0;14;0
WireConnection;16;1;15;0
WireConnection;19;0;17;0
WireConnection;19;1;18;0
WireConnection;21;0;16;0
WireConnection;22;0;21;0
WireConnection;22;1;19;0
WireConnection;22;2;20;0
WireConnection;23;0;21;0
WireConnection;23;1;17;0
WireConnection;23;2;20;0
WireConnection;24;0;22;0
WireConnection;25;0;23;0
WireConnection;25;1;24;0
WireConnection;33;3;26;0
WireConnection;31;3;27;0
WireConnection;30;3;29;0
WireConnection;34;0;25;0
WireConnection;35;3;28;0
WireConnection;41;0;22;0
WireConnection;36;0;34;0
WireConnection;36;1;34;0
WireConnection;36;2;34;0
WireConnection;36;3;34;0
WireConnection;37;0;30;1
WireConnection;37;1;33;0
WireConnection;37;2;31;0
WireConnection;37;3;32;0
WireConnection;37;4;35;0
WireConnection;40;0;37;0
WireConnection;44;0;41;0
WireConnection;39;0;38;0
WireConnection;39;1;36;0
WireConnection;42;0;38;4
WireConnection;42;1;44;0
WireConnection;43;0;39;0
WireConnection;43;1;40;0
WireConnection;0;2;43;0
WireConnection;0;9;42;0
ASEEND*/
//CHKSM=BF5F31EB8FE0C1D5A4F5229E945767AE1F390ABD