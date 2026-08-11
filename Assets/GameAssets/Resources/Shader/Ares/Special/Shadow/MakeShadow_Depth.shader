// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'
/*
Author:gzg
Date:2019-08-20
Desc:这个Shader使用来为自定义的阴影系统,来生成ShadowMap用的,这里用于保存深度到一个Shadowmap中.
*/
Shader "Ares/SpecialEffect/MakeShadow_Depth"
{
	Properties
	{
		_MainTex("Base (RGB)", 2D) = "white" {}
	}
	CGINCLUDE
				#include "UnityCG.cginc"
				#include "../../Gonbest/Include/Shadow/ShadowFunctionCG.cginc"
				uniform sampler2D _MainTex;
				uniform float4 _MainTex_ST;

				struct vertexdata
				{
					float4 vertex : POSITION;
					float4 texcoord : TEXCOORD0;
				};

				struct v2f
				{
					float4 pos : SV_POSITION;
					float2 uv: TEXCOORD0;               
				};

				v2f vert(vertexdata v)
				{
					v2f o = (v2f)0;
					o.pos = UnityObjectToClipPos(v.vertex);
					o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);               
					return o;
				}

				void frag(v2f i, out float4 outColor : SV_Target, out float outDepth : SV_Depth)
				{
					float4 c = tex2D(_MainTex, i.uv);
					clip(c.a - 0.3);
					float d = CalcDepth(i.pos);
					outColor = float4(0, 0, 0, 1); // Color not used, just output black
					outDepth = d;
				}
		ENDCG
	SubShader
	{
		Tags { "RenderType" = "Opaque" }
		Pass
		{
			Blend One Zero,Zero OneMinusSrcAlpha	 
			ZTest LEqual
			ZWrite On
			Lighting Off
			Fog {Mode Off}

			   CGPROGRAM
			   #pragma vertex vert
			   #pragma fragment frag
			   #pragma target 2.0
			   #pragma fragmentoption ARB_precision_hint_fastest
			   ENDCG
		}
	}

	SubShader
	{
		Tags { "GonbestBloomType"="BloomMask"}
		Pass
		{
			Blend One Zero,Zero OneMinusSrcAlpha	 
			ZTest LEqual
			ZWrite On
			Lighting Off
			Fog {Mode Off}

			   CGPROGRAM
			   #pragma vertex vert
			   #pragma fragment frag
			   #pragma target 2.0
			   #pragma fragmentoption ARB_precision_hint_fastest
			   #include "UnityCG.cginc"
			   ENDCG
		}
	}

	SubShader
	{
		Tags{ "RenderType" = "ShadowMesh" }
		Pass
		{
			Blend One Zero,Zero OneMinusSrcAlpha	
			ZTest LEqual
			ZWrite On
			Cull Off
			Lighting Off
			Fog{ Mode Off }

			   CGPROGRAM
			   #pragma vertex vert
			   #pragma fragment frag
			   #pragma target 2.0
			   #pragma fragmentoption ARB_precision_hint_fastest
			   ENDCG
		}
	}
}
