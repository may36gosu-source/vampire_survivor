/*
Author:gzg
Date:2019-08-29
Desc:This Shader does not perform any operation and the output is empty
*/

Shader "Gonbest/FallBack/FBNothing"
{
	Properties
	{		
	}

	SubShader
	{ 
		Tags { "RenderType"="Opaque" }
		Pass
		{
			ColorMask 0
			ZWrite Off
		}
	}
}