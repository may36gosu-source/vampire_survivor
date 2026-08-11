Shader "Ares/Scene/Diffuse_Normal_AlphaBlend_RGB"
{
	Properties
	{
		_Color ("Main Color", Color) = (1, 1, 1, 1)		
		_ColorMultiplier("Color Multipler",range(0,2)) = 1		
		_MainTex("Base (RGB)", 2D) = "white" {}
		_AlphaTex("alpha (AAA)", 2D) = "white" {}
		_BumpMap("Normal(RGB)",2D) = "black"{}	
		_BumpScale("_BumpScale",Range(0,2)) = 1  			//法线比率	
		_EnvCube("Env Cube", Cube) = "white" {}
		_EnvPower("_EnvPower",float) = 0.1        //环境高亮的强度
		_NoiseMap ("_NoiseMap", 2D) = "white" {}
		_NoiseBumpMap ("_NoiseBumpMap", 2D) = "white" {}
		_NoiseTiling("_NoiseTiling",float) = 5.2
		_NoisePower("_NoisePower",float) = 0.35			
		_Glossiness("_Glossiness",Range(0,1)) = 0.2  //光滑度	
		_Metallic("_Metallic",Range(0,1)) = 0  //金属度
		_MetallicTex("Metallic(R)&Glossiness(G)&AO(B)",2D) = "white"{}  	//金属度
		_SpecularPower("_SpecularPower",Range(0,2)) = 1  //高亮强度		
		_RainStength("_RainStength",Range(0,10)) = 0  			//雨的强度	
		_RainSpeed("_RainSpeed",Range(-2,2)) = 1	  			  			//雨的闪烁速度
		_DiffuseColor ("Diffuse Color", Color) = (0.7, 0.7, 0.7, 0.7)	
		_BloomTex ("BloomTex", 2D) = "(0.5,0.5,0.5,0.5)" {}
		_BloomFactor("BloomFactor", float) = 0
		_ISUI("(> 0.5) is ui",float) = 0
		[HideInInspector]_RainFactor("_RainFactor",Range(0,1)) = 0.5  			//雨的影响因子		
		[HideInInspector]_RainScale("_RainScale",float) = 1	  			  			  			//雨的地面闪烁碎裂程度							
		
	}
	SubShader
	{
		//使用这个Shader的基本上都是贴在地面上的一些透贴,那么就使其提前渲染.不会挡住场景中的一些alpha特效
        Tags { "Queue" = "Transparent-10" "IgnoreProjector"="True" "RenderType"="Opaque" "GonbestBloomType"="BloomMask"} 
		LOD 250
		UsePass "Gonbest/PBR/ScenePBRHelper/LIGHTMAP&ALPHABLEND&ALPHATEX&SUNNY"
	}
	
	
	SubShader
	{
		//使用这个Shader的基本上都是贴在地面上的一些透贴,那么就使其提前渲染.不会挡住场景中的一些alpha特效
        Tags { "Queue" = "Transparent-10" "IgnoreProjector"="True" "RenderType"="Opaque" "GonbestBloomType"="BloomMask"}
		LOD 100
		UsePass "Gonbest/Legacy/SceneHelper/LIGHTMAP&ALPHABLEND&ALPHATEX"
	}
	Fallback "Gonbest/FallBack/FBWithShadowAlpha"
	
}
