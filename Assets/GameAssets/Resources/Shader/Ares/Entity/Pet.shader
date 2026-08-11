Shader "Ares/Entity/Pet"
{
	Properties
	{
		_Color ("Main Color", Color) = ( 1, 1, 1, 1)
		_ColorMultiplier("Color Multipler",Range(0,2)) = 1
		_MainTex( "Base( RGB )", 2D ) = "white" {}		
		_BloomTex ("BloomTex", 2D) = "(0.5,0.5,0.5,0.5)" {}
		_BloomFactor("BloomFactor", float) = 0
	}

	SubShader
	{
		Tags { "RenderType" = "Opaque" "Queue" = "Geometry-50" "GonbestBloomType"="BloomMask"}		
		UsePass "Gonbest/Legacy/BodyHelper/COMMON"
		
	}	
	Fallback "Gonbest/FallBack/FBNothing"
}
