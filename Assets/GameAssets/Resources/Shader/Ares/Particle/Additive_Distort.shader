Shader "Ares/Particle/Additive_Distort"
{
	Properties
	{
		_Color ("Main Color", Color) = (1, 1, 1, 1)
		_ColorMultiplier("Color Multipler",range(0,10)) = 2		
		_MainTex ("Effect Texture", 2D) = "black" {}
		_MaskTex ("Mask", 2D) = "white" {}		
		_Alpha ( "Transparent ratio", Range( 0, 1 ) ) = 1
		_NoiseTex("Distort Texture ( R )",2D) = "white"{}
		_TimeScale("Speed", range ( -1, 1 ) ) = 0
		_DistortScaleX( "Strength X", range ( 0, 1 ) ) = 0.1
		_DistortScaleY( "Strength Y", range ( 0, 1 ) ) = 0.1
		_UseClip("UseClip",float) = 0
		_ClipRect("ClipRect",Vector)= (-50000,-50000,50000,50000)
		_BloomTex ("BloomTex", 2D) = "(0.5,0.5,0.5,0.5)" {}
		_BloomFactor("BloomFactor", float) = 0
	}

	SubShader
	{
		Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }
		
		UsePass "Gonbest/Legacy/ParticleHelper/COMMON&ADD&DISTORT"
	}
	Fallback "Gonbest/FallBack/FBNothing"
}