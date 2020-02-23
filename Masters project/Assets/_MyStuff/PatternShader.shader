// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "PatternShader"
{
	Properties
	{
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float temp_output_100_0 = fmod( floor( ( i.uv_texcoord.x * 12.0 ) ) , 2.0 );
			float4 color124 = IsGammaSpace() ? float4(0.5,0.08254716,0.08254716,0) : float4(0.2140411,0.007524507,0.007524507,0);
			float fmodResult109 = frac(floor( ( i.uv_texcoord.y * 12.0 ) )/2.0)*2.0;
			o.Emission = ( ( temp_output_100_0 + color124 ) * ( color124.g + fmodResult109 ) ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17000
31;302;1920;997;445.4928;-2832.42;1;True;True
Node;AmplifyShaderEditor.TextureCoordinatesNode;102;-1617.479,3575.67;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;99;-1553.479,3927.67;Float;False;Constant;_Float5;Float 5;0;0;Create;True;0;0;False;0;12;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;98;-1233.479,3943.67;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;103;-1233.479,3719.67;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FloorOpNode;108;-929.4788,4071.67;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FloorOpNode;107;-929.4788,3719.67;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FmodOpNode;100;-737.4788,3735.67;Float;True;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimplifiedFModOpNode;109;-753.4788,4071.67;Float;True;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;128;-321.4788,3623.67;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;129;-337.4788,4247.67;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;124;-97.47878,3879.67;Float;False;Constant;_Color2;Color 2;3;0;Create;True;0;0;False;0;0.5,0.08254716,0.08254716,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;123;126.5212,3639.67;Float;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;126;142.5212,4167.67;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;56;-287.6542,417.1028;Float;True;2;0;FLOAT;0;False;1;FLOAT;1.39;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;139;-1328.37,2916.221;Float;False;Constant;_Float7;Float 7;0;0;Create;True;0;0;False;0;60;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;62;-45.26891,1855.001;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;32;400.4361,-231.683;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;31;541.7789,-732.4152;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;63;1693.75,-339.7033;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FractNode;19;-431.0595,-492.2001;Float;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;86;-843.6545,232.4028;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;2.31;False;1;FLOAT;0
Node;AmplifyShaderEditor.LengthOpNode;24;63.39951,-477.1693;Float;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;91;-1210.005,220.0352;Float;False;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;73;28.39581,323.5661;Float;False;Constant;_thickness;thickness;0;0;Create;True;0;0;False;0;0.28;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;29;115.8816,-165.0481;Float;False;Constant;_Float0;Float 0;0;0;Create;True;0;0;False;0;0.91;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;36;-1.906891,783.1973;Float;False;Constant;_Float3;Float 3;0;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;89;-1456.141,183.4628;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;76;-3242.061,119.4868;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SqrtOpNode;55;-1153.978,1328.383;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;35;-20.73549,429.8704;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;16;-955.7245,-631.2433;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;49;-860.1305,1742.958;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;38;-720.0441,299.3615;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;84;659.7083,283.067;Float;False;Property;_Keyword0;Keyword 0;1;0;Create;True;0;0;False;0;0;1;0;True;;Toggle;2;Key0;Key1;Create;False;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;28;69.01041,-698.8593;Float;True;Simplex2D;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;3.81;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;37;192.0931,790.1973;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;67;1499.548,562.041;Float;False;Property;_Keyword1;Keyword 1;2;0;Create;True;0;0;False;0;0;1;0;True;;Toggle;2;Key0;Key1;Create;False;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;52;-1382.036,1601.376;Float;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;94;-781.2155,542.5642;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;2.63;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;64;-1700.828,454.9252;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SqrtOpNode;95;-1027.747,2076.68;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;65;-1205.151,494.7736;Float;False;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;71;858.668,726.7791;Float;True;ConstantBiasScale;-1;;1;63208df05c83e8e49a48ffbdce2e43a0;0;3;3;FLOAT;0;False;1;FLOAT;-0.2;False;2;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;30;305.2886,-877.8253;Float;False;Constant;_Color0;Color 0;0;0;Create;True;0;0;False;0;1,0.96875,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SinTimeNode;20;-270.6932,-633.1083;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;79;-2621.834,170.9406;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;33;517.976,-501.1714;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;27;346.5829,-464.8878;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;81;1474.061,-326.9628;Float;False;Constant;_Vector0;Vector 0;3;0;Create;True;0;0;False;0;5,5;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleAddOpNode;50;-452.1299,1694.958;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;88;-758.3279,2023.768;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;66;924.1683,-590.0764;Float;True;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.FloorOpNode;25;-322.7421,-878.8743;Float;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ClampOpNode;59;-1469.403,2295.329;Float;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;130;-1377.314,1208.551;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;-571.9621,-756.3842;Float;True;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;83;573.7332,452.9212;Float;True;Simplex2D;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;2.41;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;21;-246.3689,-492.5513;Float;True;5;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT2;1,1;False;3;FLOAT2;-1,-1;False;4;FLOAT2;1,1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;77;-2863.4,265.2816;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;54;-1629.528,1332.135;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SqrtOpNode;75;-3128.84,-0.5351563;Float;False;1;0;FLOAT;2.67;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;68;-3174.523,462.9785;Float;False;Constant;_Float2;Float 2;0;0;Create;True;0;0;False;0;3.2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ATanOpNode;60;-1212.257,2250.553;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;-2908.764,407.7968;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimplifiedFModOpNode;131;-40.64632,1570.153;Float;True;2;0;FLOAT;0;False;1;FLOAT;0.3;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;47;-381.1299,1993.958;Float;False;Constant;_Float9;Float 9;19;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;46;-1984.13,1686.958;Float;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.AbsOpNode;23;-60.1593,-603.9474;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;74;-1441.745,480.2315;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;34;-2439.094,2043.125;Float;True;Constant;_Vector2;Vector 2;2;0;Create;True;0;0;False;0;2.1,2.1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.FmodOpNode;72;-2165.795,350.0793;Float;True;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;61;-1725.382,2060.037;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;85;558.0931,688.1973;Float;True;Property;_TextureSample1;Texture Sample 1;0;0;Create;True;0;0;False;0;61c0b9c0523734e0e91bc6043c72a490;61c0b9c0523734e0e91bc6043c72a490;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ATanOpNode;53;-1136.771,1597.338;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;41;2028.538,-323.5812;Float;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FloorOpNode;93;-2353.246,292.2726;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;26;-98.99219,-895.4023;Float;False;Constant;_Color1;Color 1;0;0;Create;True;0;0;False;0;1,0.3055533,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;45;-2220.13,1678.958;Float;True;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;43;-2908.129,1550.958;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;51;-1526.901,1614.907;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;48;-1714.479,1719.473;Float;False;Constant;_Float4;Float 4;2;0;Create;True;0;0;False;0;0.04;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;82;172.0931,544.1973;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;90;422.0931,682.1973;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;78;-2916.825,-0.5351563;Float;True;2;0;FLOAT;2;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FloorOpNode;137;-737.4788,3047.67;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-650.9779,-502.8235;Float;True;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimplifiedFModOpNode;138;-529.4788,3047.67;Float;True;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;142;462.5212,2999.67;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;70;252.3958,351.5661;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;42;-2844.13,1854.958;Float;True;Constant;_Vector1;Vector 1;2;0;Create;True;0;0;False;0;0.5,0.5;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.AbsOpNode;80;1126.373,738.0836;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-882.7515,-306.2422;Float;False;Constant;_Float1;Float 1;0;0;Create;True;0;0;False;0;6;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;92;-1024.221,241.3379;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;141;-1025.479,2935.67;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;127;366.5212,3879.67;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;44;-2508.13,1646.958;Float;True;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.AbsOpNode;40;-1025.473,474.9119;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;58;-1622.756,2342.809;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;57;-1896.448,2356.728;Float;False;Constant;_Float8;Float 8;2;0;Create;True;0;0;False;0;0.04;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;69;-548.289,390.4107;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;132;-1489.479,4279.67;Float;False;Constant;_Float6;Float 6;0;0;Create;True;0;0;False;0;60;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;111;-305.4788,3751.67;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;110;-321.4788,4007.67;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;136;-449.4788,4727.67;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;87;-1970.174,364.4561;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;2.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimplifiedFModOpNode;135;-689.4788,4759.67;Float;True;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.FloorOpNode;134;-881.4788,4775.67;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;133;-1185.479,4663.67;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;143;334.5212,4743.67;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;140;-305.4788,2999.67;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2961.652,1328.146;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;PatternShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;98;0;102;2
WireConnection;98;1;99;0
WireConnection;103;0;102;1
WireConnection;103;1;99;0
WireConnection;108;0;98;0
WireConnection;107;0;103;0
WireConnection;100;0;107;0
WireConnection;109;0;108;0
WireConnection;128;0;100;0
WireConnection;129;0;109;0
WireConnection;123;0;128;0
WireConnection;123;1;124;0
WireConnection;126;0;124;2
WireConnection;126;1;129;0
WireConnection;56;0;69;0
WireConnection;62;0;50;0
WireConnection;62;1;47;0
WireConnection;32;0;24;0
WireConnection;32;1;29;0
WireConnection;31;0;30;0
WireConnection;31;1;26;0
WireConnection;31;2;28;0
WireConnection;63;0;81;0
WireConnection;19;0;18;0
WireConnection;86;0;92;0
WireConnection;24;0;21;0
WireConnection;91;0;89;0
WireConnection;89;0;79;0
WireConnection;55;0;53;0
WireConnection;35;0;56;0
WireConnection;49;0;55;0
WireConnection;38;0;86;0
WireConnection;38;1;40;0
WireConnection;84;1;82;0
WireConnection;84;0;70;0
WireConnection;28;0;25;0
WireConnection;28;1;23;0
WireConnection;37;0;36;0
WireConnection;67;1;84;0
WireConnection;67;0;80;0
WireConnection;52;0;51;0
WireConnection;94;0;40;0
WireConnection;64;0;87;0
WireConnection;64;1;39;0
WireConnection;95;0;60;0
WireConnection;65;0;74;0
WireConnection;71;3;85;1
WireConnection;79;0;78;0
WireConnection;79;1;77;0
WireConnection;33;0;27;0
WireConnection;27;0;24;0
WireConnection;50;0;49;0
WireConnection;50;1;88;0
WireConnection;88;0;95;0
WireConnection;66;0;31;0
WireConnection;66;1;32;0
WireConnection;66;2;33;0
WireConnection;25;0;22;0
WireConnection;59;0;58;0
WireConnection;130;0;54;0
WireConnection;22;0;16;0
WireConnection;22;1;17;0
WireConnection;83;0;90;0
WireConnection;21;0;19;0
WireConnection;77;0;76;1
WireConnection;77;1;68;0
WireConnection;54;0;46;0
WireConnection;60;0;59;0
WireConnection;39;0;76;2
WireConnection;39;1;68;0
WireConnection;131;0;50;0
WireConnection;46;0;45;0
WireConnection;23;0;20;4
WireConnection;74;0;64;0
WireConnection;72;0;93;0
WireConnection;61;0;46;1
WireConnection;85;1;90;0
WireConnection;53;0;52;0
WireConnection;41;0;63;0
WireConnection;93;0;79;0
WireConnection;45;0;44;0
WireConnection;45;1;34;0
WireConnection;51;0;54;0
WireConnection;51;1;48;0
WireConnection;82;0;35;0
WireConnection;90;0;82;0
WireConnection;90;1;37;0
WireConnection;78;1;75;0
WireConnection;137;0;141;0
WireConnection;18;0;16;0
WireConnection;18;1;17;0
WireConnection;138;0;137;0
WireConnection;142;0;140;0
WireConnection;142;1;136;0
WireConnection;70;0;73;0
WireConnection;70;1;35;0
WireConnection;80;0;71;0
WireConnection;92;0;91;0
WireConnection;141;0;102;1
WireConnection;141;1;139;0
WireConnection;127;0;123;0
WireConnection;127;1;126;0
WireConnection;44;0;43;0
WireConnection;44;1;42;0
WireConnection;40;0;65;0
WireConnection;58;0;61;0
WireConnection;58;1;57;0
WireConnection;69;0;38;0
WireConnection;69;1;94;0
WireConnection;111;0;100;0
WireConnection;111;1;109;0
WireConnection;110;0;100;0
WireConnection;110;1;109;0
WireConnection;136;0;109;0
WireConnection;136;1;135;0
WireConnection;87;0;72;0
WireConnection;135;0;134;0
WireConnection;134;0;133;0
WireConnection;133;0;102;2
WireConnection;133;1;132;0
WireConnection;143;0;140;0
WireConnection;143;1;136;0
WireConnection;140;0;100;0
WireConnection;140;1;138;0
WireConnection;0;2;127;0
ASEEND*/
//CHKSM=0E23992D099E500CE31A927C0C4776ADBAE987DC