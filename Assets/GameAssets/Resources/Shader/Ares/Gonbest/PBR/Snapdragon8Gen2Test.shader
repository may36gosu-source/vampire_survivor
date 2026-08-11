/*===============================================================
Author: Compatibility Test for Snapdragon 8 Gen 2
Date: 2025-08-27
Desc: Test shader for verifying flow effects on Snapdragon 8 Gen 2
===============================================================*/
Shader "Gonbest/PBR/Snapdragon8Gen2Test"
{
    Properties
    {
        _Color ("Main Color", Color) = (1, 1, 1, 1)      
        _MainTex("Albedo", 2D) = "white" {}
        _FlowTex ("Flow (RGB)", 2D) = "black" {}
        _FlowStrength("FlowStrength", Range(0,2)) = 1
        _FlowSpeed ("Flow Speed", Float) = 1.0
        _FlowTileCount("Flow Tile Count", Float) = 1
        _FlowColor ("Flow Color1", Color) = (1, 1, 1, 1)      
        _FlowColor2("Flow Color2", Color) = (1, 1, 1, 1)     
        _FlowUseUV2 ("FlowUseUV2", Float) = 0       
    }

    CGINCLUDE        
        
        // Platform detection for Snapdragon 8 Gen 2 is handled in FlowUtilsCG.cginc
        
        #include "../Include/Base/CommonCG.cginc"
        #include "../Include/Utility/FlowUtilsCG.cginc"

        uniform sampler2D _MainTex;              
        uniform float4 _MainTex_ST;
            
        struct v2f
        {
            float4 pos : SV_POSITION;
            float4 uv  : TEXCOORD0;
        };

        v2f vert(appdata_full v)
        {
            v2f o;
            o.pos = UnityObjectToClipPos(v.vertex);
            o.uv.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
            o.uv.zw = GONBEST_CALC_FLOW_UV(v, GONBEST_USE_FLOW_UV(v.texcoord, v.texcoord1));
            return o;
        }

        fixed4 frag(v2f i) : COLOR
        {
            fixed4 color = tex2D(_MainTex, i.uv.xy);
            // Apply flow effect with factor = 1.0
            GONBEST_APPLY_FLOW(i.uv.zw, color.rgb, 1.0);
            return color;
        }
    ENDCG    
    
    SubShader
    { 
        Tags { "RenderType"="Opaque" }
        LOD 100
        ZWrite On
        
        Pass
        {
            Name "TEST_FLOW"            
            Tags { "LightMode" = "ForwardBase" }        
            Cull Back            
            CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag        
                #pragma target 3.0
            ENDCG
        }
    }
    
    FallBack "Diffuse"
}
