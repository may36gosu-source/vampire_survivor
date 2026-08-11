Shader "Ares/Particle/Multiply_Dissolve"
{
	Properties
	{
		_Color ("Main Color", Color) = (1, 1, 1, 1)
		_ColorMultiplier("Color Multipler",range(0,2)) = 2		
		_MainTex ("Effect Texture", 2D) = "black" {}
		_Alpha ( "Transparent ratio", Range( 0, 1 ) ) = 1
		_DissolveTex("DissolveTex",2D) = "black"{}
		_DissolveSoft("DissolveSoft",Range(0,1)) = 0
		_CtrlTexUseUV2("_CtrlTexUseUV2",float) = 0
		_UseCustomData("UseCustomData(custom1.w)",float) = 0
		_UseClip("UseClip",float) = 0
		_ClipRect("ClipRect",Vector)= (-50000,-50000,50000,50000)
		_BloomTex ("BloomTex", 2D) = "(0.5,0.5,0.5,0.5)" {}
		_BloomFactor("BloomFactor", float) = 0
	}

	SubShader
	{
		Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }
		
		UsePass "Gonbest/Legacy/ParticleHelper/COMMON&MULTIPLY&DISSOLVE"
	}
	Fallback "Gonbest/FallBack/FBNothing"
}