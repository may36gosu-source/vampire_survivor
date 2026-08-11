/*
Author:gzg
Date:2019-09-12
Desc:创建角色场景使用的头发Shader
*/
Shader "Ares/Special/CreatePlayer/Hair"
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
        _DayNightTimeRatio("DayNightTimeRatio",Range(0,1)) = 1
        _DayNightVector("_DayNightVector",Vector) = (0,0,0,0)        
        _Cutoff("_Cutoff",Range(0,1)) = 0.3
        _PointLightColor("_PointLightColor",Color) = (0,0,0,0)
        _PointLightPos("_PointLightPos",Vector) = (0,0,0,0)
        _EmissiveFactor("EmissiveFactor",Range(0,1)) =1
        

    }
    CGINCLUDE
            #include "../../Gonbest/Include/Base/CommonCG.cginc"
            #include "../../Gonbest/Include/Base/MathCG.cginc"
            #include "../../Gonbest/Include/Specular/GGXCG.cginc"
            #include "../../Gonbest/Include/Diffuse/LambertCG.cginc"
            #include "../../Gonbest/Include/Base/FresnelCG.cginc"  
            #include "../../Gonbest/Include//Base/EnergyCG.cginc"         


            struct v2f
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;                
                float3 wn : TEXCOORD1;                
                float4 wp : TEXCOORD2;
                
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

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv); 
                float4 _MaskTexValue = tex2D(_MaskTex,i.uv);
                col =lerp(col,col*col,_SquareFactor);

                float3 V = GBNormalizeSafe(_WorldSpaceCameraPos.xyz - i.wp.xyz);
                float3 L = GBNormalizeSafe(_WorldSpaceLightPos0.xyz);
                float3 N = GBNormalizeSafe(i.wn);
                float3 H = GBNormalizeSafe(V+L);
                float3 LoVRaw = dot(L,V);
                float3 NoVRaw = dot(N,V);
                float3 R = reflect(-V, N);

                float NoLRaw = dot(N,L);
                float NoL = saturate(NoLRaw);
                float NoL01 = NoLRaw *0.5 + 0.5;



                float3 diffuse = float3(col.xy,col.z-0.01*(col.x+col.y)) * (_MaskTexValue.x+_MaskTexValue.y+_MaskTexValue.z) + col.xyz * (1 - (_MaskTexValue.x+_MaskTexValue.y+_MaskTexValue.z));
               
                float s57b = abs(dot(V,R));
                s57b = s57b * s57b * s57b * 5.0;

                float4 _MetalTexParam = tex2D(_MetalTex,i.uv);
                float3 indirect = (float3)0;// texCUBE(_EnvCube,R);
                indirect = (diffuse + indirect * 2) ;
                float3 _Local34 = min(8,max(0,(diffuse + indirect * 2) * s57b * _MetalTexParam.z));

                float s57c = abs(saturate(((1-saturate(dot(V,N))) -0.66)/ 0.66));
                s57c*=s57c;
                float3 rimColor = s57c * float3(0.59,0.28,0.117) * dot(N,float3(1,1,0)) ;

                float3 _Local58 = ((_DayNightTimeRatio * _DayNightVector.x + _DayNightVector.y)*max(0,(1 - dot((-L),N)))) *float3(0.908,0.666,0.349)  +  float3(0,0,0);

                //diffuse * _Local58 + 
                float3 EmissColor = min(_Local34, 8) * _EmissiveFactor ;

                

                float3 specColor = lerp(float3(0.04,0.04,0.04),col,_PRB_Metallic);

                float _InvLenH = rsqrt((2.0 + (2.0 * LoVRaw)));
                float NoH =  saturate((NoLRaw + NoVRaw) * _InvLenH);
                float VoH = saturate(_InvLenH + (_InvLenH * LoVRaw));               
                float NoV = saturate(abs(NoVRaw));
                //NoH = saturate(dot(N,H));
                float3 F = GBFresnelTermFastWithSpecGreen(specColor,NoH);
                float D = GBGGXTerm(NoH,_PBR_Roughness);
                float Vis = GBSmithJointGGXVisibilityTerm(NoV,NoL,_PBR_Roughness);

                float3 sun = col.xyz + F*D*Vis * _MaskTexValue.x    ; //

                float3 pointLight = f_PointLightLit_float4_float4(_PointLightColor,_PointLightPos+i.wp,i.wp,N) ;//* col.xyz ;

                col.xyz =  sun + EmissColor   ;
                #if defined(_GONBEST_SPEC_ALPHA_ON)
				    col.a = GBLuminance(EmissColor);
			    #endif 
                return col;                
            }
            ENDCG

    SubShader
    {
        Tags { "LightMode" = "ForwardBase" "Queue" = "Transparent" "RenderType" = "Opaque"} 
         /*
         Pass
            {
            Tags { "LightMode" = "ForwardBase" "Queue" = "Geometry"}                   
			ZWrite On
			ZTest Less			
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag            
            ENDCG
            }	
        */
        
        Pass
		{		
           


			//先写深度
			//这个Pass用处是写ZBuffer和Alpha信息,不写颜色信息
			//好处是,在pixelshader部分改变ZBuffer了,所以只能Late-Z,但是pixelshader的语句简单,所以能提高效率
		    Name "WRITE&Z&A"
			Tags  { "Queue" = "AlphaTest"  "RenderType" = "TransparentCutout" }
			Cull Off   
			ZWrite On			
			ZTest Less
			ColorMask 0   
            
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag_write_z_a	
            #pragma multi_compile _GONBEST_SPEC_ALPHA_ON
			//写深度的处理
			fixed4 frag_write_z_a(v2f i): COLOR
			{			
				fixed4 color = tex2D(_MainTex,i.uv) ;		
				clip(color.a * color.a - _Cutoff);
				return float4(color.xyz,0);
			}		
			ENDCG
		}

        Pass
        {
            Tags { "LightMode" = "ForwardBase" "Queue" = "AlphaTest" "RenderType" = "TransparentCutout"}   
            Cull Off                 
			ZWrite Off
			ZTest Equal			
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag   
            #pragma multi_compile _GONBEST_SPEC_ALPHA_ON         
            ENDCG
        }	

        Pass
        {
            Tags { "LightMode" = "ForwardBase" "Queue" = "Transparent" "RenderType" = "Transparent"}  
            Cull Front           
			ZWrite Off
			ZTest Less
            Blend SrcAlpha OneMinusSrcAlpha,Zero OneMinusSrcAlpha			
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            ENDCG
        }

        Pass
        {
            Tags { "LightMode" = "ForwardBase" "Queue" = "Transparent" "RenderType" = "Transparent"}  
            Cull Back           
			ZWrite Off
			ZTest Less
			Blend SrcAlpha OneMinusSrcAlpha,Zero OneMinusSrcAlpha
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            ENDCG
        }
       
    }
    Fallback "Gonbest/FallBack/FBWithShadow"
}
