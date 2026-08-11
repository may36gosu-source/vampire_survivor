Shader "Hidden/Ares/PostEffect/DistortVfx"
{
	Properties
	{
	}

	CGINCLUDE
		#include "UnityCG.cginc"
		#include "../Gonbest/Include/Base/CommonCG.cginc"
        struct appdata
		{
			float4 vertex : POSITION;
			float2 uv : TEXCOORD0;
		};

		struct v2f
		{
			float2 uv0 : TEXCOORD0;
			float4 vertex : SV_POSITION;
		};

        uniform sampler2D _MainTex;
        uniform sampler2D _DistortTex;     
		uniform float _Strength;   
 
        //基本
        v2f vert(appdata v)
        {
            v2f o = (v2f)0;
            o.vertex = v.vertex;
            o.uv0 = v.uv;			
        #if defined(UNITY_UV_STARTS_AT_TOP)
            o.uv0 = o.uv0 * float2(1, -1) + float2(0, 1);
        #endif
            return o;
        }

        //处理片元
        fixed4 frag(v2f i) : SV_Target
        {
            //根据时间改变采样噪声图获得随机的输出
            float4 noise = tex2D(_DistortTex, i.uv0);
            //以随机的输出*控制系数得到偏移值
            float2 offset = noise.xy * _Strength;
            //像素采样时偏移offset，用Mask权重进行修改
            float2 uv = offset + i.uv0;
            float4 col = tex2D(_MainTex, uv);
            return col;
        }
	ENDCG
	SubShader
	{
		Pass
		{
			ZTest Always
			Cull Off
			ZWrite Off
			Fog { Mode off }
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest 
			ENDCG
		}
	}
	Fallback off
}