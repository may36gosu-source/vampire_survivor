Shader "Ares/Entity/Monster_Cube_AlphaBlend"
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
		Tags {"Queue"="Transparent+50" "IgnoreProjector"="True" "RenderType"= "Opaque" "GonbestBloomType"="BloomMask"}	
		UsePass "Gonbest/Function/DepthHelper/ONLYWRITEDEPTH"       
		UsePass "Gonbest/Legacy/BodyHelper/COMMON&BLEND&CUBE"
		
	}	
	
	Fallback "Gonbest/FallBack/FBNothing"
}
