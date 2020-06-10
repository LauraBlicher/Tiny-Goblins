// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "SpeechBubble"
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
		_Image("Image", 2D) = "white" {}
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_FadeIn("FadeIn", Range( 0 , 2)) = 1.939624
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
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
		};

		uniform sampler2D _Image;
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
		uniform sampler2D _TextureSample0;
		uniform float4 _TextureSample0_ST;
		uniform float _FadeIn;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 uv0_TextureSample2 = i.uv_texcoord * _TextureSample2_ST.xy + _TextureSample2_ST.zw;
			float4 color42 = IsGammaSpace() ? float4(0.5019608,0.5019608,1,0) : float4(0.2158605,0.2158605,1,0);
			float4 appendResult23 = (float4(-_FlickerSpeed , -_FlickerSpeed , 0.0 , 0.0));
			float3 ase_worldPos = i.worldPos;
			float4 appendResult18 = (float4(ase_worldPos.x , ase_worldPos.y , ase_worldPos.z , 0.0));
			float2 uv0_TextureSample1 = i.uv_texcoord * _TextureSample1_ST.xy + _TextureSample1_ST.zw;
			float2 panner26 = ( ( round( ( _FrameRate * _Time.y ) ) * _WobbleAmount ) * appendResult23.xy + ( ( appendResult18 * _WorldPosEffect ) + float4( ( _NoiseAmount * uv0_TextureSample1 ), 0.0 , 0.0 ) ).xy);
			float4 lerpResult43 = lerp( color42 , float4( UnpackNormal( tex2D( _TextureSample1, panner26 ) ) , 0.0 ) , _WobbleScale);
			float2 temp_output_32_0 = ( uv0_TextureSample2 + ( (lerpResult43).rg - float2( 0.5,0.5 ) ) );
			float4 tex2DNode33 = tex2D( _TextureSample2, temp_output_32_0 );
			float4 temp_cast_4 = (0.6).xxxx;
			float4 color97 = IsGammaSpace() ? float4(0,0,0,0) : float4(0,0,0,0);
			float2 uv_TextureSample0 = i.uv_texcoord * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
			float4 lerpResult94 = lerp( color97 , ( 1.0 - tex2D( _TextureSample0, uv_TextureSample0 ) ) , _FadeIn);
			float4 color101 = IsGammaSpace() ? float4(1,1,1,0) : float4(1,1,1,0);
			float4 lerpResult100 = lerp( lerpResult94 , color101 , ( _FadeIn - 1.0 ));
			float4 temp_cast_5 = (1.0).xxxx;
			float4 ifLocalVar98 = 0;
			if( _FadeIn > 1.0 )
				ifLocalVar98 = lerpResult100;
			else if( _FadeIn < 1.0 )
				ifLocalVar98 = lerpResult94;
			float4 temp_output_105_0 = ( step( ( 1.0 - lerpResult100 ) , temp_cast_5 ) * ifLocalVar98 );
			o.Emission = ( 1.0 - ( tex2D( _Image, temp_output_32_0 ).a * tex2DNode33.r * step( temp_cast_4 , temp_output_105_0 ) ) ).rgb;
			float4 temp_cast_7 = (1.0).xxxx;
			o.Alpha = ( tex2DNode33.a * temp_output_105_0 ).r;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Unlit alpha:fade keepalpha fullforwardshadows 

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
7;6;1895;1013;520.7271;313.6725;1;True;False
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
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;-1704.545,97.45752;Float;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NegateNode;20;-1730.264,345.7193;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RoundOpNode;4;-1426.916,701.8134;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;-1710.341,-112.3997;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DynamicAppendNode;23;-1580.069,318.6485;Float;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;24;-1519.181,47.1323;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;-1247.231,580.3078;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;93;-1551.192,1421.573;Float;True;Property;_TextureSample0;Texture Sample 0;10;0;Create;True;0;0;False;0;None;1c27a16fdfa8a56478137ad2d8008ee8;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;103;-1146.022,1880.181;Float;False;Constant;_Float5;Float 5;12;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;26;-1367.346,216.4563;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;1,0.5;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;95;-1467.365,1725.059;Float;False;Property;_FadeIn;FadeIn;11;0;Create;True;0;0;False;0;1.939624;2;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;97;-1160.951,1163.817;Float;False;Constant;_Color3;Color 3;12;0;Create;True;0;0;False;0;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;96;-1266.671,1427.785;Float;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;102;-921.022,1864.181;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;101;-840.8868,1197.179;Float;False;Constant;_Color4;Color 4;12;0;Create;True;0;0;False;0;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;94;-951.8478,1428.151;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;27;-1185.874,188.9365;Float;True;Property;_TextureSample1;Texture Sample 1;2;0;Create;True;0;0;False;0;80445246cc51bc649a90911a060ce7ca;f5453dca2ac649e4182c56a3966ad395;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;42;-1241.024,-91.92497;Float;False;Constant;_Color0;Color 0;8;0;Create;True;0;0;False;0;0.5019608,0.5019608,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;45;-1373.456,64.17113;Float;False;Property;_WobbleScale;WobbleScale;8;0;Create;True;0;0;False;0;0.71;0.1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;43;-1055.632,16.48338;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;100;-516.8867,1211.179;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;106;-282.652,1268.115;Float;False;Constant;_Float6;Float 6;12;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;28;-854.9158,219.4688;Float;True;True;True;False;False;1;0;COLOR;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;99;-454.8867,1636.179;Float;False;Constant;_Float4;Float 4;12;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;108;-251.9857,1155.881;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StepOpNode;104;-116.6521,1184.315;Float;True;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ConditionalIfNode;98;-216.3737,1433.286;Float;True;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;3;FLOAT;0;False;4;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;30;-663.2781,-117.2997;Float;True;0;33;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;29;-599.3651,201.08;Float;True;2;0;FLOAT2;-0.5,-0.5;False;1;FLOAT2;0.5,0.5;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;105;95.24805,1417.315;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;111;-154.4145,1023.449;Float;False;Constant;_Float0;Float 0;12;0;Create;True;0;0;False;0;0.6;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;32;-399.7152,76.8054;Float;True;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;33;-134.8862,72.56362;Float;True;Property;_TextureSample2;Texture Sample 2;1;0;Create;True;0;0;False;0;b660c4345ac92a84b8b5077c2553fd2a;b660c4345ac92a84b8b5077c2553fd2a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StepOpNode;110;191.7242,786.4703;Float;True;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;47;-118.4522,-162.2135;Float;True;Property;_Image;Image;9;0;Create;True;0;0;False;0;None;a20186a90f28e294e8ee5780dde5705c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;48;299.3014,-5.581206;Float;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleTimeNode;25;-1571.631,461.3192;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;49;525.3395,-10.93246;Float;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;109;771.8257,262.659;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;34;-1751.346,509.5193;Float;False;Property;_Float3;Float 3;5;0;Create;True;0;0;False;0;-1;0.8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1028.044,-97.93887;Float;False;True;2;Float;ASEMaterialInspector;0;0;Unlit;SpeechBubble;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;18;0;14;1
WireConnection;18;1;14;2
WireConnection;18;2;14;3
WireConnection;39;0;40;0
WireConnection;39;1;37;0
WireConnection;21;0;16;0
WireConnection;21;1;15;0
WireConnection;20;0;17;0
WireConnection;4;0;39;0
WireConnection;22;0;18;0
WireConnection;22;1;19;0
WireConnection;23;0;20;0
WireConnection;23;1;20;0
WireConnection;24;0;22;0
WireConnection;24;1;21;0
WireConnection;12;0;4;0
WireConnection;12;1;13;0
WireConnection;26;0;24;0
WireConnection;26;2;23;0
WireConnection;26;1;12;0
WireConnection;96;0;93;0
WireConnection;102;0;95;0
WireConnection;102;1;103;0
WireConnection;94;0;97;0
WireConnection;94;1;96;0
WireConnection;94;2;95;0
WireConnection;27;1;26;0
WireConnection;43;0;42;0
WireConnection;43;1;27;0
WireConnection;43;2;45;0
WireConnection;100;0;94;0
WireConnection;100;1;101;0
WireConnection;100;2;102;0
WireConnection;28;0;43;0
WireConnection;108;0;100;0
WireConnection;104;0;108;0
WireConnection;104;1;106;0
WireConnection;98;0;95;0
WireConnection;98;1;99;0
WireConnection;98;2;100;0
WireConnection;98;4;94;0
WireConnection;29;0;28;0
WireConnection;105;0;104;0
WireConnection;105;1;98;0
WireConnection;32;0;30;0
WireConnection;32;1;29;0
WireConnection;33;1;32;0
WireConnection;110;0;111;0
WireConnection;110;1;105;0
WireConnection;47;1;32;0
WireConnection;48;0;47;4
WireConnection;48;1;33;1
WireConnection;48;2;110;0
WireConnection;25;0;34;0
WireConnection;49;0;48;0
WireConnection;109;0;33;4
WireConnection;109;1;105;0
WireConnection;0;2;49;0
WireConnection;0;9;109;0
ASEEND*/
//CHKSM=D6673865B052BDA69C18C172BAC587F447D93BA1