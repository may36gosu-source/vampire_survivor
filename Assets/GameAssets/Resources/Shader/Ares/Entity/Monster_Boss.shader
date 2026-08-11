//被击的特效
Shader "Ares/Entity/Monster_Boss"
{
	Properties
	{
		_Color ("Main Color", Color) = ( 1, 1, 1, 1)		
		_ColorMultiplier("Color Multipler",Range(0,2)) = 1
		_MainTex( "Base( RGB )", 2D ) = "white" {}
		_RimColor("RimColor",Color) = ( 1, 1, 1, 1 )
		_RimMultiplier("RimMultiplier",range(0,5)) = 1
		_RimPower("Rim Light Power",float) = 1
		_InnerColor ("InnerColor", Color) = ( 1, 1, 1, 1)
		_InnerColorPower( "InnerColorPower", float ) = 10	
		_BloomTex ("BloomTex", 2D) = "(0.5,0.5,0.5,0.5)" {}
		_BloomFactor("BloomFactor", float) = 0
		_ViewFixedDir("ViewFixedParam",Vector) = (0,0,0,0)
	}
	SubShader
	{
		//LOD 100
		Tags { "RenderType" = "Opaque" "Queue" = "Geometry-50" "GonbestBloomType"="BloomMask"}
		UsePass "Gonbest/Function/RimHelper/RIMLIGHT"
	}
	Fallback "Gonbest/FallBack/FBNothing"
}
