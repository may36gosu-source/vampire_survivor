Shader "Ares/Scene/NoDiffuse_AlphaTest" 
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
        Tags { "Queue" = "AlphaTest"  "GonbestBloomType"="BloomMask"}
		UsePass "Gonbest/Legacy/SceneHelper/NOLIGHTMAP&ALPHATEST"
	}
	
	Fallback "Gonbest/FallBack/FBWithShadowAlphaTest"
}
