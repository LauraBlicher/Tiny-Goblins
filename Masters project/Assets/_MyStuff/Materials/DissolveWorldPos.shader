// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "DissolveWorldPos"
{
	Properties
	{
		_MainTex("MainTex", 2D) = "white" {}
		_TopTexture4("Top Texture 4", 2D) = "white" {}
		_GoblinPo("GoblinPo", Vector) = (0.001,0.001,0,0)
		_StartPosition("StartPosition", Vector) = (0,0,0,0)
		_TopTexture3("Top Texture 3", 2D) = "white" {}
		_Radius("Radius", Float) = 1
		_TopTexture2("Top Texture 2", 2D) = "white" {}
		_SmoothEdge("SmoothEdge", Float) = 0
		_Texture0("Texture 0", 2D) = "white" {}
		_SmootedgeB("SmootedgeB", Float) = -2.59
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
			float4 triplanar95 = TriplanarSamplingSF( _TopTexture4, ase_worldPos, ase_worldNormal, 1.0, _Vector8, 1.0, 0 );
			float4 triplanar91 = TriplanarSamplingSF( _TopTexture1, ase_worldPos, ase_worldNormal, 1.0, _Vector10, 1.0, 0 );
			float4 triplanar93 = TriplanarSamplingSF( _TopTexture2, ase_worldPos, ase_worldNormal, 1.0, _Vector9, 1.0, 0 );
			float4 triplanar92 = TriplanarSamplingSF( _TopTexture3, ase_worldPos, ase_worldNormal, 1.0, _Vector11, 1.0, 0 );
			float4 myVarName97 = ( triplanar95.x * triplanar91 * triplanar93 * _TexInfluence * triplanar92 );
			o.Emission = ( ( tex2DNode9 * ( temp_output_76_0 * temp_output_76_0 * temp_output_76_0 * temp_output_76_0 ) ) + myVarName97 ).rgb;
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
178;341;1274;635;-3513.545;2796.756;1.3;True;False
Node;AmplifyShaderEditor.PosVertexDataNode;40;1114.863,-1601.298;Float;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;45;1676.114,-1857.487;Float;False;Property;_Radius;Radius;5;0;Create;True;0;0;False;0;1;7.56;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;43;1288.808,-1882.348;Float;False;Property;_StartPosition;StartPosition;3;0;Create;True;0;0;False;0;0,0,0;6.62,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;46;1686.114,-1772.595;Float;False;Constant;_Float7;Float 7;4;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TransformPositionNode;41;1383.466,-1610.669;Float;False;Object;World;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DistanceOpNode;42;1695.092,-1630.309;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;47;1832.818,-1797.911;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;44;1992.983,-1700.53;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;48;2235.8,-1671.442;Float;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;7;2369.273,-1121.984;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.OneMinusNode;49;2612.713,-1608.817;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;61;2423.511,-1330.674;Float;True;Property;_Texture0;Texture 0;8;0;Create;True;0;0;False;0;None;cd460ee4ac5c1e746b7a734cc7cc64dd;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.Vector2Node;8;2443.272,-986.9836;Float;False;Property;_GoblinPo;GoblinPo;2;0;Create;True;0;0;False;0;0.001,0.001;0.15,0.15;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TFHCRemapNode;50;2895.417,-1499.506;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-0.06;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TriplanarNode;4;2690.772,-1166.984;Float;True;Spherical;World;False;Top Texture 0;_TopTexture0;white;0;None;Mid Texture 0;_MidTexture0;white;-1;None;Bot Texture 0;_BotTexture0;white;-1;None;Triplanar Sampler;False;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT2;1,1;False;4;FLOAT;1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;51;3166.366,-1287.807;Float;False;2;2;0;FLOAT;0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;56;3328.717,-988.5457;Float;False;Property;_SmoothEdge;SmoothEdge;7;0;Create;True;0;0;False;0;0;0.22;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;70;3403.281,-1372.242;Float;False;Constant;_Float0;Float 0;7;0;Create;True;0;0;False;0;1.36;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;69;3499.492,-1476.82;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;60;3367.887,-903.6923;Float;False;Property;_SmootedgeB;SmootedgeB;9;0;Create;True;0;0;False;0;-2.59;-0.09;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;52;3361.965,-1284.754;Float;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SmoothstepOpNode;68;3745.374,-1010.801;Float;True;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT4;1,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SmoothstepOpNode;59;3778.771,-1270.185;Float;True;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT4;1,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.OneMinusNode;73;4040.915,-1257.213;Float;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;66;4203.396,-1485.496;Float;True;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.Vector2Node;90;3852.342,-2897.873;Float;False;Property;_Vector10;Vector 10;14;0;Create;True;0;0;False;0;0.2,0.2;0.01,0.01;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;89;3848.342,-2641.873;Float;False;Property;_Vector9;Vector 9;12;0;Create;True;0;0;False;0;0.2,0.2;0.05,0.05;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;87;3777.129,-2194.506;Float;False;Property;_Vector11;Vector 11;11;0;Create;True;0;0;False;0;0.2,0.2;0.05,0.01;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;88;3849.817,-3153.79;Float;False;Property;_Vector8;Vector 8;13;0;Create;True;0;0;False;0;0.2,0.2;0.002,0.002;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TriplanarNode;95;4020.313,-3193.06;Float;True;Spherical;World;False;Top Texture 4;_TopTexture4;white;1;Assets/_MyStuff/Sprites/4bf9a3477bd635c0d02fab3e7d44b92f.jpg;Mid Texture 4;_MidTexture4;white;-1;None;Bot Texture 4;_BotTexture4;white;-1;None;Triplanar Sampler;False;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT2;1,1;False;4;FLOAT;1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TriplanarNode;93;4018.838,-2681.142;Float;True;Spherical;World;False;Top Texture 2;_TopTexture2;white;6;Assets/AmplifyShaderEditor/Examples/Assets/Textures/Misc/Checkers.png;Mid Texture 2;_MidTexture2;white;-1;None;Bot Texture 2;_BotTexture2;white;-1;None;Triplanar Sampler;False;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT2;1,1;False;4;FLOAT;1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;94;4172.744,-2379.094;Float;False;Property;_TexInfluence;TexInfluence;15;0;Create;True;0;0;False;0;1;-3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TriplanarNode;91;4022.838,-2937.142;Float;True;Spherical;World;False;Top Texture 1;_TopTexture1;white;10;Assets/AmplifyShaderEditor/Examples/Assets/Textures/Misc/AnisoMap.jpg;Mid Texture 1;_MidTexture1;white;-1;None;Bot Texture 1;_BotTexture1;white;-1;None;Triplanar Sampler;False;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT2;1,1;False;4;FLOAT;1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;76;4419.118,-1478.087;Float;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TriplanarNode;92;4038.909,-2252.662;Float;True;Spherical;World;False;Top Texture 3;_TopTexture3;white;4;Assets/AmplifyShaderEditor/Examples/Assets/Textures/Misc/Checkers.png;Mid Texture 3;_MidTexture3;white;-1;None;Bot Texture 3;_BotTexture3;white;-1;None;Triplanar Sampler;False;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT2;1,1;False;4;FLOAT;1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;83;4603.49,-1481.969;Float;True;4;4;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT4;0,0,0,0;False;3;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;96;4516.59,-3126.507;Float;True;5;5;0;FLOAT;0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT4;0,0,0,0;False;3;FLOAT;0;False;4;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SamplerNode;9;4317.959,-1828.806;Float;True;Property;_MainTex;MainTex;0;0;Create;True;0;0;False;0;None;368e7c0ec3559db49828b483eb113c1e;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;77;4882.944,-1535.228;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;97;4927.196,-2945.778;Float;False;myVarName;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SaturateNode;65;4425.395,-1011.674;Float;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;86;5161.734,-1386.564;Float;False;Constant;_Float1;Float 1;7;0;Create;True;0;0;False;0;1.3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;84;4909.059,-1134.263;Float;False;2;2;0;FLOAT;0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;99;5147.764,-1646.661;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;5382.332,-1507.106;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;DissolveWorldPos;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
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
WireConnection;69;0;56;0
WireConnection;69;1;70;0
WireConnection;52;0;51;0
WireConnection;68;0;52;0
WireConnection;68;1;69;0
WireConnection;68;2;60;0
WireConnection;59;0;52;0
WireConnection;59;1;56;0
WireConnection;59;2;60;0
WireConnection;73;0;68;0
WireConnection;66;0;59;0
WireConnection;66;1;73;0
WireConnection;95;3;88;0
WireConnection;93;3;89;0
WireConnection;91;3;90;0
WireConnection;76;0;66;0
WireConnection;92;3;87;0
WireConnection;83;0;76;0
WireConnection;83;1;76;0
WireConnection;83;2;76;0
WireConnection;83;3;76;0
WireConnection;96;0;95;1
WireConnection;96;1;91;0
WireConnection;96;2;93;0
WireConnection;96;3;94;0
WireConnection;96;4;92;0
WireConnection;77;0;9;0
WireConnection;77;1;83;0
WireConnection;97;0;96;0
WireConnection;65;0;68;0
WireConnection;84;0;9;4
WireConnection;84;1;65;0
WireConnection;99;0;77;0
WireConnection;99;1;97;0
WireConnection;0;2;99;0
WireConnection;0;9;84;0
ASEEND*/
//CHKSM=E833A7509BFE6DB491F5221164ED0EAC8B6FF8D2