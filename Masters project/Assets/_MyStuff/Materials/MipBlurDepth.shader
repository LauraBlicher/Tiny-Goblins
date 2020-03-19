// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "MipBlurDepth"
{
	Properties
	{
		_MainTex("MainTex", 2D) = "white" {}
		_Float6("Float 6", Float) = 0
		_Float2("Float 2", Float) = 0
		_Float5("Float 5", Float) = 0
		_BlurAmount("BlurAmount", Range( 0 , 20)) = 0.01
		_TextureSample16("Texture Sample 16", 2D) = "white" {}
		_Float1("Float 1", Float) = 0
		_Color1("Color 1", Color) = (0.4094874,0.6091207,0.8113208,0)
		_Color0("Color 0", Color) = (1,1,1,0)
		_ForegroundColor("ForegroundColor", Color) = (0.4094874,0.6091207,0.8113208,0)
		_Float3("Float 3", Float) = 0
		_Float4("Float 4", Float) = 0
		_Float7("Float 7", Float) = 0
		_Float8("Float 8", Float) = 0
		_MipInfliuence("MipInfliuence", Float) = 1
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
		uniform float _MipInfliuence;
		uniform float _Float7;
		uniform float _Float8;
		uniform float _Float6;
		uniform float _Float5;
		uniform float4 _Color1;
		uniform float _Float3;
		uniform float _Float4;
		uniform float4 _ForegroundColor;
		uniform sampler2D _TextureSample16;
		uniform float4 _TextureSample16_ST;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			o.eyeDepth = -UnityObjectToViewPos( v.vertex.xyz ).z;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float cameraDepthFade3 = (( i.eyeDepth -_ProjectionParams.y - _Float1 ) / _Float2);
			float temp_output_8_0 = ( abs( cameraDepthFade3 ) * _BlurAmount );
			float2 temp_output_17_0 = ( float2( 0.001,0 ) * temp_output_8_0 );
			float2 uv_TexCoord43 = i.uv_texcoord + temp_output_17_0;
			float temp_output_103_0 = ( _MipInfliuence * temp_output_8_0 );
			float4 tex2DNode56 = tex2Dlod( _MainTex, float4( uv_TexCoord43, 0, temp_output_103_0) );
			float2 uv_TexCoord32 = i.uv_texcoord + -temp_output_17_0;
			float4 tex2DNode99 = tex2Dlod( _MainTex, float4( uv_TexCoord32, 0, temp_output_103_0) );
			float2 temp_output_21_0 = ( float2( 0,0.001 ) * temp_output_8_0 );
			float2 uv_TexCoord40 = i.uv_texcoord + temp_output_21_0;
			float4 tex2DNode100 = tex2Dlod( _MainTex, float4( uv_TexCoord40, 0, temp_output_103_0) );
			float2 uv_TexCoord38 = i.uv_texcoord + -temp_output_21_0;
			float4 tex2DNode101 = tex2Dlod( _MainTex, float4( uv_TexCoord38, 0, temp_output_103_0) );
			float4 temp_output_72_0 = ( tex2DNode56 + tex2DNode99 + tex2DNode100 + tex2DNode101 );
			float cameraDepthFade80 = (( i.eyeDepth -_ProjectionParams.y - _Float5 ) / _Float6);
			float smoothstepResult82 = smoothstep( _Float7 , _Float8 , cameraDepthFade80);
			float cameraDepthFade71 = (( i.eyeDepth -_ProjectionParams.y - _Float4 ) / _Float3);
			float2 uv_TextureSample16 = i.uv_texcoord * _TextureSample16_ST.xy + _TextureSample16_ST.zw;
			o.Emission = ( ( ( _Color0 * ( temp_output_72_0 / 4.0 ) ) + ( smoothstepResult82 * _Color1 ) ) * saturate( ( cameraDepthFade71 + ( ( 1.0 - cameraDepthFade71 ) * _ForegroundColor * tex2D( _TextureSample16, uv_TextureSample16 ) ) ) ) ).rgb;
			float temp_output_92_0 = ( tex2DNode56.a + tex2DNode99.a + tex2DNode100.a + tex2DNode101.a );
			o.Alpha = ( temp_output_92_0 / 4.0 );
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard alpha:fade keepalpha fullforwardshadows vertex:vertexDataFunc 

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
0;0;1920;1019;6977.496;2996.577;4.522127;True;False
Node;AmplifyShaderEditor.RangedFloatNode;1;-5142.749,306.2096;Float;False;Property;_Float1;Float 1;10;0;Create;True;0;0;False;0;0;28.8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2;-5151.884,209.3697;Float;False;Property;_Float2;Float 2;4;0;Create;True;0;0;False;0;0;78.9;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CameraDepthFade;3;-4961.56,218.8407;Float;False;3;2;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;5;-4664.283,204.1337;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-4965.764,451.3236;Float;True;Property;_BlurAmount;BlurAmount;7;0;Create;True;0;0;False;0;0.01;20;0;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;4;-3829.51,-2575.005;Float;False;2373.493;1433.292;Love side to side;15;92;72;56;43;40;38;32;27;25;21;17;11;7;101;99;;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector2Node;11;-3707.449,-1648.871;Float;False;Constant;_Vector1;Vector 1;1;0;Create;True;0;0;False;0;0,0.001;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;-4529.104,298.3146;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;7;-3652.383,-2236.882;Float;False;Constant;_Vector0;Vector 0;1;0;Create;True;0;0;False;0;0.001,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;-3440.188,-2211.588;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;-3468.727,-1620.096;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;102;-4460.021,-148.5867;Float;False;Property;_MipInfliuence;MipInfliuence;18;0;Create;True;0;0;False;0;1;0.38;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;25;-3204.893,-1439.361;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NegateNode;27;-3253.896,-2038.356;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;62;-351.7516,225.2124;Float;False;Property;_Float4;Float 4;15;0;Create;True;0;0;False;0;0;10.68;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;103;-4245.076,-80.83997;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;36;-2755.065,746.2373;Float;True;Property;_MainTex;MainTex;0;0;Create;True;0;0;False;0;None;None;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;43;-3050.915,-2401.14;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0.17,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;32;-3054.536,-2090.674;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0.59,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;38;-3056,-1491.679;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0.59,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;40;-3052.379,-1797.014;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0.17,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;61;-330.1886,154.7747;Float;False;Property;_Float3;Float 3;14;0;Create;True;0;0;False;0;0;11.95;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;101;-2188.935,-1526.888;Float;True;Property;_TextureSample3;Texture Sample 3;4;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;MipLevel;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;99;-2157.037,-2062.077;Float;True;Property;_TextureSample1;Texture Sample 1;2;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;MipLevel;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;56;-2166.79,-2279.74;Float;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;MipLevel;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;100;-2178.302,-1782.077;Float;True;Property;_TextureSample2;Texture Sample 2;1;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;MipLevel;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;73;-357.2496,-411.8431;Float;False;Property;_Float5;Float 5;6;0;Create;True;0;0;False;0;0;10.03;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CameraDepthFade;71;-119.2806,101.1071;Float;False;3;2;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;68;-366.3846,-508.6841;Float;False;Property;_Float6;Float 6;3;0;Create;True;0;0;False;0;0;80;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;72;-1619.561,-1613.046;Float;False;4;4;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;76;-119.6646,-330.2216;Float;False;Property;_Float7;Float 7;16;0;Create;True;0;0;False;0;0;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CameraDepthFade;80;-176.0605,-499.212;Float;False;3;2;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;78;-122.6256,-254.736;Float;False;Property;_Float8;Float 8;17;0;Create;True;0;0;False;0;0;0.55;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;75;-728.7366,666.2787;Float;False;Constant;_Float0;Float 0;2;0;Create;True;0;0;False;0;4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;81;129.8125,66.02451;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;74;-81.23059,319.3803;Float;False;Property;_ForegroundColor;ForegroundColor;13;0;Create;True;0;0;False;0;0.4094874,0.6091207,0.8113208,0;0.5660378,0.5232416,0.4298683,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;79;166.2683,-618.3911;Float;True;Property;_TextureSample16;Texture Sample 16;9;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;86;-646.4796,135.6388;Float;False;Property;_Color0;Color 0;12;0;Create;True;0;0;False;0;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SmoothstepOpNode;82;82.17139,-353.7216;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;85;-529.1306,561.0458;Float;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;83;-77.42163,-182.9499;Float;False;Property;_Color1;Color 1;11;0;Create;True;0;0;False;0;0.4094874,0.6091207,0.8113208,0;0,0,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;84;495.8174,2.773621;Float;True;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;89;242.0544,-345.6527;Float;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;90;719.2534,-26.4472;Float;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;88;-346.0977,493.7206;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;96;952.6694,-90.771;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;94;716.8083,-374.963;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;92;-1640.74,-1400.355;Float;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;31;-3154.584,3834.437;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;98;1091.961,-278.4376;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;87;-1479.042,1741.767;Float;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;13;-3610.583,1119.064;Float;False;Constant;_Vector4;Vector 4;1;0;Create;True;0;0;False;0;0.001,0.001;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;33;-3012.737,1265.273;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0.59,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;91;-1565.313,3229.238;Float;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;65;-2059.8,1282.137;Float;True;Property;_TextureSample15;Texture Sample 15;2;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NegateNode;30;-3244.762,-518.4291;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-3431.053,-691.6611;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;57;-2071.263,3577.723;Float;True;Property;_TextureSample14;Texture Sample 14;5;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;95;-824.1276,1059.177;Float;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;67;-1553.366,2892.824;Float;False;4;4;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector2Node;15;-3635.65,1721.075;Float;False;Constant;_Vector7;Vector 7;1;0;Create;True;0;0;False;0;-0.001,0.001;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SamplerNode;59;-2076.115,3304.304;Float;True;Property;_TextureSample12;Texture Sample 12;3;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;48;-3038.618,120.8366;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0.17,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;34;-3008.854,2785.199;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0.59,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;-3454.966,297.7544;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NegateNode;29;-3212.096,1317.59;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NegateNode;28;-3163.094,1916.585;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NegateNode;26;-3191.132,478.4906;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;107;-4341.861,962.3898;Float;True;Property;_TextureSample20;Texture Sample 20;1;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;MipLevel;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;104;-4330.349,464.7267;Float;True;Property;_TextureSample17;Texture Sample 17;2;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;MipLevel;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;44;-3014.2,1864.267;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0.59,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;14;-3738.2,-787.4601;Float;False;Constant;_Vector3;Vector 3;1;0;Create;True;0;0;False;0;0.0005,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleAddOpNode;77;-839.2936,365.6556;Float;True;4;4;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;-3398.388,1144.357;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;69;-1595.166,-463.1221;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;60;-2056.637,1863.46;Float;True;Property;_TextureSample11;Texture Sample 11;2;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;12;-3742.409,2732.932;Float;False;Constant;_Vector6;Vector 6;1;0;Create;True;0;0;False;0;0.0005,0.0005;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SamplerNode;105;-4320.596,682.3902;Float;True;Property;_TextureSample18;Texture Sample 18;5;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;MipLevel;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;45;-3009.116,954.8066;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0.17,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;47;-3047.491,426.1725;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0.59,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;50;-2069.782,1024.111;Float;True;Property;_TextureSample10;Texture Sample 10;1;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;-3394.506,2664.285;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;-3418.417,3653.701;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;41;-3010.58,1558.931;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0.17,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;70;-1477.27,1325.299;Float;False;4;4;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector2Node;10;-3818.582,3278.667;Float;False;Constant;_Vector5;Vector 5;1;0;Create;True;0;0;False;0;-0.0005,0.0005;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;39;-3005.69,3782.119;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0.59,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;55;-2074.426,2996.399;Float;True;Property;_TextureSample8;Texture Sample 8;6;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;35;-3041.781,-881.2131;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0.17,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;58;-2084.409,2738.373;Float;True;Property;_TextureSample9;Texture Sample 9;4;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-3426.928,1735.85;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;42;-3005.233,2474.733;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0.17,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NegateNode;24;-3208.214,2837.517;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;93;-1607.113,-126.7084;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;63;-2061.489,1590.042;Float;True;Property;_TextureSample13;Texture Sample 13;1;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;46;-3002.071,3476.783;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0.17,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;9;-3659.623,233.4706;Float;False;Constant;_Vector2;Vector 2;1;0;Create;True;0;0;False;0;0,0.0005;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleDivideOpNode;97;-540.9386,729.3048;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;37;-3045.402,-570.7471;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0.59,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;106;-4352.494,1217.579;Float;True;Property;_TextureSample19;Texture Sample 19;8;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;MipLevel;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1447.991,-89.1547;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;MipBlurDepth;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;3;0;2;0
WireConnection;3;1;1;0
WireConnection;5;0;3;0
WireConnection;8;0;5;0
WireConnection;8;1;6;0
WireConnection;17;0;7;0
WireConnection;17;1;8;0
WireConnection;21;0;11;0
WireConnection;21;1;8;0
WireConnection;25;0;21;0
WireConnection;27;0;17;0
WireConnection;103;0;102;0
WireConnection;103;1;8;0
WireConnection;43;1;17;0
WireConnection;32;1;27;0
WireConnection;38;1;25;0
WireConnection;40;1;21;0
WireConnection;101;0;36;0
WireConnection;101;1;38;0
WireConnection;101;2;103;0
WireConnection;99;0;36;0
WireConnection;99;1;32;0
WireConnection;99;2;103;0
WireConnection;56;0;36;0
WireConnection;56;1;43;0
WireConnection;56;2;103;0
WireConnection;100;0;36;0
WireConnection;100;1;40;0
WireConnection;100;2;103;0
WireConnection;71;0;61;0
WireConnection;71;1;62;0
WireConnection;72;0;56;0
WireConnection;72;1;99;0
WireConnection;72;2;100;0
WireConnection;72;3;101;0
WireConnection;80;0;68;0
WireConnection;80;1;73;0
WireConnection;81;0;71;0
WireConnection;82;0;80;0
WireConnection;82;1;76;0
WireConnection;82;2;78;0
WireConnection;85;0;72;0
WireConnection;85;1;75;0
WireConnection;84;0;81;0
WireConnection;84;1;74;0
WireConnection;84;2;79;0
WireConnection;89;0;82;0
WireConnection;89;1;83;0
WireConnection;90;0;71;0
WireConnection;90;1;84;0
WireConnection;88;0;86;0
WireConnection;88;1;85;0
WireConnection;96;0;90;0
WireConnection;94;0;88;0
WireConnection;94;1;89;0
WireConnection;92;0;56;4
WireConnection;92;1;99;4
WireConnection;92;2;100;4
WireConnection;92;3;101;4
WireConnection;31;0;19;0
WireConnection;98;0;94;0
WireConnection;98;1;96;0
WireConnection;87;0;50;4
WireConnection;87;1;65;4
WireConnection;87;2;63;4
WireConnection;87;3;60;4
WireConnection;33;1;29;0
WireConnection;91;0;58;4
WireConnection;91;1;55;4
WireConnection;91;2;59;4
WireConnection;91;3;57;4
WireConnection;65;0;36;0
WireConnection;65;1;33;0
WireConnection;30;0;16;0
WireConnection;16;0;14;0
WireConnection;16;1;8;0
WireConnection;57;0;36;0
WireConnection;57;1;39;0
WireConnection;95;0;92;0
WireConnection;95;1;93;0
WireConnection;95;2;87;0
WireConnection;95;3;91;0
WireConnection;67;0;58;0
WireConnection;67;1;55;0
WireConnection;67;2;59;0
WireConnection;67;3;57;0
WireConnection;59;0;36;0
WireConnection;59;1;46;0
WireConnection;48;1;20;0
WireConnection;34;1;24;0
WireConnection;20;0;9;0
WireConnection;20;1;8;0
WireConnection;29;0;22;0
WireConnection;28;0;18;0
WireConnection;26;0;20;0
WireConnection;44;1;28;0
WireConnection;77;0;72;0
WireConnection;77;1;69;0
WireConnection;77;2;70;0
WireConnection;77;3;67;0
WireConnection;22;0;13;0
WireConnection;22;1;8;0
WireConnection;60;0;36;0
WireConnection;60;1;44;0
WireConnection;45;1;22;0
WireConnection;47;1;26;0
WireConnection;50;0;36;0
WireConnection;50;1;45;0
WireConnection;23;0;12;0
WireConnection;23;1;8;0
WireConnection;19;0;10;0
WireConnection;19;1;8;0
WireConnection;41;1;18;0
WireConnection;70;0;50;0
WireConnection;70;1;65;0
WireConnection;70;2;63;0
WireConnection;70;3;60;0
WireConnection;39;1;31;0
WireConnection;55;0;36;0
WireConnection;55;1;34;0
WireConnection;35;1;16;0
WireConnection;58;0;36;0
WireConnection;58;1;42;0
WireConnection;18;0;15;0
WireConnection;18;1;8;0
WireConnection;42;1;23;0
WireConnection;24;0;23;0
WireConnection;63;0;36;0
WireConnection;63;1;41;0
WireConnection;46;1;19;0
WireConnection;97;0;92;0
WireConnection;97;1;75;0
WireConnection;37;1;30;0
WireConnection;0;2;98;0
WireConnection;0;9;97;0
ASEEND*/
//CHKSM=2AF53BA8CC4EDBF57B3B4B03153D6287B1A7D0F5