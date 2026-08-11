// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Ares/Water/WaterMiddle" {
	Properties {
		//水的纹路
		_WaterMap ("Base (RGB)", 2D) = "white" {}
		//天空图片
		_Skybox("SkyBoxCube",2D) = "white"{}
		//波频率的而速度1
		_WaveFreqSpeed1("WaveFreqSpeed1",Vector) = (1,1,1,1)
		//波频率的速度2
		_WaveFreqSpeed2("WaveFreqSpeed2",Vector) = (1,1,1,1)
		//灯光的方向
		_LightDirection("LightDirection",Vector) = (1,1,1,1)
		//水的颜色
		_WaterColor("WaterColor",Color) = (1,1,1,1)
		//高光的颜色
		_SpecularColor("SpecularColor",Color) = (1,1,1,1)
		//高光的光滑度
		_SpecularGlossy("SpecularGlossy",Range(0,1)) = 1
		//高光的程度
		_SpecularIntensity("SpecularIntensity",float) = 1
		//反射图的扭曲度
		_ReflectionDistort("ReflectionDistort",float) = 1
		//反射的程度
		_ReflectionIntensity("ReflectionIntensity",float) = 1		
		//反射图片的透明对比度
		_ReflectionClarity("ReflectionClarity",float) = 1
		//明暗值
		_OneMinusDarkness("OneMinusDarkness",Range(0,1)) = 1
		//与岸边alpha渐变值
		_AlphaGradient("AlphaGradient",Range(0,0.2)) = 0.05
		_BloomTex ("BloomTex", 2D) = "(0.5,0.5,0.5,0.5)" {}
		_BloomFactor("BloomFactor", float) = 0
		
	}
	
	CGINCLUDE
		#include "UnityCG.cginc"	
		#include "../Gonbest/Include/Base/MathCG.cginc"	
		
		struct VertData
		{
			float4	vertex : POSITION;	
			float4	texcoord : TEXCOORD0;
			float4 	color : COLOR;
		};
		struct FragData
		{
			float4 pos : SV_POSITION;
			float4 color : COLOR;
			float4 ViewDir : TEXCOORD0;
			float4 uv : TEXCOORD1;			
			half4 proj :TEXCOORD2;
			half4 reflParam :TEXCOORD3;
		};
		
		uniform sampler2D _WaterMap;
		uniform sampler2D _Skybox;
		uniform sampler2D _CameraDepthTexture;
		
		uniform float4 _WaveFreqSpeed1;
		uniform float4 _WaveFreqSpeed2;
		uniform float4 _WaterColor;
		uniform float4 _LightDirection;
		uniform float4 _SpecularColor;
		uniform float _SpecularGlossy;
		uniform float _SpecularIntensity;
		
		uniform float _ReflectionDistort;
		uniform float _ReflectionIntensity;
		uniform float _ReflectionClarity;
		uniform float _OneMinusDarkness ;
		uniform float _AlphaGradient;
		
		
		FragData vert(VertData IN)
		{
			FragData o;
			
			float4 pos = UnityObjectToClipPos(IN.vertex);			
			o.pos = pos;			
			
			pos.xy = pos.xz * 0.01;	
			o.uv.xy = pos.xy * _WaveFreqSpeed1.xy + _Time.y * 0.01 * float2(_WaveFreqSpeed1.z, _WaveFreqSpeed1.w) ;							
			o.uv.zw = pos.xy * _WaveFreqSpeed2.xy + _Time.y * 0.01 * float2(_WaveFreqSpeed2.z, _WaveFreqSpeed2.w) ;	
			
            o.color =  _WaterColor;   
			
			o.ViewDir.xyz = GBNormalizeSafe( _WorldSpaceCameraPos.xyz -  mul(unity_ObjectToWorld,IN.vertex).xyz); 
			//记录屏幕上像素的Z值
			o.ViewDir.w = saturate(pos.z);
			//计算当前顶点投影到屏幕的位置
			o.proj = ComputeScreenPos(o.pos);		
			//计算z分量,在视图空间的值
			o.proj.z = -mul( UNITY_MATRIX_MV, IN.vertex ).z;
			
			//记录反射的参数
			o.reflParam.xy = float2((1-_ReflectionIntensity), (1- _ReflectionClarity)); //反射强度和清晰度
			o.reflParam.z = _ReflectionIntensity;
			o.reflParam.w = _ReflectionClarity;
			return o;
		}		
		
		fixed4 frag(FragData IN):COLOR
		{		
			//先从深度纹理_CameraDepthTexture中,投影采样一个Z值,
			//然后在计算视图坐标的Z值
			//SAMPLE_DEPTH_TEXTURE_PROJ = (tex2Dproj(sampler, uv).r)
			float sceneZ = LinearEyeDepth (SAMPLE_DEPTH_TEXTURE_PROJ(_CameraDepthTexture, UNITY_PROJ_COORD(IN.proj)));  
			float partZ = IN.proj.z;  
			float fade = saturate (_AlphaGradient*(sceneZ-partZ));  
			
			
			//通过Map获取一个法线值
			float3 M = tex2D(_WaterMap, IN.uv.xy).xyz + tex2D(_WaterMap, IN.uv.zw).xyz;
			
			M= M * 2.0 + float3(-2.0, -2.0, -2.0); //(-1,0)
			
			M= GBNormalizeSafe(M);			
			M.y = M.y * 0.5 + 1.0;			
			M = GBNormalizeSafe(M);
			
			//计算光线与map的值
			float4 L=GBNormalizeSafe(_LightDirection);			
			float tmpValue = dot(L.xyz, M.xyz);
			tmpValue += tmpValue;
			L.xyz = L.xyz - M.xyz * tmpValue; 
			L= GBNormalizeSafe(L);
			
			//计算光线与视线的值,获取高光
			float4 V = float4( IN.ViewDir.xyz,0);					
			//求光线与视线夹角
			tmpValue = max(dot((-L.xyz), V.xyz),0);			
			//光泽度
			tmpValue = log2(tmpValue)* _SpecularGlossy;			
			//强度
			tmpValue = exp2(tmpValue) * _SpecularIntensity;
			//获取高光颜色信息
			float3 spec = tmpValue * _SpecularColor.xyz;
			
			//计算视线与M的值 -- 反射
			tmpValue = dot(V.xyz, M.xyz);			
			
			M.xyz = M.xyz * _ReflectionDistort ;  //反射扭曲值		
			//重新设置灯光信息 -- 视线以xz面进行翻转
			L.xyz = float3(V.x,-V.y,V.z);//= V.yyy * float3(-0.0, -2.0, -0.0) + V.xyz;						
			//重新设置为顶点色
			V.xyz = IN.color.xyz * (1 - max(tmpValue, 0.0) * 0.25);		
			tmpValue = max(1 - tmpValue, 0.0);
			
			//5次方
			float t19 = tmpValue * tmpValue;
			t19 = t19 * t19;
			tmpValue = tmpValue * t19;			
			
			//计算反射
			float4 refl;
			refl.xy = IN.reflParam.xy; //反射强度和清晰度
			tmpValue = refl.x * tmpValue + IN.reflParam.z;
			
			refl.xzw = max(tmpValue,0.0) * V.xyz;
			
			L.xyz = GBNormalizeSafe(L.xyz);				
			M.xyz = M.xyz * 0.5-L.xyz;	
			
			
			//直接进行图片采样 -- 环境反射
			float3 env = tex2D(_Skybox, M.xyz).xyz; //			
			
			env = env * 4.0;
			
			env.xyz = env.xyz * IN.reflParam.w + refl.yyy;			
			
			spec.xyz = refl.xzw  * env.xyz + spec.xyz;
			
			M.xyz = spec.xyz * _OneMinusDarkness ;
			
			M.xyz =  M.xyz * IN.ViewDir.w;
			
			return  float4(M.xyz,fade * IN.color.a);
		}
	ENDCG
	SubShader {
		Tags { "Queue" = "Transparent" "RenderType"="Transparent"  "GonbestBloomType"="BloomMask"}
		LOD 200
		
		Pass{
			Blend SrcAlpha OneMinusSrcAlpha,Zero OneMinusSrcAlpha
			ZWrite Off			
			ZTest Less		
			
			CGPROGRAM								
			#pragma vertex vert
			#pragma fragment frag
			ENDCG
		}
	} 
	FallBack "Gonbest/FallBack/FBNothing"
}
