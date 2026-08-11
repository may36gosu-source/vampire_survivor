Shader "Ares/Particle/AlphaBlend_Rim" 
{
	Properties
	{
		_Color ("Main Color", Color) = (0.5,0.5,0.5,0.5)
		_ColorMultiplier("Color Multipler",range(0,2)) = 0.5	
		_MainTex( "Effect Texture", 2D ) = "black" {}		
		_RimColor ("Rim Color", Color) = (0.5,0.5,0.5,0.5)
		_RimPower ("Rim Power", Range(0.0,5.0)) = 2.5		
		_AlphaPower ("Alpha Rim Power", Range(0.0,8.0)) = 4.0
		_Alpha ("All Power", Range(0.0, 10.0)) = 1.0
		_UseClip("UseClip",float) = 0
		_ClipRect("ClipRect",Vector)= (-50000,-50000,50000,50000)
		_BloomTex ("BloomTex", 2D) = "(0.5,0.5,0.5,0.5)" {}
		_BloomFactor("BloomFactor", float) = 0

	}

	SubShader
	{
		Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"  "GonbestBloomType"="BloomMask"}		
		UsePass "Gonbest/Legacy/ParticleHelper/BLEND&RIM"
	}
	Fallback "Gonbest/FallBack/FBNothing"	 
}
