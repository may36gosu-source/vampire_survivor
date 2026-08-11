//霸体效果
Shader "Ares/EntityState/SuperArmor_Wing_RGB"
{
	Properties
	{
		_Color ("Main Color", Color) = ( 1, 1, 1, 1)
		_ColorMultiplier("Color Multipler",range(0,2)) = 1
		_MainTex ( "Base (RGB)", 2D ) = "white" {}
		_AlphaTex("alpha (AAA)", 2D) = "white" {}
		[HideInInspector]_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5		
		[HideInInspector]_BumpScale("Normal Map Scale",Range(0,2)) = 1  			//发现比率				
		[HideInInspector]_BumpMap("Normal Map",2D) = "black"{}		
		[HideInInspector]_Glossiness("Smoothness",Range(0,1)) = 0.2  //光滑度	
		[HideInInspector]_Metallic("Metallic",Range(0,1)) = 0  //光滑度
		[HideInInspector]_MetallicTex("Metallic(R)&Glossiness(G)&Skin(B) Tex",2D) = "white"{}  	//金属度	
		[HideInInspector]_EnvDiffPower("Cube Diff Power",Range(0,4)) = 1
		[HideInInspector]_EnvSpecPower("Cube Spec Power",Range(0,4)) = 1
		[HideInInspector]_EnvCubeMipLevel("Cube MipLevel" , Range(0,100)) = 32
		[HideInInspector]_EnvCube("Cube Map", Cube) = "grey" {}	
		[HideInInspector]_DiffuseColor ("Diffuse Color", Color) = (0.7, 0.7, 0.7, 0.7)						
		[HideInInspector]_SpecPower("SpecPower",Range(0,10)) = 1	
		[HideInInspector]_OA("OA",Range(0,1)) = 0.5
		[HideInInspector]_MainLightPos("Main Light Pos",Vector) = (0,0,0,1)
		[HideInInspector]_MainLightColor("Main Light Color",Color) = (1,1,1,1)
		[HideInInspector]_FillInLightPos("Fill In Light Pos",Vector) = (0,0,0,0)
		[HideInInspector]_FillInLightColor("Fill In Light Color",Color) = (1,1,1,1)
		[HideInInspector]_ISUI("(> 0.5) is ui",float) = 0
		[HideInInspector]_MaskTex("Flow(R)&Flash(G)&LogicColor(B) MaskTex",2D) = "black"{}  	//Mask贴图
		[HideInInspector]_LogicColor("LogicColor", Color) = (0, 0, 0, 0)
		[HideInInspector]_SSSColor("SSSColor",Color) = (0,0,0,0)
		[HideInInspector]_FlowTex ("Flow (RGB)", 2D) = "black" {}		
		[HideInInspector]_FlowNoiseTex ("Flow Distort Noise Tex (RG)", 2D) = "white" {}
		[HideInInspector]_FlowType ("Flow Type:(T<1,T<2,T<3,T>3)", Float) = 0
		[HideInInspector]_FlowStrength("FlowStrength",Range(0,2)) = 1
		[HideInInspector]_FlowSpeed ("Flow Speed", Float) = 1.0
		[HideInInspector]_FlowTileCount("Flow Tile Count",Float) = 1
		[HideInInspector]_FlowColor ("Flow Color1", Color) = (1, 1, 1, 1)		
		[HideInInspector]_FlowColor2("Flow Color2", Color) = (1, 1, 1, 1)		
		[HideInInspector]_FlowForceX  ("Flow Strength X", range (0,1)) = 0.1
		[HideInInspector]_FlowForceY  ("Flow Strength Y", range (0,1)) = 0.1
		[HideInInspector]_FlowUseUV2 ("FlowUseUV2", Float) = 0	
		[HideInInspector]_FlashSpeed("FlashSpeed",Float) = 1
		[HideInInspector]_FlashColor("FlashColor", Color) = (1, 1, 1, 1)
		[HideInInspector]_BloomTex ("BloomTex", 2D) = "(0.5,0.5,0.5,0.5)" {}
		[HideInInspector]_BloomFactor("BloomFactor", float) = 0
	}

	SubShader
	{
        Tags {"Queue"="Transparent+100" "IgnoreProjector"="True" "RenderType"= "Opaque" "GonbestBloomType"="BloomMask"}
        //LOD 100    	
		
	    UsePass "Gonbest/Legacy/BodyHelper/COMMON&BLEND&ALPHATEX"
	}	
}
