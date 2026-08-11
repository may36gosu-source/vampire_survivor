/*
Author:gzg
Date:2019-09-12
Desc:曝光处理系统所需的Shader,用于另外一个摄像机
*/
Shader "Ares/Bloom/BloomMaskPass"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_BloomTex ("BloomTex", 2D) = "(0.5,0.5,0.5,0.5)" {}
		_BloomFactor("BloomFactor", float) = 0

	}
	SubShader
	{
		Tags { "GonbestBloomType"="BloomMask" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"
			#include "../../Gonbest/Include/Base/MathCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				float3 normal:NORMAL;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;				
				float4 vertex : SV_POSITION;
				//float nov : TEXCOORD1;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			sampler2D _BloomTex;
			float _BloomFactor;			
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				/*
				float3 wn = GBNormalizeSafe(mul(float4(v.normal,0),unity_WorldToObject).xyz);				
				float3 V = GBNormalizeSafe(_WorldSpaceCameraPos.xyz - mul(unity_ObjectToWorld,v.vertex).xyz);
				o.nov = saturate(dot(wn,V)) * 0.5 + 0.5;
				o.nov *= o.nov;				
				*/
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				fixed4 col = (tex2D(_BloomTex, i.uv) - 0.5) * clamp(0,2,_BloomFactor);
				return col;
			}
			ENDCG
		}
	}
}
