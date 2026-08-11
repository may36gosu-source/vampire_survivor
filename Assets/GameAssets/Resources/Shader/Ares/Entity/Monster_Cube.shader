Shader "Ares/Entity/Monster_Cube"
{
	Properties
	{
		_Color ("Main Color", Color) = ( 1, 1, 1, 1)
		_ColorMultiplier("Color Multipler",Range(0,2)) = 1
		_MainTex( "Base( RGB )", 2D ) = "white" {}
		_EnvCube("_EnvCube", Cube) = "black"{}
		_EnvCubeMixer("_EnvCubeMixer",float) = 1
		_BloomTex ("BloomTex", 2D) = "(0.5,0.5,0.5,0.5)" {}
		_BloomFactor("BloomFactor", float) = 0
	}

	SubShader
	{
		Tags { "RenderType" = "Opaque" "Queue" = "Geometry-50" "GonbestBloomType"="BloomMask"}		
		UsePass "Gonbest/Legacy/BodyHelper/COMMON&CUBE"
		
	}	
	
	Fallback "Gonbest/FallBack/FBNothing"
}
