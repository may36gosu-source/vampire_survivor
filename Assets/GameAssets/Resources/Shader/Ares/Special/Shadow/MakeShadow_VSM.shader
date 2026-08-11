// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'
/*
Author:gzg
Date:2021-12-20
Desc:这个Shader使用来为自定义的阴影系统,来生成ShadowMap用的,这里用于保存深度到一个Shadowmap中.产生VSM需要的阴影贴图
*/
Shader "Ares/SpecialEffect/MakeShadow_VSM"
{
	Properties
	{
		_MainTex("Base (RGB)", 2D) = "white" {}
	}
	CGINCLUDE
			#include "UnityCG.cginc"
			#include "../../Gonbest/Include/Shadow/ShadowFunctionCG.cginc"
			
			// Check for low-end GPU global shader keyword
			#if defined(_GONBEST_LOWEND_GPU)
			#define UNITY_LOWEND_GPU 1
			#endif
			
			// Better precision handling for mobile GPUs
			#if defined(SHADER_API_GLES) || defined(SHADER_API_GLES3)
			#pragma warning (disable : 3205) // conversion of larger type to smaller
			
			// Adreno specific optimizations
			#if defined(SHADER_API_ADRENO)
			#define UNITY_ADRENO_ES3 1
			#endif
			
			// Mali specific optimizations
			#if defined(SHADER_API_MALI) || defined(SHADER_API_MALI_GL)
			#define UNITY_MALI 1
			// Mali prefers higher precision to avoid artifacts
			#define SHADOW_PRECISION float
			#else
			// For other mobile GPUs
			#define SHADOW_PRECISION half
			#endif
			#endif
			
			uniform sampler2D _MainTex;
			uniform half4 _MainTex_ST;

			struct vertexdata
			{
				float4 vertex : POSITION;
				half4 texcoord : TEXCOORD0;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				half2 uv: TEXCOORD0;				
			};

			v2f vert(vertexdata v)
			{
				v2f o = (v2f)0;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);				
				return o;
			}

			float4 frag(v2f i) : SV_Target
			{
				// Check if we're on a low-end GPU (set by _GONBEST_LOWEND_GPU keyword)
				#if defined(UNITY_LOWEND_GPU)
					// Ultra-simplified path for very low-end GPUs
					fixed4 c = tex2D(_MainTex, i.uv);
					clip(c.a - 0.3);
					float d = CalcDepth(i.pos);
					float moment1 = d; // First moment
					float moment2 = d * d; // Second moment
					// Simplified acne fix for low-end devices
					moment2 += 0.2 * (d * 0.01); 
					return float4(moment1, moment2, 0, 1);
				#elif defined(UNITY_MALI)
					// Mali GPUs sometimes need higher precision texture reads
					half4 c = tex2D(_MainTex, i.uv);
					clip(c.a - 0.3);
					float d = CalcDepth(i.pos);
					float moment1 = d; // First moment
					float moment2 = d * d; // Second moment
					float dx = ddx(d);
					float dy = ddy(d);
					// Mali may need special handling for derivatives
					moment2 += 0.25 * (dx * dx + dy * dy); // Solve acne issues
					return float4(moment1, moment2, 0, 1);
				#else
					fixed4 c = tex2D(_MainTex, i.uv);	
					clip(c.a - 0.3);
					float d = CalcDepth(i.pos);	     
					float moment1 = d; // First moment
					float moment2 = d * d; // Second moment
					float dx = ddx(d);
					float dy = ddy(d);
					moment2 += 0.25 * (dx * dx + dy * dy); // Solve acne issues    			
					return float4(moment1, moment2, 0, 1);
				#endif
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

			#pragma target 3.0
			#pragma vertex vert
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest
			
			// Add support for low-end GPU keyword
			#pragma multi_compile __ _GONBEST_LOWEND_GPU
			
			// Add specific GPU architecture variants
			#pragma multi_compile __ UNITY_MALI UNITY_ADRENO_ES3
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

			#pragma target 3.0
			#pragma vertex vert
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest
			
			// Add support for low-end GPU keyword
			#pragma multi_compile __ _GONBEST_LOWEND_GPU
			
			// Add specific GPU architecture variants
			#pragma multi_compile __ UNITY_MALI UNITY_ADRENO_ES3
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

			#pragma target 3.0
			#pragma vertex vert
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest
			
			// Add support for low-end GPU keyword
			#pragma multi_compile __ _GONBEST_LOWEND_GPU
			
			// Add specific GPU architecture variants
			#pragma multi_compile __ UNITY_MALI UNITY_ADRENO_ES3						
			ENDCG
		}
	}
	
	// Low-end GPU specific optimized shader (used when _GONBEST_LOWEND_GPU is enabled)
	SubShader
	{
		Tags { "RenderType" = "Opaque" "PreferLowEndGPU" = "On" }
		Pass
		{
			// Simplified rendering for maximum performance
			Blend One Zero
			ZTest LEqual
			ZWrite On
			Cull Back
			
			CGPROGRAM
			// Use lowest possible shader target for compatibility
			#pragma target 2.0
			#pragma vertex vert_lowend
			#pragma fragment frag_lowend
			#pragma fragmentoption ARB_precision_hint_fastest
			
			// This shader specifically looks for the _GONBEST_LOWEND_GPU keyword
			#pragma shader_feature _GONBEST_LOWEND_GPU
			
			// Ultra-simplified vertex shader
			v2f vert_lowend(vertexdata v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				return o;
			}
			
			float4 frag_lowend(v2f i) : SV_Target
			{
				// Minimal texture sampling with lowest precision
				fixed4 c = tex2D(_MainTex, i.uv);
				clip(c.a - 0.3);
				float d = CalcDepth(i.pos);
				// Simplified VSM calculation for low-end devices
				float moment1 = d;
				float moment2 = d * d;
				// Skip derivative calculations for performance
				return float4(moment1, moment2, 0, 1);
			}
			ENDCG
		}
	}
}
