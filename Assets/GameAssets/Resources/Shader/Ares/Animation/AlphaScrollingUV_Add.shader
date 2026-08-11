Shader "Ares/Animation/AlphaScrollingUV_Add" 
{
	Properties
	{
		_Color( "Tint Color", Color ) = (0.5, 0.5, 0.5, 0.5)
		_ColorMultiplier("Color Multipler",range(0,10)) = 1
		_MainTex( "Effect Texture", 2D ) = "(0,0,0,0)" {}
		_ScrollSpeed ("scroll(x,y),a(z) ", Vector) = (2,2,1,-1)
		_UseClip("UseClip",float) = 0
		_ClipRect("ClipRect",Vector)= (-50000,-50000,50000,50000)				
	}

	SubShader
	{
		Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" "GonbestBloomType"="BloomMask"}
		
		UsePass "Gonbest/Legacy/ScrollUVHelper/ONE&ADD"
	}
	Fallback "Gonbest/FallBack/FBNothing"
	
}
