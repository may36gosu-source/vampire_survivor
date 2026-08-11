/*
Author:gzg
Date:2019-08-20
Desc:这个Shader是用于让图片某一块进行镂空处理,在系统中主要用于向导遮挡镂空处理.
*/
Shader "Ares/UI/HollowClip" 
{
	Properties 
	{
		_Color("BaseColor",Color) = (0,0,0,0.5)
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Rect ("(Left,Bottom,Right,Top)", Vector) = (0.3,0.1,0.6,0.6)
	}
	SubShader 
	{
		Tags { "RenderType" = "Opaque" "Queue" = "Transparent"}        
		LOD 100		
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
			uniform float4 _Rect;
			uniform float4 _Color;

			struct appdata
			{
				float4 vertex :POSITION;
				half4 color : COLOR;
				float2 texcoord : TEXCOORD0;
			};

			struct v2f
			{
				float4 pos: POSITION;
				half4 color : COLOR;
				float2 uv : TEXCOORD0;
			};

			v2f vert(appdata v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.color = v.color;
				o.uv = TRANSFORM_TEX( v.texcoord, _MainTex );
				return o;
			}

			fixed4 frag(v2f vf):COLOR
			{					
				float4 cr = tex2D(_MainTex,vf.uv)*_Color;				
				float2 tt = float2((vf.uv.x - _Rect.x) * (vf.uv.x - _Rect.z),(vf.uv.y - _Rect.y) * (vf.uv.y - _Rect.w));
				cr.a = saturate(step(0,tt.x) + step(0,tt.y)) * cr.a * vf.color.a;
				return cr;
			}

			ENDCG
		}		
	} 
	FallBack "Gonbest/FallBack/FBNothing"
}
