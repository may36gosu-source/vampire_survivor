/*
Author:gzg
Date:2020/06/12
Desc:运动模糊处理
*/
Shader "Hidden/Ares/PostEffect/RadiaBlur"
{
	Properties 
	{
		_MainTex("Base (RGB)", 2D) = "white"{}	
		_CenterAndStrength("_CenterAndStrength",Vector) = (0.5,0.5,1,1)
	}
    HLSLINCLUDE
#if _GONBEST_GRAPHIC_BLIT_ON
        #include "UNITYCG.cginc"
#else
		#include "../Gonbest/Include/PostEffect/StdLib.hlsl"
#endif
        uniform sampler2D   _MainTex;
        uniform half4	    _CenterAndStrength;

        struct vertexData 
        {
            float4 vertex : POSITION;
            half2 texcoord : TEXCOORD0;
        };

        struct v2f
        {
            float4 pos : POSITION;
            half2 texCoord0 : TEXCOORD0;
            half2 texCoord1 : TEXCOORD1;
            half2 texCoord2 : TEXCOORD2;
            half2 texCoord3 : TEXCOORD3;
            half2 texCoord4 : TEXCOORD4;
            half2 texCoord5 : TEXCOORD5;
            half2 texCoord6 : TEXCOORD6;
            half2 texCoord7 : TEXCOORD7;
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


            half2 center = _CenterAndStrength.xy;
            half2 strength = _CenterAndStrength.zw;
            half2 dir = (center - uv) * strength;
            o.texCoord0 = uv + dir * 0.00;
            o.texCoord1 = uv + dir * 0.01;
            o.texCoord2 = uv + dir * 0.02;
            o.texCoord3 = uv + dir * 0.03;
            o.texCoord4 = uv + dir * 0.04;
            o.texCoord5 = uv + dir * 0.05;
            o.texCoord6 = uv + dir * 0.06;
            o.texCoord7 = uv + dir * 0.07;
            return o;
        }


        half4 frag(v2f i) : COLOR
        {
            half4 color = tex2D(_MainTex, i.texCoord0);
            color += tex2D(_MainTex, i.texCoord1);
            color += tex2D(_MainTex, i.texCoord2);
            color += tex2D(_MainTex, i.texCoord3);
            color += tex2D(_MainTex, i.texCoord4);
            color += tex2D(_MainTex, i.texCoord5);
            color += tex2D(_MainTex, i.texCoord6);
            color += tex2D(_MainTex, i.texCoord7);
            return color / 8;
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