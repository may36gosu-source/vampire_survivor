Shader "Ares/Particle/AlphaBlend_Rim_Multiply" 
{
	Properties
	{
		_Color ("Main Color", Color) = (0.5,0.5,0.5,0.5)
		_ColorMultiplier("Color Multipler",range(0,2)) = 0.5	
		_MainTex( "Effect Texture", 2D ) = "black" {}	
		_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5	
		_DissolveTex("DissolveTex",2D) = "black"{}
		_DissolveSoft("DissolveSoft",Range(0,1)) = 0
		_RimColor ("Rim Color", Color) = (0.5,0.5,0.5,0.5)
		_RimPower ("Rim Power", Range(0.0,10.0)) = 2.5
		_RimInnerColor ("RimInnerColor", Color) =  (0.5,0.5,0.5,0.5)	
        _RimInnerPower("RimInnerPower", Range(0.0,10.0)) = 2.5	
		_AlphaPower("AlphaPower",Range(0.0, 1.0)) = 0
		_Alpha ("Alpha", Range(0.0, 1.0)) = 1.0
		_CtrlTexUseUV2("CtrlTexUseUV2",float) = 0
		_UseCustomData("UseCustomData(custom1.w)",float) = 0
		_UseClip("UseClip",float) = 0
		_ClipRect("ClipRect",Vector)= (-50000,-50000,50000,50000)
		_BloomTex ("BloomTex", 2D) = "(0.5,0.5,0.5,0.5)" {}
		_BloomFactor("BloomFactor", float) = 0

	}

	SubShader
	{
		Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"  "GonbestBloomType"="BloomMask"}	
		UsePass "Gonbest/Function/DepthHelper/ONLYWRITEDEPTH&ALPHATEST"	
		UsePass "Gonbest/Legacy/ParticleHelper/BLEND&RIM&MULTIPLY&DISSOLVE"
	}
	Fallback "Gonbest/FallBack/FBNothing"	 
}