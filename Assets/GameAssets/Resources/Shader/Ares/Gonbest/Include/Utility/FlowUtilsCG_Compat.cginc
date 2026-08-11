/*
Author: Simplified implementation for Snapdragon 8 Gen 2 and newer GPUs
Date: 2025-08-27
Desc: Provides a completely different, simplified implementation that works on newer Adreno GPUs
*/

// Variable declarations - shared with the main shader
uniform float _FlowUseUV2;
uniform sampler2D _FlowTex;  
uniform half _FlowSpeed;    
uniform fixed4 _FlowColor;   
uniform fixed4 _FlowColor2;
uniform half _FlowTileCount; 
uniform half _FlowStrength;

// Use a much simpler implementation for Snapdragon 8 Gen 2
#define GONBEST_USE_FLOW_UV(uv1,uv2) uv1

// Very simple flow UV calculation that avoids complex math
inline float2 snapdragon_flow_uv(float2 uv) 
{
    return uv * _FlowTileCount + frac(_Time.xx * _FlowSpeed * 0.2);
}

#define GONBEST_CALC_FLOW_UV(i,uv) snapdragon_flow_uv(uv.xy)

// Simplified flow application that works on Snapdragon 8 Gen 2
inline void snapdragon_apply_flow(float2 uv, inout float4 color, float factor) 
{
    // Simple texture sample with minimal computation
    float4 flowTex = tex2D(_FlowTex, uv);
    
    // Simple color blending without complex calculations
    float3 flowColor = lerp(_FlowColor.rgb, _FlowColor2.rgb, flowTex.r);
    
    // Apply to the color
    color.rgb += flowColor * flowTex.a * factor * _FlowStrength;
}

#define GONBEST_APPLY_FLOW(flowuv,color,factor) snapdragon_apply_flow(flowuv, color, factor);

// Empty implementation for other flow effects
#define GONBEST_APPLY_FLOW_FELIGHTWIPE(uv,color,factor)

// Blink effect implementation (simplified)
#if defined(_GONBEST_FLOW_BLINK_ON)
    inline void snapdragon_apply_blink(float2 uv, inout float4 color, float factor) 
    {
        float4 flowTex = tex2D(_FlowTex, uv);
        color.rgb += flowTex.rgb * _FlowColor.rgb * factor * _FlowStrength;
    }
    #undef GONBEST_APPLY_FLOW
    #define GONBEST_APPLY_FLOW(flowuv,color,factor) snapdragon_apply_blink(flowuv, color, factor);
#endif

// Distort effect implementation (simplified)
#if defined(_GONBEST_FLOW_DISTORT_ON)
    uniform sampler2D _FlowNoiseTex;
    uniform float _FlowForceX;
    uniform float _FlowForceY;
    
    inline void snapdragon_apply_distort(float2 uv, inout float4 color, float factor) 
    {
        float4 flowTex = tex2D(_FlowTex, uv);
        color.rgb += flowTex.rgb * lerp(_FlowColor.rgb, _FlowColor2.rgb, factor) * _FlowStrength;
    }
    #undef GONBEST_APPLY_FLOW
    #define GONBEST_APPLY_FLOW(flowuv,color,factor) snapdragon_apply_distort(flowuv, color, factor);
#endif

// Flux effect implementation - match standard _addon_fx_fluxay (iOS/Metal path)
#if defined(_GONBEST_FLOW_FLUX_ON)
    #undef GONBEST_USE_FLOW_UV
    #define GONBEST_USE_FLOW_UV(uv1,uv2) lerp(uv1,uv2,step(0.5,_FlowUseUV2))

    #undef GONBEST_CALC_FLOW_UV
    #define GONBEST_CALC_FLOW_UV(i,uv) uv.xy * _FlowTileCount + _FlowSpeed * frac(_Time.x) * 0.8

    inline fixed3 snapdragon_addon_fx_fluxay(float3 baseColor, float2 soffset)
    {
        half2 uvW = abs(frac((baseColor.rg + soffset) * 0.5) * 2.0 - 1.0);
        half2 uvA = abs(frac((baseColor.gb + soffset) * 0.37) * 2.0 - 1.0);
        fixed4 color = lerp(_FlowColor, _FlowColor2, tex2D(_FlowTex, uvW).r);
        color.a *= tex2D(_FlowTex, uvA).r;
        return color.rgb * color.a;
    }

    inline void snapdragon_apply_flux(float2 uv, inout float4 color, float factor)
    {
        color.rgb += snapdragon_addon_fx_fluxay(color.rgb, uv) * factor * _FlowStrength;
    }
    #undef GONBEST_APPLY_FLOW
    #define GONBEST_APPLY_FLOW(flowuv,color,factor) snapdragon_apply_flux(flowuv, color, factor);
#endif
