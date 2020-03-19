// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "BlurShader"
{
	Properties
	{
		_MainTex("MainTex", 2D) = "white" {}
		_Float2("Float 2", Float) = 0
		_BlurAmount("BlurAmount", Range( 0 , 20)) = 0.01
		_Float1("Float 1", Float) = 0
		_Color0("Color 0", Color) = (1,1,1,0)
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
			float eyeDepth;
			float2 uv_texcoord;
		};

		uniform float4 _Color0;
		uniform sampler2D _MainTex;
		uniform float _Float2;
		uniform float _Float1;
		uniform float _BlurAmount;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			o.eyeDepth = -UnityObjectToViewPos( v.vertex.xyz ).z;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float cameraDepthFade115 = (( i.eyeDepth -_ProjectionParams.y - _Float1 ) / _Float2);
			float temp_output_116_0 = ( abs( cameraDepthFade115 ) * _BlurAmount );
			float2 temp_output_28_0 = ( float2( 0.001,0 ) * temp_output_116_0 );
			float2 uv_TexCoord2 = i.uv_texcoord + temp_output_28_0;
			float4 tex2DNode24 = tex2D( _MainTex, uv_TexCoord2 );
			float2 uv_TexCoord4 = i.uv_texcoord + -temp_output_28_0;
			float4 tex2DNode25 = tex2D( _MainTex, uv_TexCoord4 );
			float2 temp_output_29_0 = ( float2( 0,0.001 ) * temp_output_116_0 );
			float2 uv_TexCoord32 = i.uv_texcoord + temp_output_29_0;
			float4 tex2DNode34 = tex2D( _MainTex, uv_TexCoord32 );
			float2 uv_TexCoord33 = i.uv_texcoord + -temp_output_29_0;
			float4 tex2DNode35 = tex2D( _MainTex, uv_TexCoord33 );
			float2 temp_output_53_0 = ( float2( 0.0005,0 ) * temp_output_116_0 );
			float2 uv_TexCoord51 = i.uv_texcoord + temp_output_53_0;
			float4 tex2DNode48 = tex2D( _MainTex, uv_TexCoord51 );
			float2 uv_TexCoord50 = i.uv_texcoord + -temp_output_53_0;
			float4 tex2DNode49 = tex2D( _MainTex, uv_TexCoord50 );
			float2 temp_output_41_0 = ( float2( 0,0.0005 ) * temp_output_116_0 );
			float2 uv_TexCoord43 = i.uv_texcoord + temp_output_41_0;
			float4 tex2DNode45 = tex2D( _MainTex, uv_TexCoord43 );
			float2 uv_TexCoord44 = i.uv_texcoord + -temp_output_41_0;
			float4 tex2DNode46 = tex2D( _MainTex, uv_TexCoord44 );
			float2 temp_output_80_0 = ( float2( 0.001,0.001 ) * temp_output_116_0 );
			float2 uv_TexCoord93 = i.uv_texcoord + temp_output_80_0;
			float4 tex2DNode98 = tex2D( _MainTex, uv_TexCoord93 );
			float2 uv_TexCoord87 = i.uv_texcoord + -temp_output_80_0;
			float4 tex2DNode103 = tex2D( _MainTex, uv_TexCoord87 );
			float2 temp_output_79_0 = ( float2( -0.001,0.001 ) * temp_output_116_0 );
			float2 uv_TexCoord94 = i.uv_texcoord + temp_output_79_0;
			float4 tex2DNode101 = tex2D( _MainTex, uv_TexCoord94 );
			float2 uv_TexCoord90 = i.uv_texcoord + -temp_output_79_0;
			float4 tex2DNode99 = tex2D( _MainTex, uv_TexCoord90 );
			float2 temp_output_81_0 = ( float2( 0.0005,0.0005 ) * temp_output_116_0 );
			float2 uv_TexCoord91 = i.uv_texcoord + temp_output_81_0;
			float4 tex2DNode97 = tex2D( _MainTex, uv_TexCoord91 );
			float2 uv_TexCoord89 = i.uv_texcoord + -temp_output_81_0;
			float4 tex2DNode96 = tex2D( _MainTex, uv_TexCoord89 );
			float2 temp_output_82_0 = ( float2( -0.0005,0.0005 ) * temp_output_116_0 );
			float2 uv_TexCoord88 = i.uv_texcoord + temp_output_82_0;
			float4 tex2DNode100 = tex2D( _MainTex, uv_TexCoord88 );
			float2 uv_TexCoord92 = i.uv_texcoord + -temp_output_82_0;
			float4 tex2DNode102 = tex2D( _MainTex, uv_TexCoord92 );
			o.Emission = ( _Color0 * ( ( ( tex2DNode24 + tex2DNode25 + tex2DNode34 + tex2DNode35 ) + ( tex2DNode48 + tex2DNode49 + tex2DNode45 + tex2DNode46 ) + ( tex2DNode98 + tex2DNode103 + tex2DNode101 + tex2DNode99 ) + ( tex2DNode97 + tex2DNode96 + tex2DNode100 + tex2DNode102 ) ) / 16.0 ) ).rgb;
			o.Alpha = ( ( ( tex2DNode24.a + tex2DNode25.a + tex2DNode34.a + tex2DNode35.a ) + ( tex2DNode48.a + tex2DNode49.a + tex2DNode45.a + tex2DNode46.a ) + ( tex2DNode98.a + tex2DNode103.a + tex2DNode101.a + tex2DNode99.a ) + ( tex2DNode97.a + tex2DNode96.a + tex2DNode100.a + tex2DNode102.a ) ) / 16.0 );
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard alpha:fade keepalpha fullforwardshadows exclude_path:deferred vertex:vertexDataFunc 

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
				vertexDataFunc( v, customInputData );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.customPack1.x = customInputData.eyeDepth;
				o.customPack1.yz = customInputData.uv_texcoord;
				o.customPack1.yz = v.texcoord;
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
				surfIN.eyeDepth = IN.customPack1.x;
				surfIN.uv_texcoord = IN.customPack1.yz;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
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
495;199;1301;691;2336.958;-1427.722;4.913529;True;True
Node;AmplifyShaderEditor.RangedFloatNode;113;-3519.01,2702.15;Float;False;Property;_Float1;Float 1;3;0;Create;True;0;0;False;0;0;28.8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;114;-3528.145,2605.31;Float;False;Property;_Float2;Float 2;1;0;Create;True;0;0;False;0;0;78.9;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CameraDepthFade;115;-3337.821,2614.781;Float;False;3;2;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;112;-1851.118,-201.9457;Float;False;2103.261;1440.595;Love side to side;16;7;3;35;25;24;34;2;4;33;32;30;16;29;28;26;38;;1,1,1,1;0;0
Node;AmplifyShaderEditor.AbsOpNode;117;-3040.544,2600.074;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;12;-3342.025,2847.264;Float;True;Property;_BlurAmount;BlurAmount;2;0;Create;True;0;0;False;0;0.01;20;0;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;116;-2905.366,2694.255;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;38;-1729.057,724.1881;Float;False;Constant;_Vector1;Vector 1;1;0;Create;True;0;0;False;0;0,0.001;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;77;-1764.017,5105.991;Float;False;Constant;_Vector6;Vector 6;1;0;Create;True;0;0;False;0;0.0005,0.0005;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;110;-1840.19,5651.726;Float;False;Constant;_Vector5;Vector 5;1;0;Create;True;0;0;False;0;-0.0005,0.0005;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;26;-1673.991,136.177;Float;False;Constant;_Vector0;Vector 0;1;0;Create;True;0;0;False;0;0.001,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;78;-1657.258,4094.134;Float;False;Constant;_Vector7;Vector 7;1;0;Create;True;0;0;False;0;-0.001,0.001;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;39;-1681.231,2606.53;Float;False;Constant;_Vector2;Vector 2;1;0;Create;True;0;0;False;0;0,0.0005;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;75;-1632.192,3492.123;Float;False;Constant;_Vector4;Vector 4;1;0;Create;True;0;0;False;0;0.001,0.001;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;47;-1759.808,1585.599;Float;False;Constant;_Vector3;Vector 3;1;0;Create;True;0;0;False;0;0.0005,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;53;-1452.661,1681.398;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;80;-1419.996,3517.417;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;-1490.335,752.963;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;81;-1416.114,5037.344;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;41;-1476.574,2670.814;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;82;-1440.026,6026.76;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;-1461.796,161.4713;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;79;-1448.536,4108.909;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NegateNode;86;-1184.702,4289.644;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NegateNode;84;-1176.193,6207.496;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NegateNode;85;-1233.704,3690.649;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NegateNode;30;-1226.501,933.6983;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NegateNode;42;-1212.74,2851.55;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NegateNode;52;-1266.37,1854.63;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NegateNode;83;-1229.822,5210.576;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NegateNode;16;-1275.504,334.7036;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;88;-1023.679,5849.842;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0.17,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;93;-1030.724,3327.866;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0.17,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;90;-1035.808,4237.326;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0.59,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;2;-1072.523,-28.08045;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0.17,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;50;-1067.01,1802.312;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0.59,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;89;-1030.463,5158.258;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0.59,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;44;-1069.099,2799.232;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0.59,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;51;-1063.389,1491.846;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0.17,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;94;-1032.188,3931.99;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0.17,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;92;-1027.299,6155.178;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0.59,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;87;-1034.345,3638.332;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0.59,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;43;-1060.226,2493.896;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0.17,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;23;-821.3557,3123.209;Float;True;Property;_MainTex;MainTex;0;0;Create;True;0;0;False;0;None;None;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;4;-1076.144,282.3856;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0.59,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;32;-1073.987,576.045;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0.17,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;91;-1026.841,4847.792;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0.17,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;33;-1077.608,881.3803;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0.59,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;103;-436.0612,3678.077;Float;True;Property;_TextureSample15;Texture Sample 15;2;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;49;-492.4869,2036.393;Float;True;Property;_TextureSample7;Texture Sample 7;6;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;35;-474.6978,903.4546;Float;True;Property;_TextureSample3;Texture Sample 3;2;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;25;-477.8609,322.1311;Float;True;Property;_TextureSample1;Texture Sample 1;2;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;34;-479.5498,630.0363;Float;True;Property;_TextureSample2;Texture Sample 2;1;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;48;-502.4697,1778.367;Float;True;Property;_TextureSample6;Texture Sample 6;4;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;101;-437.7502,3985.982;Float;True;Property;_TextureSample13;Texture Sample 13;1;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;97;-460.6701,5134.313;Float;True;Property;_TextureSample9;Texture Sample 9;4;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;100;-452.3762,5700.244;Float;True;Property;_TextureSample12;Texture Sample 12;3;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;96;-450.6873,5392.339;Float;True;Property;_TextureSample8;Texture Sample 8;6;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;98;-446.044,3420.051;Float;True;Property;_TextureSample10;Texture Sample 10;1;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;102;-447.5241,5973.663;Float;True;Property;_TextureSample14;Texture Sample 14;5;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;45;-494.1758,2344.298;Float;True;Property;_TextureSample4;Texture Sample 4;3;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;46;-489.3238,2617.717;Float;True;Property;_TextureSample5;Texture Sample 5;5;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;24;-487.8437,64.10523;Float;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;99;-432.8982,4259.4;Float;True;Property;_TextureSample11;Texture Sample 11;2;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;55;28.57265,1932.818;Float;False;4;4;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;3;59.38523,730.7994;Float;False;4;4;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;106;146.4686,3721.239;Float;False;4;4;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;107;70.37219,5288.764;Float;False;4;4;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;105;58.42554,5625.178;Float;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;56;16.62597,2269.232;Float;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;9;895.0017,3062.219;Float;False;Constant;_Float0;Float 0;2;0;Create;True;0;0;False;0;16;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;57;784.4454,2761.596;Float;False;4;4;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;104;144.6965,4137.707;Float;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;7;38.20586,943.4902;Float;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;58;799.6106,3455.117;Float;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;108;977.2593,2531.579;Float;False;Property;_Color0;Color 0;4;0;Create;True;0;0;False;0;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleDivideOpNode;8;1094.608,2956.986;Float;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;109;1277.641,2889.661;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;10;1082.8,3125.245;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1714.165,2842.783;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;BlurShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;ForwardOnly;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;115;0;114;0
WireConnection;115;1;113;0
WireConnection;117;0;115;0
WireConnection;116;0;117;0
WireConnection;116;1;12;0
WireConnection;53;0;47;0
WireConnection;53;1;116;0
WireConnection;80;0;75;0
WireConnection;80;1;116;0
WireConnection;29;0;38;0
WireConnection;29;1;116;0
WireConnection;81;0;77;0
WireConnection;81;1;116;0
WireConnection;41;0;39;0
WireConnection;41;1;116;0
WireConnection;82;0;110;0
WireConnection;82;1;116;0
WireConnection;28;0;26;0
WireConnection;28;1;116;0
WireConnection;79;0;78;0
WireConnection;79;1;116;0
WireConnection;86;0;79;0
WireConnection;84;0;82;0
WireConnection;85;0;80;0
WireConnection;30;0;29;0
WireConnection;42;0;41;0
WireConnection;52;0;53;0
WireConnection;83;0;81;0
WireConnection;16;0;28;0
WireConnection;88;1;82;0
WireConnection;93;1;80;0
WireConnection;90;1;86;0
WireConnection;2;1;28;0
WireConnection;50;1;52;0
WireConnection;89;1;83;0
WireConnection;44;1;42;0
WireConnection;51;1;53;0
WireConnection;94;1;79;0
WireConnection;92;1;84;0
WireConnection;87;1;85;0
WireConnection;43;1;41;0
WireConnection;4;1;16;0
WireConnection;32;1;29;0
WireConnection;91;1;81;0
WireConnection;33;1;30;0
WireConnection;103;0;23;0
WireConnection;103;1;87;0
WireConnection;49;0;23;0
WireConnection;49;1;50;0
WireConnection;35;0;23;0
WireConnection;35;1;33;0
WireConnection;25;0;23;0
WireConnection;25;1;4;0
WireConnection;34;0;23;0
WireConnection;34;1;32;0
WireConnection;48;0;23;0
WireConnection;48;1;51;0
WireConnection;101;0;23;0
WireConnection;101;1;94;0
WireConnection;97;0;23;0
WireConnection;97;1;91;0
WireConnection;100;0;23;0
WireConnection;100;1;88;0
WireConnection;96;0;23;0
WireConnection;96;1;89;0
WireConnection;98;0;23;0
WireConnection;98;1;93;0
WireConnection;102;0;23;0
WireConnection;102;1;92;0
WireConnection;45;0;23;0
WireConnection;45;1;43;0
WireConnection;46;0;23;0
WireConnection;46;1;44;0
WireConnection;24;0;23;0
WireConnection;24;1;2;0
WireConnection;99;0;23;0
WireConnection;99;1;90;0
WireConnection;55;0;48;0
WireConnection;55;1;49;0
WireConnection;55;2;45;0
WireConnection;55;3;46;0
WireConnection;3;0;24;0
WireConnection;3;1;25;0
WireConnection;3;2;34;0
WireConnection;3;3;35;0
WireConnection;106;0;98;0
WireConnection;106;1;103;0
WireConnection;106;2;101;0
WireConnection;106;3;99;0
WireConnection;107;0;97;0
WireConnection;107;1;96;0
WireConnection;107;2;100;0
WireConnection;107;3;102;0
WireConnection;105;0;97;4
WireConnection;105;1;96;4
WireConnection;105;2;100;4
WireConnection;105;3;102;4
WireConnection;56;0;48;4
WireConnection;56;1;49;4
WireConnection;56;2;45;4
WireConnection;56;3;46;4
WireConnection;57;0;3;0
WireConnection;57;1;55;0
WireConnection;57;2;106;0
WireConnection;57;3;107;0
WireConnection;104;0;98;4
WireConnection;104;1;103;4
WireConnection;104;2;101;4
WireConnection;104;3;99;4
WireConnection;7;0;24;4
WireConnection;7;1;25;4
WireConnection;7;2;34;4
WireConnection;7;3;35;4
WireConnection;58;0;7;0
WireConnection;58;1;56;0
WireConnection;58;2;104;0
WireConnection;58;3;105;0
WireConnection;8;0;57;0
WireConnection;8;1;9;0
WireConnection;109;0;108;0
WireConnection;109;1;8;0
WireConnection;10;0;58;0
WireConnection;10;1;9;0
WireConnection;0;2;109;0
WireConnection;0;9;10;0
ASEEND*/
//CHKSM=C79A81E091BDF4A6C4A14B6E865CA2EDCD010741