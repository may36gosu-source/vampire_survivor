/*
Author:gzg
Date:2021-09-10
Desc:模仿Blit的Shader
*/
Shader "Hidden/Ares/PostEffect/Blit"
{
    Properties
    {
      
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
		};
	
		sampler2D _MainTex;		
		float4 _MainTex_ST;
        //基本
		v2f vert(appdata v)
		{
			v2f o = (v2f)0;
			o.vertex = v.vertex;
			o.uv0 = v.uv;			
		#if defined(UNITY_UV_STARTS_AT_TOP)
			o.uv0 = o.uv0 * float2(1, -1) + float2(0, 1);
		#endif
			return o;
		}

        //通用的纹理拷贝
		fixed4 frag(v2f i) : SV_Target
		{
			fixed4 col = tex2D(_MainTex, i.uv0);			
			return col;
		}
	
	ENDCG
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100
		ZWrite Off
        ZTest Always
		Cull Off
  		Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            ENDCG
        }
    }
}
