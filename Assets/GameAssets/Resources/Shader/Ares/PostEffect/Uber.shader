/*
Author:gzg
Date:2020-06-12
Desc:后处理的默认Shader
*/
Shader "Hidden/Ares/PostEffect/Uber"
{
	Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }

	HLSLINCLUDE
		#include "../Gonbest/Include/PostEffect/StdLib.hlsl"
		#include "../Gonbest/Include/PostEffect/Colors.hlsl"
		#include "../Gonbest/Include/PostEffect/Sampling.hlsl"
		#include "../Gonbest/Include/PostEffect/xRLib.hlsl"
		#include "./Uber/UberBloom.hlsl"		

		#pragma multi_compile __ _GONBEST_BLOOM_ON
		#pragma multi_compile __ _GONBEST_RADIABLUR_ON
		#pragma multi_compile __ _GONBEST_GRAPHIC_BLIT_ON

		#pragma vertex VertUber
		#pragma fragment FragUber

		TEXTURE2D_SAMPLER2D(_MainTex, sampler_MainTex);
		float4 _MainTex_TexelSize;
		float4 _MainTex_ST;

		struct vdata
		{
			float4 vertex : POSITION;
			half2 texcoord : TEXCOORD0;			
		};

		VaryingsDefault VertUber(vdata v)
		{
			VaryingsDefault o = (VaryingsDefault)0;
#if _GONBEST_GRAPHIC_BLIT_ON
			o.vertex =float4(v.vertex.xy, 0, 1);
#else
			o.vertex =float4(v.vertex.xy*2 - 1, 0, 1);
#endif
			o.texcoord = v.texcoord;
			o.texcoord = o.texcoord * _UVTransform.xy + _UVTransform.zw;
			return o;
		}

		half4 FragUber(VaryingsDefault i) : SV_Target
		{
			 
			 float2 uv = i.texcoord;			
			 half4 color = (half4)0;
			 color = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, uv);
			 GONBEST_BLOOM_APPLY(color, uv);
			 half4 output = color;
			 return output;
		}
	ENDHLSL

	SubShader
	{
		Cull Off ZWrite Off ZTest Always
		Pass
		{
			HLSLPROGRAM
				#pragma exclude_renderers gles vulkan switch
			ENDHLSL
		}
	}

	SubShader
	{
		Cull Off ZWrite Off ZTest Always
		Pass
		{
			HLSLPROGRAM
				#pragma only_renderers vulkan switch
			ENDHLSL
		}
	}

	SubShader
	{
		Cull Off ZWrite Off ZTest Always
		Pass
		{
			HLSLPROGRAM
				#pragma only_renderers gles
			ENDHLSL
		}
	}
  
   
}