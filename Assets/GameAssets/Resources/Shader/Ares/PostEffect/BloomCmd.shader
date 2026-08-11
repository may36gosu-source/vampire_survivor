/*
Author:gzg
Date:2021-08-23
Desc:Bloom处理
*/
Shader "Hidden/Ares/PostEffect/BloomCmd"
{
	CGINCLUDE
		#include "UnityCG.cginc"
		struct appdata
		{
			float4 vertex : POSITION;
			float2 uv : TEXCOORD0;
		};

		struct v2f
		{
			float2 uv0 : TEXCOORD0;
			float4 vertex : SV_POSITION;
			float4 uv1 : TEXCOORD1;
			float4 uv2 : TEXCOORD2;
			float4 uv3 : TEXCOORD3;
		};


		//常量定义
		//gauss -- 高斯卷积核
		static const half curve[4] = { 0.324, 0.232, 0.0855, 0.0205 }; 
		//box -- 盒式卷积核 
		//static const half curve[4] = { 0.142857, 0.142857, 0.142857, 0.142857 }; 

		sampler2D _MainTex;		
		float4 _MainTex_ST;
		float4 _MainTex_TexelSize;

		sampler2D _BloomTex;
		float4 _BloomTex_ST;
		float4 _Params;
		float4 _Threshold;
		
        //基本
		v2f vertbase(appdata v)
		{
			v2f o = (v2f)0;
			o.vertex = v.vertex;
			o.uv0 = v.uv;			
		#if defined(UNITY_UV_STARTS_AT_TOP)
			o.uv0 = o.uv0 * float2(1, -1) + float2(0, 1);
		#endif
		    o.uv1 = _Threshold;
			o.uv2 = _Params;
			return o;
		}

        //水平采样
		v2f vertHorizontal(appdata v)
		{
			v2f o = (v2f)0;
			o.vertex = v.vertex;
			o.uv0 = v.uv;			
		#if defined(UNITY_UV_STARTS_AT_TOP)
			o.uv0 = o.uv0 * float2(1, -1) + float2(0, 1);
		#endif
			float t = _MainTex_TexelSize.x*_Params.x;
			float4 offset = float4(t,0,-t,0);
			o.uv1 = o.uv0.xyxy + offset;
			o.uv2 = o.uv1 + offset;
			o.uv3 = o.uv2 + offset;
			return o;
		}

        //列采样
		v2f vertVertical(appdata v)
		{
			v2f o = (v2f)0;
			o.vertex = v.vertex;
			o.uv0 = v.uv;			
		#if defined(UNITY_UV_STARTS_AT_TOP)
			o.uv0 = o.uv0 * float2(1, -1) + float2(0, 1);
		#endif
			float t = _MainTex_TexelSize.y*_Params.y;
			float4 offset = float4(0,t,0,-t);
			o.uv1 = o.uv0.xyxy + offset;
			o.uv2 = o.uv1 + offset;
			o.uv3 = o.uv2 + offset;
			return o;
		}
		

		//复制Color.HLSL中的方法,把纹理亮度修改为alpha
		// curve = (threshold - knee, knee * 2, 0.25 / knee)
		half4 QuadraticThreshold(half4 color, half threshold, half3 curve)
		{
			// Pixel brightness
			half br = color.a;

			// Under-threshold part: quadratic curve
			half rq = clamp(br - curve.x, 0.0, curve.y);
			rq = curve.z * rq * rq;

			// Combine and apply the brightness response curve.
			color *= max(rq, br - threshold) / max(br, 0.00001);

			return color;
		}

		//阈值过滤
		fixed4 fragfilter(v2f i) : SV_Target
		{
			fixed4 col = tex2D(_MainTex, i.uv0);						
			return QuadraticThreshold(col,i.uv1.x,i.uv1.yzw);
		}
		//模糊采样
		fixed4 frag(v2f i) : SV_Target
		{
			
			fixed4 col = tex2D(_MainTex, i.uv0) * curve[0];
			col += tex2D(_MainTex, i.uv1.xy) * curve[1];
			col += tex2D(_MainTex, i.uv1.zw) * curve[1];
			col += tex2D(_MainTex, i.uv2.xy) * curve[2];
			col += tex2D(_MainTex, i.uv2.zw) * curve[2];
			col += tex2D(_MainTex, i.uv3.xy) * curve[3];
			col += tex2D(_MainTex, i.uv3.zw) * curve[3];						
			return col;
		}

        //通用的纹理拷贝
		fixed4 fragblit(v2f i) : SV_Target
		{
			fixed4 col = tex2D(_MainTex, i.uv0);			
			return col;
		}

		//组合两个纹理
		fixed4 fragcom(v2f i) : SV_Target
		{
			fixed4 col1 = tex2D(_MainTex, i.uv0);
			fixed4 col2 = tex2D(_BloomTex, i.uv0) * i.uv2.z;
			return col1 + col2;
		}
	ENDCG
    SubShader
    {
		ZWrite Off
        ZTest Always
		Cull Off
		Fog { Mode off }
  		Pass
        {
            //0-过滤
            CGPROGRAM
            #pragma vertex vertbase
            #pragma fragment fragfilter
            ENDCG
        }

        Pass
        {
            //1-水平采样
            CGPROGRAM
            #pragma vertex vertHorizontal
            #pragma fragment frag
            ENDCG
        }

		Pass
		{
            //2-垂直采样
			CGPROGRAM
			#pragma vertex vertVertical
			#pragma fragment frag
			ENDCG
		}
	

		Pass
		{
            //3-blit
			CGPROGRAM
			#pragma vertex vertbase
			#pragma fragment fragblit
			ENDCG
		}

			
		Pass
		{
            //4-组合
			CGPROGRAM
			#pragma vertex vertbase
			#pragma fragment fragcom
			ENDCG
		}
    }
}
