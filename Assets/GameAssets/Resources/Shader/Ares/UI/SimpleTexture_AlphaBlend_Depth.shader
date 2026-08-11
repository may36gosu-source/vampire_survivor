Shader "Ares/UI/SimpleTexture_AlphaBlend_Depth"
{
    Properties
    {
        _Color ("Tint Color", Color) = (1,1,1,1)
        _MainTex ("Texture", 2D) = "black" {}
        _Cutoff ("CutOff", Range(0,1)) = 0.5
    }
    SubShader
    {
        Tags { "RenderType" = "Opaque" "Queue" = "Transparent"}

        UsePass "Gonbest/Function/DepthHelper/ONLYWRITEDEPTH&ALPHATEST"

        UsePass "Ares/UI/SimpleTexture_AlphaBlend/BASEBLEND"        
    }
    Fallback "Gonbest/FallBack/FBWithShadow"
}
