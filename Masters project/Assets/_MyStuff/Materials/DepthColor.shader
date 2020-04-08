// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "DepthColor"
{
	Properties
	{
		_Float0("Float 0", Float) = 0
		_Float1("Float 1", Float) = 0
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_Color0("Color 0", Color) = (0.4094874,0.6091207,0.8113208,0)
		_ForegroundColor("ForegroundColor", Color) = (0.4094874,0.6091207,0.8113208,0)
		_Float2("Float 2", Float) = 0
		_Float3("Float 3", Float) = 0
		_Float4("Float 4", Float) = 0
		_Float5("Float 5", Float) = 0
		_MainTex("MainTex", 2D) = "white" {}
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
			float eyeDepth;
		};

		uniform sampler2D _TextureSample0;
		uniform float4 _TextureSample0_ST;
		uniform float _Float4;
		uniform float _Float5;
		uniform float _Float0;
		uniform float _Float1;
		uniform float4 _Color0;
		uniform float _Float2;
		uniform float _Float3;
		uniform float4 _ForegroundColor;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			o.eyeDepth = -UnityObjectToViewPos( v.vertex.xyz ).z;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_TextureSample0 = i.uv_texcoord * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
			float4 tex2DNode4 = tex2D( _TextureSample0, uv_TextureSample0 );
			float cameraDepthFade1 = (( i.eyeDepth -_ProjectionParams.y - _Float1 ) / _Float0);
			float smoothstepResult45 = smoothstep( _Float4 , _Float5 , cameraDepthFade1);
			float cameraDepthFade18 = (( i.eyeDepth -_ProjectionParams.y - _Float3 ) / _Float2);
			o.Emission = ( ( tex2DNode4 + ( smoothstepResult45 * _Color0 ) ) * saturate( ( cameraDepthFade18 + ( ( 1.0 - cameraDepthFade18 ) * _ForegroundColor * tex2DNode4 ) ) ) ).rgb;
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			o.Alpha = tex2D( _MainTex, uv_MainTex ).a;
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
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.customPack1.z = customInputData.eyeDepth;
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
				surfIN.eyeDepth = IN.customPack1.z;
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
63;338;1366;681;554.4127;363.5759;1.570004;True;False
Node;AmplifyShaderEditor.RangedFloatNode;36;-305.8612,490.4477;Float;False;Property;_Float2;Float 2;5;0;Create;True;0;0;False;0;0;24.97;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;37;-327.4236,560.8854;Float;False;Property;_Float3;Float 3;6;0;Create;True;0;0;False;0;0;10.68;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-332.9222,-76.17012;Float;False;Property;_Float1;Float 1;1;0;Create;True;0;0;False;0;0;10.03;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;35;-342.0569,-173.0111;Float;False;Property;_Float0;Float 0;0;0;Create;True;0;0;False;0;0;80;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CameraDepthFade;18;-94.95278,436.7801;Float;False;3;2;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;46;-95.33728,5.451332;Float;False;Property;_Float4;Float 4;7;0;Create;True;0;0;False;0;0;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;33;-56.90282,655.0533;Float;False;Property;_ForegroundColor;ForegroundColor;4;0;Create;True;0;0;False;0;0.4094874,0.6091207,0.8113208,0;0.3301887,0.2909141,0.1884567,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CameraDepthFade;1;-151.7333,-163.539;Float;False;3;2;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;38;154.1397,401.6975;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;4;190.596,-282.7177;Float;True;Property;_TextureSample0;Texture Sample 0;2;0;Create;True;0;0;False;0;None;750b1bd7ba8bd28489650de6d0a95cc5;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;47;-98.29809,80.93694;Float;False;Property;_Float5;Float 5;8;0;Create;True;0;0;False;0;0;0.55;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;5;-53.09438,152.7231;Float;False;Property;_Color0;Color 0;3;0;Create;True;0;0;False;0;0.4094874,0.6091207,0.8113208,0;0.3099858,0.4917053,0.509434,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;520.1446,338.4465;Float;True;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;45;106.4988,-18.04862;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;266.3818,-9.979653;Float;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;39;743.5805,309.2258;Float;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;7;741.1356,-39.29004;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;41;976.9968,244.902;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;48;1160.093,543.399;Float;True;Property;_MainTex;MainTex;9;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;40;1116.289,57.23537;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1487.992,-131.2116;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;DepthColor;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;18;0;36;0
WireConnection;18;1;37;0
WireConnection;1;0;35;0
WireConnection;1;1;3;0
WireConnection;38;0;18;0
WireConnection;31;0;38;0
WireConnection;31;1;33;0
WireConnection;31;2;4;0
WireConnection;45;0;1;0
WireConnection;45;1;46;0
WireConnection;45;2;47;0
WireConnection;6;0;45;0
WireConnection;6;1;5;0
WireConnection;39;0;18;0
WireConnection;39;1;31;0
WireConnection;7;0;4;0
WireConnection;7;1;6;0
WireConnection;41;0;39;0
WireConnection;40;0;7;0
WireConnection;40;1;41;0
WireConnection;0;2;40;0
WireConnection;0;9;48;4
ASEEND*/
//CHKSM=6F30EC63609BCE07886B61ED9808D069FA756361