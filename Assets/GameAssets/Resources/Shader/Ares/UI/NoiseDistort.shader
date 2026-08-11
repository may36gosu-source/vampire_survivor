/*
Author:gzg
Date:2019-08-20
Desc:这个Shader是用于让图片通过噪音图进行扭曲处理.仿照通讯噪音处理
*/
Shader "Ares/UI/NoiseDistort"
{
	Properties
	{
		_Color("_Color",Color) = (0.879,0.885,0.956,1)  
		_MainTex("_MainTex",2D) = "black"{}
		_ColorScatterStrength("纹理颜色离散强度",Range(0,1)) = 0

		_DistortTex("扭曲纹理",2D) = "black"{}				
		_DistortionAnmSpeed ("扭曲的速度",float) = 2        											
		_DistortionFrequency("扭曲频率",float) = 10
		_DistortionAmplitude("扭曲振幅",Range(-0.5,0.5)) = 0.005

		_NoiseTex("噪音纹理",2D) = "black"{}
		_NoiseAnmSpeed("噪音的速度",float) = 10				
		_NoiseStrength("噪音的强度",float) = 0.5

		_BackgroundColor("背景颜色",Color) = (0.119,0.137,0.162,0.779)
	}
	
	CGINCLUDE
			#include "UnityCG.cginc"
			#include "../Gonbest/Include/Utility/WidgetUtilsCG.cginc"
			
			struct appdata
			{
				float4 vertex:POSITION;
				float2 uv:TEXCOORD0;
				float4 color:COLOR;				
			};
			
			struct v2f
			{
				float4 pos : SV_POSITION;
				float2 vppos : TEXCOORD0;
				float4 color:TEXCOORD1;				
				float4 uv : TEXCOORD2;				
				float2 noiseuv:TEXCOORD3;
			};
			
			uniform float4 _Color;			     //颜色
			uniform float _DistortionAnmSpeed;  //扭曲速度
			uniform float _DistortionFrequency; //扭曲频率
			uniform float _NoiseAnmSpeed; //噪音的闪动速度
			
			uniform float4 _BackgroundColor; //背景颜色			
			uniform float _DistortionAmplitude;   //扭曲振幅
			uniform float _NoiseStrength;	//噪音强度
			
			uniform sampler2D _DistortTex;
			uniform sampler2D _MainTex;
			uniform sampler2D _NoiseTex;
			uniform float4 _NoiseTex_ST;
			
			v2f vert(appdata i)
			{
				v2f o = (v2f)0;
				float4 pos  = UnityObjectToClipPos(i.vertex);						
				o.pos = float4(pos.x, pos.y, (pos.w + pos.z)* 0.5, pos.w);
				o.vppos = pos;
				o.color = i.color * _Color;
				o.uv = float4(i.uv.xy, _DistortionAnmSpeed * _Time.y, i.uv.y * _DistortionFrequency);							
				float4 tp = float4(_SinTime.wx,_CosTime.xw) * 12.98 ;
				float2 tt = tp.xy + tp.zw;
				o.noiseuv = i.uv.xy * _NoiseTex_ST.xy + _NoiseTex_ST.zw +  _NoiseAnmSpeed * tt.xy;
				return o;
				
			}
			
			float4 frag(v2f i):COLOR
			{
				//采样扭曲参数
				float dist = tex2D(_DistortTex,i.uv.zw).x;// - 0.498;				
				
				float2 uv = i.uv.xy + dist * _DistortionAmplitude;				
				
				fixed4 main = float4(0,0,0,0);
				GONBEST_TEX_SAMPLE_SCATTER(_MainTex,uv,main)
				main.rgb *= i.color.xyz;				
				//判断alpha值
				float a = main.a + 0.5;				
				if(floor(a) == 0)  main = _BackgroundColor;	
				
				//采样噪音
				float3 noise = tex2D(_NoiseTex,i.noiseuv).xyz * _NoiseStrength;
				
				//汇合颜色
				float3 ret = 1 - (1 - main.xyz) * (1 - noise);
				
				return float4(ret,main.a);
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
	
	/*
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
			ENDCG
		}		
	}*/
	Fallback "Gonbest/FallBack/FBNothing"
}