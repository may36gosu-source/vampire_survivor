Shader "Ares/Scene/Diffuse_AlphaTest_DoubleFace" 
{
	Properties
	{
		_Color ("Main Color", Color) = (1, 1, 1, 1)		
		_ColorMultiplier("Color Multipler",range(0,2)) = 1
		_MainTex ("Base (RGB) Trans (A)", 2D) = "white" {}
		_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
		_DiffuseColor("EmissiveColor",Color) = (1,1,1,0)
		_BloomTex ("BloomTex", 2D) = "(0.5,0.5,0.5,0.5)" {}
		_BloomFactor("BloomFactor", float) = 0
		_ISUI("(> 0.5) is ui",float) = 0
	}
	
	SubShader
	{
        Tags { "Queue" = "AlphaTest" "RenderType" = "Opaque" "GonbestBloomType"="BloomMask"}
		UsePass "Gonbest/Legacy/SceneHelper/LIGHTMAP&ALPHATEST&DOUBLEFACE"
	}
	Fallback "Gonbest/FallBack/FBWithShadowAlphaTest"
}
