Shader "Ares/Water/WaterComplex_AlphaBlend"
{
	Properties
	{
		_WaterTex ("Normal Map (RGB), Foam (A)", 2D) = "white" {}
		_ReflectionTex ("Reflection", 2D) = "white" { }		
		_Color0 ("Shallow Color", Color) = (1,1,1,1)
		_Color1 ("Deep Color", Color) = (0,0,0,0)
		_Specular("Specular", float) = 1.86
		_Shininess ("Shininess", Range(0.01, 1.0)) = 1.0
		_TilingScale ("Tiling", Range(0.025, 0.25)) = 0.25
		_ReflectionTint ("Reflection Tint", Range(0.0, 1.0)) = 0.8
		_InvRanges ("Inverse Alpha, Depth and Color ranges", Vector) = (1.0, 0.17, 0.17, 0.0)
		_LightPos ("LightPos", Vector) = (0,0,0,0)
		_Steps("Steps of toon",range(0,9)) = 3//色阶层数
		_ToonEffect("Toon Effect",range(0,1)) = 0.5//卡通化程度
	    _Gloss("Gloss", float) = 0.71
		_SpecularColor("SpecColor", Color) = (1, 1, 1, 1)
		_BloomTex ("BloomTex", 2D) = "(0.5,0.5,0.5,0.5)" {}
		_BloomFactor("BloomFactor", float) = 0
	}

	SubShader
	{
		Tags { "Queue" = "Transparent"  "GonbestBloomType"="BloomMask"}
		Lod 200
	    Pass{
		

	    Blend SrcAlpha OneMinusSrcAlpha,Zero OneMinusSrcAlpha
		ZTest LEqual
		ZWrite Off


		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag	
		#include "UnityCG.cginc"
		#include "../Gonbest/Include/Base/MathCG.cginc"
	
	    half4 _Color0;
	    half4 _Color1;
		float _Specular;
	    float _Shininess;
	    float _TilingScale;
	    float _ReflectionTint;
	    half4 _InvRanges;
		float4 _LightPos;
		float _Steps;
		float _ToonEffect;
		float _Gloss;
		half4 _SpecularColor;
	
		sampler2D _WaterTex;
		sampler2D _ReflectionTex;

	    struct v2f {
		   float4 pos : POSITION;
		   half2 uv : TEXCOORD0;
		   float3 nl:TEXCOORD1;
		   float3 lightDir:TEXCOORD2;
		   float4 color : TEXCOORD3;

			float4 worldPos  : TEXCOORD4;	// Used to calculate the texture UVs and world view vector
			float4 proj0   	 : TEXCOORD5;	// Used for depth and reflection textures
			float4 texcoord  : TEXCOORD7;
			float3 viewDir: TEXCOORD8;
	    };

	    v2f vert( appdata_full v ) {
		   v2f o = ( v2f )0;
		   o.worldPos = mul(unity_ObjectToWorld,v.vertex);
		   o.uv.xy = v.texcoord.xy;
		   o.pos = UnityObjectToClipPos(v.vertex);
		   o.proj0 = ComputeScreenPos(o.pos);
		   COMPUTE_EYEDEPTH(o.proj0.z);
		
		   //o.proj1 = o.proj0;
		   //#if UNITY_UV_STARTS_AT_TOP
		   //o.proj1.y = (o.pos.w - o.pos.y) * 0.5;
		   o.texcoord = v.texcoord ;
		   float3 normal = v.normal;
           float3 tangent = v.tangent;
           float3 binormal= cross(v.normal,v.tangent.xyz) * v.tangent.w;
		   float3x3 Object2TangentMatrix = float3x3(tangent,binormal,normal);
		   o.lightDir = mul(Object2TangentMatrix, (mul(unity_WorldToObject,_LightPos) - v.vertex).xyz);//ObjSpaceLightDir(v.vertex));
		   o.color = v.color;
		   o.viewDir = mul(Object2TangentMatrix, ObjSpaceViewDir(v.vertex));
		   //#endif	
		   return o;
	    }
	
	    fixed4 frag( v2f i ) : COLOR {
		   float3 worldView = (i.worldPos.xyz - _WorldSpaceCameraPos);
		   worldView = GBNormalizeSafe(worldView);
		   float offset = _Time.x * 0.5;
		   half2 tiling = i.worldPos.xz * _TilingScale;
		   half4 nmap = (tex2D(_WaterTex, tiling + offset) + tex2D(_WaterTex, half2(-tiling.y, tiling.x) - offset)) * 0.5;
		   i.nl = nmap.xyz * 2.0 - 1.0;
		   half3 worldNormal = i.nl.xzy;
		   worldNormal.z = -worldNormal.z;
		
		
			// Calculate the depth ranges (X = Alpha, Y = Color Depth)
		   half3 ranges = saturate(_InvRanges.xyz );//saturate(_InvRanges.xyz * depth);
		   ranges.y = 1.0 - ranges.y;
		   ranges.y = lerp(ranges.y, ranges.y * ranges.y * ranges.y, 0.5);
		
			// Calculate the color tint
		   fixed4 col;
		   col.rgb = lerp(_Color1.rgb, _Color0.rgb, ranges.y);
		   col.a = ranges.x;
			
		   nmap.a = col.a;
		   //i.Gloss = _Shininess;

			half fresnel = sqrt(1-dot(-GBNormalizeSafe(worldView), GBNormalizeSafe(worldNormal)) * 0.5);
			
			// High-quality reflection uses the dynamic reflection texture
			i.proj0.xy += i.nl.xy * 0.5;
			i.texcoord.xy +=i.nl.xy * 0.05;
			half3 reflection = tex2Dproj(_ReflectionTex, i.texcoord).rgb; 
			reflection = lerp(reflection * col.rgb, reflection, fresnel * _ReflectionTint);

			// The amount of foam added (35% of intensity so it's subtle)
			half foam = nmap.a * (1.0 - abs(col.a * 2.0 - 1.0)) * 0.35;

			// Always assume 20% reflection right off the bat, and make the fresnel fade out slower so there is more refraction overall
			fresnel *= fresnel * fresnel;
			fresnel = (0.8 * fresnel + 0.2) * col.a;

			// Calculate the initial material color
			nmap.rgb = lerp(half3(0.8, 0.8, 0.8), reflection, fresnel) + half3(foam, foam, foam);
		
			// Calculate the amount of illumination that the pixel has received already
			// Foam is counted at 50% to make it more visible at night
			fresnel = min(1.0, fresnel + foam * 0.5);
			//o.Emission = o.Albedo * (1.0 - fresnel);
		
			// Set the final color
			//nmap.rgb = fresnel * nmap.rgb;
			//卡通高光
			float dist = length(i.lightDir);//求出距离光源的距离
			i.viewDir = GBNormalizeSafe(i.viewDir);
			i.lightDir = GBNormalizeSafe(i.lightDir);
			i.nl = GBNormalizeSafe(i.nl);
			//float atten = 1 / (dist);//根据距光源的距离求出衰减
			half3 halfVector = GBNormalizeSafe(i.lightDir + i.viewDir);
			float diffFactor = max(0, dot(i.lightDir, i.nl)) * 0.8f + 0.2f;
			diffFactor = (diffFactor + 1) / 2;
			diffFactor = smoothstep(0, 1, diffFactor);
			float toon = floor(diffFactor*_Steps) / _Steps;	
			diffFactor = lerp(diffFactor, toon, _ToonEffect);
			float nh = max(0, dot(halfVector, i.nl));
			float spec = pow(nh, _Specular * 128.0f) * _Gloss;
			float toonSpec = floor(spec * 2) / 2;//把高光也离散化
			spec = lerp(spec, toonSpec, _ToonEffect);//调节卡通与现实高光的比重
			fixed4 c;
			c.rgb = (nmap.rgb *diffFactor + _SpecularColor.rgb * spec);//* (atten * 2);
			//c.rgb = (nmap.rgb * (diffFactor + spec * _SpecularColor.rgb));
			c.a = i.color.a;
			return c;
	    }
		ENDCG
		}		
	}
	SubShader
	{
		//LOD 100
		Pass{
			ColorMask 0
			ZWrite Off
		}
	}
}
