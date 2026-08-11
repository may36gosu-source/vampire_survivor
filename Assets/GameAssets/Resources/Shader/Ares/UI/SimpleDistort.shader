/*
Author:gzg
Date:2019-08-20
Desc:简单的图片扭曲效果
*/
Shader "Ares/UI/SimpleDistort"
{
	Properties
	{
		_Color("_Color",Color) = (0.879,0.885,0.956,1)  
		_MainTex("_MainTex",2D) = "black"{}
		_DistortTex("R:扭曲纹理",2D) = "black"{}						
		_DistortionSpeedX("扭曲的X方向速度",float) = 2        											
		_DistortionSpeedY("扭曲的Y方向速度",float) = 2
		_DistortionAmplitude("扭曲振幅",Range(-0.5,0.5)) = 0.005
		_DistortColorEffect("扭曲纹理的颜色(R)影响",Range(0,0.5))=0.2
	}
	
	CGINCLUDE
			#include "../Gonbest/Include/Base/CommonCG.cginc"			
			#include "../Gonbest/Include/Base/EnergyCG.cginc"
			
			struct appdata
			{
				float4 vertex:POSITION;
				float2 uv:TEXCOORD0;
				float4 color:COLOR;				
			};
			
			struct v2f
			{
				float4 pos : SV_POSITION;				
				float4 color:TEXCOORD1;				
				float4 uv : TEXCOORD2;				
				float2 noiseuv:TEXCOORD3;
			};
			
			uniform float4 _Color;			     //颜色
			uniform sampler2D _MainTex;
			uniform float4 _MainTex_ST;
			uniform sampler2D _DistortTex;
			uniform float _DistortionSpeedX;  //扭曲速度
			uniform float _DistortionSpeedY; //扭曲频率
			uniform float _DistortionAmplitude;   //扭曲振幅
			uniform float _DistortColorEffect;
			
			
	
			
			v2f vert(appdata i)
			{
				v2f o = (v2f)0;
				o.pos  = UnityObjectToClipPos(i.vertex);
				o.color = i.color * _Color;
				o.uv.xy= i.uv.xy;
				o.uv.zw = i.uv.xy + frac(float2(_DistortionSpeedX,_DistortionSpeedY) * _Time.x);			
				return o;
				
			}
			
			float4 frag(v2f i):COLOR
			{
				//采样扭曲参数
				float4 dist = tex2D(_DistortTex,i.uv.zw);				
				
				float2 uv = i.uv.xy + GBLuminance(dist.rgb) * _DistortionAmplitude;	

				float4 color = tex2D(_MainTex,uv);
				color *= i.color;
				color.xyz += dist.rgb * _DistortColorEffect;
				return color;
			}
	ENDCG
	
	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "LightMode" = "ForwardBase" }		
		Pass
		{
			Blend SrcAlpha OneMinusSrcAlpha,Zero OneMinusSrcAlpha
			ZWrite Off
			ZTest On			
			
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile _GONBEST_COLOR_SCATTER
			ENDCG
		}		
	}	
	Fallback "Gonbest/FallBack/FBNothing"
}