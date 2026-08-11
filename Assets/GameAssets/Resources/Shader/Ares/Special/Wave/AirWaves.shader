//空气波特效
Shader "Ares/SpecialEffect/AirWaves" {
	Properties {
	_MainTex ("MainTex", 2D) = "white" {}           // 波形图    
	_NoiseTex ("NoiseTex", 2D) = "white" {}         // 紊乱图
	_Strength  ("Strength", range (0,0.5)) = 0.2     // 波形叠加强度
 }
 Category { 
	Tags { "Queue"="Transparent+1" "RenderType"="Transparent" }  
	Blend SrcAlpha OneMinusSrcAlpha,Zero OneMinusSrcAlpha       	
	Cull Off 
	Lighting Off 
	ZWrite Off
	
	
	CGINCLUDE
		#include "UnityCG.cginc"
		struct appdata_t {
			 float4 vertex : POSITION; 
			 float2 texcoord: TEXCOORD0; 
		};
		
		struct v2f {
			 float4 pos : SV_POSITION; 
			 float4 uvgrab : TEXCOORD0; 
			 float2 uvmain : TEXCOORD1; 
		};   
			
		uniform sampler2D _MainTex;				
		uniform sampler2D _NoiseTex;				
		uniform float _Strength;  	

		v2f vert (appdata_t v)
		{
			 v2f o;				 
			 o.pos = UnityObjectToClipPos(v.vertex);						 
			 o.uvgrab = ComputeGrabScreenPos(o.pos);			 
			 o.uvmain = v.texcoord.xy;
			 return o;
		}		
		
	ENDCG
	
	SubShader {
		//这个SubShader使用GrabPass来进行实现,不过据说在移动平台下效率不高,并且也是在iphone5c下可能会崩溃,
		//这里的LOD = 210,那么这就需要设置全局Shader的LOD在小于210,才会选择这个SubShader
	   LOD 210
		GrabPass {       //抓取屏幕,得到当前屏幕的纹理_GrabTexture
			Name "BASE"
			Tags { "LightMode" = "Always" }
		}

		Pass {
			Name "BASE"
			Tags { "LightMode" = "Always" }

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest
			
			sampler2D _GrabTexture; //全屏幕纹理的样本对象，由GrabPass赋值			
		
			half4 frag( v2f i ) : COLOR
			{
				 
				 half4 noiseColor = tex2D(_NoiseTex, i.uvmain );				 				 
				 float datx = noiseColor.r * _Strength;
				 float daty = noiseColor.g * _Strength;
				 i.uvgrab.x += datx; 
				 i.uvgrab.y += daty;				 				 
				 // 但是上面给x,y叠加了运动的rg值，所以就形成透明絮乱图运动的效果
				 half4 texcolor = tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.uvgrab));				 
				 //float2 uv = i.uvgrab/i.uvgrab.w;
				 //half4 texcolor = tex2D(_GrabTexture, uv);				 
				 texcolor.a =  noiseColor.b * step(0.001,(1-(texcolor.r + texcolor.g +texcolor.b)/3));
				 return  texcolor ;
			}
			ENDCG
		}//end pass 
	}//end subshader
	
	SubShader {
		//这个SubShader使用Rendertexture来进行实现,其中_MainTex,用于保存Rendertextrue信息
		//这里的LOD = 200,那么这就需要设置Shader的LOD在小于200,大于200才会选择这个SubShader
	    LOD 200
		Pass {
				Name "BASE"
				Tags { "LightMode" = "Always" }

				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				#pragma fragmentoption ARB_precision_hint_fastest						
			
				fixed4 frag( v2f i ) : COLOR
				{					 
					 half4 noiseColor = tex2D(_NoiseTex, i.uvmain );				 				 
					 float datx = noiseColor.r * _Strength;
					 float daty = noiseColor.g * _Strength;
					 i.uvgrab.x += datx; 
					 i.uvgrab.y += daty;			
					 
					 // 但是上面给x,y叠加了运动的rg值，所以就形成透明絮乱图运动的效果
					 //half4 texcolor = tex2Dproj(_MainTex, UNITY_PROJ_COORD(i.uvgrab));				 
					 float2 uv = i.uvgrab/i.uvgrab.w;
					 #if UNITY_UV_STARTS_AT_TOP
					 uv.y = 1-uv.y;			
					 #endif
					 fixed4 texcolor = tex2D(_MainTex, uv);				
					//	后面的Step用来判断当RenderTexture不赋值的情况
					 texcolor.a =  noiseColor.b * step(0.001,(1-(texcolor.r + texcolor.g +texcolor.b)/3));		
					 return  texcolor ;
				}
				ENDCG
			}
	}	
	
	// 用于老式显卡
	SubShader {
		//LOD 100		
		Pass {			
			//Name "ONLYWRITEDEPTH"	
			//ZTest LEqual
			//ZWrite On
			ColorMask 0
		}
	}
}
}
