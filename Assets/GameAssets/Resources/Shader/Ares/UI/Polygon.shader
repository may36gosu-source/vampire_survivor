//画多边形 -- 暂时定义最大6个点
/*
Author:gzg
Date:2019-08-20
Desc:通过传入的最大6个点,形成一个多边形.
*/
Shader "Ares/UI/Polygon"
{
	Properties
	{
		//这个纹理不使用,增加他的原因是:NGUI的老是访问Material.mainTexture,并报错.尴尬.
		_MainTex ("Not use tex", 2D) = "white"{}
		_InnColor ("InnColor", Color) = (0,0.5,0.5,1)
		_OutColor ("OutColor", Color) = (0,1,1,1)
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
			float2 uv : TEXCOORD0;		
			float4 vertex : SV_POSITION;
		};
		
		//主纹理
		//uniform sampler2D _MainTex;
		//内部颜色
		uniform float4 _InnColor;
		//外部颜色
		uniform float4 _OutColor;	
		
		/*--- 外部动态传入  begin---*/
		//当前多边形的点数 
		uniform float _PointCount;
		//多边形的点,顺时针给出 区间[-0.5,0.5]--这里设定最大6个点,以后可以扩充,这里使用float4,有点尴尬,因为外部只有SetVectorArray("",Vector4[]).为了方便才这样设定
		uniform float4 _PolyPoints[6];		
		/*--- 外部动态传入 end ---*/
		
		//基本算法是:判断一个点是否在6个点连线的内部.
		//也就是判断某个点在某条线段的那一侧.
		//把六条线都判断一遍,就能得出一个六边形
		fixed checkpoint(int i, int j, fixed c, float2 p)
		{
		    //判断当前线段是否有效--如果当前点已经大于有效的point值索引,那么表示已经是无效点了.
		    fixed valid = step(i,_PointCount-1);
			//判定是否在点的y值是否在两个顶点之间,
			fixed cy = abs(step(p.y,_PolyPoints[i].y) - step(p.y,_PolyPoints[j].y));			
			//求两个点连线的斜率k
			float2 ab = _PolyPoints[j] - _PolyPoints[i];			
			float k = ab.x/ab.y;
			//求点的y值,在此斜率下的x值.
			float zx = (p.y-_PolyPoints[i].y)*k + _PolyPoints[i].x;
			//判断求出的x值是否大于点的x值.
			fixed cx = step(p.x,zx);			
			//如果zx大于p.x,并且y在两点中间,那么c=!c
			return abs(cx*cy*valid - c);
		}
		
		
		v2f vert (appdata v)
		{
			v2f o;
			o.vertex = UnityObjectToClipPos(v.vertex);
			o.uv = v.uv;
			return o;
		}
		
		fixed4 frag (v2f i) : COLOR
		{
			//float4 texCol = tex2D(_MainTex,i.uv);
			float2 p = i.uv-0.5;
			fixed4 finalCol = lerp(_InnColor,_OutColor,length(p));
			fixed c =checkpoint(0,_PointCount - 1,0,p);
			c =checkpoint(1,0,c,p);
			c =checkpoint(2,1,c,p);
			c =checkpoint(3,2,c,p);
			c =checkpoint(4,3,c,p);
			c =checkpoint(5,4,c,p);
			finalCol.a *= c ;
			return finalCol;
		}
	ENDCG
	
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		//LOD 100
		ZWrite Off
		Blend SrcAlpha OneMinusSrcAlpha,Zero OneMinusSrcAlpha
		
		Pass
		{
			CGPROGRAM			
			#pragma vertex vert
			#pragma fragment frag		
			#pragma fragmentoption ARB_precision_hint_fastest						
			ENDCG
		}
	}	
	FallBack "Gonbest/FallBack/FBNothing"
}
