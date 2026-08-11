Shader "Ares/Particle/Additive_Skill_Distort_ScrollUV"
{
	Properties
	{
		_Color ("Main Color", Color) = (1, 1, 1, 1)
		_ColorMultiplier("Color Multipler",range(0,10)) = 2		
		_MainTex ("Effect Texture", 2D) = "black" {}
		_ScrollSpeed ("scroll(x,y),a(z) ", Vector) = (2,2,1,-1)
		_MaskTex ("Mask", 2D) = "white" {}		
		_Alpha ( "Transparent ratio", Range( 0, 1 ) ) = 1
		_NoiseTex("Distort Texture ( R )",2D) = "white"{}
		_TimeScale("Distort Speed", range ( -1, 1 ) ) = 0
		_DistortScaleX( "Strength X", range ( 0, 1 ) ) = 0.1
		_DistortScaleY( "Strength Y", range ( 0, 1 ) ) = 0.1
		_UseClip("UseClip",float) = 0
		_ClipRect("ClipRect",Vector)= (-50000,-50000,50000,50000)
		_BloomTex ("BloomTex", 2D) = "(0.5,0.5,0.5,0.5)" {}
		_BloomFactor("BloomFactor", float) = 0
	}

	SubShader
	{
		Tags { "Queue"="Transparent+50" "IgnoreProjector"="True" "RenderType"="Transparent"  "GonbestBloomType"="BloomMask"}				
		UsePass "Gonbest/Legacy/ParticleHelper/SKILL&DISTORT&SCROLLONE"
		
	}
	Fallback "Gonbest/FallBack/FBNothing"
}