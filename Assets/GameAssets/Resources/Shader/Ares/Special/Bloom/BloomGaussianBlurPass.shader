/*
Author:gzg
Date:2019-08-20
Desc:曝光处理系统所需的Shader,对纹理进行高斯模糊
*/
Shader "Ares/Bloom/BloomGaussianBlurPass"
{
	Properties
	{
		_MainTex ("Base (RGB)", 2D) = "white" {}
	}

	SubShader
	{
		Pass
		{
			ZWrite Off
			ZTest Always
			Cull Off
			Lighting Off
			Fog {Mode Off}

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest

			#include "UnityCG.cginc"

			uniform half4 _Parameter;
			uniform half4 _MainTex_TexelSize;
			uniform sampler2D _MainTex;

			#define OFFSET_DIR _Parameter.xy
			#define BLUR_SIZE _Parameter.z

			static const half weights[7] = { 0.0205, 0.0855, 0.232, 0.324, 0.232, 0.0855, 0.0205 };

			struct v2f
			{
				float4 pos : POSITION;
				half2 uv : TEXCOORD0;
				half2 offs : TEXCOORD1;
			};

			v2f vert(appdata_img v)
			{
				v2f o = (v2f)0;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv = v.texcoord;
				o.offs = _MainTex_TexelSize.xy * OFFSET_DIR * BLUR_SIZE;
				return o;
			}

			fixed4 frag(v2f i) : COLOR
			{
				half2 coords = i.uv - i.offs * 3.0;
				fixed4 color = 0;
				
				fixed4 color0 = tex2D(_MainTex, coords);
				color += color0 * weights[0];
				coords += i.offs;

				fixed4 color1 = tex2D(_MainTex, coords);
				color += color1 * weights[1];
				coords += i.offs;

				fixed4 color2 = tex2D(_MainTex, coords);
				color += color2 * weights[2];
				coords += i.offs;

				fixed4 color3 = tex2D(_MainTex, coords);
				color += color3 * weights[3];
				coords += i.offs;

				fixed4 color4 = tex2D(_MainTex, coords);
				color += color4 * weights[4];
				coords += i.offs;

				fixed4 color5 = tex2D(_MainTex, coords);
				color += color5 * weights[5];
				coords += i.offs;

				fixed4 color6 = tex2D(_MainTex, coords);
				color += color6 * weights[6];
								

				return color;
			}

			ENDCG
		}
	}
}