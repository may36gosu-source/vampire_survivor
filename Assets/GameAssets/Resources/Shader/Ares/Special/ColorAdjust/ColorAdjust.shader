/*
Author:gzg
Date:2020-01-02
Desc:颜色矫正
*/
Shader "Ares/SpecialEffect/ColorAdjust" {
	Properties{
		_MainTex("Base (RGB)", 2D) = "white" {}
		_BrightnessPower("亮度", Range(0,2)) = 1
		_SaturationPower("饱和度", Range(0,2)) = 1
		_ContrastPower("对比度", Range(0,2)) = 1
		_TemperaturePower("温度", Range(-1,1)) = 1
	}

	CGINCLUDE

		#include "../../Gonbest/Include/Base/ColorCG.cginc"

		sampler2D _MainTex;
		half4 _MainTex_ST;

		struct v2f_tap
		{
			float4 pos : SV_POSITION;
			half2 uv : TEXCOORD0;	
		};

		v2f_tap vert(appdata_img v)
		{
			v2f_tap o;

			o.pos = UnityObjectToClipPos(v.vertex);
			o.uv = v.texcoord;
			return o;
		}

		fixed4 frag(v2f_tap i) : SV_Target
		{
			fixed4 color = tex2D(_MainTex, i.uv);
			GONBEST_ADJUST_BRIGHTNESS_APPLY(color.rgb)
			GONBEST_ADJUST_SATURATION_APPLY(color.rgb)
			GONBEST_ADJUST_CONTRAST_APPLY(color.rgb)
			//GONBEST_ADJUST_TEMPERATURE_APPLY(color.rgb)
			color.a = 0;
			return color;
		}

	ENDCG

		SubShader {
			// 0
			Pass{

				CGPROGRAM

					#pragma vertex vert
					#pragma fragment frag	
					#pragma multi_compile _GONBEST_ADJUST_BRIGHTNESS_ON				
					#pragma multi_compile _GONBEST_ADJUST_SATURATION_ON
					#pragma multi_compile _GONBEST_ADJUST_CONTRAST_ON
					#pragma multi_compile _GONBEST_ADJUST_TEMPERATURE_ON
				ENDCG

			}
	}

	FallBack Off
}
