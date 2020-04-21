// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "GrassWiggleDepthB"
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
		_WobbleScaleB("WobbleScaleB", Range( 0 , 1)) = 0.71
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
		uniform float _WobbleScaleB;
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

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			o.Normal = float3(0,0,1);
			float cameraDepthFade192 = (( i.eyeDepth -_ProjectionParams.y - _Float1 ) / _Float2);
			float temp_output_200_0 = ( abs( cameraDepthFade192 ) * _BlurAmount );
			float2 temp_output_210_0 = ( float2( 0.001,0 ) * temp_output_200_0 );
			float2 uv_TexCoord243 = i.uv_texcoord + temp_output_210_0;
			float4 color187 = IsGammaSpace() ? float4(0.5019608,0.5019608,1,0) : float4(0.2158605,0.2158605,1,0);
			float mulTime181 = _Time.y * _timeScale;
			float4 appendResult182 = (float4(-_FlickerSpeed , -_FlickerSpeed , -_FlickerSpeed , 0.0));
			float3 ase_worldPos = i.worldPos;
			float4 appendResult175 = (float4(ase_worldPos.x , ase_worldPos.y , ase_worldPos.z , 0.0));
			float smoothstepResult339 = smoothstep( 0.0 , 1.0 , i.uv_texcoord.y);
			float2 panner184 = ( mulTime181 * appendResult182.xy + ( ( appendResult175 * _WorldPosMultiplier ) + saturate( ( _NoiseScale * smoothstepResult339 ) ) ).xy);
			float4 lerpResult190 = lerp( color187 , tex2D( _Noise, panner184 ) , _WobbleScaleB);
			float2 WiggleVarB228 = ( i.uv_texcoord + ( i.uv_texcoord.y * ( (lerpResult190).rg - float2( 0.5,0.5 ) ) * i.uv_texcoord.y ) );
			float4 tex2DNode289 = tex2D( _MainTex, ( ( uv_TexCoord243 + WiggleVarB228 ) / float2( 2,2 ) ) );
			float2 uv_TexCoord235 = i.uv_texcoord + -temp_output_210_0;
			float4 tex2DNode291 = tex2D( _MainTex, ( ( uv_TexCoord235 + WiggleVarB228 ) / float2( 2,2 ) ) );
			float2 temp_output_211_0 = ( float2( 0,0.001 ) * temp_output_200_0 );
			float2 uv_TexCoord242 = i.uv_texcoord + temp_output_211_0;
			float4 tex2DNode292 = tex2D( _MainTex, ( ( uv_TexCoord242 + WiggleVarB228 ) / float2( 2,2 ) ) );
			float2 uv_TexCoord234 = i.uv_texcoord + -temp_output_211_0;
			float4 tex2DNode296 = tex2D( _MainTex, ( ( uv_TexCoord234 + WiggleVarB228 ) / float2( 2,2 ) ) );
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float4 triplanar245 = TriplanarSamplingSF( _TopTexture0, ase_worldPos, ase_worldNormal, 1.0, _Vector8, 1.0, 0 );
			float4 triplanar239 = TriplanarSamplingSF( _TopTexture1, ase_worldPos, ase_worldNormal, 1.0, _Vector10, 1.0, 0 );
			float4 triplanar237 = TriplanarSamplingSF( _TopTexture2, ase_worldPos, ase_worldNormal, 1.0, _Vector9, 1.0, 0 );
			float4 triplanar241 = TriplanarSamplingSF( _TopTexture3, ase_worldPos, ase_worldNormal, 1.0, _Vector11, 1.0, 0 );
			float4 temp_output_253_0 = ( triplanar245.x * triplanar239 * triplanar237 * _TexInfluence * triplanar241 );
			float4 TexVar281 = temp_output_253_0;
			float2 temp_output_215_0 = ( float2( 0.0005,0 ) * temp_output_200_0 );
			float2 uv_TexCoord236 = i.uv_texcoord + temp_output_215_0;
			float4 tex2DNode293 = tex2D( _MainTex, ( ( uv_TexCoord236 + WiggleVarB228 ) / float2( 2,2 ) ) );
			float2 uv_TexCoord249 = i.uv_texcoord + -temp_output_215_0;
			float4 tex2DNode298 = tex2D( _MainTex, ( ( uv_TexCoord249 + WiggleVarB228 ) / float2( 2,2 ) ) );
			float2 temp_output_209_0 = ( float2( 0,0.0005 ) * temp_output_200_0 );
			float2 uv_TexCoord233 = i.uv_texcoord + temp_output_209_0;
			float4 tex2DNode288 = tex2D( _MainTex, ( ( uv_TexCoord233 + WiggleVarB228 ) / float2( 2,2 ) ) );
			float2 uv_TexCoord238 = i.uv_texcoord + -temp_output_209_0;
			float4 tex2DNode297 = tex2D( _MainTex, ( ( uv_TexCoord238 + WiggleVarB228 ) / float2( 2,2 ) ) );
			float2 temp_output_212_0 = ( float2( 0.001,0.001 ) * temp_output_200_0 );
			float2 uv_TexCoord240 = i.uv_texcoord + temp_output_212_0;
			float4 tex2DNode305 = tex2D( _MainTex, ( ( uv_TexCoord240 + WiggleVarB228 ) / float2( 2,2 ) ) );
			float2 uv_TexCoord247 = i.uv_texcoord + -temp_output_212_0;
			float4 tex2DNode290 = tex2D( _MainTex, ( ( uv_TexCoord247 + WiggleVarB228 ) / float2( 2,2 ) ) );
			float2 temp_output_216_0 = ( float2( -0.001,0.001 ) * temp_output_200_0 );
			float2 uv_TexCoord231 = i.uv_texcoord + temp_output_216_0;
			float4 tex2DNode294 = tex2D( _MainTex, ( ( uv_TexCoord231 + WiggleVarB228 ) / float2( 2,2 ) ) );
			float2 uv_TexCoord244 = i.uv_texcoord + -temp_output_216_0;
			float4 tex2DNode295 = tex2D( _MainTex, ( ( uv_TexCoord244 + WiggleVarB228 ) / float2( 2,2 ) ) );
			float2 temp_output_213_0 = ( float2( 0.0005,0.0005 ) * temp_output_200_0 );
			float2 uv_TexCoord250 = i.uv_texcoord + temp_output_213_0;
			float4 tex2DNode299 = tex2D( _MainTex, ( ( uv_TexCoord250 + WiggleVarB228 ) / float2( 2,2 ) ) );
			float2 uv_TexCoord232 = i.uv_texcoord + -temp_output_213_0;
			float4 tex2DNode300 = tex2D( _MainTex, ( ( uv_TexCoord232 + WiggleVarB228 ) / float2( 2,2 ) ) );
			float2 temp_output_214_0 = ( float2( -0.0005,0.0005 ) * temp_output_200_0 );
			float2 uv_TexCoord246 = i.uv_texcoord + temp_output_214_0;
			float4 tex2DNode303 = tex2D( _MainTex, ( ( uv_TexCoord246 + WiggleVarB228 ) / float2( 2,2 ) ) );
			float2 uv_TexCoord248 = i.uv_texcoord + -temp_output_214_0;
			float4 tex2DNode301 = tex2D( _MainTex, ( ( uv_TexCoord248 + WiggleVarB228 ) / float2( 2,2 ) ) );
			float cameraDepthFade319 = (( i.eyeDepth -_ProjectionParams.y - _Float5 ) / _Float6);
			float smoothstepResult324 = smoothstep( _Float7 , _Float8 , cameraDepthFade319);
			float cameraDepthFade307 = (( i.eyeDepth -_ProjectionParams.y - _Float4 ) / _Float3);
			o.Emission = ( ( ( _Color0 * ( ( ( tex2DNode289 + tex2DNode291 + tex2DNode292 + tex2DNode296 + TexVar281 ) + ( tex2DNode293 + tex2DNode298 + tex2DNode288 + tex2DNode297 + TexVar281 ) + ( tex2DNode305 + tex2DNode290 + tex2DNode294 + tex2DNode295 + TexVar281 ) + ( tex2DNode299 + tex2DNode300 + tex2DNode303 + tex2DNode301 + TexVar281 ) ) / 16.0 ) ) + ( smoothstepResult324 * _Color1 ) ) * saturate( ( cameraDepthFade307 + ( ( 1.0 - cameraDepthFade307 ) * _ForegroundColor ) ) ) ).rgb;
			o.Alpha = ( ( ( tex2DNode289.a + tex2DNode291.a + tex2DNode292.a + tex2DNode296.a ) + ( tex2DNode293.a + tex2DNode298.a + tex2DNode288.a + tex2DNode297.a ) + ( tex2DNode305.a + tex2DNode290.a + tex2DNode294.a + tex2DNode295.a ) + ( tex2DNode299.a + tex2DNode300.a + tex2DNode303.a + tex2DNode301.a ) ) / 16.0 );
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
76;257;1000;496;11668.05;-3097.395;1.552292;True;False
Node;AmplifyShaderEditor.TextureCoordinatesNode;172;-11057.76,3311.02;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;174;-10807.54,3302.59;Float;False;Property;_NoiseScale;NoiseScale;3;0;Create;True;0;0;False;0;-0.05;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;339;-10800.62,3393.01;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;170;-11025.49,3028.129;Float;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;173;-10993.62,3693.777;Float;False;Property;_FlickerSpeed;FlickerSpeed;5;0;Create;True;0;0;False;0;0.2;0.01;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;176;-10829.22,3207.077;Float;False;Property;_WorldPosMultiplier;WorldPosMultiplier;9;0;Create;True;0;0;False;0;0.001;0.002;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;175;-10759.71,3053.58;Float;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;178;-10605.94,3347.216;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;177;-10583.17,3796.61;Float;False;Property;_timeScale;timeScale;7;0;Create;True;0;0;False;0;-1;1.96;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;180;-10654.54,3626.448;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;340;-10413.08,3386.374;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;179;-10544.13,3149.058;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DynamicAppendNode;182;-10447.12,3547.029;Float;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleTimeNode;181;-10333.01,3748.409;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;183;-10317.81,3312.664;Float;True;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.PannerNode;184;-10042.24,3583.474;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;1,0.5;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;186;-9863.771,3654.35;Float;True;Property;_Noise;Noise;1;0;Create;True;0;0;False;0;80445246cc51bc649a90911a060ce7ca;a9632794e416b2a428fad300fdd6fe7c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;185;-9922.207,3881.053;Float;False;Property;_WobbleScaleB;WobbleScaleB;12;0;Create;True;0;0;False;0;0.71;0.079;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;187;-9824.979,3426.803;Float;False;Constant;_Color2;Color 2;8;0;Create;True;0;0;False;0;0.5019608,0.5019608,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;190;-9495.642,3680.796;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;188;-8991.553,-1782.651;Float;False;Property;_Float2;Float 2;10;0;Create;True;0;0;False;0;0;22;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;189;-8982.418,-1685.811;Float;False;Property;_Float1;Float 1;20;0;Create;True;0;0;False;0;0;20.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CameraDepthFade;192;-8801.229,-1773.18;Float;False;3;2;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;191;-9240.389,3705.684;Float;False;True;True;False;False;1;0;COLOR;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.AbsOpNode;194;-8503.952,-1787.887;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;196;-9004.863,3709.169;Float;False;2;0;FLOAT2;-0.5,-0.5;False;1;FLOAT2;0.5,0.5;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;195;-7669.179,-4569.025;Float;False;2373.493;1433.292;Love side to side;24;328;311;296;292;291;289;285;282;277;271;264;263;259;258;243;242;235;234;229;225;211;210;199;198;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;193;-8805.433,-1540.697;Float;True;Property;_BlurAmount;BlurAmount;14;0;Create;True;0;0;False;0;0.01;40;0;40;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;197;-9062.511,3404.859;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;201;-7450.253,-872.9573;Float;False;Constant;_Vector4;Vector 4;1;0;Create;True;0;0;False;0;0.001,0.001;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;199;-7547.118,-3640.891;Float;False;Constant;_Vector1;Vector 1;1;0;Create;True;0;0;False;0;0,0.001;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;207;-7577.869,-2779.48;Float;False;Constant;_Vector3;Vector 3;1;0;Create;True;0;0;False;0;0.0005,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;202;-7582.078,740.9113;Float;False;Constant;_Vector6;Vector 6;1;0;Create;True;0;0;False;0;0.0005,0.0005;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;200;-8368.773,-1693.706;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;204;-7658.252,1286.646;Float;False;Constant;_Vector5;Vector 5;1;0;Create;True;0;0;False;0;-0.0005,0.0005;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;198;-7492.052,-4228.903;Float;False;Constant;_Vector0;Vector 0;1;0;Create;True;0;0;False;0;0.001,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;205;-7499.292,-1758.55;Float;False;Constant;_Vector2;Vector 2;1;0;Create;True;0;0;False;0;0,0.0005;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;206;-8756.198,3651.525;Float;False;3;3;0;FLOAT;0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;203;-7475.319,-270.9462;Float;False;Constant;_Vector7;Vector 7;1;0;Create;True;0;0;False;0;-0.001,0.001;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;215;-7270.722,-2683.681;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;213;-7234.175,672.2641;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;216;-7266.597,-256.1711;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;208;-8563.408,3604.638;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;211;-7308.396,-3612.117;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;214;-7258.087,1661.68;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;212;-7238.057,-847.6631;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;210;-7279.857,-4205.608;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;209;-7294.635,-1694.266;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NegateNode;218;-7082.254,1811.416;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;228;-8331.854,3590.952;Float;False;WiggleVarB;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;223;-9810.381,2226.568;Float;False;Property;_Vector9;Vector 9;16;0;Create;True;0;0;False;0;0.2,0.2;0.05,0.05;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.NegateNode;225;-7093.565,-4030.377;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NegateNode;217;-7084.431,-2510.45;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NegateNode;221;-7144.801,-1550.53;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NegateNode;229;-7044.563,-3431.382;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;219;-9808.906,1714.651;Float;False;Property;_Vector8;Vector 8;18;0;Create;True;0;0;False;0;0.2,0.2;0.002,0.002;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;226;-9881.594,2673.935;Float;False;Property;_Vector11;Vector 11;15;0;Create;True;0;0;False;0;0.2,0.2;0.05,0.01;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;220;-9806.381,1970.568;Float;False;Property;_Vector10;Vector 10;19;0;Create;True;0;0;False;0;0.2,0.2;0.01,0.01;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.NegateNode;227;-7047.883,845.4963;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NegateNode;222;-7118.184,-672.0491;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NegateNode;224;-7074.902,-104.2902;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TriplanarNode;245;-9638.41,1675.381;Float;True;Spherical;World;False;Top Texture 0;_TopTexture0;white;0;Assets/_MyStuff/Sprites/4bf9a3477bd635c0d02fab3e7d44b92f.jpg;Mid Texture 0;_MidTexture0;white;-1;None;Bot Texture 0;_BotTexture0;white;-1;None;Triplanar Sampler;False;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT2;1,1;False;4;FLOAT;1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;232;-6848.524,793.1782;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0.59,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;251;-9485.979,2489.347;Float;False;Property;_TexInfluence;TexInfluence;28;0;Create;True;0;0;False;0;1;-3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;242;-6892.048,-3789.034;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0.17,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TriplanarNode;241;-9619.814,2615.779;Float;True;Spherical;World;False;Top Texture 3;_TopTexture3;white;4;Assets/AmplifyShaderEditor/Examples/Assets/Textures/Misc/Checkers.png;Mid Texture 3;_MidTexture3;white;-1;None;Bot Texture 3;_BotTexture3;white;-1;None;Triplanar Sampler;False;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT2;1,1;False;4;FLOAT;1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;247;-6852.406,-726.7483;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0.59,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;244;-6853.869,-127.7532;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0.59,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;243;-6890.584,-4395.16;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0.17,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;240;-6848.785,-1037.214;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0.17,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;238;-6887.16,-1565.848;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0.59,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;234;-6895.669,-3483.7;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0.59,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;249;-6885.071,-2562.767;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0.59,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;246;-6841.74,1484.762;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0.17,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;250;-6844.902,482.7118;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0.17,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;233;-6878.287,-1871.184;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0.17,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;230;-6793.018,-1242.722;Float;True;228;WiggleVarB;1;0;OBJECT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;231;-6850.25,-433.0901;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0.17,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TriplanarNode;239;-9635.885,1931.299;Float;True;Spherical;World;False;Top Texture 1;_TopTexture1;white;11;Assets/AmplifyShaderEditor/Examples/Assets/Textures/Misc/AnisoMap.jpg;Mid Texture 1;_MidTexture1;white;-1;None;Bot Texture 1;_BotTexture1;white;-1;None;Triplanar Sampler;False;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT2;1,1;False;4;FLOAT;1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;248;-6819.36,1785.098;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0.59,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TriplanarNode;237;-9639.885,2187.299;Float;True;Spherical;World;False;Top Texture 2;_TopTexture2;white;6;Assets/AmplifyShaderEditor/Examples/Assets/Textures/Misc/Checkers.png;Mid Texture 2;_MidTexture2;white;-1;None;Bot Texture 2;_BotTexture2;white;-1;None;Triplanar Sampler;False;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT2;1,1;False;4;FLOAT;1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;236;-6881.45,-2873.234;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0.17,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;235;-6894.206,-4082.695;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0.59,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;253;-9142.133,1741.934;Float;True;5;5;0;FLOAT;0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT4;0,0,0,0;False;3;FLOAT;0;False;4;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;267;-6148.788,990.0533;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;266;-6233.125,1402.024;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;256;-6267.203,-2008.692;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;252;-6283.263,-2604.65;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;259;-6293.758,-4235.921;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;257;-6230.61,-668.8711;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;255;-6209.294,-358.0062;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;254;-6240.748,-2393.249;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;262;-6174.473,1691.236;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;264;-6261.937,-3668.676;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;261;-6162.548,719.6833;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;258;-6239.442,-3982.699;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;263;-6275.769,-3352.653;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;265;-6275.088,-955.0503;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;268;-6144.274,-84.94714;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;260;-6280.589,-1657.582;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;284;-6026.088,1651.719;Float;False;2;0;FLOAT2;0,0;False;1;FLOAT2;2,2;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;276;-6016.588,-352.7861;Float;False;2;0;FLOAT2;0,0;False;1;FLOAT2;2,2;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;280;-5988.343,-90.79114;Float;False;2;0;FLOAT2;0,0;False;1;FLOAT2;2,2;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;271;-6157.83,-4229.991;Float;False;2;0;FLOAT2;0,0;False;1;FLOAT2;2,2;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;278;-6028.458,1038.482;Float;False;2;0;FLOAT2;0,0;False;1;FLOAT2;2,2;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;277;-6121.526,-3985.882;Float;False;2;0;FLOAT2;0,0;False;1;FLOAT2;2,2;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;283;-6051.841,1391.07;Float;False;2;0;FLOAT2;0,0;False;1;FLOAT2;2,2;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;286;-6098.83,-2370.359;Float;False;2;0;FLOAT2;0,0;False;1;FLOAT2;2,2;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;279;-6044.583,729.1167;Float;False;2;0;FLOAT2;0,0;False;1;FLOAT2;2,2;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;274;-6078.873,-2001.164;Float;False;2;0;FLOAT2;0,0;False;1;FLOAT2;2,2;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;285;-6122.504,-3365.578;Float;False;2;0;FLOAT2;0,0;False;1;FLOAT2;2,2;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;281;-8619.422,1720.01;Float;False;TexVar;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;275;-6038.588,-656.7861;Float;False;2;0;FLOAT2;0,0;False;1;FLOAT2;2,2;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;269;-6098.83,-2593.209;Float;False;2;0;FLOAT2;0,0;False;1;FLOAT2;2,2;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;270;-6451.837,-1284.813;Float;True;Property;_MainTex;MainTex;2;0;Create;True;0;0;False;0;None;None;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;272;-6073.588,-933.7861;Float;False;2;0;FLOAT2;0,0;False;1;FLOAT2;2,2;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;282;-6129.852,-3662.209;Float;False;2;0;FLOAT2;0,0;False;1;FLOAT2;2,2;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;273;-6082.588,-1684.786;Float;False;2;0;FLOAT2;0,0;False;1;FLOAT2;2,2;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;292;-5998.166,-3705.83;Float;True;Property;_TextureSample2;Texture Sample 2;1;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;293;-5965.878,-2609.594;Float;True;Property;_TextureSample6;Texture Sample 6;4;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;302;-5944.407,-1371.837;Float;True;281;TexVar;1;0;OBJECT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SamplerNode;305;-5909.452,-967.9102;Float;True;Property;_TextureSample10;Texture Sample 10;1;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;301;-5910.932,1585.702;Float;True;Property;_TextureSample14;Texture Sample 14;5;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;298;-5955.895,-2351.568;Float;True;Property;_TextureSample7;Texture Sample 7;6;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;300;-5914.096,1004.378;Float;True;Property;_TextureSample8;Texture Sample 8;6;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;287;-4169.858,-1837.246;Float;False;Property;_Float3;Float 3;24;0;Create;True;0;0;False;0;0;7.9;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;299;-5924.078,746.3524;Float;True;Property;_TextureSample9;Texture Sample 9;4;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;294;-5901.158,-401.9792;Float;True;Property;_TextureSample13;Texture Sample 13;1;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;303;-5915.785,1312.283;Float;True;Property;_TextureSample12;Texture Sample 12;3;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;290;-5899.469,-709.8843;Float;True;Property;_TextureSample15;Texture Sample 15;2;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;289;-6006.459,-4271.761;Float;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;291;-5996.477,-4013.734;Float;True;Property;_TextureSample1;Texture Sample 1;2;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;288;-5957.584,-2043.663;Float;True;Property;_TextureSample4;Texture Sample 4;3;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;297;-5952.732,-1770.244;Float;True;Property;_TextureSample5;Texture Sample 5;5;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;295;-5808.752,-105.3032;Float;True;Property;_TextureSample11;Texture Sample 11;2;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;304;-4191.421,-1766.808;Float;False;Property;_Float4;Float 4;25;0;Create;True;0;0;False;0;0;6.8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;296;-5993.313,-3432.411;Float;True;Property;_TextureSample3;Texture Sample 3;2;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;312;-4196.919,-2403.864;Float;False;Property;_Float5;Float 5;13;0;Create;True;0;0;False;0;0;10.03;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;308;-5434.835,-2455.142;Float;False;5;5;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;FLOAT4;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;310;-5393.036,900.8032;Float;False;5;5;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;FLOAT4;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;309;-5316.939,-666.7222;Float;False;5;5;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;FLOAT4;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;306;-4206.054,-2500.704;Float;False;Property;_Float6;Float 6;8;0;Create;True;0;0;False;0;0;56.9;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CameraDepthFade;307;-3958.95,-1892.913;Float;False;3;2;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;311;-5459.23,-3605.066;Float;False;5;5;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;FLOAT4;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;313;-3709.857,-1927.996;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;317;-3920.9,-1674.64;Float;False;Property;_ForegroundColor;ForegroundColor;23;0;Create;True;0;0;False;0;0.4094874,0.6091207,0.8113208,0;0.5660378,0.5232416,0.4298683,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;316;-3959.334,-2324.242;Float;False;Property;_Float7;Float 7;26;0;Create;True;0;0;False;0;0;0.25;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CameraDepthFade;319;-4015.73,-2493.232;Float;False;3;2;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;314;-4640.806,-1294.713;Float;True;Constant;_Float0;Float 0;2;0;Create;True;0;0;False;0;16;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;315;-3962.295,-2248.756;Float;False;Property;_Float8;Float 8;27;0;Create;True;0;0;False;0;0;0.55;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;318;-4678.963,-1626.365;Float;False;4;4;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;321;-3343.852,-1991.247;Float;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;322;-4486.149,-1856.382;Float;False;Property;_Color0;Color 0;22;0;Create;True;0;0;False;0;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;320;-3917.091,-2176.97;Float;False;Property;_Color1;Color 1;21;0;Create;True;0;0;False;0;0.4094874,0.6091207,0.8113208,0;0.390308,0.4020675,0.4622642,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleDivideOpNode;323;-4368.8,-1430.975;Float;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;324;-3757.498,-2347.742;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;329;-5404.983,1237.217;Float;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;328;-5480.41,-3392.376;Float;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;330;-4185.767,-1498.3;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;327;-5446.782,-2118.729;Float;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;331;-5318.712,-250.2532;Float;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;326;-3597.615,-2339.673;Float;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;325;-3120.416,-2020.468;Float;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;333;-3122.861,-2368.983;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;334;-2887,-2084.791;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;332;-4663.797,-932.8442;Float;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;335;-8850.597,1728.807;Float;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;336;-2747.708,-2272.458;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;337;-4380.608,-1262.716;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;338;-3673.401,-2612.411;Float;True;Property;_TextureSample16;Texture Sample 16;17;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-1968.927,-2097.914;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;GrassWiggleDepthB;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;339;0;172;2
WireConnection;175;0;170;1
WireConnection;175;1;170;2
WireConnection;175;2;170;3
WireConnection;178;0;174;0
WireConnection;178;1;339;0
WireConnection;180;0;173;0
WireConnection;340;0;178;0
WireConnection;179;0;175;0
WireConnection;179;1;176;0
WireConnection;182;0;180;0
WireConnection;182;1;180;0
WireConnection;182;2;180;0
WireConnection;181;0;177;0
WireConnection;183;0;179;0
WireConnection;183;1;340;0
WireConnection;184;0;183;0
WireConnection;184;2;182;0
WireConnection;184;1;181;0
WireConnection;186;1;184;0
WireConnection;190;0;187;0
WireConnection;190;1;186;0
WireConnection;190;2;185;0
WireConnection;192;0;188;0
WireConnection;192;1;189;0
WireConnection;191;0;190;0
WireConnection;194;0;192;0
WireConnection;196;0;191;0
WireConnection;200;0;194;0
WireConnection;200;1;193;0
WireConnection;206;0;197;2
WireConnection;206;1;196;0
WireConnection;206;2;197;2
WireConnection;215;0;207;0
WireConnection;215;1;200;0
WireConnection;213;0;202;0
WireConnection;213;1;200;0
WireConnection;216;0;203;0
WireConnection;216;1;200;0
WireConnection;208;0;197;0
WireConnection;208;1;206;0
WireConnection;211;0;199;0
WireConnection;211;1;200;0
WireConnection;214;0;204;0
WireConnection;214;1;200;0
WireConnection;212;0;201;0
WireConnection;212;1;200;0
WireConnection;210;0;198;0
WireConnection;210;1;200;0
WireConnection;209;0;205;0
WireConnection;209;1;200;0
WireConnection;218;0;214;0
WireConnection;228;0;208;0
WireConnection;225;0;210;0
WireConnection;217;0;215;0
WireConnection;221;0;209;0
WireConnection;229;0;211;0
WireConnection;227;0;213;0
WireConnection;222;0;212;0
WireConnection;224;0;216;0
WireConnection;245;3;219;0
WireConnection;232;1;227;0
WireConnection;242;1;211;0
WireConnection;241;3;226;0
WireConnection;247;1;222;0
WireConnection;244;1;224;0
WireConnection;243;1;210;0
WireConnection;240;1;212;0
WireConnection;238;1;221;0
WireConnection;234;1;229;0
WireConnection;249;1;217;0
WireConnection;246;1;214;0
WireConnection;250;1;213;0
WireConnection;233;1;209;0
WireConnection;231;1;216;0
WireConnection;239;3;220;0
WireConnection;248;1;218;0
WireConnection;237;3;223;0
WireConnection;236;1;215;0
WireConnection;235;1;225;0
WireConnection;253;0;245;1
WireConnection;253;1;239;0
WireConnection;253;2;237;0
WireConnection;253;3;251;0
WireConnection;253;4;241;0
WireConnection;267;0;232;0
WireConnection;267;1;230;0
WireConnection;266;0;246;0
WireConnection;266;1;230;0
WireConnection;256;0;233;0
WireConnection;256;1;230;0
WireConnection;252;0;236;0
WireConnection;252;1;230;0
WireConnection;259;0;243;0
WireConnection;259;1;230;0
WireConnection;257;0;247;0
WireConnection;257;1;230;0
WireConnection;255;0;231;0
WireConnection;255;1;230;0
WireConnection;254;0;249;0
WireConnection;254;1;230;0
WireConnection;262;0;248;0
WireConnection;262;1;230;0
WireConnection;264;0;242;0
WireConnection;264;1;230;0
WireConnection;261;0;250;0
WireConnection;261;1;230;0
WireConnection;258;0;235;0
WireConnection;258;1;230;0
WireConnection;263;0;234;0
WireConnection;263;1;230;0
WireConnection;265;0;240;0
WireConnection;265;1;230;0
WireConnection;268;0;244;0
WireConnection;268;1;230;0
WireConnection;260;0;238;0
WireConnection;260;1;230;0
WireConnection;284;0;262;0
WireConnection;276;0;255;0
WireConnection;280;0;268;0
WireConnection;271;0;259;0
WireConnection;278;0;267;0
WireConnection;277;0;258;0
WireConnection;283;0;266;0
WireConnection;286;0;254;0
WireConnection;279;0;261;0
WireConnection;274;0;256;0
WireConnection;285;0;263;0
WireConnection;281;0;253;0
WireConnection;275;0;257;0
WireConnection;269;0;252;0
WireConnection;272;0;265;0
WireConnection;282;0;264;0
WireConnection;273;0;260;0
WireConnection;292;0;270;0
WireConnection;292;1;282;0
WireConnection;293;0;270;0
WireConnection;293;1;269;0
WireConnection;305;0;270;0
WireConnection;305;1;272;0
WireConnection;301;0;270;0
WireConnection;301;1;284;0
WireConnection;298;0;270;0
WireConnection;298;1;286;0
WireConnection;300;0;270;0
WireConnection;300;1;278;0
WireConnection;299;0;270;0
WireConnection;299;1;279;0
WireConnection;294;0;270;0
WireConnection;294;1;276;0
WireConnection;303;0;270;0
WireConnection;303;1;283;0
WireConnection;290;0;270;0
WireConnection;290;1;275;0
WireConnection;289;0;270;0
WireConnection;289;1;271;0
WireConnection;291;0;270;0
WireConnection;291;1;277;0
WireConnection;288;0;270;0
WireConnection;288;1;274;0
WireConnection;297;0;270;0
WireConnection;297;1;273;0
WireConnection;295;0;270;0
WireConnection;295;1;280;0
WireConnection;296;0;270;0
WireConnection;296;1;285;0
WireConnection;308;0;293;0
WireConnection;308;1;298;0
WireConnection;308;2;288;0
WireConnection;308;3;297;0
WireConnection;308;4;302;0
WireConnection;310;0;299;0
WireConnection;310;1;300;0
WireConnection;310;2;303;0
WireConnection;310;3;301;0
WireConnection;310;4;302;0
WireConnection;309;0;305;0
WireConnection;309;1;290;0
WireConnection;309;2;294;0
WireConnection;309;3;295;0
WireConnection;309;4;302;0
WireConnection;307;0;287;0
WireConnection;307;1;304;0
WireConnection;311;0;289;0
WireConnection;311;1;291;0
WireConnection;311;2;292;0
WireConnection;311;3;296;0
WireConnection;311;4;302;0
WireConnection;313;0;307;0
WireConnection;319;0;306;0
WireConnection;319;1;312;0
WireConnection;318;0;311;0
WireConnection;318;1;308;0
WireConnection;318;2;309;0
WireConnection;318;3;310;0
WireConnection;321;0;313;0
WireConnection;321;1;317;0
WireConnection;323;0;318;0
WireConnection;323;1;314;0
WireConnection;324;0;319;0
WireConnection;324;1;316;0
WireConnection;324;2;315;0
WireConnection;329;0;299;4
WireConnection;329;1;300;4
WireConnection;329;2;303;4
WireConnection;329;3;301;4
WireConnection;328;0;289;4
WireConnection;328;1;291;4
WireConnection;328;2;292;4
WireConnection;328;3;296;4
WireConnection;330;0;322;0
WireConnection;330;1;323;0
WireConnection;327;0;293;4
WireConnection;327;1;298;4
WireConnection;327;2;288;4
WireConnection;327;3;297;4
WireConnection;331;0;305;4
WireConnection;331;1;290;4
WireConnection;331;2;294;4
WireConnection;331;3;295;4
WireConnection;326;0;324;0
WireConnection;326;1;320;0
WireConnection;325;0;307;0
WireConnection;325;1;321;0
WireConnection;333;0;330;0
WireConnection;333;1;326;0
WireConnection;334;0;325;0
WireConnection;332;0;328;0
WireConnection;332;1;327;0
WireConnection;332;2;331;0
WireConnection;332;3;329;0
WireConnection;335;0;253;0
WireConnection;336;0;333;0
WireConnection;336;1;334;0
WireConnection;337;0;332;0
WireConnection;337;1;314;0
WireConnection;0;2;336;0
WireConnection;0;9;337;0
ASEEND*/
//CHKSM=1E3E8C67C1B48B8FCC2BC6139F17C2CD001B31D1