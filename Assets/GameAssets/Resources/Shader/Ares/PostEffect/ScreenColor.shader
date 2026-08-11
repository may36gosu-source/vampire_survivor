/*
Author:gzg
Date:2020/07/11
Desc:屏幕颜色
*/
Shader "Hidden/Ares/PostEffect/ScreenColor"
{
	Properties 
	{
		_MainTex("Base (RGB)", 2D) = "white"{}	
		_Color("_Color",Color) = (0,0,0,1)
        _Factor("_Factor",float) = 0
	}
    HLSLINCLUDE
#if _GONBEST_GRAPHIC_BLIT_ON
        #include "UNITYCG.cginc"
#else
		#include "../Gonbest/Include/PostEffect/StdLib.hlsl"
#endif
        uniform sampler2D   _MainTex;
        uniform half4	    _Color;
        uniform half	    _Factor;

        struct vertexData 
        {
            float4 vertex : POSITION;
            half2 texcoord : TEXCOORD0;
        };

        struct v2f
        {
            float4 pos : POSITION;
            half2 texCoord0 : TEXCOORD0;
        };	

        v2f vert(vertexData v)
        {
            v2f o = (v2f)0;
            //是否使用原始的Blit
#if _GONBEST_GRAPHIC_BLIT_ON
           
            o.pos = UnityObjectToClipPos(v.vertex);
            half2 uv = v.texcoord;
            
#else
            o.pos = v.vertex;
            half2 uv = TransformTriangleVertexToUV(v.vertex.xy);            
            #if UNITY_UV_STARTS_AT_TOP
                uv = uv * float2(1.0, -1.0) + float2(0.0, 1.0);
            #endif
           
#endif
            o.texCoord0 = uv;
         
            return o;
        }


        half4 frag(v2f i) : COLOR
        {
            half4 color = tex2D(_MainTex, i.texCoord0);           
            color.rgb = lerp(color.rgb,_Color.rgb,_Factor);
            return color;
        }
    ENDHLSL

	SubShader
	{
        Cull Off  ZWrite Off  ZTest Always
		Pass
		{
			HLSLPROGRAM
			#pragma vertex vert
			#pragma fragment frag	
            #pragma multi_compile __ _GONBEST_GRAPHIC_BLIT_ON	
            ENDHLSL
		}
	}
}