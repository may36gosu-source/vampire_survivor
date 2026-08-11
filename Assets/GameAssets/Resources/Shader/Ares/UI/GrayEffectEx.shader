/*
Author:gzg
Date:2019-08-20
Desc:这个Shader是用于让图片灰色化处理,这个主要是根据灰化强度来处理整体灰化效果.
*/
Shader "Ares/UI/GrayEffectEx"
{
	Properties
	{
		_Color ("Main Color", Color) = (1, 1, 1, 1)
		_ColorMultiplier("Color Multipler",Range(0,2)) = 1
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_GrayFactor("GrayFactor",Range(0,1)) = 0
	}

	SubShader
	{
        Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"= "Opaque" }   
		UsePass "Gonbest/Function/DepthHelper/ONLYWRITEDEPTH"      
	    UsePass "Gonbest/Legacy/BodyHelper/COMMON&BLEND&GRAY"
	}	
	
	Fallback "Gonbest/FallBack/FBNothing"
}
