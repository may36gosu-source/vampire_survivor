Shader "Ares/Entity/Wing"
{
	Properties
	{
		_Color ("Main Color", Color) = (1,1,1,1)
		_ColorMultiplier("Color Multipler",range(0,2)) = 1
		_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
		_MainTex ("Base (RGB) Trans (A)", 2D) = "white" {}	
		_MaskTex("Mask (R = flow mask)", 2D) = "white" {}
		_FlowTex("Flow (RGB)", 2D) = "black" {}
		_FlowType("Flow Type:(T<1,T<2,T<3,T>3)", Float) = 0
		_FlowStrength("FlowStrength",Range(0,2)) = 1
		_FlowSpeed("Flow Speed", Float) = 1.0
		_FlowTileCount("Flow Tile Count",Float) = 1
		_FlowColor("Flow Color", Color) = (1, 1, 1, 1)
		_FlowUseUV2 ("FlowUseUV2", Float) = 0	
		_BloomTex ("BloomTex", 2D) = "(0.5,0.5,0.5,0.5)" {}
		_BloomFactor("BloomFactor", float) = 0
	}

	SubShader
	{
        Tags {"Queue"="Transparent+50" "IgnoreProjector"="True" "RenderType"= "Opaque" "GonbestBloomType"="BloomMask"}
        //LOD 100    	
	    UsePass "Gonbest/Legacy/BodyHelper/COMMON&BLEND"
	}	
	Fallback "Gonbest/FallBack/FBNothing"
}
