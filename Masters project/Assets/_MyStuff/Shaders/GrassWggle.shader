// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "GrassWiggle"
{
	Properties
	{
		_MainTex("MainTex", 2D) = "white" {}
		_Noise("Noise", 2D) = "white" {}
		_NoiseScale("NoiseScale", Float) = -0.05
		_FlameFlickerSpeed("FlameFlickerSpeed", Float) = 0.2
		_timeScale("timeScale", Float) = -1
		_WorldPosMultiplier("WorldPosMultiplier", Float) = 0.001
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

		uniform sampler2D _MainTex;
		uniform sampler2D _Noise;
		uniform float _timeScale;
		uniform float _FlameFlickerSpeed;
		uniform float _WorldPosMultiplier;
		uniform float _NoiseScale;
		uniform float4 _Noise_ST;
		uniform float _WobbleScale;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 color31 = IsGammaSpace() ? float4(0.5019608,0.5019608,1,0) : float4(0.2158605,0.2158605,1,0);
			float mulTime12 = _Time.y * _timeScale;
			float4 appendResult13 = (float4(-_FlameFlickerSpeed , -_FlameFlickerSpeed , 0.0 , 0.0));
			float3 ase_worldPos = i.worldPos;
			float4 appendResult2 = (float4(ase_worldPos.x , ase_worldPos.y , ase_worldPos.z , 0.0));
			float2 uv0_Noise = i.uv_texcoord * _Noise_ST.xy + _Noise_ST.zw;
			float2 panner14 = ( mulTime12 * appendResult13.xy + ( ( appendResult2 * _WorldPosMultiplier ) + float4( ( _NoiseScale * uv0_Noise ), 0.0 , 0.0 ) ).xy);
			float4 lerpResult28 = lerp( color31 , tex2D( _Noise, panner14 ) , _WobbleScale);
			float4 tex2DNode23 = tex2D( _MainTex, ( i.uv_texcoord + ( i.uv_texcoord.y * ( (lerpResult28).rg - float2( 0.5,0.5 ) ) * i.uv_texcoord.y ) ) );
			o.Emission = tex2DNode23.rgb;
			o.Alpha = tex2DNode23.a;
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
611;445;1274;623;976.0801;491.7652;2.721034;True;False
Node;AmplifyShaderEditor.WorldPosInputsNode;1;-31.94977,-218.3698;Float;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode;2;233.8322,-192.918;Float;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;4;164.3162,-39.42207;Float;False;Property;_WorldPosMultiplier;WorldPosMultiplier;5;0;Create;True;0;0;False;0;0.001;0.002;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-214.3298,374.2642;Float;False;Property;_FlameFlickerSpeed;FlameFlickerSpeed;3;0;Create;True;0;0;False;0;0.2;0.01;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;3;267.4002,38.55884;Float;False;Property;_NoiseScale;NoiseScale;2;0;Create;True;0;0;False;0;-0.05;0.0005;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;6;216.7822,136.5212;Float;False;0;15;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NegateNode;8;30.26009,407.6461;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;455.2042,112.4167;Float;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;449.4082,-97.44054;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;7;114.8554,612.5427;Float;False;Property;_timeScale;timeScale;4;0;Create;True;0;0;False;0;-1;0.41;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;11;674.1792,66.16553;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleTimeNode;12;365.0219,564.3425;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;13;250.9067,362.9625;Float;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.PannerNode;14;655.7953,399.4075;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;1,0.5;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;15;834.2609,470.2835;Float;True;Property;_Noise;Noise;1;0;Create;True;0;0;False;0;80445246cc51bc649a90911a060ce7ca;a9632794e416b2a428fad300fdd6fe7c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;29;800.7973,1004.982;Float;False;Property;_WobbleScale;WobbleScale;6;0;Create;True;0;0;False;0;0.71;0.54;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;31;631.65,796.2958;Float;False;Constant;_Color0;Color 0;8;0;Create;True;0;0;False;0;0.5019608,0.5019608,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;28;1160.769,654.8892;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ComponentMaskNode;16;1420.184,513.2933;Float;False;True;True;False;False;1;0;COLOR;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;17;1315.039,8.523697;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;18;1659.872,446.0225;Float;False;2;0;FLOAT2;-0.5,-0.5;False;1;FLOAT2;0.5,0.5;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;1638,142.8134;Float;False;3;3;0;FLOAT;0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;20;1760.034,91.76463;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;27;867.987,-255.4943;Float;False;1;0;FLOAT;0.27;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;23;2104.503,64.01083;Float;True;Property;_MainTex;MainTex;0;0;Create;True;0;0;False;0;8a9d0b74ea0537641a4e7cbb6a6baed7;0fffd48a72fdb3e4394f338a17558687;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldPosInputsNode;24;854.2399,-397.0656;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ScaleAndOffsetNode;25;1101.039,-339.1772;Float;True;3;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2720.202,-63.39805;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;GrassWiggle;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;2;0;1;1
WireConnection;2;1;1;2
WireConnection;2;2;1;3
WireConnection;8;0;5;0
WireConnection;9;0;3;0
WireConnection;9;1;6;0
WireConnection;10;0;2;0
WireConnection;10;1;4;0
WireConnection;11;0;10;0
WireConnection;11;1;9;0
WireConnection;12;0;7;0
WireConnection;13;0;8;0
WireConnection;13;1;8;0
WireConnection;14;0;11;0
WireConnection;14;2;13;0
WireConnection;14;1;12;0
WireConnection;15;1;14;0
WireConnection;28;0;31;0
WireConnection;28;1;15;0
WireConnection;28;2;29;0
WireConnection;16;0;28;0
WireConnection;18;0;16;0
WireConnection;19;0;17;2
WireConnection;19;1;18;0
WireConnection;19;2;17;2
WireConnection;20;0;17;0
WireConnection;20;1;19;0
WireConnection;23;1;20;0
WireConnection;25;0;24;0
WireConnection;25;2;27;0
WireConnection;0;2;23;0
WireConnection;0;9;23;4
ASEEND*/
//CHKSM=54D8F11C34892FC6098CAC415F54F30722847058