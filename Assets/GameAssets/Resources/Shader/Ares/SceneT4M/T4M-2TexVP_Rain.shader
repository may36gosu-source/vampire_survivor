Shader "Ares/SceneT4M/T4M-2TexVP_Rain" 
{
	Properties 
	{
		_Color ("Main Color", Color) = (1, 1, 1, 1)		
		_ColorMultiplier("Color Multipler",range(0,2)) = 1
		_Splat0 ( "Layer 1", 2D ) = "white" {}
		_Splat1 ( "Layer 2", 2D ) = "white" {}		
		_Splat0_BumpMap ( "Layer 1 Normal Map", 2D ) = "white" {}
		_Splat1_BumpMap ( "Layer 2 Normal Map", 2D ) = "white" {}
		_Control ("Control (RGBA )", 2D ) = "white" {}
		_EnvPower("_EnvPower",float) = 0.1        //环境高亮的强度
		_EnvCube("Env Cube", Cube) = "white" {}
		_NoiseMap ("_NoiseMap", 2D) = "white" {}
		_NoiseBumpMap ("_NoiseBumpMap", 2D) = "white" {}
		_NoiseTiling("_NoiseTiling",float) = 5.2
		_NoisePower("_NoisePower",float) = 0.35	
		_BumpScale("_BumpScale",Range(0,2)) = 1  			//发现比率				
		_Glossiness("_Smoothness",Range(0,1)) = 0.2  //光滑度	
		_Metallic("_Metallic",Range(0,1)) = 0  //金属度
		_SpecularPower("_SpecularPower",Range(0,2)) = 0.8  //高亮强度
		_RainStength("_RainStength",Range(0,10)) = 1  			//雨的强度				
		_RainSpeed("_RainSpeed",Range(-2,2)) = 1	  			  			//雨的闪烁速度
		_DiffuseColor ("Diffuse Color", Color) = (0.7, 0.7, 0.7, 0.7)			
	}


	SubShader 
	{
		Tags {"SplatCount" = "2" "RenderType" = "Opaque" "Queue" = "Geometry+50"  "GonbestBloomType"="BloomMask"}
		LOD 250
		UsePass "Gonbest/PBR/T4MPBRHelper/TWO&RAIN"
	}    

	SubShader 
	{
		Tags {"SplatCount" = "2" "RenderType" = "Opaque" "Queue" = "Geometry+50" "GonbestBloomType"="BloomMask" }	
		LOD 100	
		UsePass "Gonbest/Legacy/T4MHelper/TWO"
	}
}
