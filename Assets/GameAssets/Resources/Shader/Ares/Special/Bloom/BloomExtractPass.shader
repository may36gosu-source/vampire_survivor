/*
Author:gzg
Date:2019-08-20
Desc:曝光处理系统所需的Shader,用于对纹理进行上下左右的偏移渲染
*/
Shader "Ares/Bloom/BloomExtractPass"
{
	Properties
	{
		_MainTex ("Base (RGB)", 2D) = "white"{}
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
			uniform half4 _MainTex_TexelSize;
			
			uniform half4 _Parameter;

			#define OFFSET_SCALE _Parameter.x
			#define THRESHHOLD _Parameter.z
			#define INTENSITY _Parameter.w

			struct v2f
			{
				float4 pos : POSITION;
				half2 uv0 : TEXCOORD0;
				half2 uv1 : TEXCOORD1;
				half2 uv2 : TEXCOORD2;
				half2 uv3 : TEXCOORD3;
			};

			v2f vert(appdata_img v)
			{
				v2f o = (v2f)0;
				o.pos = UnityObjectToClipPos(v.vertex);
				
				half2 offset = _MainTex_TexelSize * OFFSET_SCALE;
				o.uv0 = v.texcoord + half2(-offset.x, -offset.y); 	// top left
				o.uv1 = v.texcoord + half2(offset.x, -offset.y);	// top right
				o.uv2 = v.texcoord + half2(-offset.x, offset.y);	// bottom left
				o.uv3 = v.texcoord + half2(offset.x, offset.y); 	// bottom right

				return o;
			}

			fixed4 frag(v2f i) : COLOR
			{
				fixed4 color = tex2D(_MainTex, i.uv0);
				color += tex2D(_MainTex, i.uv1);
				color += tex2D(_MainTex, i.uv2);
				color += tex2D(_MainTex, i.uv3);

				return max(color / 4 - THRESHHOLD, 0) * INTENSITY;
			}
			ENDCG
		}
	}
}