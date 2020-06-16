// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Hidden/Custom/BLUR (SoftMaskable)" {
    Properties {
        _Color ("Main Color", Color) = (1,1,1,1)
        _BumpAmt  ("Distortion", Range (0,128)) = 10
        _MainTex ("Tint Color (RGB)", 2D) = "white" {}
        _BumpMap ("Normalmap", 2D) = "bump" {}
        _Size("Size", Range(0, 20)) = 1

        _StencilComp("Stencil Comparison", Float) = 8
        _Stencil("Stencil ID", Float) = 0
        _StencilOp("Stencil Operation", Float) = 0
        _StencilWriteMask("Stencil Write Mask", Float) = 255
        _StencilReadMask("Stencil Read Mask", Float) = 255

        _ColorMask("Color Mask", Float) = 15

        [Toggle(UNITY_UI_ALPHACLIP)] _UseUIAlphaClip("Use Alpha Clip", Float) = 1
    }

        Category{

            Tags { "Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Transparent" "CanUseSpriteAtlas" = "True" }


            SubShader {

         Stencil
            {
                Ref[_Stencil]
                Comp[_StencilComp]
                Pass[_StencilOp]
                ReadMask[_StencilReadMask]
                WriteMask[_StencilWriteMask]
            }
        Cull Off
        Lighting Off
        ZWrite Off
        ZTest[unity_GUIZTestMode]
        //Blend SrcAlpha OneMinusSrcAlpha
        ColorMask[_ColorMask]

            GrabPass {                    
                Tags { "LightMode" = "Always" }
            }
            Pass {
                Tags { "LightMode" = "Always" }
             
                CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag
                #pragma fragmentoption ARB_precision_hint_fastest
                #include "UnityCG.cginc"
		#include "Assets/SoftMaskForUGUI/Shaders/SoftMask.cginc"
		#pragma shader_feature __ SOFTMASK_EDITOR
             
                struct appdata_t {
                    float4 vertex : POSITION;
                    float2 texcoord: TEXCOORD0;
                };
             
                struct v2f {
                    float4 vertex : SV_POSITION;
                    float4 uvgrab : TEXCOORD0;
                    float4 worldPos : TEXCOORD1;
                };
             
                v2f vert (appdata_t v) {
                    v2f o;
                    o.vertex = UnityObjectToClipPos(v.vertex);
                    #if UNITY_UV_STARTS_AT_TOP
                    float scale = -1.0;
                    #else
                    float scale = 1.0;
                    #endif
                    o.uvgrab.xy = (float2(o.vertex.x, o.vertex.y*scale) + o.vertex.w) * 0.5;
                    o.uvgrab.zw = o.vertex.zw;
                    return o;
                }
             
                sampler2D _GrabTexture;
                float4 _GrabTexture_TexelSize;
                float _Size;
             
                half4 frag( v2f i ) : SV_Target {
                 
                    half4 sum = half4(0,0,0,0);
                    #define GRABPIXEL(weight,kernelx) tex2Dproj( _GrabTexture, UNITY_PROJ_COORD(float4(i.uvgrab.x + _GrabTexture_TexelSize.x * kernelx*_Size, i.uvgrab.y, i.uvgrab.z, i.uvgrab.w))) * weight
                    sum += GRABPIXEL(0.05, -4.0);
                    sum += GRABPIXEL(0.09, -3.0);
                    sum += GRABPIXEL(0.12, -2.0);
                    sum += GRABPIXEL(0.15, -1.0);
                    sum += GRABPIXEL(0.18,  0.0);
                    sum += GRABPIXEL(0.15, +1.0);
                    sum += GRABPIXEL(0.12, +2.0);
                    sum += GRABPIXEL(0.09, +3.0);
                    sum += GRABPIXEL(0.05, +4.0);
                    
                    sum.a *= SoftMask(i.vertex, i.worldPos);
                    return sum;
                }
                ENDCG
            }
 
            GrabPass {                        
                Tags { "LightMode" = "Always" }
            }
            Pass {
                Tags { "LightMode" = "Always" }
             
                CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag
                #pragma fragmentoption ARB_precision_hint_fastest
                #include "UnityCG.cginc"
                
                #include "Assets/SoftMaskForUGUI/Shaders/SoftMask.cginc"
                #pragma shader_feature __ SOFTMASK_EDITOR
             
                struct appdata_t {
                    float4 vertex : POSITION;
                    float2 texcoord: TEXCOORD0;
                };
             
                struct v2f {
                    float4 vertex : SV_POSITION;
                    float4 uvgrab : TEXCOORD0;
                    float4 worldPos : TEXCOORD1;
                };
             
                v2f vert (appdata_t v) {
                    v2f o;
                    o.vertex = UnityObjectToClipPos(v.vertex);
                    #if UNITY_UV_STARTS_AT_TOP
                    float scale = -1.0;
                    #else
                    float scale = 1.0;
                    #endif
                    o.uvgrab.xy = (float2(o.vertex.x, o.vertex.y*scale) + o.vertex.w) * 0.5;
                    o.uvgrab.zw = o.vertex.zw;
                    return o;
                }
             
                sampler2D _GrabTexture;
                float4 _GrabTexture_TexelSize;
                float _Size;
             
                half4 frag( v2f i ) : SV_Target {
                 
                    half4 sum = half4(0,0,0,0);
                    #define GRABPIXEL(weight,kernely) tex2Dproj( _GrabTexture, UNITY_PROJ_COORD(float4(i.uvgrab.x, i.uvgrab.y + _GrabTexture_TexelSize.y * kernely*_Size, i.uvgrab.z, i.uvgrab.w))) * weight
                 
                    sum += GRABPIXEL(0.05, -4.0);
                    sum += GRABPIXEL(0.09, -3.0);
                    sum += GRABPIXEL(0.12, -2.0);
                    sum += GRABPIXEL(0.15, -1.0);
                    sum += GRABPIXEL(0.18,  0.0);
                    sum += GRABPIXEL(0.15, +1.0);
                    sum += GRABPIXEL(0.12, +2.0);
                    sum += GRABPIXEL(0.09, +3.0);
                    sum += GRABPIXEL(0.05, +4.0);
                 
                    sum.a *= SoftMask(i.vertex, i.worldPos);
                    return sum;
                }
                ENDCG
            }
         
            GrabPass {                        
                Tags { "LightMode" = "Always" }
            }
            Pass {
                Tags { "LightMode" = "Always" }
             
                CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag
                #pragma fragmentoption ARB_precision_hint_fastest
                #include "UnityCG.cginc"

                    #include "UnityUI.cginc"

            #pragma multi_compile __ UNITY_UI_CLIP_RECT
            #pragma multi_compile __ UNITY_UI_ALPHACLIP

                #include "Assets/SoftMaskForUGUI/Shaders/SoftMask.cginc"
                #pragma shader_feature __ SOFTMASK_EDITOR
             
                struct appdata_t {
                    float4 vertex : POSITION;
                    float2 texcoord: TEXCOORD0;
                    fixed4 color : COLOR;
                };
             
                struct v2f {
                    float4 vertex : SV_POSITION;
                    float4 uvgrab : TEXCOORD0;
                    fixed4 color : COLOR;
                    //float2 uvbump : TEXCOORD1;
                    float4 worldPos : TEXCOORD1;
                    float2 uvmain : TEXCOORD2;
                };
             
                float _BumpAmt;
                float4 _BumpMap_ST;
                float4 _MainTex_ST;
             
                v2f vert (appdata_t v) {
                    v2f o;
                    o.vertex = UnityObjectToClipPos(v.vertex);
                    #if UNITY_UV_STARTS_AT_TOP
                    float scale = -1.0;
                    #else
                    float scale = 1.0;
                    #endif
                    o.uvgrab.xy = (float2(o.vertex.x, o.vertex.y*scale) + o.vertex.w) * 0.5;
                    o.uvgrab.zw = o.vertex.zw;
                    o.worldPos.xy = TRANSFORM_TEX( v.texcoord, _BumpMap );
                    o.uvmain = TRANSFORM_TEX( v.texcoord, _MainTex );
                    
                    return o;
                }
             
                fixed4 _Color;
                float4 _ClipRect;
                sampler2D _GrabTexture;
                float4 _GrabTexture_TexelSize;
                sampler2D _BumpMap;
                sampler2D _MainTex;
             
                fixed4 frag( v2f i ) : SV_Target {
             
                    half2 bump = UnpackNormal(tex2D( _BumpMap, i.worldPos.xy )).rg;
                    float2 offset = bump * _BumpAmt * _GrabTexture_TexelSize.xy;
                    i.uvgrab.xy = offset * i.uvgrab.z + i.uvgrab.xy;
                 
                    half4 col = tex2Dproj( _GrabTexture, UNITY_PROJ_COORD(i.uvgrab));

                    col.a *= UnityGet2DClipping(i.worldPos.xy, _ClipRect);
                    
                    #ifdef UNITY_UI_ALPHACLIP
                    clip(col.a - 0.001);
                    #endif
                    
                    col.a *= SoftMask(i.vertex, i.worldPos);

                    half4 tint = tex2D( _MainTex, i.uvmain ) * _Color;
                 
                    return col;// *tint;
                }

                ENDCG
            }
        }
    }
}