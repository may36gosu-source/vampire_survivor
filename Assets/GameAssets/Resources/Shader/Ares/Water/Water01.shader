
/*
一个水的效果,这个主要用于大海等比较大的水域.并且海水的透明度也是根据视线改变.
这个需要的透明度也需要使用顶点颜色来处理
*/
Shader "Ares/Water/Water01"
{
    Properties
    {
        _Color("_Color",Color) = (0,0.05,0.03,1)
        _MainTex ("Base Texture", 2D) = "white" {}        
		_BumpMap("Normal Map",2D) = "black"{}		
		_EnvCube("Cube Map", Cube) = "grey" {}
        _EnvPower("Cube Map Power", Range(-2,2)) = 1
        _WaterSpeed("WaterSpeed",Vector) = (0,0.02,0,-0.02)
        _Refraction("Refraction",Range(0,2)) = 0.6
        _FresnelPower("FresnelPower",float) = 0
        _Alpha ( "Transparent", Range( 0, 1 ) ) = 1 
    }
    SubShader
    {
        Tags { "Queue" = "Transparent"  "GonbestBloomType"="BloomMask"}
        LOD 100

        Pass
        {
            ZWrite Off
            Blend SrcAlpha OneMinusSrcAlpha,Zero OneMinusSrcAlpha
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"
            #include "../Gonbest/Include/Base/MathCG.cginc"
            #include "../Gonbest/Include/Base/NormalCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float4 uv : TEXCOORD0;
                float4 color:COLOR;                
                float3 normal:NORMAL;
                float4 tangent:TANGENT;
            };

            struct v2f
            {
                float4 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
                float4 wn:TEXCOORD2;
                float4 wt:TEXCOORD3;
                float4 wb:TEXCOORD4;
                float4 vcolor:TEXCOORD5;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;		
		    uniform sampler2D _BumpMap;	
            float4 _BumpMap_ST;					
		    uniform samplerCUBE _EnvCube;
            uniform float4 _WaterSpeed;
            uniform float _Refraction;
            uniform float4 _Color;
            uniform float _FresnelPower;
            uniform float _Alpha;
            uniform float _EnvPower;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                float3 wp = mul(unity_ObjectToWorld,v.vertex);
                o.wn.xyz = GBNormalizeSafe(mul(float4(v.normal,0),unity_WorldToObject).xyz);
                o.wt.xyz = GBNormalizeSafe(mul(unity_ObjectToWorld,float4(v.tangent.xyz,1)).xyz);
                o.wb.xyz = cross(o.wn.xyz,o.wt.xyz) * v.tangent.w;
                o.wt.w = wp.x;
                o.wb.w = wp.y;
                o.wn.w = wp.z;    
                o.vcolor = v.color;
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float4 uv = (_Time.yyyy * _WaterSpeed)  + TRANSFORM_TEX(i.uv,_BumpMap).xyxy;                
                float3 TN1 = GBUnpackScaleNormal(tex2D(_BumpMap, uv.zw),1);
                float3 TN2 = GBUnpackScaleNormal(tex2D(_BumpMap, uv.xy),1);
                float3 TN = GBNormalizeSafe(GBBlendNormals(TN1,TN2)); 
                float3 N = GBNormalizeSafe(TN.x * i.wt.xyz + TN.y*i.wb.xyz + TN.z*i.wn.xyz);
                float3 V = GBNormalizeSafe( _WorldSpaceCameraPos.xyz -float3(i.wt.w,i.wb.w,i.wn.w));
                float TNV = dot(V,N); //dot(V,TN);
                float3 R = GBNormalizeSafe(reflect(-V,N));
                float3 envColor = texCUBE(_EnvCube, R).xyz;
                float3 RefrColor= lerp(envColor,_Color,_Refraction);              
                float F = pow((1-TNV),_FresnelPower);
                float4 col = float4(0,0,0,0);
                col.xyz = lerp(RefrColor,_Color.xyz,TNV) + envColor * F;               
                float3 mainColor = tex2D(_MainTex, TRANSFORM_TEX(i.uv,_MainTex)).xyz;
                col.xyz = (mainColor * col.xyz) + envColor * _EnvPower;
                col.a = (1 - (1-_Alpha) * i.vcolor.a) * F;
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
