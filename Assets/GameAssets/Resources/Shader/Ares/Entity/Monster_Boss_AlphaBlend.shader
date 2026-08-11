//被击的特效
Shader "Ares/Entity/Monster_Boss_AlphaBlend"
{
	Properties
	{
		_Color ("Main Color", Color) = (1, 1, 1, 1)		
		_ColorMultiplier("Color Multipler",range(0,2)) = 1
        _MainTex ("Base (R:颜色强度,G:流光信息,B:透明通道)", 2D) = "white" {}
		_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
		_BumpMap("Normal Map",2D) = "black"{}
		_BumpScale("Normal Map Scale",Range(0,2)) = 1  	        		
        _RimColor("RimColor",Color) = ( 1, 1, 1, 1 )
		_InnerColor("RimColor2",Color) = (1,1,1,1)
		_RimMultiplier("RimMultiplier",range(0,5)) = 1
		_RimPower("RimPower",float) = 1  
		_FlowPower("FlowPower",float) = 3  
		_FlowFreq("FlowFreq",float) = 3  
		_ViewFixedDir("ViewFixedParam",Vector) = (0,0,0,0)
		_FlashFreq("FlashFreq",float) = 0 
		_ISUI("IsUI",float) = 0  
	}
	SubShader
	{
		Tags {"Queue"="Transparent+50" "IgnoreProjector"="True" "RenderType"= "Opaque" "GonbestBloomType"="BloomMask"}
		UsePass "Gonbest/Function/DepthHelper/ONLYWRITEDEPTH"
		UsePass "Gonbest/Function/RimHelper/RIMLIGHT&ALPHA"
	}
	Fallback "Gonbest/FallBack/FBNothing"
}
