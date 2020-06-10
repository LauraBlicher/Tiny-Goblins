// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "GrassWiggleDepth"
{
	Properties
	{
		_TopTexture0("Top Texture 0", 2D) = "white" {}
		_Noise("Noise", 2D) = "white" {}
		_MainTex("MainTex", 2D) = "white" {}
		_NoiseScale("NoiseScale", Float) = -0.05
		_TopTexture3("Top Texture 3", 2D) = "white" {}
		_FlickerSpeed("FlickerSpeed", Float) = 0.2
		_TopTexture2("Top Texture 2", 2D) = "white" {}
		_timeScale("timeScale", Float) = -1
		_Float6("Float 6", Float) = 0
		_WorldPosMultiplier("WorldPosMultiplier", Float) = 0.001
		_Float2("Float 2", Float) = 0
		_TopTexture1("Top Texture 1", 2D) = "white" {}
		_WobbleScale("WobbleScale", Range( 0 , 1)) = 0.71
		_Float5("Float 5", Float) = 0
		_BlurAmount("BlurAmount", Range( 0 , 40)) = 0.01
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
		uniform sampler2D _Noise;
		uniform float _timeScale;
		uniform float _FlickerSpeed;
		uniform float _WorldPosMultiplier;
		uniform float _NoiseScale;
		uniform float _WobbleScale;
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
			float cameraDepthFade21 = (( i.eyeDepth -_ProjectionParams.y - _Float1 ) / _Float2);
			float temp_output_34_0 = ( abs( cameraDepthFade21 ) * _BlurAmount );
			float2 temp_output_1_0 = ( float2( 0.001,0 ) * temp_output_34_0 );
			float2 uv_TexCoord2 = i.uv_texcoord + temp_output_1_0;
			float4 color128 = IsGammaSpace() ? float4(0.5019608,0.5019608,1,0) : float4(0.2158605,0.2158605,1,0);
			float mulTime123 = _Time.y * _timeScale;
			float4 appendResult124 = (float4(-_FlickerSpeed , -_FlickerSpeed , -_FlickerSpeed , 0.0));
			float3 ase_worldPos = i.worldPos;
			float4 appendResult113 = (float4(ase_worldPos.x , ase_worldPos.y , ase_worldPos.z , 0.0));
			float2 uv_TexCoord117 = i.uv_texcoord * float2( 1,1 );
			float2 panner125 = ( mulTime123 * appendResult124.xy + ( ( appendResult113 * _WorldPosMultiplier ) + float4( ( _NoiseScale * uv_TexCoord117 ), 0.0 , 0.0 ) ).xy);
			float4 lerpResult129 = lerp( color128 , tex2D( _Noise, panner125 ) , _WobbleScale);
			float2 WiggleVar136 = ( i.uv_texcoord + ( i.uv_texcoord.y * ( (lerpResult129).rg - float2( 0.5,0.5 ) ) * i.uv_texcoord.y ) );
			float4 tex2DNode83 = tex2D( _MainTex, ( ( uv_TexCoord2 + WiggleVar136 ) / float2( 2,2 ) ) );
			float2 uv_TexCoord65 = i.uv_texcoord + -temp_output_1_0;
			float4 tex2DNode88 = tex2D( _MainTex, ( ( uv_TexCoord65 + WiggleVar136 ) / float2( 2,2 ) ) );
			float2 temp_output_39_0 = ( float2( 0,0.001 ) * temp_output_34_0 );
			float2 uv_TexCoord60 = i.uv_texcoord + temp_output_39_0;
			float4 tex2DNode81 = tex2D( _MainTex, ( ( uv_TexCoord60 + WiggleVar136 ) / float2( 2,2 ) ) );
			float2 uv_TexCoord68 = i.uv_texcoord + -temp_output_39_0;
			float4 tex2DNode85 = tex2D( _MainTex, ( ( uv_TexCoord68 + WiggleVar136 ) / float2( 2,2 ) ) );
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float4 triplanar47 = TriplanarSamplingSF( _TopTexture0, ase_worldPos, ase_worldNormal, 1.0, _Vector8, 1.0, 0 );
			float4 triplanar40 = TriplanarSamplingSF( _TopTexture1, ase_worldPos, ase_worldNormal, 1.0, _Vector10, 1.0, 0 );
			float4 triplanar44 = TriplanarSamplingSF( _TopTexture2, ase_worldPos, ase_worldNormal, 1.0, _Vector9, 1.0, 0 );
			float4 triplanar42 = TriplanarSamplingSF( _TopTexture3, ase_worldPos, ase_worldNormal, 1.0, _Vector11, 1.0, 0 );
			float4 temp_output_51_0 = ( triplanar47.x * triplanar40 * triplanar44 * _TexInfluence * triplanar42 );
			float4 myVarName73 = temp_output_51_0;
			float2 temp_output_37_0 = ( float2( 0.0005,0 ) * temp_output_34_0 );
			float2 uv_TexCoord62 = i.uv_texcoord + temp_output_37_0;
			float4 tex2DNode82 = tex2D( _MainTex, ( ( uv_TexCoord62 + WiggleVar136 ) / float2( 2,2 ) ) );
			float2 uv_TexCoord61 = i.uv_texcoord + -temp_output_37_0;
			float4 tex2DNode87 = tex2D( _MainTex, ( ( uv_TexCoord61 + WiggleVar136 ) / float2( 2,2 ) ) );
			float2 temp_output_38_0 = ( float2( 0,0.0005 ) * temp_output_34_0 );
			float2 uv_TexCoord74 = i.uv_texcoord + temp_output_38_0;
			float4 tex2DNode86 = tex2D( _MainTex, ( ( uv_TexCoord74 + WiggleVar136 ) / float2( 2,2 ) ) );
			float2 uv_TexCoord64 = i.uv_texcoord + -temp_output_38_0;
			float4 tex2DNode91 = tex2D( _MainTex, ( ( uv_TexCoord64 + WiggleVar136 ) / float2( 2,2 ) ) );
			float2 temp_output_48_0 = ( float2( 0.001,0.001 ) * temp_output_34_0 );
			float2 uv_TexCoord71 = i.uv_texcoord + temp_output_48_0;
			float4 tex2DNode89 = tex2D( _MainTex, ( ( uv_TexCoord71 + WiggleVar136 ) / float2( 2,2 ) ) );
			float2 uv_TexCoord58 = i.uv_texcoord + -temp_output_48_0;
			float4 tex2DNode78 = tex2D( _MainTex, ( ( uv_TexCoord58 + WiggleVar136 ) / float2( 2,2 ) ) );
			float2 temp_output_43_0 = ( float2( -0.001,0.001 ) * temp_output_34_0 );
			float2 uv_TexCoord63 = i.uv_texcoord + temp_output_43_0;
			float4 tex2DNode92 = tex2D( _MainTex, ( ( uv_TexCoord63 + WiggleVar136 ) / float2( 2,2 ) ) );
			float2 uv_TexCoord70 = i.uv_texcoord + -temp_output_43_0;
			float4 tex2DNode76 = tex2D( _MainTex, ( ( uv_TexCoord70 + WiggleVar136 ) / float2( 2,2 ) ) );
			float2 temp_output_46_0 = ( float2( 0.0005,0.0005 ) * temp_output_34_0 );
			float2 uv_TexCoord66 = i.uv_texcoord + temp_output_46_0;
			float4 tex2DNode75 = tex2D( _MainTex, ( ( uv_TexCoord66 + WiggleVar136 ) / float2( 2,2 ) ) );
			float2 uv_TexCoord59 = i.uv_texcoord + -temp_output_46_0;
			float4 tex2DNode90 = tex2D( _MainTex, ( ( uv_TexCoord59 + WiggleVar136 ) / float2( 2,2 ) ) );
			float2 temp_output_41_0 = ( float2( -0.0005,0.0005 ) * temp_output_34_0 );
			float2 uv_TexCoord72 = i.uv_texcoord + temp_output_41_0;
			float4 tex2DNode84 = tex2D( _MainTex, ( ( uv_TexCoord72 + WiggleVar136 ) / float2( 2,2 ) ) );
			float2 uv_TexCoord67 = i.uv_texcoord + -temp_output_41_0;
			float4 tex2DNode80 = tex2D( _MainTex, ( ( uv_TexCoord67 + WiggleVar136 ) / float2( 2,2 ) ) );
			float cameraDepthFade7 = (( i.eyeDepth -_ProjectionParams.y - _Float5 ) / _Float6);
			float smoothstepResult10 = smoothstep( _Float7 , _Float8 , cameraDepthFade7);
			float cameraDepthFade3 = (( i.eyeDepth -_ProjectionParams.y - _Float4 ) / _Float3);
			o.Emission = ( ( ( _Color0 * ( ( ( tex2DNode83 + tex2DNode88 + tex2DNode81 + tex2DNode85 + myVarName73 ) + ( tex2DNode82 + tex2DNode87 + tex2DNode86 + tex2DNode91 + myVarName73 ) + ( tex2DNode89 + tex2DNode78 + tex2DNode92 + tex2DNode76 + myVarName73 ) + ( tex2DNode75 + tex2DNode90 + tex2DNode84 + tex2DNode80 + myVarName73 ) ) / 16.0 ) ) + ( smoothstepResult10 * _Color1 ) ) * saturate( ( cameraDepthFade3 + ( ( 1.0 - cameraDepthFade3 ) * _ForegroundColor ) ) ) ).rgb;
			o.Alpha = ( ( ( tex2DNode83.a + tex2DNode88.a + tex2DNode81.a + tex2DNode85.a ) + ( tex2DNode82.a + tex2DNode87.a + tex2DNode86.a + tex2DNode91.a ) + ( tex2DNode89.a + tex2DNode78.a + tex2DNode92.a + tex2DNode76.a ) + ( tex2DNode75.a + tex2DNode90.a + tex2DNode84.a + tex2DNode80.a ) ) / 16.0 );
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
240;276;1387;709;5658.128;-1494.951;1.654069;True;False
Node;AmplifyShaderEditor.WorldPosInputsNode;112;-4845.383,1379.705;Float;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector2Node;189;-4892.439,1732.072;Float;False;Constant;_InfluenceGradient;InfluenceGradient;29;0;Create;True;0;0;False;0;1,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;117;-4596.652,1734.596;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;115;-4813.512,2045.353;Float;False;Property;_FlickerSpeed;FlickerSpeed;5;0;Create;True;0;0;False;0;0.2;0.01;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;116;-4546.035,1636.634;Float;False;Property;_NoiseScale;NoiseScale;3;0;Create;True;0;0;False;0;-0.05;0.0005;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;113;-4579.602,1405.156;Float;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;114;-4649.119,1558.653;Float;False;Property;_WorldPosMultiplier;WorldPosMultiplier;9;0;Create;True;0;0;False;0;0.001;0.002;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;118;-4474.431,1978.024;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;120;-4364.027,1500.634;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;121;-4403.069,2148.186;Float;False;Property;_timeScale;timeScale;7;0;Create;True;0;0;False;0;-1;1.96;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;119;-4358.231,1710.492;Float;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;123;-4152.902,2099.985;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;124;-4267.018,1898.605;Float;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;122;-4139.256,1664.24;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.PannerNode;125;-3862.131,1935.05;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;1,0.5;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;128;-3644.873,1778.379;Float;False;Constant;_Color2;Color 2;8;0;Create;True;0;0;False;0;0.5019608,0.5019608,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;127;-3742.101,2232.629;Float;False;Property;_WobbleScale;WobbleScale;12;0;Create;True;0;0;False;0;0.71;0.823;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;126;-3683.665,2005.926;Float;True;Property;_Noise;Noise;1;0;Create;True;0;0;False;0;80445246cc51bc649a90911a060ce7ca;a9632794e416b2a428fad300fdd6fe7c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;19;-2802.312,-3334.235;Float;False;Property;_Float1;Float 1;20;0;Create;True;0;0;False;0;0;20.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;129;-3315.536,2032.372;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-2811.447,-3431.075;Float;False;Property;_Float2;Float 2;10;0;Create;True;0;0;False;0;0;22;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;130;-3060.283,2057.26;Float;False;True;True;False;False;1;0;COLOR;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CameraDepthFade;21;-2621.123,-3421.604;Float;False;3;2;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;22;-2625.327,-3189.121;Float;True;Property;_BlurAmount;BlurAmount;14;0;Create;True;0;0;False;0;0.01;40;0;40;0;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;23;-2323.846,-3436.311;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;18;-1489.073,-6217.449;Float;False;2373.493;1433.292;Love side to side;24;104;95;88;85;83;81;68;65;60;53;49;39;36;29;2;1;185;186;187;188;155;156;157;158;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;132;-2824.757,2060.745;Float;False;2;0;FLOAT2;-0.5,-0.5;False;1;FLOAT2;0.5,0.5;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;131;-2882.405,1756.435;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;34;-2188.668,-3342.13;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;133;-2576.092,2003.101;Float;False;3;3;0;FLOAT;0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;33;-1319.186,-3406.974;Float;False;Constant;_Vector2;Vector 2;1;0;Create;True;0;0;False;0;0,0.0005;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;31;-1478.146,-361.7776;Float;False;Constant;_Vector5;Vector 5;1;0;Create;True;0;0;False;0;-0.0005,0.0005;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;28;-1295.213,-1919.37;Float;False;Constant;_Vector7;Vector 7;1;0;Create;True;0;0;False;0;-0.001,0.001;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;36;-1367.012,-5289.315;Float;False;Constant;_Vector1;Vector 1;1;0;Create;True;0;0;False;0;0,0.001;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;32;-1270.147,-2521.381;Float;False;Constant;_Vector4;Vector 4;1;0;Create;True;0;0;False;0;0.001,0.001;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;27;-1397.763,-4427.904;Float;False;Constant;_Vector3;Vector 3;1;0;Create;True;0;0;False;0;0.0005,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;29;-1311.946,-5877.327;Float;False;Constant;_Vector0;Vector 0;1;0;Create;True;0;0;False;0;0.001,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;35;-1401.972,-907.5125;Float;False;Constant;_Vector6;Vector 6;1;0;Create;True;0;0;False;0;0.0005,0.0005;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;37;-1090.616,-4332.105;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;46;-1054.069,-976.1597;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;43;-1086.491,-1904.595;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;48;-1057.951,-2496.087;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;41;-1077.981,13.25635;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1;-1099.751,-5854.032;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;-1128.29,-5260.541;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;38;-1114.529,-3342.69;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;134;-2383.302,1956.214;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NegateNode;49;-864.4564,-5079.806;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;136;-2151.748,1942.528;Float;False;WiggleVar;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NegateNode;55;-867.7774,-802.9275;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NegateNode;53;-913.4594,-5678.801;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NegateNode;57;-894.7958,-1752.714;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;26;-3630.275,578.1445;Float;False;Property;_Vector9;Vector 9;16;0;Create;True;0;0;False;0;0.2,0.2;0.05,0.05;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;24;-3701.488,1025.511;Float;False;Property;_Vector11;Vector 11;15;0;Create;True;0;0;False;0;0.2,0.2;0.05,0.01;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.NegateNode;50;-964.6954,-3198.954;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;30;-3626.275,322.1445;Float;False;Property;_Vector10;Vector 10;19;0;Create;True;0;0;False;0;0.2,0.2;0.01,0.01;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;25;-3628.8,66.22754;Float;False;Property;_Vector8;Vector 8;18;0;Create;True;0;0;False;0;0.2,0.2;0.002,0.002;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.NegateNode;52;-902.1484,162.9924;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NegateNode;54;-904.3254,-4158.874;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NegateNode;56;-938.0777,-2320.473;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;2;-710.4783,-6043.584;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0.17,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;70;-673.7634,-1776.177;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0.59,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;45;-3305.873,840.9233;Float;False;Property;_TexInfluence;TexInfluence;28;0;Create;True;0;0;False;0;1;-3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TriplanarNode;47;-3458.304,26.95752;Float;True;Spherical;World;False;Top Texture 0;_TopTexture0;white;0;Assets/_MyStuff/Sprites/4bf9a3477bd635c0d02fab3e7d44b92f.jpg;Mid Texture 0;_MidTexture0;white;-1;None;Bot Texture 0;_BotTexture0;white;-1;None;Triplanar Sampler;False;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT2;1,1;False;4;FLOAT;1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;67;-639.2543,136.6746;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0.59,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;58;-672.3004,-2375.172;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0.59,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;61;-704.9654,-4211.191;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0.59,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;66;-664.7964,-1165.712;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0.17,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;60;-711.9424,-5437.458;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0.17,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;72;-661.6343,-163.6616;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0.17,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TriplanarNode;42;-3439.708,967.3555;Float;True;Spherical;World;False;Top Texture 3;_TopTexture3;white;4;Assets/AmplifyShaderEditor/Examples/Assets/Textures/Misc/Checkers.png;Mid Texture 3;_MidTexture3;white;-1;None;Bot Texture 3;_BotTexture3;white;-1;None;Triplanar Sampler;False;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT2;1,1;False;4;FLOAT;1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;62;-701.3444,-4521.658;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0.17,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TriplanarNode;40;-3455.779,282.8755;Float;True;Spherical;World;False;Top Texture 1;_TopTexture1;white;11;Assets/AmplifyShaderEditor/Examples/Assets/Textures/Misc/AnisoMap.jpg;Mid Texture 1;_MidTexture1;white;-1;None;Bot Texture 1;_BotTexture1;white;-1;None;Triplanar Sampler;False;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT2;1,1;False;4;FLOAT;1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;71;-668.6794,-2685.638;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0.17,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;63;-670.1434,-2081.514;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0.17,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;59;-668.4184,-855.2456;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0.59,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;74;-698.1813,-3519.608;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0.17,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;137;-612.9121,-2891.146;Float;False;136;WiggleVar;1;0;OBJECT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;65;-714.0994,-5731.119;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0.59,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TriplanarNode;44;-3459.779,538.8755;Float;True;Spherical;World;False;Top Texture 2;_TopTexture2;white;6;Assets/AmplifyShaderEditor/Examples/Assets/Textures/Misc/Checkers.png;Mid Texture 2;_MidTexture2;white;-1;None;Bot Texture 2;_BotTexture2;white;-1;None;Triplanar Sampler;False;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT2;1,1;False;4;FLOAT;1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;64;-707.0544,-3214.272;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0.59,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;68;-715.5634,-5132.124;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0.59,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;170;5.633301,42.81226;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;166;35.83179,-1733.371;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;168;31.31763,-658.3705;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;169;-53.01953,-246.3997;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;163;-94.98219,-2603.474;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;157;-81.83081,-5317.1;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;158;-95.66235,-5001.077;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;167;17.55833,-928.7405;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;160;-60.64136,-4041.673;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;155;-113.6521,-5884.345;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;156;-59.33594,-5631.123;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;164;-50.50391,-2317.295;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;161;-87.09709,-3657.116;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;165;-29.18799,-2006.43;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;162;-100.4832,-3306.006;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;51;-2962.027,93.5105;Float;True;5;5;0;FLOAT;0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT4;0,0,0,0;False;3;FLOAT;0;False;4;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;159;-103.1567,-4253.074;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;183;81.2761,-4018.783;Float;False;2;0;FLOAT2;0,0;False;1;FLOAT2;2,2;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;185;57.60194,-5014.002;Float;False;2;0;FLOAT2;0,0;False;1;FLOAT2;2,2;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;174;154.0181,3.295044;Float;False;2;0;FLOAT2;0,0;False;1;FLOAT2;2,2;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;173;128.2645,-257.3542;Float;False;2;0;FLOAT2;0,0;False;1;FLOAT2;2,2;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;186;50.25417,-5310.633;Float;False;2;0;FLOAT2;0,0;False;1;FLOAT2;2,2;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;73;-2439.316,71.58643;Float;False;myVarName;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;177;191.7627,-1739.215;Float;False;2;0;FLOAT2;0,0;False;1;FLOAT2;2,2;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;175;135.5228,-919.3071;Float;False;2;0;FLOAT2;0,0;False;1;FLOAT2;2,2;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;171;151.6475,-609.9415;Float;False;2;0;FLOAT2;0,0;False;1;FLOAT2;2,2;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;184;81.27614,-4241.633;Float;False;2;0;FLOAT2;0,0;False;1;FLOAT2;2,2;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;178;163.5181,-2001.21;Float;False;2;0;FLOAT2;0,0;False;1;FLOAT2;2,2;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;179;141.5181,-2305.21;Float;False;2;0;FLOAT2;0,0;False;1;FLOAT2;2,2;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;182;101.2328,-3649.588;Float;False;2;0;FLOAT2;0,0;False;1;FLOAT2;2,2;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;181;97.51807,-3333.21;Float;False;2;0;FLOAT2;0,0;False;1;FLOAT2;2,2;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;180;106.5181,-2582.21;Float;False;2;0;FLOAT2;0,0;False;1;FLOAT2;2,2;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;188;22.27586,-5878.415;Float;False;2;0;FLOAT2;0,0;False;1;FLOAT2;2,2;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;69;-271.7313,-2933.237;Float;True;Property;_MainTex;MainTex;2;0;Create;True;0;0;False;0;None;None;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;187;58.58025,-5634.306;Float;False;2;0;FLOAT2;0,0;False;1;FLOAT2;2,2;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;87;224.2108,-3999.992;Float;True;Property;_TextureSample7;Texture Sample 7;6;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;75;256.0276,-902.0715;Float;True;Property;_TextureSample9;Texture Sample 9;4;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;89;270.6537,-2616.334;Float;True;Property;_TextureSample10;Texture Sample 10;1;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;91;227.3739,-3418.668;Float;True;Property;_TextureSample5;Texture Sample 5;5;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;93;235.6989,-3020.261;Float;True;73;myVarName;1;0;OBJECT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SamplerNode;84;264.3215,-336.1406;Float;True;Property;_TextureSample12;Texture Sample 12;3;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;79;1988.685,-3415.232;Float;False;Property;_Float4;Float 4;25;0;Create;True;0;0;False;0;0;6.8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;80;269.1736,-62.72144;Float;True;Property;_TextureSample14;Texture Sample 14;5;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;85;186.7926,-5080.835;Float;True;Property;_TextureSample3;Texture Sample 3;2;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;90;266.0104,-644.0457;Float;True;Property;_TextureSample8;Texture Sample 8;6;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;92;278.9475,-2050.403;Float;True;Property;_TextureSample13;Texture Sample 13;1;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;82;214.228,-4258.018;Float;True;Property;_TextureSample6;Texture Sample 6;4;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;81;181.9406,-5354.254;Float;True;Property;_TextureSample2;Texture Sample 2;1;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;88;183.6295,-5662.158;Float;True;Property;_TextureSample1;Texture Sample 1;2;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;78;280.6365,-2358.308;Float;True;Property;_TextureSample15;Texture Sample 15;2;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;83;173.6467,-5920.185;Float;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;86;222.5219,-3692.087;Float;True;Property;_TextureSample4;Texture Sample 4;3;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;77;2010.248,-3485.67;Float;False;Property;_Float3;Float 3;24;0;Create;True;0;0;False;0;0;7.9;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;76;371.3542,-1753.727;Float;True;Property;_TextureSample11;Texture Sample 11;2;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;97;1983.187,-4052.288;Float;False;Property;_Float5;Float 5;13;0;Create;True;0;0;False;0;0;10.03;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;95;720.8757,-5253.49;Float;False;5;5;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;FLOAT4;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;99;787.0699,-747.6206;Float;False;5;5;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;FLOAT4;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;98;1974.052,-4149.128;Float;False;Property;_Float6;Float 6;8;0;Create;True;0;0;False;0;0;56.9;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;96;745.2703,-4103.566;Float;False;5;5;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;FLOAT4;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CameraDepthFade;3;2221.156,-3541.337;Float;False;3;2;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;94;863.1663,-2315.146;Float;False;5;5;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;FLOAT4;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;4;2259.206,-3323.064;Float;False;Property;_ForegroundColor;ForegroundColor;23;0;Create;True;0;0;False;0;0.4094874,0.6091207,0.8113208,0;0.5660378,0.5232416,0.4298683,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CameraDepthFade;7;2164.376,-4141.656;Float;False;3;2;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;6;2220.772,-3972.666;Float;False;Property;_Float7;Float 7;26;0;Create;True;0;0;False;0;0;0.25;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;100;1501.143,-3274.789;Float;False;4;4;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;101;1539.3,-2943.137;Float;True;Constant;_Float0;Float 0;2;0;Create;True;0;0;False;0;16;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;5;2470.249,-3576.42;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;8;2217.811,-3897.18;Float;False;Property;_Float8;Float 8;27;0;Create;True;0;0;False;0;0;0.55;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;11;2263.015,-3825.394;Float;False;Property;_Color1;Color 1;21;0;Create;True;0;0;False;0;0.4094874,0.6091207,0.8113208,0;0.390308,0.4020675,0.4622642,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;2836.254,-3639.671;Float;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;102;1693.957,-3504.806;Float;False;Property;_Color0;Color 0;22;0;Create;True;0;0;False;0;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleDivideOpNode;103;1811.306,-3079.399;Float;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;10;2422.608,-3996.166;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;107;861.3942,-1898.677;Float;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;106;1994.339,-3146.724;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;105;775.1232,-411.2065;Float;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;104;699.6964,-5040.8;Float;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;2582.491,-3988.097;Float;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;13;3059.69,-3668.892;Float;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;108;733.3237,-3767.153;Float;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;109;1516.309,-2581.268;Float;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;15;3057.245,-4017.407;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;14;3293.106,-3733.215;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;17;2506.705,-4260.835;Float;True;Property;_TextureSample16;Texture Sample 16;17;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;110;-2670.491,80.38354;Float;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;3432.398,-3920.882;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;111;1799.498,-2911.14;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;3983.335,-4088.954;Float;False;True;2;Float;ASEMaterialInspector;0;0;Unlit;GrassWiggleDepth;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;5;True;True;0;False;Transparent;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;117;0;189;0
WireConnection;113;0;112;1
WireConnection;113;1;112;2
WireConnection;113;2;112;3
WireConnection;118;0;115;0
WireConnection;120;0;113;0
WireConnection;120;1;114;0
WireConnection;119;0;116;0
WireConnection;119;1;117;0
WireConnection;123;0;121;0
WireConnection;124;0;118;0
WireConnection;124;1;118;0
WireConnection;124;2;118;0
WireConnection;122;0;120;0
WireConnection;122;1;119;0
WireConnection;125;0;122;0
WireConnection;125;2;124;0
WireConnection;125;1;123;0
WireConnection;126;1;125;0
WireConnection;129;0;128;0
WireConnection;129;1;126;0
WireConnection;129;2;127;0
WireConnection;130;0;129;0
WireConnection;21;0;20;0
WireConnection;21;1;19;0
WireConnection;23;0;21;0
WireConnection;132;0;130;0
WireConnection;34;0;23;0
WireConnection;34;1;22;0
WireConnection;133;0;131;2
WireConnection;133;1;132;0
WireConnection;133;2;131;2
WireConnection;37;0;27;0
WireConnection;37;1;34;0
WireConnection;46;0;35;0
WireConnection;46;1;34;0
WireConnection;43;0;28;0
WireConnection;43;1;34;0
WireConnection;48;0;32;0
WireConnection;48;1;34;0
WireConnection;41;0;31;0
WireConnection;41;1;34;0
WireConnection;1;0;29;0
WireConnection;1;1;34;0
WireConnection;39;0;36;0
WireConnection;39;1;34;0
WireConnection;38;0;33;0
WireConnection;38;1;34;0
WireConnection;134;0;131;0
WireConnection;134;1;133;0
WireConnection;49;0;39;0
WireConnection;136;0;134;0
WireConnection;55;0;46;0
WireConnection;53;0;1;0
WireConnection;57;0;43;0
WireConnection;50;0;38;0
WireConnection;52;0;41;0
WireConnection;54;0;37;0
WireConnection;56;0;48;0
WireConnection;2;1;1;0
WireConnection;70;1;57;0
WireConnection;47;3;25;0
WireConnection;67;1;52;0
WireConnection;58;1;56;0
WireConnection;61;1;54;0
WireConnection;66;1;46;0
WireConnection;60;1;39;0
WireConnection;72;1;41;0
WireConnection;42;3;24;0
WireConnection;62;1;37;0
WireConnection;40;3;30;0
WireConnection;71;1;48;0
WireConnection;63;1;43;0
WireConnection;59;1;55;0
WireConnection;74;1;38;0
WireConnection;65;1;53;0
WireConnection;44;3;26;0
WireConnection;64;1;50;0
WireConnection;68;1;49;0
WireConnection;170;0;67;0
WireConnection;170;1;137;0
WireConnection;166;0;70;0
WireConnection;166;1;137;0
WireConnection;168;0;59;0
WireConnection;168;1;137;0
WireConnection;169;0;72;0
WireConnection;169;1;137;0
WireConnection;163;0;71;0
WireConnection;163;1;137;0
WireConnection;157;0;60;0
WireConnection;157;1;137;0
WireConnection;158;0;68;0
WireConnection;158;1;137;0
WireConnection;167;0;66;0
WireConnection;167;1;137;0
WireConnection;160;0;61;0
WireConnection;160;1;137;0
WireConnection;155;0;2;0
WireConnection;155;1;137;0
WireConnection;156;0;65;0
WireConnection;156;1;137;0
WireConnection;164;0;58;0
WireConnection;164;1;137;0
WireConnection;161;0;74;0
WireConnection;161;1;137;0
WireConnection;165;0;63;0
WireConnection;165;1;137;0
WireConnection;162;0;64;0
WireConnection;162;1;137;0
WireConnection;51;0;47;1
WireConnection;51;1;40;0
WireConnection;51;2;44;0
WireConnection;51;3;45;0
WireConnection;51;4;42;0
WireConnection;159;0;62;0
WireConnection;159;1;137;0
WireConnection;183;0;160;0
WireConnection;185;0;158;0
WireConnection;174;0;170;0
WireConnection;173;0;169;0
WireConnection;186;0;157;0
WireConnection;73;0;51;0
WireConnection;177;0;166;0
WireConnection;175;0;167;0
WireConnection;171;0;168;0
WireConnection;184;0;159;0
WireConnection;178;0;165;0
WireConnection;179;0;164;0
WireConnection;182;0;161;0
WireConnection;181;0;162;0
WireConnection;180;0;163;0
WireConnection;188;0;155;0
WireConnection;187;0;156;0
WireConnection;87;0;69;0
WireConnection;87;1;183;0
WireConnection;75;0;69;0
WireConnection;75;1;175;0
WireConnection;89;0;69;0
WireConnection;89;1;180;0
WireConnection;91;0;69;0
WireConnection;91;1;181;0
WireConnection;84;0;69;0
WireConnection;84;1;173;0
WireConnection;80;0;69;0
WireConnection;80;1;174;0
WireConnection;85;0;69;0
WireConnection;85;1;185;0
WireConnection;90;0;69;0
WireConnection;90;1;171;0
WireConnection;92;0;69;0
WireConnection;92;1;178;0
WireConnection;82;0;69;0
WireConnection;82;1;184;0
WireConnection;81;0;69;0
WireConnection;81;1;186;0
WireConnection;88;0;69;0
WireConnection;88;1;187;0
WireConnection;78;0;69;0
WireConnection;78;1;179;0
WireConnection;83;0;69;0
WireConnection;83;1;188;0
WireConnection;86;0;69;0
WireConnection;86;1;182;0
WireConnection;76;0;69;0
WireConnection;76;1;177;0
WireConnection;95;0;83;0
WireConnection;95;1;88;0
WireConnection;95;2;81;0
WireConnection;95;3;85;0
WireConnection;95;4;93;0
WireConnection;99;0;75;0
WireConnection;99;1;90;0
WireConnection;99;2;84;0
WireConnection;99;3;80;0
WireConnection;99;4;93;0
WireConnection;96;0;82;0
WireConnection;96;1;87;0
WireConnection;96;2;86;0
WireConnection;96;3;91;0
WireConnection;96;4;93;0
WireConnection;3;0;77;0
WireConnection;3;1;79;0
WireConnection;94;0;89;0
WireConnection;94;1;78;0
WireConnection;94;2;92;0
WireConnection;94;3;76;0
WireConnection;94;4;93;0
WireConnection;7;0;98;0
WireConnection;7;1;97;0
WireConnection;100;0;95;0
WireConnection;100;1;96;0
WireConnection;100;2;94;0
WireConnection;100;3;99;0
WireConnection;5;0;3;0
WireConnection;9;0;5;0
WireConnection;9;1;4;0
WireConnection;103;0;100;0
WireConnection;103;1;101;0
WireConnection;10;0;7;0
WireConnection;10;1;6;0
WireConnection;10;2;8;0
WireConnection;107;0;89;4
WireConnection;107;1;78;4
WireConnection;107;2;92;4
WireConnection;107;3;76;4
WireConnection;106;0;102;0
WireConnection;106;1;103;0
WireConnection;105;0;75;4
WireConnection;105;1;90;4
WireConnection;105;2;84;4
WireConnection;105;3;80;4
WireConnection;104;0;83;4
WireConnection;104;1;88;4
WireConnection;104;2;81;4
WireConnection;104;3;85;4
WireConnection;12;0;10;0
WireConnection;12;1;11;0
WireConnection;13;0;3;0
WireConnection;13;1;9;0
WireConnection;108;0;82;4
WireConnection;108;1;87;4
WireConnection;108;2;86;4
WireConnection;108;3;91;4
WireConnection;109;0;104;0
WireConnection;109;1;108;0
WireConnection;109;2;107;0
WireConnection;109;3;105;0
WireConnection;15;0;106;0
WireConnection;15;1;12;0
WireConnection;14;0;13;0
WireConnection;110;0;51;0
WireConnection;16;0;15;0
WireConnection;16;1;14;0
WireConnection;111;0;109;0
WireConnection;111;1;101;0
WireConnection;0;2;16;0
WireConnection;0;9;111;0
ASEEND*/
//CHKSM=367FFD341901096EBFD5DE3B3767A7224E1BF346