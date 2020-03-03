// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Doodle"
{
	Properties
	{
		_WobbleAmount("WobbleAmount", Float) = 0.3
		_TextureSample2("Texture Sample 2", 2D) = "white" {}
		_TextureSample1("Texture Sample 1", 2D) = "bump" {}
		_NoiseAmount("NoiseAmount", Float) = -0.05
		_FlickerSpeed("FlickerSpeed", Float) = 0.2
		_WorldPosEffect("WorldPosEffect", Float) = 0.001
		_FrameRate("FrameRate", Float) = 1
		_WobbleScale("WobbleScale", Range( 0 , 1)) = 0.71
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
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
		};

		uniform sampler2D _TextureSample2;
		uniform float4 _TextureSample2_ST;
		uniform sampler2D _TextureSample1;
		uniform float _FrameRate;
		uniform float _WobbleAmount;
		uniform float _FlickerSpeed;
		uniform float _WorldPosEffect;
		uniform float _NoiseAmount;
		uniform float4 _TextureSample1_ST;
		uniform float _WobbleScale;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv0_TextureSample2 = i.uv_texcoord * _TextureSample2_ST.xy + _TextureSample2_ST.zw;
			float4 color42 = IsGammaSpace() ? float4(0.5019608,0.5019608,1,0) : float4(0.2158605,0.2158605,1,0);
			float4 appendResult23 = (float4(-_FlickerSpeed , -_FlickerSpeed , 0.0 , 0.0));
			float3 ase_worldPos = i.worldPos;
			float4 appendResult18 = (float4(ase_worldPos.x , ase_worldPos.y , ase_worldPos.z , 0.0));
			float2 uv0_TextureSample1 = i.uv_texcoord * _TextureSample1_ST.xy + _TextureSample1_ST.zw;
			float2 panner26 = ( ( round( ( _FrameRate * _Time.y ) ) * _WobbleAmount ) * appendResult23.xy + ( ( appendResult18 * _WorldPosEffect ) + float4( ( _NoiseAmount * uv0_TextureSample1 ), 0.0 , 0.0 ) ).xy);
			float4 lerpResult43 = lerp( color42 , float4( UnpackNormal( tex2D( _TextureSample1, panner26 ) ) , 0.0 ) , _WobbleScale);
			float4 tex2DNode33 = tex2D( _TextureSample2, ( uv0_TextureSample2 + ( (lerpResult43).rg - float2( 0.5,0.5 ) ) ) );
			o.Emission = tex2DNode33.rgb;
			o.Alpha = tex2DNode33.a;
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
				float3 worldPos : TEXCOORD2;
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
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.worldPos = worldPos;
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
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
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
0;591;1920;428;1976.132;33.0166;1;True;True
Node;AmplifyShaderEditor.WorldPosInputsNode;14;-2120.404,-221.107;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleTimeNode;37;-1793.997,858.6726;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;40;-1772.997,721.6726;Float;False;Property;_FrameRate;FrameRate;7;0;Create;True;0;0;False;0;1;3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-1952.552,415.0881;Float;False;Property;_FlickerSpeed;FlickerSpeed;4;0;Create;True;0;0;False;0;0.2;0.01;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;15;-2050.08,106.4756;Float;True;0;27;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;18;-1925.917,-207.8772;Float;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;-1585.997,751.6726;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-1935.341,-56.39979;Float;False;Property;_WorldPosEffect;WorldPosEffect;6;0;Create;True;0;0;False;0;0.001;0.002;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;16;-1892.349,23.59961;Float;False;Property;_NoiseAmount;NoiseAmount;3;0;Create;True;0;0;False;0;-0.05;0.01;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-1256.815,889.3415;Float;False;Property;_WobbleAmount;WobbleAmount;0;0;Create;True;0;0;False;0;0.3;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;20;-1730.264,345.7193;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;-1704.545,97.45752;Float;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;-1710.341,-112.3997;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RoundOpNode;4;-1426.916,701.8134;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;23;-1580.069,318.6485;Float;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;24;-1519.181,47.1323;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;-1247.231,580.3078;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;26;-1367.346,216.4563;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;1,0.5;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;27;-1185.874,188.9365;Float;True;Property;_TextureSample1;Texture Sample 1;2;0;Create;True;0;0;False;0;80445246cc51bc649a90911a060ce7ca;f5453dca2ac649e4182c56a3966ad395;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;42;-1263.632,-6.516617;Float;False;Constant;_Color0;Color 0;8;0;Create;True;0;0;False;0;0.5019608,0.5019608,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;45;-1305.632,129.4834;Float;False;Property;_WobbleScale;WobbleScale;8;0;Create;True;0;0;False;0;0.71;0.71;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;43;-1055.632,16.48338;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ComponentMaskNode;28;-854.9158,219.4688;Float;True;True;True;False;False;1;0;COLOR;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;29;-599.3651,201.08;Float;True;2;0;FLOAT2;-0.5,-0.5;False;1;FLOAT2;0.5,0.5;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;30;-753.7106,-93.43555;Float;True;0;33;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;32;-399.7152,76.8054;Float;True;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;25;-1571.631,461.3192;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;34;-1751.346,509.5193;Float;False;Property;_Float3;Float 3;5;0;Create;True;0;0;False;0;-1;0.8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;33;-210.2465,70.05161;Float;True;Property;_TextureSample2;Texture Sample 2;1;0;Create;True;0;0;False;0;8a9d0b74ea0537641a4e7cbb6a6baed7;45ea98975d00f49d4a37af20347af491;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;184.6,-5.199999;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;Doodle;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;18;0;14;1
WireConnection;18;1;14;2
WireConnection;18;2;14;3
WireConnection;39;0;40;0
WireConnection;39;1;37;0
WireConnection;20;0;17;0
WireConnection;21;0;16;0
WireConnection;21;1;15;0
WireConnection;22;0;18;0
WireConnection;22;1;19;0
WireConnection;4;0;39;0
WireConnection;23;0;20;0
WireConnection;23;1;20;0
WireConnection;24;0;22;0
WireConnection;24;1;21;0
WireConnection;12;0;4;0
WireConnection;12;1;13;0
WireConnection;26;0;24;0
WireConnection;26;2;23;0
WireConnection;26;1;12;0
WireConnection;27;1;26;0
WireConnection;43;0;42;0
WireConnection;43;1;27;0
WireConnection;43;2;45;0
WireConnection;28;0;43;0
WireConnection;29;0;28;0
WireConnection;32;0;30;0
WireConnection;32;1;29;0
WireConnection;25;0;34;0
WireConnection;33;1;32;0
WireConnection;0;2;33;0
WireConnection;0;9;33;4
ASEEND*/
//CHKSM=59045390C5C38EF8AAB025BE245682EABAD5A3F2