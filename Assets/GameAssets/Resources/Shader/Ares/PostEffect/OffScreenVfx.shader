/*
Author:gzg
Date:2021-10-08
Desc:一个子纹理合并到主纹理上
*/
Shader "Hidden/Ares/PostEffect/OffScreenVfx"
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
		sampler2D _OffScreenTex;		
		float4 _OffScreenTex_ST;
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

        //通用的纹理拷贝blend
		fixed4 frag1(v2f i) : SV_Target
		{
			fixed4 mcol = tex2D(_MainTex, i.uv0);			
			fixed4 ocol = tex2D(_OffScreenTex, i.uv0);
			mcol.rgb = mcol.rgb * ocol.a  + ocol.rgb;			
			return mcol;
		}
		//通用的纹理拷贝--add
		fixed4 frag2(v2f i) : SV_Target
		{
			fixed4 mcol = tex2D(_MainTex, i.uv0);			
			fixed4 ocol = tex2D(_OffScreenTex, i.uv0);
			mcol.rgb = mcol.rgb  + ocol.rgb;
			return mcol;
		}
		//通用的纹理拷贝--skill
		fixed4 frag3(v2f i) : SV_Target
		{
			fixed4 mcol = tex2D(_MainTex, i.uv0);			
			fixed4 ocol = tex2D(_OffScreenTex, i.uv0);
			mcol.rgb = mcol.rgb  + ocol.rgb * (1-mcol.rgb);
			return mcol;
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
        {//blend
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag1
            ENDCG
        }
		Pass
        {//add
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag2
            ENDCG
        }
		Pass
        {//skill
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag3
            ENDCG
        }
    }
}
