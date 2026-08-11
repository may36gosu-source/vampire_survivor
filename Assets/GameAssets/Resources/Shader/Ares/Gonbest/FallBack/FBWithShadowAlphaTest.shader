/*
Author:gzg
Date:2019-08-29
Desc:This Shader is used to generate shadows and has alpha processing
*/

Shader "Gonbest/FallBack/FBWithShadowAlphaTest"
{
	Properties
	{
        _MainTex ("Base (RGB)", 2D) = "white" {}	
		_Cutoff("Cutoff",float) = 0.5	
	}

	SubShader
	{ 
		Tags { "RenderType"="Opaque" }
		UsePass "Gonbest/Function/ShadowCasterHelper/SHADOWCASTER&ALPHATEST"	
	}

    Fallback "Gonbest/FallBack/FBWithShadow"
}