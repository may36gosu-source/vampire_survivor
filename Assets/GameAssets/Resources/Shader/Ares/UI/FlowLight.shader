/*
Author:gzg
Date:2019-08-20
Desc:这个Shader是用于界面上图片有一道倾斜的流光扫过的效果.
*/
Shader "Ares/UI/FlowLight"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "black" {}	
		_FlowColor("Flow Light Color",Color)=(1,1,1,1)
		_FlowWidth("Flow Light Width",Range(0,10)) = 5
		_FlowSpeed("Flow Speed",Range(-5,5)) = 1
		_FlowPeriod("Flow Period",Range(1,5)) = 1
	}
	SubShader
	{
		Tags { "RenderType"="Transparent" }
		//LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
		

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				
				float4 vertex : SV_POSITION;
				float4 uv : TEXCOORD0;
			};

			sampler2D _MainTex;	
			float4 _FlowColor;
			float _FlowWidth;
			float _FlowSpeed;
			float _FlowPeriod;
			
			v2f vert (appdata v)
			{
				v2f o = (v2f)0;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv.xy = v.uv.xy;	
				o.uv.z = _FlowPeriod - frac(_Time.y *_FlowSpeed / _FlowPeriod) * _FlowPeriod * 2;
				o.uv.w =_FlowWidth;
				return o;
			}

			//在物体上生成一道流光闪过,右旋转30度
			//uv:是采样图片的uv值[0,1],offset:是用于移动的偏移,值在[0,1]
			inline half CalcFlowLight30(half2 uv, half offset, half width)
			{
				half2 fuv = uv - 0.5;        
				fuv.x = fuv.x + offset;
				half flow = abs(fuv.x * 0.88 - fuv.y*0.5); //近似30度
				flow *= width;
				flow = max(0 , lerp(1,0,flow));//flow的值必须是大于0
				return flow;
			}

			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				fixed4 finalColor = tex2D(_MainTex, i.uv.xy);
				
				half flow = CalcFlowLight30(i.uv.xy,i.uv.z,i.uv.w);
				
				finalColor = finalColor +  flow * _FlowColor ;
				return  float4(finalColor.xyz,0);
			}
			
		
			ENDCG
		}
	}
    Fallback "Gonbest/FallBack/FBNothing"
}
