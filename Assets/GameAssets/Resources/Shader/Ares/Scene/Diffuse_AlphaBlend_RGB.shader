
Shader "Ares/Scene/Diffuse_AlphaBlend_RGB"
{
	Properties
	{
		_Color ("Main Color", Color) = (1, 1, 1, 1)		
		_ColorMultiplier("Color Multipler",range(0,2)) = 1		
		_MainTex("Base (RGB)", 2D) = "white" {}
		_AlphaTex("alpha (AAA)", 2D) = "white" {}
		_DiffuseColor("EmissiveColor",Color) = (1,1,1,0)
		_BloomTex ("BloomTex", 2D) = "(0.5,0.5,0.5,0.5)" {}
		_BloomFactor("BloomFactor", float) = 0
		_ISUI("(> 0.5) is ui",float) = 0
	}
	
	SubShader
	{
		//使用这个Shader的基本上都是贴在地面上的一些透贴,那么就使其提前渲染.不会挡住场景中的一些alpha特效
        Tags { "Queue" = "Transparent-10" "IgnoreProjector"="True" "RenderType"="Opaque" "GonbestBloomType"="BloomMask"}
		UsePass "Gonbest/Legacy/SceneHelper/LIGHTMAP&ALPHABLEND&ALPHATEX"
	}
	Fallback "Gonbest/FallBack/FBWithShadowAlpha"
	
}
