
/*
一个水的效果,这个用于晚上的水效果比较好.
*/
Shader "Ares/Water/Water02"
{
    Properties
    {
        _Color("_Color",Color) = (0.084,0.175,0.221,0.716)
        _MainTex ("Texture", 2D) = "white" {}
        _BumpMap("Normal Map",2D) = "black"{}		
        _BumpScale1("BumpScale1",float) = 0.3
        _BumpScale2("BumpScale2",float) = 0.9
        _WaterShadowColor("WaterShadowColor",Color) = (0.11,0.118,0.141,1)
        _DiffusePower("DiffusePower",float) = 0.125
        _RimAlpha("RimAlpha",float) = 0       
        _SpecularColor("SpecularColor",Color) = (0.639,0.689,0.741,1)
        _SpecPower("SpecPower",float) = 0.9
        _Gloss1("Gloss1",float) = 50
        _Gloss2("Gloss2",float) = 50
        _Gloss3("Gloss3",float) = 90
        _Gloss4("Gloss4",float) = 10
        _WaveDir("WaveDir",Vector) = (1.5,4,0.5,4)
        _WaveSpeed("WaveSpeed",Vector) = ( 0.1,0.1,0.1,0.1 )
    }
    SubShader
    {
        Tags { "Queue" = "Transparent"  "GonbestBloomType"="BloomMask"}
        LOD 100

        Pass
        {
           
            Tags { "LightMode" = "ForwardBase" }	
            ZWrite Off
            Blend SrcAlpha OneMinusSrcAlpha,Zero OneMinusSrcAlpha	
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"
            #include "../Gonbest/Include/Base/MathCG.cginc"

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
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
                float4 wn:TEXCOORD2;
                float4 wt:TEXCOORD3;
                float4 wb:TEXCOORD4;
                float4 vcolor:TEXCOORD5;
            };

            sampler2D _MainTex;
            sampler2D _BumpMap;
            float4 _MainTex_ST;           
            float4 _Color;               	//5
            float4 _WaterShadowColor;         	//6
            float _RimAlpha;                  	//7            
            float _DiffusePower;              	//9
            float _BumpScale1;                	//10
            float _BumpScale2;                	//11
            float4 _SpecularColor;            	//12
            float _SpecPower;                 	//13
            float _Gloss1;                    	//14
            float _Gloss2;                    	//15
            float _Gloss3;                    	//16
            float _Gloss4;                    	//17
            float4 _WaveSpeed;                 	//18
            float4 _WaveDir;                  	//19

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
                   

                float3 WN0 = GBNormalizeSafe(i.wn.xyz);

                float3 V = GBNormalizeSafe(_WorldSpaceCameraPos - float3(i.wt.w,i.wb.w,i.wn.w));

                float3 L = GBNormalizeSafe(_WorldSpaceLightPos0);
                
                float NoV = max(0, dot(V,WN0));
                
                float3 H = GBNormalizeSafe(L+V);
                
                float NoH = max(0,dot(WN0,H));
               
                float spec4 = pow(NoH,_Gloss4)*_SpecPower;

                float2 uv = TRANSFORM_TEX(i.uv,_MainTex);
               
                float4 wDir = _WaveDir * _Time.y;               

                float2 uv1 = _WaveSpeed.xy * wDir.xy + uv;

                float2 uv2 = _WaveSpeed.zw * wDir.zw * 1.2 + uv;

                //基础纹理
                float2 mainBG1 = tex2D(_MainTex,uv1).yz;
                float2 mainBG2 = tex2D(_MainTex,uv2).yz;
                mainBG2 = mainBG2 * mainBG1;

                //法线混合
                float4 norm = (float4)0;
                float4 r8 = (float4)0;
                norm.xy = tex2D(_BumpMap,uv1).xy;
                norm.xyzw = norm.xyxy * 2 - 1;                
                norm.xyzw = tex2D(_BumpMap,uv2).xyxy * 2 - 1 + norm.xyzw;
                norm.xyzw *=  float4(_BumpScale1.xx,_BumpScale2.xx);     

                //N2             
                float3 TN1 = float3(norm.zw,sqrt(1 - min(dot(norm.zw,norm.zw),1))); 

                float3 WN1 = GBNormalizeSafe(TN1.x*i.wt.xyz+TN1.y*i.wb.xyz+TN1.z*i.wn.xyz);               

                float diff = dot(L,WN1)*_DiffusePower - _DiffusePower + 1;

                float spec3 = pow(max(dot(H,WN1),0),_Gloss3) * _SpecPower;

                float3 specColor0 =  spec4 * spec3 * _SpecularColor * mainBG2.y * mainBG1.y ;
                
                //N2                
                float3 TN2 = float3(norm.xy,sqrt(1 - min(dot(norm.xy,norm.xy),1)));
                float3 WN2 = GBNormalizeSafe(TN2.x*i.wt.xyz+TN2.y*i.wb.xyz+TN2.z*i.wn.xyz);
              
                float spec1 = pow(max(0,dot(WN2,H)),_Gloss1) * _SpecPower;
                float spec2 = pow(max(0,dot(WN2,H)),_Gloss1) * _SpecPower;
                
                float3 specColor1 = spec1*_SpecularColor * spec2 * _SpecularColor;
                specColor1 += specColor0;
               
                float3 diffColor = mainBG2.x * mainBG1.x * mainBG1.y * mainBG2.y * _DiffusePower * 3;
                
                float3 envColor = (_Color - _WaterShadowColor) *  NoV * NoV * NoV;
               
                diffColor = (envColor + _WaterShadowColor)* diff  + diffColor;
                         
                float3 fColor = UNITY_LIGHTMODEL_AMBIENT * _WaterShadowColor * 2 + diffColor  + specColor1;
               
                float a = specColor1.z + _Color.w - NoV + 1;              
                a = (1- _RimAlpha * i.vcolor.a )* a;

                return float4(fColor,a);
            }
            ENDCG
        }
    }
}
