/*
Author:gzg
Date:2019-12-09
Desc:纹理叠加
*/
Shader "Hidden/Ares/Amplify/AddTexture"
{
	Properties
	{
		_MainTex ("Base (RGB)", 2D) = "white"{}
		_EffectTex ("Effect (RGB)", 2D) = "white"{}		
	}

	SubShader
	{
		Pass
		{
			ZWrite Off
			ZTest Off
			Cull Off
			Lighting Off
			Fog {Mode Off}

			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest

			#include "UnityCG.cginc"

			uniform sampler2D _MainTex;
			uniform sampler2D _EffectTex;
			uniform float _LerpValue;
			uniform float4 _MainTex_TexelSize;
			uniform float4 _EffectTex_TexelSize;
			
			struct v2f
			{
				float4 pos : SV_POSITION;
				half2 uv0 : TEXCOORD0;				
                half2 uv1 : TEXCOORD1;
			};

			v2f vert(appdata_img v)
			{
				v2f o = (v2f)0;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv0 = v.texcoord;
				o.uv1 = v.texcoord;

				#if defined(UNITY_UV_STARTS_AT_TOP)	
				if(_MainTex_TexelSize.y < 0)
				{
					o.uv0.y = 1 - o.uv0.y;
				}
				if(_EffectTex_TexelSize.y < 0)
				{
					o.uv1.y = 1 - o.uv1.y;
					o.uv0.y = 1 - o.uv0.y;
				}
				#endif

				return o;
			}

			fixed4 frag(v2f i) : COLOR
			{
				fixed4 color0 = tex2D(_EffectTex, i.uv1);
				fixed4 color1 = tex2D(_MainTex, i.uv0);				
				return color0+color1;
			}
			ENDCG
		}
	}
}