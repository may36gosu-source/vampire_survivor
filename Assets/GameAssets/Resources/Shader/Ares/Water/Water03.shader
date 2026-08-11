/*
一个湖水效果
*/
Shader "Ares/Water/Water03"
{
    Properties
    {
        _BaseColor ("基础颜色", Color) = (0.234,0.605,0.676,1)
        _BumpMap ("法线贴图", 2D) = "white" {}
        _BumpTiling ("法线图平铺信息", Vector) = (0.15,0.15,0.3,0.3)
        _BumpDirection ("法线图的方向", Vector) = (10,-10,-2,10)        
        _ShoreTex ("流动波光纹理", 2D) = "white" {}      
        _TransparentScale ("透明度", Range(0,1)) = 0.42
        _SimRefractionColor ("折射的颜色", Color) = (0.2,0.2,0.2,0.4)
        _ReflectionColor ("反射的颜色", Color) = (0.219,0.258,0.419,1) 
        _SpecBumpScale ("高光法线比例", Range(0,2)) = 0.810
        _Shininess ("高光范围", float) = 500
        _SpecularColor ("高光颜色", Color) = (0.722,0.875,0.859,1.0)        
        _SpecularIntensity ("高光强度", Range(0,10)) = 5                        
        _FresnelBumpScale ("菲尼尔法线比例", Range(0,4)) = 0.810
        _FresnelPower ("菲尼尔光线范围", float) = 0.2
        _FresnelStrength ("菲尼尔值", Range(0,1)) = 1
        _FoamValue ("流动波光强度", Range(0,1)) = 0
    }
    SubShader
    {
        Tags { "Queue" = "Transparent"  "GonbestBloomType"="BloomMask"}
        LOD 100

        Pass
        {
           
            Tags { "LightMode" = "ForwardBase" }	
            ZWrite Off
            Blend One One,Zero OneMinusSrcAlpha
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
           // #pragma multi_compile_fog            

            #include "UnityCG.cginc"
            #include "../Gonbest/Include/Base/MathCG.cginc"
            #include "../Gonbest/Include/Base/NormalCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float4 color:COLOR;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float4 uv :TEXCOORD0;               
                float3 wv : TEXCOORD1;   
                float4 vcolor:TEXCOORD2;          
                UNITY_FOG_COORDS(3)
            };

            sampler2D _BumpMap;            
            sampler2D _ShoreTex;                    
            uniform float4 _BumpTiling ;
            uniform float4 _BumpDirection;            
            uniform float _TransparentScale;
            uniform float4 _SimRefractionColor;
            uniform float4 _SpecularColor;
            uniform float _SpecularIntensity;
            uniform float4 _BaseColor;
            uniform float4 _ReflectionColor;
            
            uniform float _Shininess;                      
            uniform float _SpecBumpScale;
            uniform float _FresnelStrength;
            uniform float _FresnelBumpScale;
            uniform float _FresnelPower;
            uniform float _FoamValue;            
         
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);                
                float4 wpos = mul(unity_ObjectToWorld,v.vertex);
                o.wv.xyz = _WorldSpaceCameraPos.xyz - wpos.xyz;               
                o.uv =  ((_Time.xxxx * _BumpDirection) + wpos.xzxz) * _BumpTiling;        
                o.vcolor = v.color;      
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                //法线
                float3 N1 = GBUnpackScaleNormal(tex2D(_BumpMap,i.uv.xy),1);
                float3 N2 = GBUnpackScaleNormal(tex2D(_BumpMap,i.uv.zw),1);
                float3 N = GBBlendNormals(N1,N2) ;
                N *= _SpecBumpScale;
                N.z = N.y;
                N.y = 1;
                N = GBNormalizeSafe(N);

                //视线
                float3 V = GBNormalizeSafe(i.wv.xyz);
                //这里不做GBNormalizeSafe,主要是为了让光线拉出来
                float3 L = GBNormalizeSafe(_WorldSpaceLightPos0.xyz) ;//_WorldLightDir.xyz;
                //H
                float3 H = GBNormalizeSafe(V  + L);
                //高光
                float spec = pow(max(dot(N,H),0),_Shininess);
                float3 specColor = _SpecularColor.xyz * spec * _SpecularIntensity;
                
                //菲尼尔
                float3 FN = N;
                FN.xz *= _FresnelBumpScale;
                float F = pow(max(0, 1 - max(0,dot(V , FN))),_FresnelPower);
                F = lerp(1, F ,_FresnelStrength);

                //反射的颜色
                float3 refColor = lerp(_SimRefractionColor.xyz,_ReflectionColor.xyz,_ReflectionColor.w);

                //基础颜色
                float4 baseColor = _BaseColor ;//- _InvFadeParemeter.w * float4(0.15, 0.03, 0.01, 0.0);
                baseColor.xyz = lerp(_SimRefractionColor.xyz, baseColor.xyz, baseColor.w);

                //波光
                float4 uv2 = i.uv + i.uv;
                float3 flowColor = (tex2D(_ShoreTex, uv2.xy).xyz * tex2D(_ShoreTex, uv2.zw).xyz) - 0.125;
                flowColor = flowColor * _FoamValue;

                //最终颜色
                float3 fcolor = lerp(baseColor.xyz,refColor.xyz,F);    
                fcolor += specColor;
                fcolor.xyz += flowColor.xyz ;
                float a = _TransparentScale * i.vcolor.a;
                fcolor.xyz *= a;
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, fcolor);
                return float4(fcolor,a);
            }
            ENDCG
        }
    }
}
