
/*
Author:gzg
Date:2019-09-12
Desc:Create the body shader used by the character scene
*/
Shader "Ares/Special/CreatePlayer/Body"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _SquareFactor("SquareFactor",Range(0,1))=1
        _MaskTex ("MaskTex", 2D) = "white" {}
        _MetalTex ("MetalTex", 2D) = "white" {}
        _EnvCube("_EnvCube",Cube) ="white" {}
        _PRB_Metallic("Metallic",Range(0,1)) = 1        
        _PBR_Roughness("Roughness",Range(0.08,1)) = 0.1
        _EyeAdaptionLevel("_EyeAdaptionLevel",Range(0,10))=1.005
		_HDRMax("_HDRMax",Range(0,2))=2
		_HDRMin("_HDRMin",Range(0,0.5))=0.3		
		[HDR]_HDRColor("_HDRColor",Color)=(1.6,1.496,1.463,1)        
        _DayNightTimeRatio("DayNightTimeRatio",Range(0,1)) = 1
        _DayNightVector("_DayNightVector",Vector) = (0,0,0,0)        
        _Cutoff("_Cutoff",Range(0,1)) = 0.3
        _PointLightColor("_PointLightColor",Color) = (0,0,0,0)
        _PointLightPos("_PointLightPos",Vector) = (0,0,0,0)
        _EmissiveFactor("EmissiveFactor",Range(0,1)) = 1
        _BrightnessPower("Brightness", Range(0,2)) = 1
		_SaturationPower("Saturation", Range(0,2)) = 1
		_ContrastPower("Contrast", Range(0,2)) = 1
        _ShadowDepthBias("_ShadowDepthBias",Range(0,0.005)) = 0.001

    }
	CGINCLUDE

        #include "../../Gonbest/Include/Base/CommonCG.cginc"
        #include "../../Gonbest/Include/Base/MathCG.cginc"
        #include "../../Gonbest/Include/Specular/GGXCG.cginc"
        #include "../../Gonbest/Include/Diffuse/LambertCG.cginc"
        #include "../../Gonbest/Include/Base/FresnelCG.cginc"
        #include "../../Gonbest/Include/Base/ColorCG.cginc"
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
        sampler2D _MaskTex;
        sampler2D _MetalTex;
        samplerCUBE _EnvCube;
        float4 _MainTex_ST;
        uniform float _PBR_Roughness;
        uniform float _PRB_Metallic;
        float _EyeAdaptionLevel;            // Offset:  140 Size:     4
        float3 _HDRColor;                  // Offset:  144 Size:    12
        float _HDRMin;                     // Offset:  156 Size:     4
        float _HDRMax;                     // Offset:  160 Size:     4
        float4 _DayNightVector;
        float _SquareFactor;
        float _DayNightTimeRatio;
        float _Cutoff;
        float4 _PointLightColor;
        float4 _PointLightPos;
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
        float3 f_PointLightLit_float4_float4(in float4 _lightColor, in float4 _lightPoint, in float3 _position, in float3 _normal)
        {
            float3 _light_dir = {0.0, 0.0, 0.0};
            float _light_atten = {0.0};
            (_light_dir = (_lightPoint.xyz - _position.xyz));
            float _light_dist = length(_light_dir);
            float _range_atten = (_light_dist / _lightPoint.w);
            (_light_dir = (_light_dir / _light_dist));
            (_light_atten = max((1.0 - (_range_atten * _range_atten)), 0.0));
            return ((_light_atten * max(dot(_light_dir, _normal), 0.0)) * _lightColor.xyz);
        }

        fixed4 frag (v2f i, float facing : VFACE) : SV_Target
        {
            // sample the texture
            fixed4 col = tex2D(_MainTex, i.uv); 
            float4 _MaskTexValue = tex2D(_MaskTex,i.uv);
            col = lerp(col,col*col,_SquareFactor);

            float4 P = i.wp;
            float3 V = GBNormalizeSafe(_WorldSpaceCameraPos.xyz - P.xyz);
            float3 L = GBNormalizeSafe(_WorldSpaceLightPos0.xyz);
            float3 N = GBNormalizeSafe(i.wn);
            float3 H = GBNormalizeSafe(V+L);
            float3 LoVRaw = dot(L,V);
            float3 NoVRaw = dot(N,V);
            float3 R = reflect(-V, N);

            float NoLRaw = dot(N,L);
            float NoL = saturate(NoLRaw);
            float NoL01 = NoLRaw *0.5 + 0.5;
            
            float3 diffuse = lerp(float3(col.xy,col.z-0.01*(col.x+col.y)), col.xyz, (_MaskTexValue.x + _MaskTexValue.y + _MaskTexValue.z)) ;   
            
            float vdr = abs(dot(V,R));
            vdr = vdr * vdr * vdr * 5.0;

            float4 _MetalTexParam = tex2D(_MetalTex,i.uv);
            float3 indirect =  texCUBE(_EnvCube,R);
            indirect = (diffuse + indirect * 2) ;
            
            float3 EmissColor = min(8,max(0,(diffuse + indirect * 2) * vdr * _MetalTexParam.z));

            float rim = abs(saturate(((1 - saturate(dot(V,N))) - 0.66)/ 0.66));
            rim *= rim;
            float3 rimColor = rim * float3(0.59,0.28,0.117) * dot(N,float3(1,1,0)) ;

            float3 dnColor = ((_DayNightTimeRatio * _DayNightVector.x + _DayNightVector.y)*max(0,(1 - dot((-L),N)))) *float3(0.908,0.666,0.349);

            dnColor = facing>=0 ? dnColor : (float3)0;
            EmissColor = min(EmissColor, 8) * _EmissiveFactor + dnColor;//+ rimColor;            

            float3 specColor = lerp(float3(0.04,0.04,0.04),col,_PRB_Metallic);

            float _InvLenH = rsqrt((2.0 + (2.0 * LoVRaw)));
            float NoH =  saturate((NoLRaw + NoVRaw) * _InvLenH);
            float VoH = saturate(_InvLenH + (_InvLenH * LoVRaw));               
            float NoV = saturate(abs(NoVRaw));

            float3 F = GBFresnelTermFastWithSpecGreen(specColor,NoH);
            float D = GBGGXTerm(NoH,_PBR_Roughness);
            float Vis = GBSmithJointGGXVisibilityTerm(NoV,NoL,_PBR_Roughness);

          
            float3 spec = F*D*Vis * _MaskTexValue.x ;
            float3 sun = col.xyz  + spec; //

            float3 pointLight = f_PointLightLit_float4_float4(_PointLightColor,_PointLightPos+i.wp,i.wp,N) ;//* col.xyz ;            
			
            
            float lum = 0.168;
            lum*= _EyeAdaptionLevel;
            lum = min(max(lum,_HDRMin),_HDRMax);
            sun *= _HDRColor;
            sun *= 0.25;
            sun /= lum;
            sun = sun*(sun * 2.51 + 0.03)/(sun * (sun * 2.43 + 0.59) + 0.14);
            sun = sqrt(sun);

            col.xyz = sun  + EmissColor ;

            //阴影处理				
            //float shadow= GONBEST_DECODE_SHADOW_VALUE_DEPTH(i,P) ;		            
			//shadow = saturate(shadow * max(0,dot(N,L)) + 0.1);
            //col.xyz *= lerp(0.5,1,shadow);
          
            GONBEST_ADJUST_BRIGHTNESS_APPLY(col.rgb)
            GONBEST_ADJUST_SATURATION_APPLY(col.rgb)
            GONBEST_ADJUST_CONTRAST_APPLY(col.rgb)     
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
            Cull off
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag            
            
            #pragma multi_compile _GONBEST_ADJUST_BRIGHTNESS_ON				
			#pragma multi_compile _GONBEST_ADJUST_SATURATION_ON
			#pragma multi_compile _GONBEST_ADJUST_CONTRAST_ON
            //#pragma multi_compile _GONBEST_SHADOW_ON _GONBEST_SHADOW_OFF
            //#pragma multi_compile _GONBEST_CUSTOM_SHADOW_ON    
            #pragma multi_compile _GONBEST_SPEC_ALPHA_ON        
            ENDCG
        }
    }
    Fallback "Gonbest/FallBack/FBWithShadow"
}
