Shader "Ares/Skybox/SkyboxCube"
{
	Properties
	{
		_SkyColor ("Sky Color", Color) = (0.02553246,0.03709318,0.1827586,1)
        _GroundColor ("Ground Color", Color) = (0.06617647,0.5468207,1,1)
		[HDR]_SunColor("SunColor",Color) = (1,1,1,1)
        _SunRadiusB ("Sun Radius B", Range(0, 1)) = 0
        _SunRadiusA ("Sun Radius A", Range(0, 1)) = 0
        _SunIntensity ("Sun Intensity", Float ) = 2
        _HorizonColor ("HorizonColor", Color) = (0.6838235,0.9738336,1,1)
        _Horizon2Size ("Horizon2 Size", Range(0, 8)) = 1.755868
        _Horion1Size ("Horion1 Size", Range(0, 8)) = 8
        _SkyupColor ("Sky up", Color) = (0,0.1332658,0.2647059,1)
        _CloudsCube ("Clouds", Cube) = "_Skybox" {}
	}

	SubShader
	{
		Tags {  "IgnoreProjector"="True" "Queue"="Background" "RenderType"="Opaque" "PreviewType"="Skybox" "GonbestBloomType"="BloomMask"}		
		UsePass "Gonbest/Legacy/SkyHelper/SKYBOX&CUBE"
	}	
	Fallback "Gonbest/FallBack/FBNothing"
}
