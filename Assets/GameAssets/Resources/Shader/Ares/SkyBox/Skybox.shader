Shader "Ares/Skybox/Skybox"
{
	Properties
	{
		_Color( "Tint Color", Color ) = ( 1.0, 1.0, 1.0, 1.0 )
		_ColorMultiplier("Color Multipler",range(0,2)) = 1
		_MainTex( "Base( RGB )", 2D ) = "white" {}
		_FogFactor("Fog Factor",Range(0,1)) = 0
	}

	SubShader
	{
		Tags { "Queue" = "Background" "GonbestBloomType"="BloomMask"}
		//LOD 100
		Lighting Off
		ZTest LEqual
		ZWrite On
		Cull Back
		UsePass "Gonbest/Legacy/SkyHelper/SKYBOX"
	}	
	Fallback "Gonbest/FallBack/FBNothing"
}
