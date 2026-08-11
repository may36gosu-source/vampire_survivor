Shader "Ares/Animation/AlphaScrollingUV_ModelClip" 
{
	Properties
	{
		_Color( "Tint Color", Color ) = (0.5, 0.5, 0.5, 0.5)
		_ColorMultiplier("Color Multipler",range(0,10)) = 1
		_MainTex( "Effect Texture", 2D ) = "(0,0,0,0)" {}
		_ScrollSpeed ("scroll(x,y),a(z) ", Vector) = (2,2,1,-1)
		_UseClip("UseClip",float) = 0
		_ClipRect("ClipRect",Vector)= (-50000,-50000,50000,50000)	
		_InsideColor("内部颜色",Color) = (1, 1, 0, 1)
        _ClipMaxLength("被切的最大长度",float) = 4
        _ClipAmount("切的进度信息",Range(-1 , 1)) = 0
        _EdgeWidth("切割部位的高度",Range(0 , 1)) = 0.2
        _EdgeColor("切割部位的颜色",Color) = (1, 1, 0, 1)  			
	}

	SubShader
	{
		Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" "GonbestBloomType"="BloomMask"}
		
		UsePass "Gonbest/Legacy/ScrollUVHelper/ONE&BLEND&MODELCLIP"
	}
	Fallback "Gonbest/FallBack/FBNothing"
}
