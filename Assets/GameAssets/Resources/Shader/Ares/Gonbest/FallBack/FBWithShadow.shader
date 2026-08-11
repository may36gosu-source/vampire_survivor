/*
Author:gzg
Date:2019-08-29
Desc:This Shader is used to generate shadows without alpha processing.
*/

Shader "Gonbest/FallBack/FBWithShadow"
{
	Properties
	{

	}

	SubShader
	{ 
		Tags { "RenderType"="Opaque" "PerformanceChecks"="False" }
		UsePass "Gonbest/Function/ShadowCasterHelper/SHADOWCASTER"	
	}

    Fallback "Gonbest/FallBack/FBNothing"
}