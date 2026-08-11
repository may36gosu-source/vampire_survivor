Shader "Ares/Animation/Wind_RGB"{
	Properties {
		_MainTex ("Base (RGB) Gloss (A)", 2D) = "white" {}
		_AlphaTex( "Alpha 1", 2D ) = "white" {}
		_Wind("Wind params",Vector) = (1,1,1,1)
		//边缘飘起的参数(x:幅度,y:频率)
		_WindEdgeFlutter("Wind edge fultter factor or freq scale", Vector) = (0.5,0.5,1,1)
	}

	SubShader {
		Tags {"Queue"="Transparent" "RenderType"="Transparent" "GonbestBloomType"="BloomMask"}
		//LOD 100		
		UsePass "Gonbest/Legacy/WindHelper/WIND&BLEND&ALPHATEX"
	}
	Fallback "Gonbest/FallBack/FBNothing"
}


