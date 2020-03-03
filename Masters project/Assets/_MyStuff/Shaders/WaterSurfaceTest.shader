// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "WaterSurfaceTest"
{
	Properties
	{
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_TextureSample1("Texture Sample 1", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _TextureSample1;
		uniform sampler2D _TextureSample0;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 color30 = IsGammaSpace() ? float4(0.1367925,0.6861063,1,0) : float4(0.01671052,0.4284571,1,0);
			float mulTime34 = _Time.y * 0.1;
			float mulTime16 = _Time.y * 0.2;
			float2 panner12 = ( mulTime16 * float2( 0.66,-0.07 ) + i.uv_texcoord);
			float4 smoothstepResult21 = smoothstep( 0.96 , -1.55 , tex2D( _TextureSample0, panner12 ));
			float2 panner1 = ( mulTime34 * float2( 1.05,2.23 ) + smoothstepResult21.rg);
			o.Emission = ( color30 + ( 1.0 - step( tex2D( _TextureSample1, panner1 ) , 0.4 ) ) ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17000
54;548;1920;276;1444.669;226.9352;1.6;True;True
Node;AmplifyShaderEditor.RangedFloatNode;17;-1376.348,154.307;Float;False;Constant;_Float0;Float 0;3;0;Create;True;0;0;False;0;0.2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;18;-1346.914,-492.0654;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;15;-1417.348,-82.69299;Float;False;Constant;_Vector1;Vector 1;3;0;Create;True;0;0;False;0;0.66,-0.07;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleTimeNode;16;-1187.511,140.1928;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;12;-1143.348,-144.693;Float;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;35;-1595.088,250.5219;Float;False;Constant;_Float6;Float 6;3;0;Create;True;0;0;False;0;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;22;-598.6389,-159.1138;Float;False;Constant;_Float3;Float 3;2;0;Create;True;0;0;False;0;0.96;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;24;-628.6389,-6.113831;Float;False;Constant;_Float4;Float 4;2;0;Create;True;0;0;False;0;-1.55;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;-866.7401,-199.273;Float;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;False;0;9789d23040cb1fb45ad60392430c3c15;61c0b9c0523734e0e91bc6043c72a490;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;14;-867.348,56.30701;Float;False;Constant;_Vector0;Vector 0;3;0;Create;True;0;0;False;0;1.05,2.23;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SmoothstepOpNode;21;-466.9275,-178.0987;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleTimeNode;34;-1406.251,236.4077;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;1;-352.2506,75.88976;Float;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;3;-174.4517,-123.242;Float;True;Property;_TextureSample1;Texture Sample 1;1;0;Create;True;0;0;False;0;9fbef4b79ca3b784ba023cb1331520d5;9fbef4b79ca3b784ba023cb1331520d5;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;27;-6.414558,113.9213;Float;False;Constant;_Float5;Float 5;2;0;Create;True;0;0;False;0;0.4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;25;203.6229,-92.61363;Float;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;28;489.1238,54.37241;Float;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;30;446.4526,-143.4597;Float;False;Constant;_Color0;Color 0;2;0;Create;True;0;0;False;0;0.1367925,0.6861063,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;33;-699.4196,312.8481;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;29;791.7905,4.542284;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.AbsOpNode;32;-1013.091,301.5632;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinTimeNode;9;-1246.048,352.807;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;6;-879.9074,207.4251;Float;False;Constant;_Float1;Float 1;2;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-1041.936,484.3174;Float;False;Constant;_Float2;Float 2;2;0;Create;True;0;0;False;0;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1068.469,-88.68433;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;WaterSurfaceTest;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;16;0;17;0
WireConnection;12;0;18;0
WireConnection;12;2;15;0
WireConnection;12;1;16;0
WireConnection;2;1;12;0
WireConnection;21;0;2;0
WireConnection;21;1;22;0
WireConnection;21;2;24;0
WireConnection;34;0;35;0
WireConnection;1;0;21;0
WireConnection;1;2;14;0
WireConnection;1;1;34;0
WireConnection;3;1;1;0
WireConnection;25;0;3;0
WireConnection;25;1;27;0
WireConnection;28;0;25;0
WireConnection;33;1;20;0
WireConnection;29;0;30;0
WireConnection;29;1;28;0
WireConnection;32;0;9;1
WireConnection;0;2;29;0
ASEEND*/
//CHKSM=47EDF9DB8B763022D10D7349B173B4690FFF37FC