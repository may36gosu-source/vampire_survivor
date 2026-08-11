Shader "Ares/Water/Water"
{
	Properties{
		//波的大小
		_WaveScale( "Wave scale", Range( 0.02,0.15 ) ) = 0.063
		//波浪的速度
		_WaveSpeed( "Wave speed (map1 x,y; map2 x,y)", Vector ) = ( 19,9,-16,-7 )	
		//地平线的光
		_HorizonColor( "Horizon color", COLOR ) = ( .172, .463, .435, 1 )
		//反射的光
		_RefrColor( "Refraction color", COLOR ) = ( .34, .85, .92, 1 )
		//折射的颜色,其中A是菲尼尔值
		_ReflectiveColorTex( "Reflective color (RGB) fresnel (A) ", 2D ) = "" {}
		//法线纹理
		_BumpMap( "Normalmap ", 2D ) = "bump" {}
		//基础纹理--反射的纹理
		_BaseTex( "Refraction Tex (RGB)", 2D ) = "gray" {}
		//反射纹理的扭曲值
		_RefrDistort( "Refraction distort", Range( 0, 1 ) ) = 0.05
		_ViewFixedDir("ViewFixedParam",Vector) = (0,0,0,0)
		_BloomTex ("BloomTex", 2D) = "(0.5,0.5,0.5,0.5)" {}
		_BloomFactor("BloomFactor", float) = 0
	}

	Subshader {
		Tags { "Queue" = "Transparent" "RenderType" = "Transparent"  "GonbestBloomType"="BloomMask"}
		UsePass "Gonbest/Function/DepthHelper/ONLYWRITEDEPTH" 
		Pass {
			Blend SrcAlpha OneMinusSrcAlpha,Zero OneMinusSrcAlpha			
			Cull Back			
			ZWrite Off

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
            #pragma multi_compile_fog
			#pragma multi_compile _GONBEST_SHADOW_ON _GONBEST_SHADOW_OFF			
			#pragma multi_compile _GONBEST_CUSTOM_SHADOW_ON
			#pragma multi_compile _GONBEST_USE_FIXED_VIEW_ON
			#include "../Gonbest/Include/Base/MathCG.cginc"
			#include "../Gonbest/Include/Utility/FogUtilsCG.cginc"
			#include "../Gonbest/Include/Shadow/ShadowCG.cginc"
			#include "../Gonbest/Include/Utility/WidgetUtilsCG.cginc"
			#include "../Gonbest/Include/Utility/PixelUtilsCG.cginc"


			sampler2D _BumpMap;
			sampler2D _ReflectiveColorTex;
			sampler2D _BaseTex;

			uniform half _WaveScale;
			uniform half4 _WaveSpeed;
			uniform half4 _BaseTex_ST;
			uniform half _RefrDistort;
			uniform fixed4 _HorizonColor;
			uniform fixed4 _RefrColor;

			struct v2fIn {
				float4 vertex : POSITION;
				float2 uv:TEXCOORD0;
				float2 uv1:TEXCOORD1;
				fixed4 color : COLOR;
			};

			struct v2f {
				float4 pos : SV_POSITION;
				fixed4 color : COLOR;
				half2 bumpuv0 : TEXCOORD0;
				half2 bumpuv1 : TEXCOORD1;
				half2 tiling : TEXCOORD2;			
				float4 wpos : TEXCOORD3;
				GONBEST_VIEW_FIXED_COORDS(4)
				GONBEST_FOG_COORDS( 5 )
				GONBEST_SHADOW_COORDS(6)
				
			};

			v2f vert( v2fIn v ) {
				v2f o = (v2f)0;
				o.pos = UnityObjectToClipPos( v.vertex );
				float4 wpos = mul (unity_ObjectToWorld, v.vertex);								
				half4 scale = _WaveScale * half4(1, 1, 0.4, 0.45);
				half4 temp = (wpos.xzxz + _WaveSpeed * _Time.y)  * scale;
				o.bumpuv0 = temp.xy;
				o.bumpuv1 = temp.wz;
				o.tiling = v.uv * _BaseTex_ST.xy + _BaseTex_ST.zw;				
				o.color = v.color;
				o.wpos = wpos;
				GONBEST_TRANSFER_FOG(o, o.pos,wpos);
				//阴影处理
				GONBEST_TRANSFER_SHADOW_WPOS(o,wpos,v.uv1);		

				GONBEST_TRANSFER_VIEW_FIXED(o);
				return o;
			}

			half4 frag( v2f i ) : SV_Target {
				float3 V = GetWorldViewDir(i.wpos);
				GONBEST_VIEW_FIXED_APPLY(i,V);
				fixed3 bump1 = UnpackNormal( tex2D( _BumpMap, i.bumpuv0 ) ).rgb;
				fixed3 bump2 = UnpackNormal( tex2D( _BumpMap, i.bumpuv1 ) ).rgb;
				half3 bump = ( bump1 + bump2 ) * 0.5;				
				fixed fresnelFac = dot( V, bump );
				half3 refr = tex2D( _BaseTex, i.tiling + ( bump * _RefrDistort ) ).rgb * _RefrColor.rgb;
				fixed4 color;
				fixed4 water = tex2D( _ReflectiveColorTex, fixed2( fresnelFac, fresnelFac ) );
				color = fixed4( lerp( water.rgb * refr, _HorizonColor.rgb, water.a ), _HorizonColor.a );
				GONBEST_APPLY_FOG( i, color );
				float shadow = GONBEST_DECODE_SHADOW_VALUE(i,i.wpos);
				color *= i.color;
				color.rgb *= lerp(1,shadow,color.a);
				return color;
			}
			ENDCG
		}
	}
}
