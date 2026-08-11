Shader "Ares/Animation/WindGrass_RGB"
{
	Properties
	{
		_Color("Tint Color",Color) = (0.5,0.5,0.5,0.5)
		_ColorMultiplier("Color Multipler",range(0,2)) = 1
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_AlphaTex( "Alpha 1", 2D ) = "white" {}
		_Direction("Direction",float) = 1
		_Frequency("Frequency",float) = 0.04		
		_Cutoff("_Cutoff",Range(0,1)) = 0.5

	}
	SubShader
	{		
		Tags { "RenderType"="TransparentCutout" "Queue"="AlphaTest" "GonbestBloomType"="BloomMask"}		
		UsePass "Gonbest/Legacy/WindHelper/WINDGRASS&ALPHATEX"
	}
	Fallback "Gonbest/FallBack/FBNothing"
}
