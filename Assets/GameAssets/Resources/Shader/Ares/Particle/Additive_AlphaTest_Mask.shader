Shader "Ares/Particle/Additive_AlphaTest_Mask"
{
	Properties
	{
		_Color ("Main Color", Color) = (1, 1, 1, 1)
		_ColorMultiplier("Color Multipler",range(0,2)) = 2		
		_MainTex ("Effect Texture", 2D) = "black" {}
		_Cutoff("_Cutoff",range(0,1)) = 1
		_AlphaTestMaskTex("_AlphaTestMaskTex (R)", 2D) = "white" {}	
		_AlphaTestColor ("_AlphaTestColor", Color) = (1, 1, 1, 1)	
		_Alpha ( "Transparent ratio", Range( 0, 1 ) ) = 1
		_UseClip("UseClip",float) = 0
		_ClipRect("ClipRect",Vector)= (-50000,-50000,50000,50000)
		_BloomTex ("BloomTex", 2D) = "(0.5,0.5,0.5,0.5)" {}
		_BloomFactor("BloomFactor", float) = 0
	}

	SubShader
	{
		Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"  "GonbestBloomType"="BloomMask"}

		UsePass "Gonbest/Legacy/ParticleHelper/COMMON&ADD&ALPHATESTMASK"
	}
	Fallback "Gonbest/FallBack/FBNothing"
}