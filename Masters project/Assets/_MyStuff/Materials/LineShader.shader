// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "LineShader"
{
	Properties
	{
		_WobbleAmount("WobbleAmount", Float) = 0.3
		_PanSpeed("PanSpeed", Vector) = (1,0,0,0)
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_Vector4("Vector 4", Vector) = (0.001,0.001,0,0)
		_TextureSample1("Texture Sample 1", 2D) = "bump" {}
		_NoiseAmount("NoiseAmount", Float) = -0.05
		_FlickerSpeed("FlickerSpeed", Float) = 0.2
		_WorldPosEffect("WorldPosEffect", Float) = 0.001
		_FrameRate("FrameRate", Float) = 1
		_WobbleScale("WobbleScale", Range( 0 , 1)) = 0.71
		_Color1("Color 1", Color) = (1,1,1,0)
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

		uniform float4 _Color1;
		uniform sampler2D _TextureSample0;
		uniform float _FrameRate;
		uniform float _WobbleAmount;
		uniform float2 _PanSpeed;
		uniform float2 _Vector4;
		uniform sampler2D _TextureSample1;
		uniform float _FlickerSpeed;
		uniform float _WorldPosEffect;
		uniform float _NoiseAmount;
		uniform float _WobbleScale;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float temp_output_18_0 = ( round( ( _FrameRate * _Time.y ) ) * _WobbleAmount );
			float2 panner41 = ( temp_output_18_0 * _PanSpeed + i.uv_texcoord);
			float2 uv_TexCoord26 = i.uv_texcoord + _Vector4;
			float4 color20 = IsGammaSpace() ? float4(0.5019608,0.5019608,1,0) : float4(0.2158605,0.2158605,1,0);
			float4 appendResult17 = (float4(-_FlickerSpeed , -_FlickerSpeed , 0.0 , 0.0));
			float3 ase_worldPos = i.worldPos;
			float4 appendResult6 = (float4(ase_worldPos.x , ase_worldPos.y , ase_worldPos.z , 0.0));
			float2 panner19 = ( temp_output_18_0 * appendResult17.xy + ( ( appendResult6 * _WorldPosEffect ) + float4( ( _NoiseAmount * i.uv_texcoord ), 0.0 , 0.0 ) ).xy);
			float4 lerpResult23 = lerp( color20 , float4( UnpackNormal( tex2D( _TextureSample1, panner19 ) ) , 0.0 ) , _WobbleScale);
			float4 tex2DNode1 = tex2D( _TextureSample0, ( ( panner41 + ( uv_TexCoord26 + ( (lerpResult23).rg - float2( 0.5,0.5 ) ) ) ) / float2( 2,2 ) ) );
			o.Emission = ( _Color1 * tex2DNode1 ).rgb;
			o.Alpha = ( _Color1.a * tex2DNode1.a );
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
0;6;1920;1013;1062.613;350.1414;1;True;False
Node;AmplifyShaderEditor.WorldPosInputsNode;2;-3673.98,-116.1965;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;3;-3278.44,889.1552;Float;False;Property;_FrameRate;FrameRate;9;0;Create;True;0;0;False;0;1;3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;4;-3299.44,1026.155;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-3457.995,582.5706;Float;False;Property;_FlickerSpeed;FlickerSpeed;6;0;Create;True;0;0;False;0;0.2;0.01;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;6;-3479.493,-102.9667;Float;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;7;-3844.317,240.2654;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;8;-3445.925,128.5102;Float;False;Property;_NoiseAmount;NoiseAmount;5;0;Create;True;0;0;False;0;-0.05;0.01;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-3488.917,48.51076;Float;False;Property;_WorldPosEffect;WorldPosEffect;8;0;Create;True;0;0;False;0;0.001;0.002;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-3091.44,919.1551;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RoundOpNode;14;-2932.359,869.2959;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;13;-3235.707,513.2017;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;-3258.121,202.368;Float;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-3263.917,-7.489247;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;12;-2762.258,1056.824;Float;False;Property;_WobbleAmount;WobbleAmount;0;0;Create;True;0;0;False;0;0.3;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;17;-3085.512,486.1309;Float;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;16;-3072.757,152.0428;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-2752.674,747.7903;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;19;-2872.789,383.9387;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;1,0.5;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;21;-2859.207,234.3939;Float;False;Property;_WobbleScale;WobbleScale;10;0;Create;True;0;0;False;0;0.71;0.772;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;22;-2691.317,356.4189;Float;True;Property;_TextureSample1;Texture Sample 1;4;0;Create;True;0;0;False;0;80445246cc51bc649a90911a060ce7ca;f5453dca2ac649e4182c56a3966ad395;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;20;-2817.207,98.39395;Float;False;Constant;_Color0;Color 0;8;0;Create;True;0;0;False;0;0.5019608,0.5019608,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;23;-2393.754,149.7731;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector2Node;24;-2190.992,-67.90774;Float;False;Property;_Vector4;Vector 4;3;0;Create;True;0;0;False;0;0.001,0.001;0,0.34;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.ComponentMaskNode;25;-2119.698,358.0719;Float;True;True;True;False;False;1;0;COLOR;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;26;-1976.425,22.09815;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;39;-1618.803,819.8331;Float;False;Property;_PanSpeed;PanSpeed;1;0;Create;True;0;0;False;0;1,0;7,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;38;-1606.458,659.9962;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;27;-1884.502,336.969;Float;True;2;0;FLOAT2;-0.5,-0.5;False;1;FLOAT2;0.5,0.5;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;41;-1338.661,944.4244;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;1,0.5;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;28;-1664.497,215.4085;Float;True;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;43;-1007.329,506.8373;Float;True;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;44;-618.8793,424.4388;Float;False;2;0;FLOAT2;0,0;False;1;FLOAT2;2,2;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;1;-525.3566,119.9591;Float;True;Property;_TextureSample0;Texture Sample 0;2;0;Create;True;0;0;False;0;79f774173c7d6714e86d577916ec643c;d2cf7c37a15761b49bafba70b9dfad51;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;46;-480.6134,-98.14142;Float;False;Property;_Color1;Color 1;11;0;Create;True;0;0;False;0;1,1,1,0;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;45;-133.6134,-23.14142;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleTimeNode;33;-3077.074,628.8017;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;34;-1808.582,-341.0134;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0.17,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;35;-3256.789,677.0018;Float;False;Property;_Float3;Float 3;7;0;Create;True;0;0;False;0;-1;0.8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;47;-132.613,173.8586;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;85,-46;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;LineShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;6;0;2;1
WireConnection;6;1;2;2
WireConnection;6;2;2;3
WireConnection;10;0;3;0
WireConnection;10;1;4;0
WireConnection;14;0;10;0
WireConnection;13;0;5;0
WireConnection;15;0;8;0
WireConnection;15;1;7;0
WireConnection;11;0;6;0
WireConnection;11;1;9;0
WireConnection;17;0;13;0
WireConnection;17;1;13;0
WireConnection;16;0;11;0
WireConnection;16;1;15;0
WireConnection;18;0;14;0
WireConnection;18;1;12;0
WireConnection;19;0;16;0
WireConnection;19;2;17;0
WireConnection;19;1;18;0
WireConnection;22;1;19;0
WireConnection;23;0;20;0
WireConnection;23;1;22;0
WireConnection;23;2;21;0
WireConnection;25;0;23;0
WireConnection;26;1;24;0
WireConnection;27;0;25;0
WireConnection;41;0;38;0
WireConnection;41;2;39;0
WireConnection;41;1;18;0
WireConnection;28;0;26;0
WireConnection;28;1;27;0
WireConnection;43;0;41;0
WireConnection;43;1;28;0
WireConnection;44;0;43;0
WireConnection;1;1;44;0
WireConnection;45;0;46;0
WireConnection;45;1;1;0
WireConnection;33;0;35;0
WireConnection;47;0;46;4
WireConnection;47;1;1;4
WireConnection;0;2;45;0
WireConnection;0;9;47;0
ASEEND*/
//CHKSM=C4801F1C0AACE5D284C3A1076F8A39CBFF83B182