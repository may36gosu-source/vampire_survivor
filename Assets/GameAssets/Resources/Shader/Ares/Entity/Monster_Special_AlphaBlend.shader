// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Ares/Entity/Monster_Special_AlphaBlend"
{
	Properties
	{
		_Color ("Main Color", Color) = ( 1, 1, 1, 1)
		_ColorMultiplier("Color Multipler",Range(0,2)) = 1
		_MainTex( "Base( RGB )", 2D ) = "white" {}		
		_MatCapTex( "MatCapTex( RGB )", 2D ) = "white" {}
		_MixValue( "Mix Factor", range(0,1) ) = 1
		_BloomTex ("BloomTex", 2D) = "(0.5,0.5,0.5,0.5)" {}
		_BloomFactor("BloomFactor", float) = 0
	}	
	SubShader
	{
		LOD 220
		Tags {"Queue"="Transparent+50" "IgnoreProjector"="True" "RenderType"= "Opaque" "GonbestBloomType"="BloomMask"}
		UsePass "Gonbest/Function/DepthHelper/ONLYWRITEDEPTH"       	
		UsePass "Gonbest/Legacy/BodyHelper/COMMON&MATCAP&BLEND"
	}	
	Fallback "Gonbest/FallBack/FBNothing"
}
