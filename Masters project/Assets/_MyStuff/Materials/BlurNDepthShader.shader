// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "BlurNDepthShader"
{
	Properties
	{
		_TopTexture0("Top Texture 0", 2D) = "white" {}
		_MainTex("MainTex", 2D) = "white" {}
		_TopTexture3("Top Texture 3", 2D) = "white" {}
		_TopTexture2("Top Texture 2", 2D) = "white" {}
		_Float6("Float 6", Float) = 0
		_Float2("Float 2", Float) = 0
		_TopTexture1("Top Texture 1", 2D) = "white" {}
		_Float5("Float 5", Float) = 0
		_BlurAmount("BlurAmount", Range( 0 , 20)) = 0.01
		_Vector11("Vector 11", Vector) = (0.2,0.2,0,0)
		_Vector9("Vector 9", Vector) = (0.2,0.2,0,0)
		_Vector8("Vector 8", Vector) = (0.2,0.2,0,0)
		_Vector10("Vector 10", Vector) = (0.2,0.2,0,0)
		_Float1("Float 1", Float) = 0
		_Color1("Color 1", Color) = (0.4094874,0.6091207,0.8113208,0)
		_Color0("Color 0", Color) = (1,1,1,0)
		_ForegroundColor("ForegroundColor", Color) = (0.4094874,0.6091207,0.8113208,0)
		_Float3("Float 3", Float) = 0
		_Float4("Float 4", Float) = 0
		_Float7("Float 7", Float) = 0
		_Float8("Float 8", Float) = 0
		_TexInfluence("TexInfluence", Float) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
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
			float eyeDepth;
			float2 uv_texcoord;
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
		};

		uniform float4 _Color0;
		uniform sampler2D _MainTex;
		uniform float _Float2;
		uniform float _Float1;
		uniform float _BlurAmount;
		uniform sampler2D _TopTexture0;
		uniform float2 _Vector8;
		uniform sampler2D _TopTexture1;
		uniform float2 _Vector10;
		uniform sampler2D _TopTexture2;
		uniform float2 _Vector9;
		uniform float _TexInfluence;
		uniform sampler2D _TopTexture3;
		uniform float2 _Vector11;
		uniform float _Float7;
		uniform float _Float8;
		uniform float _Float6;
		uniform float _Float5;
		uniform float4 _Color1;
		uniform float _Float3;
		uniform float _Float4;
		uniform float4 _ForegroundColor;


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


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			o.eyeDepth = -UnityObjectToViewPos( v.vertex.xyz ).z;
		}

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			o.Normal = float3(0,0,1);
			float cameraDepthFade3 = (( i.eyeDepth -_ProjectionParams.y - _Float1 ) / _Float2);
			float temp_output_15_0 = ( abs( cameraDepthFade3 ) * _BlurAmount );
			float2 temp_output_16_0 = ( float2( 0.001,0 ) * temp_output_15_0 );
			float2 uv_TexCoord42 = i.uv_texcoord + temp_output_16_0;
			float4 tex2DNode50 = tex2D( _MainTex, uv_TexCoord42 );
			float2 uv_TexCoord35 = i.uv_texcoord + -temp_output_16_0;
			float4 tex2DNode61 = tex2D( _MainTex, uv_TexCoord35 );
			float2 temp_output_21_0 = ( float2( 0,0.001 ) * temp_output_15_0 );
			float2 uv_TexCoord34 = i.uv_texcoord + temp_output_21_0;
			float4 tex2DNode59 = tex2D( _MainTex, uv_TexCoord34 );
			float2 uv_TexCoord32 = i.uv_texcoord + -temp_output_21_0;
			float4 tex2DNode62 = tex2D( _MainTex, uv_TexCoord32 );
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float4 triplanar104 = TriplanarSamplingSF( _TopTexture0, ase_worldPos, ase_worldNormal, 1.0, _Vector8, 1.0, 0 );
			float4 triplanar103 = TriplanarSamplingSF( _TopTexture1, ase_worldPos, ase_worldNormal, 1.0, _Vector10, 1.0, 0 );
			float4 triplanar102 = TriplanarSamplingSF( _TopTexture2, ase_worldPos, ase_worldNormal, 1.0, _Vector9, 1.0, 0 );
			float4 triplanar112 = TriplanarSamplingSF( _TopTexture3, ase_worldPos, ase_worldNormal, 1.0, _Vector11, 1.0, 0 );
			float4 temp_output_105_0 = ( triplanar104.x * triplanar103 * triplanar102 * _TexInfluence * triplanar112 );
			float4 myVarName109 = temp_output_105_0;
			float2 temp_output_22_0 = ( float2( 0.0005,0 ) * temp_output_15_0 );
			float2 uv_TexCoord41 = i.uv_texcoord + temp_output_22_0;
			float4 tex2DNode58 = tex2D( _MainTex, uv_TexCoord41 );
			float2 uv_TexCoord47 = i.uv_texcoord + -temp_output_22_0;
			float4 tex2DNode63 = tex2D( _MainTex, uv_TexCoord47 );
			float2 temp_output_18_0 = ( float2( 0,0.0005 ) * temp_output_15_0 );
			float2 uv_TexCoord37 = i.uv_texcoord + temp_output_18_0;
			float4 tex2DNode52 = tex2D( _MainTex, uv_TexCoord37 );
			float2 uv_TexCoord46 = i.uv_texcoord + -temp_output_18_0;
			float4 tex2DNode51 = tex2D( _MainTex, uv_TexCoord46 );
			float2 temp_output_23_0 = ( float2( 0.001,0.001 ) * temp_output_15_0 );
			float2 uv_TexCoord44 = i.uv_texcoord + temp_output_23_0;
			float4 tex2DNode53 = tex2D( _MainTex, uv_TexCoord44 );
			float2 uv_TexCoord38 = i.uv_texcoord + -temp_output_23_0;
			float4 tex2DNode64 = tex2D( _MainTex, uv_TexCoord38 );
			float2 temp_output_19_0 = ( float2( -0.001,0.001 ) * temp_output_15_0 );
			float2 uv_TexCoord40 = i.uv_texcoord + temp_output_19_0;
			float4 tex2DNode57 = tex2D( _MainTex, uv_TexCoord40 );
			float2 uv_TexCoord45 = i.uv_texcoord + -temp_output_19_0;
			float4 tex2DNode49 = tex2D( _MainTex, uv_TexCoord45 );
			float2 temp_output_20_0 = ( float2( 0.0005,0.0005 ) * temp_output_15_0 );
			float2 uv_TexCoord33 = i.uv_texcoord + temp_output_20_0;
			float4 tex2DNode60 = tex2D( _MainTex, uv_TexCoord33 );
			float2 uv_TexCoord48 = i.uv_texcoord + -temp_output_20_0;
			float4 tex2DNode54 = tex2D( _MainTex, uv_TexCoord48 );
			float2 temp_output_17_0 = ( float2( -0.0005,0.0005 ) * temp_output_15_0 );
			float2 uv_TexCoord43 = i.uv_texcoord + temp_output_17_0;
			float4 tex2DNode55 = tex2D( _MainTex, uv_TexCoord43 );
			float2 uv_TexCoord39 = i.uv_texcoord + -temp_output_17_0;
			float4 tex2DNode56 = tex2D( _MainTex, uv_TexCoord39 );
			float cameraDepthFade85 = (( i.eyeDepth -_ProjectionParams.y - _Float5 ) / _Float6);
			float smoothstepResult93 = smoothstep( _Float7 , _Float8 , cameraDepthFade85);
			float cameraDepthFade84 = (( i.eyeDepth -_ProjectionParams.y - _Float4 ) / _Float3);
			o.Emission = ( ( ( _Color0 * ( ( ( tex2DNode50 + tex2DNode61 + tex2DNode59 + tex2DNode62 + myVarName109 ) + ( tex2DNode58 + tex2DNode63 + tex2DNode52 + tex2DNode51 + myVarName109 ) + ( tex2DNode53 + tex2DNode64 + tex2DNode57 + tex2DNode49 + myVarName109 ) + ( tex2DNode60 + tex2DNode54 + tex2DNode55 + tex2DNode56 + myVarName109 ) ) / 16.0 ) ) + ( smoothstepResult93 * _Color1 ) ) * saturate( ( cameraDepthFade84 + ( ( 1.0 - cameraDepthFade84 ) * _ForegroundColor ) ) ) ).rgb;
			o.Alpha = ( ( ( tex2DNode50.a + tex2DNode61.a + tex2DNode59.a + tex2DNode62.a ) + ( tex2DNode58.a + tex2DNode63.a + tex2DNode52.a + tex2DNode51.a ) + ( tex2DNode53.a + tex2DNode64.a + tex2DNode57.a + tex2DNode49.a ) + ( tex2DNode60.a + tex2DNode54.a + tex2DNode55.a + tex2DNode56.a ) ) / 16.0 );
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Unlit alpha:fade keepalpha fullforwardshadows vertex:vertexDataFunc 

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
				float3 customPack1 : TEXCOORD1;
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
				vertexDataFunc( v, customInputData );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.x = customInputData.eyeDepth;
				o.customPack1.yz = customInputData.uv_texcoord;
				o.customPack1.yz = v.texcoord;
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
				surfIN.eyeDepth = IN.customPack1.x;
				surfIN.uv_texcoord = IN.customPack1.yz;
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				SurfaceOutput o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutput, o )
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
240;276;1387;709;4987.59;-2889.153;1.854053;True;False
Node;AmplifyShaderEditor.RangedFloatNode;1;-3188.128,-240.8723;Float;False;Property;_Float1;Float 1;14;0;Create;True;0;0;False;0;0;20.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2;-3197.263,-337.7122;Float;False;Property;_Float2;Float 2;5;0;Create;True;0;0;False;0;0;74.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CameraDepthFade;3;-3006.939,-328.2412;Float;False;3;2;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-3011.143,-95.7583;Float;True;Property;_BlurAmount;BlurAmount;8;0;Create;True;0;0;False;0;0.01;20;0;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;5;-2709.662,-342.9482;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;14;-1752.828,-2195.953;Float;False;Constant;_Vector1;Vector 1;1;0;Create;True;0;0;False;0;0,0.001;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;13;-1787.788,2185.85;Float;False;Constant;_Vector6;Vector 6;1;0;Create;True;0;0;False;0;0.0005,0.0005;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;-2574.484,-248.7673;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;8;-1705.002,-313.6113;Float;False;Constant;_Vector2;Vector 2;1;0;Create;True;0;0;False;0;0,0.0005;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;7;-1655.963,571.9817;Float;False;Constant;_Vector4;Vector 4;1;0;Create;True;0;0;False;0;0.001,0.001;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;12;-1863.961,2731.585;Float;False;Constant;_Vector5;Vector 5;1;0;Create;True;0;0;False;0;-0.0005,0.0005;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;101;-4012.091,3415.507;Float;False;Property;_Vector10;Vector 10;13;0;Create;True;0;0;False;0;0.2,0.2;0.01,0.01;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;9;-1697.762,-2783.964;Float;False;Constant;_Vector0;Vector 0;1;0;Create;True;0;0;False;0;0.001,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;10;-1681.029,1173.993;Float;False;Constant;_Vector7;Vector 7;1;0;Create;True;0;0;False;0;-0.001,0.001;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;11;-1783.579,-1334.542;Float;False;Constant;_Vector3;Vector 3;1;0;Create;True;0;0;False;0;0.0005,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;100;-4016.091,3671.507;Float;False;Property;_Vector9;Vector 9;10;0;Create;True;0;0;False;0;0.2,0.2;0.05,0.05;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;99;-4014.616,3159.59;Float;False;Property;_Vector8;Vector 8;12;0;Create;True;0;0;False;0;0.2,0.2;0.002,0.002;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;113;-4087.304,4118.874;Float;False;Property;_Vector11;Vector 11;9;0;Create;True;0;0;False;0;0.2,0.2;0.05,0.01;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;-1443.767,597.2756;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TriplanarNode;104;-3844.12,3120.32;Float;True;Spherical;World;False;Top Texture 0;_TopTexture0;white;0;Assets/_MyStuff/Sprites/4bf9a3477bd635c0d02fab3e7d44b92f.jpg;Mid Texture 0;_MidTexture0;white;-1;None;Bot Texture 0;_BotTexture0;white;-1;None;Triplanar Sampler;False;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT2;1,1;False;4;FLOAT;1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;-1439.885,2117.203;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;111;-3691.689,3934.286;Float;False;Property;_TexInfluence;TexInfluence;22;0;Create;True;0;0;False;0;1;-3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TriplanarNode;102;-3845.595,3632.238;Float;True;Spherical;World;False;Top Texture 2;_TopTexture2;white;3;Assets/AmplifyShaderEditor/Examples/Assets/Textures/Misc/Checkers.png;Mid Texture 2;_MidTexture2;white;-1;None;Bot Texture 2;_BotTexture2;white;-1;None;Triplanar Sampler;False;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT2;1,1;False;4;FLOAT;1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;-1472.307,1188.768;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;-1463.797,3106.619;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TriplanarNode;103;-3841.595,3376.238;Float;True;Spherical;World;False;Top Texture 1;_TopTexture1;white;6;Assets/AmplifyShaderEditor/Examples/Assets/Textures/Misc/AnisoMap.jpg;Mid Texture 1;_MidTexture1;white;-1;None;Bot Texture 1;_BotTexture1;white;-1;None;Triplanar Sampler;False;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT2;1,1;False;4;FLOAT;1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-1485.567,-2758.67;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;-1514.106,-2167.178;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-1500.345,-249.3275;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;-1476.432,-1238.743;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TriplanarNode;112;-3825.524,4060.718;Float;True;Spherical;World;False;Top Texture 3;_TopTexture3;white;2;Assets/AmplifyShaderEditor/Examples/Assets/Textures/Misc/Checkers.png;Mid Texture 3;_MidTexture3;white;-1;None;Bot Texture 3;_BotTexture3;white;-1;None;Triplanar Sampler;False;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT2;1,1;False;4;FLOAT;1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NegateNode;28;-1290.141,-1065.511;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NegateNode;29;-1208.473,1369.503;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NegateNode;25;-1257.475,770.5076;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NegateNode;30;-1253.593,2290.435;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;105;-3347.843,3186.873;Float;True;5;5;0;FLOAT;0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT4;0,0,0,0;False;3;FLOAT;0;False;4;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.NegateNode;24;-1199.964,3287.355;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NegateNode;27;-1236.511,-68.59131;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NegateNode;26;-1250.272,-1986.443;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NegateNode;31;-1299.275,-2585.438;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;45;-1059.579,1317.185;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0.59,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;36;-657.5469,160.1252;Float;True;Property;_MainTex;MainTex;1;0;Create;True;0;0;False;0;None;None;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;44;-1054.495,407.7247;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0.17,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;32;-1101.379,-2038.761;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0.59,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;109;-2825.132,3164.949;Float;False;myVarName;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;37;-1083.997,-426.2453;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0.17,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;42;-1096.294,-2948.222;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0.17,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;39;-1051.07,3235.037;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0.59,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;43;-1047.45,2929.701;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0.17,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;35;-1099.915,-2637.756;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0.59,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;38;-1058.116,718.1907;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0.59,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;48;-1054.234,2238.117;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0.59,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;34;-1097.758,-2344.096;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0.17,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;33;-1050.612,1927.651;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0.17,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;41;-1087.16,-1428.295;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0.17,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;40;-1055.959,1011.849;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0.17,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;46;-1092.87,-120.9094;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0.59,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;47;-1090.781,-1117.829;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0.59,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;110;-150.1167,73.10167;Float;True;109;myVarName;1;0;OBJECT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SamplerNode;57;-106.8681,1042.96;Float;True;Property;_TextureSample13;Texture Sample 13;1;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;51;-158.4417,-325.3052;Float;True;Property;_TextureSample5;Texture Sample 5;5;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;54;-119.8052,2449.317;Float;True;Property;_TextureSample8;Texture Sample 8;6;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;53;-115.1619,477.0288;Float;True;Property;_TextureSample10;Texture Sample 10;1;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;61;-202.1861,-2568.796;Float;True;Property;_TextureSample1;Texture Sample 1;2;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;63;-161.6048,-906.6293;Float;True;Property;_TextureSample7;Texture Sample 7;6;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;52;-163.2937,-598.7241;Float;True;Property;_TextureSample4;Texture Sample 4;3;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;62;-199.023,-1987.473;Float;True;Property;_TextureSample3;Texture Sample 3;2;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;50;-212.1689,-2826.822;Float;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;58;-171.5876,-1164.655;Float;True;Property;_TextureSample6;Texture Sample 6;4;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;56;-116.642,3030.641;Float;True;Property;_TextureSample14;Texture Sample 14;5;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;81;1602.869,-321.8695;Float;False;Property;_Float4;Float 4;19;0;Create;True;0;0;False;0;0;6.8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;64;-105.1791,735.0547;Float;True;Property;_TextureSample15;Texture Sample 15;2;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;80;1624.432,-392.3072;Float;False;Property;_Float3;Float 3;18;0;Create;True;0;0;False;0;0;7.9;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;49;-102.0161,1316.378;Float;True;Property;_TextureSample11;Texture Sample 11;2;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;60;-129.788,2191.291;Float;True;Property;_TextureSample9;Texture Sample 9;4;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;55;-121.4941,2757.222;Float;True;Property;_TextureSample12;Texture Sample 12;3;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;59;-203.875,-2260.891;Float;True;Property;_TextureSample2;Texture Sample 2;1;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CameraDepthFade;84;1835.34,-445.9748;Float;False;3;2;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;66;401.2543,2345.742;Float;False;5;5;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;FLOAT4;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;83;1588.236,-1055.766;Float;False;Property;_Float6;Float 6;4;0;Create;True;0;0;False;0;0;56.9;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;82;1597.371,-958.925;Float;False;Property;_Float5;Float 5;7;0;Create;True;0;0;False;0;0;10.03;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;68;335.0601,-2160.128;Float;False;5;5;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;FLOAT4;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;65;477.3507,778.2168;Float;False;5;5;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;FLOAT4;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;67;359.4547,-1010.204;Float;False;5;5;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;FLOAT4;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;71;1153.484,150.2256;Float;True;Constant;_Float0;Float 0;2;0;Create;True;0;0;False;0;16;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;89;1831.995,-801.8179;Float;False;Property;_Float8;Float 8;21;0;Create;True;0;0;False;0;0;0.55;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CameraDepthFade;85;1778.56,-1046.294;Float;False;3;2;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;72;1115.327,-181.4263;Float;False;4;4;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;90;2084.433,-481.0574;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;87;1873.39,-227.7016;Float;False;Property;_ForegroundColor;ForegroundColor;17;0;Create;True;0;0;False;0;0.4094874,0.6091207,0.8113208,0;0.5660378,0.5232416,0.4298683,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;86;1834.956,-877.3035;Float;False;Property;_Float7;Float 7;20;0;Create;True;0;0;False;0;0;0.25;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;92;2450.438,-544.3083;Float;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;76;1308.141,-411.4431;Float;False;Property;_Color0;Color 0;16;0;Create;True;0;0;False;0;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SmoothstepOpNode;93;2036.792,-900.8035;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;91;1877.199,-730.0318;Float;False;Property;_Color1;Color 1;15;0;Create;True;0;0;False;0;0.4094874,0.6091207,0.8113208,0;0.3921569,0.4434128,0.4627451,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleDivideOpNode;77;1425.49,13.96387;Float;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;73;475.5786,1194.685;Float;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;70;347.5081,-673.7903;Float;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;95;2673.874,-573.5291;Float;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;74;313.8808,-1947.437;Float;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;69;389.3076,2682.156;Float;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;94;2196.675,-892.7346;Float;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;79;1608.523,-53.36133;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;96;2907.29,-637.8529;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;75;1130.493,512.0947;Float;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;97;2671.429,-922.0449;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;106;-3056.307,3173.746;Float;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;98;3046.582,-825.5195;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;78;1413.682,182.2229;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;88;2120.889,-1165.473;Float;True;Property;_TextureSample16;Texture Sample 16;11;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;3730.211,-192.4579;Float;False;True;2;Float;ASEMaterialInspector;0;0;Unlit;BlurNDepthShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.CommentaryNode;4;-1874.889,-3122.087;Float;False;2373.493;1433.292;Love side to side;0;;1,1,1,1;0;0
WireConnection;3;0;2;0
WireConnection;3;1;1;0
WireConnection;5;0;3;0
WireConnection;15;0;5;0
WireConnection;15;1;6;0
WireConnection;23;0;7;0
WireConnection;23;1;15;0
WireConnection;104;3;99;0
WireConnection;20;0;13;0
WireConnection;20;1;15;0
WireConnection;102;3;100;0
WireConnection;19;0;10;0
WireConnection;19;1;15;0
WireConnection;17;0;12;0
WireConnection;17;1;15;0
WireConnection;103;3;101;0
WireConnection;16;0;9;0
WireConnection;16;1;15;0
WireConnection;21;0;14;0
WireConnection;21;1;15;0
WireConnection;18;0;8;0
WireConnection;18;1;15;0
WireConnection;22;0;11;0
WireConnection;22;1;15;0
WireConnection;112;3;113;0
WireConnection;28;0;22;0
WireConnection;29;0;19;0
WireConnection;25;0;23;0
WireConnection;30;0;20;0
WireConnection;105;0;104;1
WireConnection;105;1;103;0
WireConnection;105;2;102;0
WireConnection;105;3;111;0
WireConnection;105;4;112;0
WireConnection;24;0;17;0
WireConnection;27;0;18;0
WireConnection;26;0;21;0
WireConnection;31;0;16;0
WireConnection;45;1;29;0
WireConnection;44;1;23;0
WireConnection;32;1;26;0
WireConnection;109;0;105;0
WireConnection;37;1;18;0
WireConnection;42;1;16;0
WireConnection;39;1;24;0
WireConnection;43;1;17;0
WireConnection;35;1;31;0
WireConnection;38;1;25;0
WireConnection;48;1;30;0
WireConnection;34;1;21;0
WireConnection;33;1;20;0
WireConnection;41;1;22;0
WireConnection;40;1;19;0
WireConnection;46;1;27;0
WireConnection;47;1;28;0
WireConnection;57;0;36;0
WireConnection;57;1;40;0
WireConnection;51;0;36;0
WireConnection;51;1;46;0
WireConnection;54;0;36;0
WireConnection;54;1;48;0
WireConnection;53;0;36;0
WireConnection;53;1;44;0
WireConnection;61;0;36;0
WireConnection;61;1;35;0
WireConnection;63;0;36;0
WireConnection;63;1;47;0
WireConnection;52;0;36;0
WireConnection;52;1;37;0
WireConnection;62;0;36;0
WireConnection;62;1;32;0
WireConnection;50;0;36;0
WireConnection;50;1;42;0
WireConnection;58;0;36;0
WireConnection;58;1;41;0
WireConnection;56;0;36;0
WireConnection;56;1;39;0
WireConnection;64;0;36;0
WireConnection;64;1;38;0
WireConnection;49;0;36;0
WireConnection;49;1;45;0
WireConnection;60;0;36;0
WireConnection;60;1;33;0
WireConnection;55;0;36;0
WireConnection;55;1;43;0
WireConnection;59;0;36;0
WireConnection;59;1;34;0
WireConnection;84;0;80;0
WireConnection;84;1;81;0
WireConnection;66;0;60;0
WireConnection;66;1;54;0
WireConnection;66;2;55;0
WireConnection;66;3;56;0
WireConnection;66;4;110;0
WireConnection;68;0;50;0
WireConnection;68;1;61;0
WireConnection;68;2;59;0
WireConnection;68;3;62;0
WireConnection;68;4;110;0
WireConnection;65;0;53;0
WireConnection;65;1;64;0
WireConnection;65;2;57;0
WireConnection;65;3;49;0
WireConnection;65;4;110;0
WireConnection;67;0;58;0
WireConnection;67;1;63;0
WireConnection;67;2;52;0
WireConnection;67;3;51;0
WireConnection;67;4;110;0
WireConnection;85;0;83;0
WireConnection;85;1;82;0
WireConnection;72;0;68;0
WireConnection;72;1;67;0
WireConnection;72;2;65;0
WireConnection;72;3;66;0
WireConnection;90;0;84;0
WireConnection;92;0;90;0
WireConnection;92;1;87;0
WireConnection;93;0;85;0
WireConnection;93;1;86;0
WireConnection;93;2;89;0
WireConnection;77;0;72;0
WireConnection;77;1;71;0
WireConnection;73;0;53;4
WireConnection;73;1;64;4
WireConnection;73;2;57;4
WireConnection;73;3;49;4
WireConnection;70;0;58;4
WireConnection;70;1;63;4
WireConnection;70;2;52;4
WireConnection;70;3;51;4
WireConnection;95;0;84;0
WireConnection;95;1;92;0
WireConnection;74;0;50;4
WireConnection;74;1;61;4
WireConnection;74;2;59;4
WireConnection;74;3;62;4
WireConnection;69;0;60;4
WireConnection;69;1;54;4
WireConnection;69;2;55;4
WireConnection;69;3;56;4
WireConnection;94;0;93;0
WireConnection;94;1;91;0
WireConnection;79;0;76;0
WireConnection;79;1;77;0
WireConnection;96;0;95;0
WireConnection;75;0;74;0
WireConnection;75;1;70;0
WireConnection;75;2;73;0
WireConnection;75;3;69;0
WireConnection;97;0;79;0
WireConnection;97;1;94;0
WireConnection;106;0;105;0
WireConnection;98;0;97;0
WireConnection;98;1;96;0
WireConnection;78;0;75;0
WireConnection;78;1;71;0
WireConnection;0;2;98;0
WireConnection;0;9;78;0
ASEEND*/
//CHKSM=8C59CE6826500A78D89730B6F565076FB17B3A40