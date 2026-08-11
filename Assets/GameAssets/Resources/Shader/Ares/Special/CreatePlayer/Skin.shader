/*
Author:gzg
Date:2019-09-12
Desc:Create skins for character scenes
*/
Shader "Ares/Special/CreatePlayer/Skin"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _SquareFactor("SquareFactor",Range(0,1))=1
        _LutTex ("Lut", 2D) = "white" {}
        _PRB_Metallic("Metallic",Range(0,1)) = 1
        _PBR_Roughness("Roughness",Range(0.08,1)) = 0.1
        _EyeAdaptionLevel("_EyeAdaptionLevel",Range(0,10))=1.005
		_HDRMax("_HDRMax",Range(0,2))=2
		_HDRMin("_HDRMin",Range(0,0.5))=0.3		
		[HDR]_HDRColor("_HDRColor",Color)=(1.6,1.496,1.463,1)     
        _PointLightColor("_PointLightColor",Color) = (0,0,0,0)
        _PointLightPos("_PointLightPos",Vector) = (0,0,0,0) 
        _EmissiveFactor("EmissiveFactor",Range(0,1)) =1
        _ShadowDepthBias("_ShadowDepthBias",Range(0,0.005)) = 0.001

    }
    CGINCLUDE

        #include "../../Gonbest/Include/Base/CommonCG.cginc"
        #include "../../Gonbest/Include/Base/MathCG.cginc"
        #include "../../Gonbest/Include/Specular/GGXCG.cginc"
        #include "../../Gonbest/Include/Diffuse/LambertCG.cginc"
        #include "../../Gonbest/Include/Base/FresnelCG.cginc"  
        #include "../../Gonbest/Include/Shadow/ShadowCG.cginc" 
        #include "../../Gonbest/Include//Base/EnergyCG.cginc"     

        struct v2f
        {
            float4 vertex : SV_POSITION;
            float2 uv : TEXCOORD0;                
            float3 wn : TEXCOORD1;                
            float4 wp : TEXCOORD2;
            GONBEST_SHADOW_COORDS(3)
            
        };

        sampler2D _MainTex;
        sampler2D _LutTex;
        float4 _MainTex_ST;
        uniform float _PBR_Roughness;
        uniform float _PRB_Metallic;
        float _EyeAdaptionLevel;            
        float3 _HDRColor;                  
        float _HDRMin;                     
        float _HDRMax;                     
        float _SquareFactor;
        float _EmissiveFactor;

        v2f vert (appdata_full v)
        {
            v2f o;
            o.wp = mul(unity_ObjectToWorld,v.vertex).xyzw;
            o.vertex = mul(UNITY_MATRIX_VP,o.wp);
            o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
            o.wn = GBNormalizeSafe(mul(v.normal.xyz,(float3x3)unity_WorldToObject));
             //阴影处理
			GONBEST_TRANSFER_SHADOW_WPOS(o,o.wp,v.texcoord1);		
            return o;
        }

        fixed4 frag (v2f i) : SV_Target
        {
            // sample the texture
            fixed4 col = tex2D(_MainTex, i.uv); 
            col =lerp(col,col*col,_SquareFactor);

            float4 P = i.wp;
            float3 V = GBNormalizeSafe(_WorldSpaceCameraPos.xyz - i.wp.xyz);
            float3 L = V;//GBNormalizeSafe(_WorldSpaceLightPos0.xyz);
            float3 N = GBNormalizeSafe(i.wn);
            float3 H = GBNormalizeSafe(V+L);
            float3 LoVRaw = dot(L,V);
            float3 NoVRaw = dot(N,V);

            float NoLRaw = dot(N,L);
            float NoL = saturate(NoLRaw);
            

            float rim = abs(saturate(((1.0 - NoVRaw) -  0.5)/ 0.5));
            rim *=rim;
            float3 rimColor = rim* float3(0.64,0.41,0.3)* dot(N,float3(1,1,0)) ;
            float3 EmissColor =(saturate(1- dot(-L,N)) * 0.1 * col.xyz ) * _EmissiveFactor ;               

            float NoL01 = NoLRaw *0.5 + 0.5;
            float2 lutuv1 =  float2(NoL01,0);
            float3 sss_lut = tex2D(_LutTex,lutuv1);
            sss_lut *= sss_lut;

            float3 specColor = lerp(float3(0.04,0.04,0.04),col,_PRB_Metallic);

            float _InvLenH = rsqrt((2.0 + (2.0 * LoVRaw)));
            float NoH =  saturate((NoLRaw + NoVRaw) * _InvLenH);
            float VoH = saturate(_InvLenH + (_InvLenH * LoVRaw));               
            float NoV = saturate(abs(NoVRaw));
            float3 F = GBFresnelTermFastWithSpecGreen(specColor,NoH);
            float D = GBGGXTerm(NoH,_PBR_Roughness);
            float Vis = 1;//GBSmithJointGGXVisibilityTerm(NoV,NoL,_PBR_Roughness);              
            float3 spec = F*D*Vis ;
            float3 sun = saturate(col.xyz + spec );
            sun *= sss_lut + col.xyz * saturate(1-dot(L,N)) * 0.3;                 
            
            float lum = 0.168;// tex2D(_LumTex,i.uv.xy).x;
            lum*= _EyeAdaptionLevel;
            lum = min(max(lum,_HDRMin),_HDRMax);	

            sun *= _HDRColor;
            sun *= 0.25;
            sun /= lum;
            sun = sun*(sun * 2.51 + 0.03)/(sun * (sun * 2.43 + 0.59) + 0.14);
            sun = sqrt(sun);
            
            col.xyz = sun + EmissColor;

           //阴影处理	
			//float shadow = GONBEST_DECODE_SHADOW_VALUE_DEPTH(i,P);
            //shadow = saturate(shadow * max(0,dot(N,L)) + 0.1);
            //col.xyz *= lerp(0.6,1,shadow);
            #if defined(_GONBEST_SPEC_ALPHA_ON)
				col.a = GBLuminance(EmissColor);
			#endif 
            return col;
            
        }
    ENDCG
    SubShader
    {
        Tags {"LightMode" = "ForwardBase" "RenderType"="Opaque" "Queue" = "Geometry"}
        LOD 100
        Pass
        {   				
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag    
            //#pragma multi_compile _GONBEST_SHADOW_ON _GONBEST_SHADOW_OFF
            //#pragma multi_compile _GONBEST_CUSTOM_SHADOW_ON  
            #pragma multi_compile _GONBEST_SPEC_ALPHA_ON    
            ENDCG
        }
    }
    Fallback "Gonbest/FallBack/FBWithShadow"
}
