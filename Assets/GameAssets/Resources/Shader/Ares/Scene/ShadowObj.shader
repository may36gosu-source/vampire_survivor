Shader "Ares/Scene/ShadowObj"
{
	Properties
	{		
		_MainTex ("Base (RGB)", 2D) = "white" {}	
	}
	SubShader
	{
		Tags { "RenderType" = "ShadowMesh"}  
		Pass
		{			
			Blend SrcAlpha OneMinusSrcAlpha,Zero OneMinusSrcAlpha

			ZTest LEqual
			ZWrite Off			
			Cull Back
			Lighting Off
			Fog {Mode Off}

			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest
			#include "UnityCG.cginc"
			uniform sampler2D _MainTex;	
			uniform half4 _MainTex_ST; 				

			struct vertexdata
			{
				float4 vertex : POSITION;
				half4 texcoord : TEXCOORD0;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				half2 uv: TEXCOORD0;
			};

			v2f vert( vertexdata v )
			{
				v2f o = (v2f)0;
				o.pos = UnityObjectToClipPos( v.vertex );				
				o.uv = TRANSFORM_TEX( v.texcoord, _MainTex );
				return o;
			}

			fixed4 frag(v2f i) : COLOR
			{
				fixed4 c = tex2D(_MainTex,i.uv);								
				return fixed4(0,0,0, c.r);
			}
			ENDCG
		}
	}
}