Shader "Ares/Entity/Player_Distort_AlphaBlend"
{
	Properties
	{
		_Color ("Tint Color", Color) = (1, 1, 1, 1)
		_ColorMultiplier("Color Multipler",Range(0,2)) = 1
		_MainTex ("Base (RGB)", 2D) = "white" {}		
		_MaskTex ("Mask (R = flow mask)", 2D) = "white" {}		
		_FlowTex ("Flow (RGB)", 2D) = "black" {}		
		_FlowNoiseTex ("Flow Distort Noise Tex (RG)", 2D) = "white" {}
		_FlowType ("Flow Type:(T<1,T<2,T<3,T>3)", Float) = 0
		_FlowStrength("FlowStrength",Range(0,2)) = 1
		_FlowSpeed ("Flow Speed", Float) = 1.0
		_FlowTileCount("Flow Tile Count",Float) = 1
		_FlowColor ("Flow Color", Color) = (1, 1, 1, 1)
		_FlowColor2 ("Flow Color2", Color) = (1, 1, 1, 1)
		_FlowForceX  ("Flow Strength X", range (0,1)) = 0.1
		_FlowForceY  ("Flow Strength Y", range (0,1)) = 0.1
		_FlowUseUV2 ("FlowUseUV2", Float) = 0	
		_BloomTex ("BloomTex", 2D) = "(0.5,0.5,0.5,0.5)" {}
		_BloomFactor("BloomFactor", float) = 0
	}

	SubShader
	{	
		Tags {"Queue"="Transparent+50" "IgnoreProjector"="True" "RenderType"= "Opaque" "GonbestBloomType"="BloomMask"}	
		LOD 220
		UsePass "Gonbest/Function/DepthHelper/ONLYWRITEDEPTH"       
		UsePass "Gonbest/Legacy/BodyHelper/COMMON&BLEND&DISTORT"
	}
	
	Fallback "Gonbest/FallBack/FBNothing"
}
