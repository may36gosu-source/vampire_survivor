/*
Author:gzg
Date:2019-08-20
Desc:这个Shader是用于让图片灰色化处理,垂直变灰,水平变灰,
*/
Shader "Ares/UI/GrayEffect" 
{
	Properties 
	{
		_Color("BaseColor",Color) = (1,1,1,1)
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_GrayParam ("Area(x=>H,y=>V,z=>D)", Vector) = (1,1,0,0)
	}
	SubShader 
	{
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		Pass
		{
			ZWrite Off
			Blend SrcAlpha OneMinusSrcAlpha,Zero OneMinusSrcAlpha
			
			CGPROGRAM			
			#pragma vertex vert
			#pragma fragment frag
			
			#include "unityCG.cginc"

			uniform sampler2D _MainTex;
			uniform float4 _MainTex_ST;
			uniform float4 _GrayParam;

			struct INVert
			{
				float4 vertex :POSITION;
				float2 texcoord : TEXCOORD0;
			};

			struct VToF
			{
				float4 pos: POSITION;
				float2 uv : TEXCOORD0;			
			};

			VToF vert(INVert v)
			{
				VToF o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX( v.texcoord, _MainTex );
				return o;
			}

			fixed4 frag(VToF vf):COLOR
			{					
				fixed4 mainTex = tex2D(_MainTex,vf.uv);								
				fixed coef = step(vf.uv.x,_GrayParam.x) * step(vf.uv.y,_GrayParam.y);
				fixed d = step(0,_GrayParam.z);
				coef = coef * d + (1-coef) * (1-d);
				fixed grey = dot(mainTex.rgb, fixed3(0.299, 0.587, 0.114)); 
				mainTex.rgb = mainTex.rgb * coef + fixed3(grey,grey,grey)*(1-coef);
				return  mainTex;
			}

			ENDCG
		}		
	} 
	FallBack "Gonbest/FallBack/FBNothing"
}