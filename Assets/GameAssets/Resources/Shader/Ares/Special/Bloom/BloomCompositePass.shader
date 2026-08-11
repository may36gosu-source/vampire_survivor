/*
Author:gzg
Date:2019-08-20
Desc:曝光处理系统所需的Shader,用于曝光纹理和主纹理的叠加
*/
Shader "Ares/Bloom/BloomCompositePass"
{
	Properties 
	{
		_MainTex("Base (RGB)", 2D) = "white"{}
		_BloomTex("Bloom (RGB)", 2D) = "black"{}
	}

	SubShader
	{
		Pass
		{
			ZWrite Off
			ZTest Off
			Cull Off
			Lighting Off
			Blend Off
			Fog { Mode Off }

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest

			#include "UnityCG.cginc"

			
			uniform sampler2D _MainTex;
			uniform sampler2D _BloomTex;
			uniform half4 _MainTex_TexelSize;

			struct v2f
			{
				float4 pos : POSITION;
				half2 uv : TEXCOORD0;
			#if UNITY_UV_STARTS_AT_TOP
				half2 uv1 : TEXCOORD1;
			#endif
			};

			v2f vert(appdata_img v)
			{
				v2f o = (v2f)0;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv = v.texcoord;

        	#if UNITY_UV_STARTS_AT_TOP
        		o.uv1 = v.texcoord;				
        		if (_MainTex_TexelSize.y < 0.0)
        			o.uv1.y = 1.0 - o.uv1.y;
        	#endif

				return o;
			}

			fixed4 frag(v2f i) : COLOR
			{
				fixed4 base = tex2D(_MainTex, i.uv);
			#if UNITY_UV_STARTS_AT_TOP
				fixed4 bloom = tex2D(_BloomTex, i.uv1);
			#else
				fixed4 bloom = tex2D(_BloomTex, i.uv);
			#endif

				return base + bloom;
			}
			ENDCG
		}
	}
}