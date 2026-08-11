/*
Author:gzg
Date:2019-08-20
Desc:这个Shader是用来生成阴影并且与StencilShadowCaster是同时使用    
*/
Shader "Ares/SpecialEffect/StencilShadowReceiver"
{
	Properties
	{
		
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		
		UsePass "Gonbest/Function/StencilShadowHelper/SHADOWRECEIVER"
	}
}
