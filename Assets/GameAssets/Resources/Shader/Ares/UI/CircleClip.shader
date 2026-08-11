/*
Author:gzg
Date:2019-08-20
Desc:这个Shader是用于,主界面右上角圆形小地图处理
*/
Shader "Ares/UI/CircleClip" 
{
	Properties 
	{
		_Color("BaseColor",Color) = (1,1,1,1)
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Circle ("Center & Size", Vector) = (0.5,0.5,0.13,0.13)
		_Reverse("Is Reverse (0 or 1)", float) = 1
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
			uniform float4 _Circle;
			uniform float _Reverse;

			struct INVert
			{
				float4 vertex :POSITION;
				float2 texcoord : TEXCOORD0;
				float4 color : COLOR;
			};

			struct VToF
			{
				float4 pos: POSITION;
				float2 uv : TEXCOORD0;			
				float4 color : COLOR;
			};

			VToF vert(INVert v)
			{
				VToF o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.color = v.color;
				o.uv = TRANSFORM_TEX( v.texcoord, _MainTex );
				return o;
			}

			fixed4 frag(VToF vf):COLOR
			{					
				fixed4 cr = tex2D(_MainTex,vf.uv);				
				float2 tuv = vf.uv - _Circle.xy;				
				fixed a = abs(step(tuv.x*tuv.x / (_Circle.z *_Circle.z) +tuv.y*tuv.y / (_Circle.w * _Circle.w) ,1) * cr.a - _Reverse);
				return  fixed4(cr.rgb,a * vf.color.a);
			}

			ENDCG
		}		
	} 
	Fallback "Gonbest/FallBack/FBNothing"
}
