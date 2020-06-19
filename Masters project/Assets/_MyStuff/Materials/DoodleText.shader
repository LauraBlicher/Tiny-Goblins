// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "DoodleText"
{
	Properties
	{
		_WobbleAmount("WobbleAmount", Float) = 0.3
		_MainTex("MainTex", 2D) = "white" {}
		_Vector4("Vector 4", Vector) = (0.001,0.001,0,0)
		_TextureSample1("Texture Sample 1", 2D) = "bump" {}
		_NoiseAmount("NoiseAmount", Float) = -0.05
		_FlickerSpeed("FlickerSpeed", Float) = 0.2
		_WorldPosEffect("WorldPosEffect", Float) = 0.001
		_FrameRate("FrameRate", Float) = 1
		_WobbleScale("WobbleScale", Range( 0 , 1)) = 0.71
		[HDR]_Color1("Color 1", Color) = (0,0,0,0)
		[Toggle]_Outline("Outline", Float) = 1
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

		uniform float _Outline;
		uniform sampler2D _MainTex;
		uniform float2 _Vector4;
		uniform sampler2D _TextureSample1;
		uniform float _FrameRate;
		uniform float _WobbleAmount;
		uniform float _FlickerSpeed;
		uniform float _WorldPosEffect;
		uniform float _NoiseAmount;
		uniform float4 _MainTex_ST;
		uniform float _WobbleScale;
		uniform float4 _Color1;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_TexCoord25 = i.uv_texcoord + _Vector4;
			float4 color20 = IsGammaSpace() ? float4(0.5019608,0.5019608,1,0) : float4(0.2158605,0.2158605,1,0);
			float4 appendResult16 = (float4(-_FlickerSpeed , -_FlickerSpeed , 0.0 , 0.0));
			float3 ase_worldPos = i.worldPos;
			float4 appendResult6 = (float4(ase_worldPos.x , ase_worldPos.y , ase_worldPos.z , 0.0));
			float2 uv0_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float2 panner18 = ( ( round( ( _FrameRate * _Time.y ) ) * _WobbleAmount ) * appendResult16.xy + ( ( appendResult6 * _WorldPosEffect ) + float4( ( _NoiseAmount * uv0_MainTex ), 0.0 , 0.0 ) ).xy);
			float4 lerpResult22 = lerp( color20 , float4( UnpackNormal( tex2D( _TextureSample1, panner18 ) ) , 0.0 ) , _WobbleScale);
			float4 tex2DNode27 = tex2D( _MainTex, ( uv_TexCoord25 + ( (lerpResult22).rg - float2( 0.5,0.5 ) ) ) );
			o.Emission = lerp(( tex2DNode27.a + _Color1 ),( _Color1 * tex2DNode27.a ),_Outline).rgb;
			o.Alpha = tex2DNode27.a;
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
0;27;1245;672;-604.5823;499.9567;1;True;False
Node;AmplifyShaderEditor.WorldPosInputsNode;1;-1333.997,-409.1078;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;3;-938.4573,596.2438;Float;False;Property;_FrameRate;FrameRate;8;0;Create;True;0;0;False;0;1;3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;2;-959.4573,733.2438;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-1118.012,289.6593;Float;False;Property;_FlickerSpeed;FlickerSpeed;5;0;Create;True;0;0;False;0;0.2;0.01;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;6;-1139.51,-395.878;Float;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;5;-1504.334,-52.64581;Float;True;0;27;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;9;-1105.942,-164.4011;Float;False;Property;_NoiseAmount;NoiseAmount;4;0;Create;True;0;0;False;0;-0.05;0.01;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-1148.934,-244.4005;Float;False;Property;_WorldPosEffect;WorldPosEffect;7;0;Create;True;0;0;False;0;0.001;0.002;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;-751.4572,626.2438;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;-923.9337,-300.4005;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-422.2751,763.9127;Float;False;Property;_WobbleAmount;WobbleAmount;0;0;Create;True;0;0;False;0;0.3;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;11;-895.7244,220.2904;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RoundOpNode;14;-592.3762,576.3846;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;-918.1378,-90.54323;Float;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;17;-732.7737,-140.8685;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DynamicAppendNode;16;-745.5292,193.2196;Float;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;-412.6911,454.879;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;18;-532.8061,91.02747;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;1,0.5;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;20;-477.2244,-194.5173;Float;False;Constant;_Color0;Color 0;8;0;Create;True;0;0;False;0;0.5019608,0.5019608,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;21;-519.2243,-58.51735;Float;False;Property;_WobbleScale;WobbleScale;9;0;Create;True;0;0;False;0;0.71;0.021;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;19;-351.3343,63.50766;Float;True;Property;_TextureSample1;Texture Sample 1;3;0;Create;True;0;0;False;0;80445246cc51bc649a90911a060ce7ca;f5453dca2ac649e4182c56a3966ad395;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;22;-53.7713,-143.1382;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector2Node;32;148.9912,-360.819;Float;False;Property;_Vector4;Vector 4;2;0;Create;True;0;0;False;0;0.001,0.001;0.01,0.01;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.ComponentMaskNode;23;220.2852,65.16061;Float;True;True;True;False;False;1;0;COLOR;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;25;363.5582,-270.8131;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;24;455.4804,44.05777;Float;True;2;0;FLOAT2;-0.5,-0.5;False;1;FLOAT2;0.5,0.5;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;26;675.4857,-77.50278;Float;True;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;31;981.9044,-324.704;Float;False;Property;_Color1;Color 1;10;1;[HDR];Create;True;0;0;False;0;0,0,0,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;27;917.9544,-96.25657;Float;True;Property;_MainTex;MainTex;1;0;Create;True;0;0;False;0;8a9d0b74ea0537641a4e7cbb6a6baed7;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;1302.377,-84.18246;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;34;1304.582,-206.9567;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleTimeNode;28;-737.0913,335.8904;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;33;531.401,-633.9246;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0.17,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;29;-916.8063,384.0905;Float;False;Property;_Float3;Float 3;6;0;Create;True;0;0;False;0;-1;0.8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;35;1474.582,-167.9567;Float;False;Property;_Outline;Outline;11;0;Create;True;0;0;False;0;1;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1690.302,-212.1096;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;DoodleText;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;6;0;1;1
WireConnection;6;1;1;2
WireConnection;6;2;1;3
WireConnection;7;0;3;0
WireConnection;7;1;2;0
WireConnection;13;0;6;0
WireConnection;13;1;8;0
WireConnection;11;0;4;0
WireConnection;14;0;7;0
WireConnection;12;0;9;0
WireConnection;12;1;5;0
WireConnection;17;0;13;0
WireConnection;17;1;12;0
WireConnection;16;0;11;0
WireConnection;16;1;11;0
WireConnection;15;0;14;0
WireConnection;15;1;10;0
WireConnection;18;0;17;0
WireConnection;18;2;16;0
WireConnection;18;1;15;0
WireConnection;19;1;18;0
WireConnection;22;0;20;0
WireConnection;22;1;19;0
WireConnection;22;2;21;0
WireConnection;23;0;22;0
WireConnection;25;1;32;0
WireConnection;24;0;23;0
WireConnection;26;0;25;0
WireConnection;26;1;24;0
WireConnection;27;1;26;0
WireConnection;30;0;31;0
WireConnection;30;1;27;4
WireConnection;34;0;27;4
WireConnection;34;1;31;0
WireConnection;28;0;29;0
WireConnection;35;0;34;0
WireConnection;35;1;30;0
WireConnection;0;2;35;0
WireConnection;0;9;27;4
ASEEND*/
//CHKSM=1FFA73BBCE2B76BF0689AB3C388E7A4382CA41CD