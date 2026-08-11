#ifndef GONBEST_UBER_BLOOM_HLSL
#define GONBEST_UBER_BLOOM_HLSL

#include "../../Gonbest/Include/PostEffect/StdLib.hlsl"
#include "../../Gonbest/Include/PostEffect/Colors.hlsl"
#include "../../Gonbest/Include/PostEffect/Sampling.hlsl"

/*
在Uber中处理曝光的信息的代码
*/

#if _GONBEST_BLOOM_ON
	// Bloom
	TEXTURE2D_SAMPLER2D(_BloomTex, sampler_BloomTex);	
	float4 _BloomTex_TexelSize;	
	float3 _Bloom_Settings; // x: sampleScale, y: intensity, z: dirt intensity
	float3 _Bloom_Color; 

	#define GONBEST_BLOOM_APPLY(color,uv) \
			float4 bloom = UpsampleBox(TEXTURE2D_PARAM(_BloomTex, sampler_BloomTex), uv, _BloomTex_TexelSize.xy, _Bloom_Settings.x);\
			bloom *= _Bloom_Settings.y;\
			color += bloom *float4(_Bloom_Color, 1.0);
#else
	#define GONBEST_BLOOM_APPLY(color,uv)
#endif

#endif //GONBEST_UBER_BLOOM_HLSL