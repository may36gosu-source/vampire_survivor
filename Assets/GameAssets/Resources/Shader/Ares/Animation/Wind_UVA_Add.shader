Shader "Ares/Animation/Wind_UVA_Add"{
	Properties {
		//颜色值
		_Color("Color", Color) = (0.5,0.5,0.5,0.5)
		_ColorMultiplier("Color Multipler",range(0,2)) = 1
		//主纹理
		_MainTex ("Base (RGB) Gloss (A)", 2D) = "white" {}
		//风的参数
		_Wind("Wind params",Vector) = (1,1,1,1)
		//边缘飘起的参数(x:幅度,y:频率)
		_WindEdgeFlutter("Wind edge fultter factor or freq scale", Vector) = (0.5,0.5,1,1)
		//UV流动速度,Alpha变换速度
		_ScrollSpeed("UV (x,y) Alpha(z) Speed",Vector) = (2,2,1,1)
	}
		
	SubShader {
		Tags { "Queue"="Transparent" "RenderType"="Transparent" "GonbestBloomType"="BloomMask"}
		//LOD 100			
		UsePass "Gonbest/Legacy/WindHelper/WIND&SCROLL&ADD"
	}
	Fallback "Gonbest/FallBack/FBNothing"
}


