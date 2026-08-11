/*
Author:gzg
Date:2021-08-23
Desc:盒式模糊
*/
Shader "Hidden/Ares/PostEffect/BoxBlur"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
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

		sampler2D _MainTex;
		float4 _MainTex_ST;
		float4 _MainTex_TexelSize;

		v2f vertHorizontal(appdata v)
		{
			v2f o;
			o.vertex = UnityObjectToClipPos(v.vertex);
			o.uv0 = TRANSFORM_TEX(v.uv, _MainTex);
			float t = _MainTex_TexelSize.x;
			float4 offset = float4(t,0,-t,0);
			o.uv1 = o.uv0.xyxy + offset;
			o.uv2 = o.uv1 + offset;
			o.uv3 = o.uv2 + offset;
			return o;
		}

		v2f vertVertical(appdata v)
		{
			v2f o;
			o.vertex = UnityObjectToClipPos(v.vertex);
			o.uv0 = TRANSFORM_TEX(v.uv, _MainTex);
			float t = _MainTex_TexelSize.y;
			float4 offset = float4(0,t,0,-t) ;
			o.uv1 = o.uv0.xyxy + offset;
			o.uv2 = o.uv1 + offset;
			o.uv3 = o.uv2 + offset;
			return o;
		}
		//gauss
		static const half curve[4] = { 0.324, 0.232, 0.0855, 0.0205 }; 
		//avg
		//static const half curve[4] = { 0.142857, 0.142857, 0.142857, 0.142857 }; 

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
	ENDCG
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            //0
            CGPROGRAM
            #pragma vertex vertHorizontal
            #pragma fragment frag
            ENDCG
        }

		Pass
		{
            //1
			CGPROGRAM
			#pragma vertex vertVertical
			#pragma fragment frag
			ENDCG
		}
    }
}
