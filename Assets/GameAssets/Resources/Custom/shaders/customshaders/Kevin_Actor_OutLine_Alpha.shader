Shader "Kevin/Actor_OutLine_Alpha"
{
  Properties
  {
    _Hit ("Hit", float) = 1
    [Toggle] _IsHit ("IsHit", Range(0, 1)) = 0
    _HitColor ("HitColor", Color) = (1,1,1,1)
    _MainColor ("MainColor", Color) = (1,1,1,1)
    _MainTex ("MainTex", 2D) = "white" {}
    _FallOffstep ("FallOffstep", float) = 2
    _FallOffColor ("FallOffColor", Color) = (1,1,1,1)
    _FallOffColorMap ("FallOffColorMap", 2D) = "white" {}
    _FallOffPower ("FallOffPower", Range(1, 2)) = 1
    _RimLightSampler ("RimLightSampler", 2D) = "black" {}
    _RimLightPower ("RimPower", Range(0, 2)) = 1
    _SAGMap ("SAGMap", 2D) = "white" {}
    _OutLineColor ("OutLineColor", Color) = (0.3529412,0.3529412,0.3529412,1)
    _OutLinePow ("OutLinePow", float) = 1
    _OutWidth ("OutWidth", float) = 1
    _FresnelPower ("FresnelPower", Range(0, 5)) = 2
    _FresnelColor ("FresnelColor", Color) = (0,0,0,1)
    _MatCap ("MatCap (RGB)", 2D) = "white" {}
    _LerpS ("LerpS", Range(0, 1)) = 1
    _ReflectPower ("ReflectPower", float) = 1
    _Alphabias ("Alphabias", Range(0, 1)) = 0
    _StencilComp ("Stencil Comparison", float) = 8
    _Stencil ("Stencil ID", float) = 0
    _StencilOp ("Stencil Operation", float) = 0
    _StencilWriteMask ("Stencil Write Mask", float) = 255
    _StencilReadMask ("Stencil Read Mask", float) = 255
    [HideInInspector] _Cutoff ("Alpha cutoff", Range(0, 1)) = 0.5
  }
  SubShader
  {
    Tags
    { 
      "IGNOREPROJECTOR" = "true"
      "QUEUE" = "Transparent"
      "Reflection" = "RenderReflectionTransparentBlend"
      "RenderType" = "Geometry"
    }
    Pass // ind: 1, name: ForwardBase
    {
      Name "ForwardBase"
      Tags
      { 
        "IGNOREPROJECTOR" = "true"
        "LIGHTMODE" = "FORWARDBASE"
        "QUEUE" = "Transparent"
        "Reflection" = "RenderReflectionTransparentBlend"
        "RenderType" = "Geometry"
        "SHADOWSUPPORT" = "true"
      }
      Stencil
      { 
        Ref 0
        ReadMask 0
        WriteMask 0
        Pass Keep
        Fail Keep
        ZFail Keep
        PassFront Keep
        FailFront Keep
        ZFailFront Keep
        PassBack Keep
        FailBack Keep
        ZFailBack Keep
      } 
      Fog
      { 
        Mode  Off
      } 
      Blend SrcAlpha OneMinusSrcAlpha
      // m_ProgramMask = 6
      CGPROGRAM
      #pragma multi_compile DIRECTIONAL
      //#pragma target 4.0
      
      #pragma vertex vert
      #pragma fragment frag
      
      #include "UnityCG.cginc"
      #define conv_mxt4x4_0(mat4x4) float4(mat4x4[0].x,mat4x4[1].x,mat4x4[2].x,mat4x4[3].x)
      #define conv_mxt4x4_1(mat4x4) float4(mat4x4[0].y,mat4x4[1].y,mat4x4[2].y,mat4x4[3].y)
      #define conv_mxt4x4_2(mat4x4) float4(mat4x4[0].z,mat4x4[1].z,mat4x4[2].z,mat4x4[3].z)
      #define conv_mxt4x4_3(mat4x4) float4(mat4x4[0].w,mat4x4[1].w,mat4x4[2].w,mat4x4[3].w)
      
      
      #define CODE_BLOCK_VERTEX
      //uniform float4x4 unity_ObjectToWorld;
      //uniform float4x4 unity_WorldToObject;
      //uniform float4x4 unity_MatrixV;
      //uniform float4x4 unity_MatrixVP;
      //uniform float3 _WorldSpaceCameraPos;
      //uniform float4 _WorldSpaceLightPos0;
      uniform float4 _LightColor0;
      uniform float4 _MainColor;
      uniform float4 _MainTex_ST;
      uniform float _FallOffstep;
      uniform float _Hit;
      uniform float _IsHit;
      uniform float4 _RimLightSampler_ST;
      uniform float _FallOffPower;
      uniform float4 _FallOffColor;
      uniform float _RimLightPower;
      uniform float4 _SAGMap_ST;
      uniform float4 _FallOffColorMap_ST;
      uniform float _FresnelPower;
      uniform float4 _FresnelColor;
      uniform float _LerpS;
      uniform float _ReflectPower;
      uniform float _Alphabias;
      uniform sampler2D _MainTex;
      uniform sampler2D _SAGMap;
      uniform sampler2D _MatCap;
      uniform sampler2D _FallOffColorMap;
      uniform sampler2D _RimLightSampler;
      struct appdata_t
      {
          float4 vertex :POSITION0;
          float3 normal :NORMAL0;
          float4 tangent :TANGENT0;
          float2 texcoord :TEXCOORD0;
      };
      
      struct OUT_Data_Vert
      {
          float2 texcoord :TEXCOORD0;
          float2 texcoord7 :TEXCOORD7;
          float4 texcoord1 :TEXCOORD1;
          float3 texcoord2 :TEXCOORD2;
          float3 texcoord3 :TEXCOORD3;
          float3 texcoord4 :TEXCOORD4;
          float4 vertex :SV_POSITION;
      };
      
      struct v2f
      {
          float2 texcoord :TEXCOORD0;
          float2 texcoord7 :TEXCOORD7;
          float4 texcoord1 :TEXCOORD1;
          float3 texcoord2 :TEXCOORD2;
      };
      
      struct OUT_Data_Frag
      {
          float4 color :SV_Target0;
      };
      
      float4 u_xlat0;
      float4 u_xlat1;
      float3 u_xlat2;
      float3 u_xlat3;
      float u_xlat9;
      OUT_Data_Vert vert(appdata_t in_v)
      {
          OUT_Data_Vert out_v;
          u_xlat0 = (in_v.vertex.yyyy * conv_mxt4x4_1(unity_ObjectToWorld));
          u_xlat0 = ((conv_mxt4x4_0(unity_ObjectToWorld) * in_v.vertex.xxxx) + u_xlat0);
          u_xlat0 = ((conv_mxt4x4_2(unity_ObjectToWorld) * in_v.vertex.zzzz) + u_xlat0);
          u_xlat1 = (u_xlat0 + conv_mxt4x4_3(unity_ObjectToWorld));
          out_v.texcoord1 = ((conv_mxt4x4_3(unity_ObjectToWorld) * in_v.vertex.wwww) + u_xlat0);
          out_v.vertex = mul(unity_MatrixVP, u_xlat1);
          u_xlat0.x = conv_mxt4x4_0(unity_WorldToObject).y;
          u_xlat0.y = conv_mxt4x4_1(unity_WorldToObject).y;
          u_xlat0.z = conv_mxt4x4_2(unity_WorldToObject).y;
          u_xlat0.xyz = (u_xlat0.xyz * in_v.normal.yyy);
          u_xlat1.x = conv_mxt4x4_0(unity_WorldToObject).x;
          u_xlat1.y = conv_mxt4x4_1(unity_WorldToObject).x;
          u_xlat1.z = conv_mxt4x4_2(unity_WorldToObject).x;
          u_xlat0.xyz = ((u_xlat1.xyz * in_v.normal.xxx) + u_xlat0.xyz);
          u_xlat1.x = conv_mxt4x4_0(unity_WorldToObject).z;
          u_xlat1.y = conv_mxt4x4_1(unity_WorldToObject).z;
          u_xlat1.z = conv_mxt4x4_2(unity_WorldToObject).z;
          u_xlat0.xyz = ((u_xlat1.xyz * in_v.normal.zzz) + u_xlat0.xyz);
          u_xlat0.xyz = normalize(u_xlat0.xyz);
          u_xlat3.xz = (u_xlat0.yy * conv_mxt4x4_1(unity_MatrixV).xy);
          u_xlat0.xy = ((conv_mxt4x4_0(unity_MatrixV).xy * u_xlat0.xx) + u_xlat3.xz);
          u_xlat0.xy = ((conv_mxt4x4_2(unity_MatrixV).xy * u_xlat0.zz) + u_xlat0.xy);
          out_v.texcoord7.xy = ((u_xlat0.xy * float2(0.5, 0.5)) + float2(0.5, 0.5));
          out_v.texcoord.xy = in_v.texcoord.xy;
          u_xlat0.x = dot(in_v.normal.xyz, conv_mxt4x4_0(unity_WorldToObject).xyz);
          u_xlat0.y = dot(in_v.normal.xyz, conv_mxt4x4_1(unity_WorldToObject).xyz);
          u_xlat0.z = dot(in_v.normal.xyz, conv_mxt4x4_2(unity_WorldToObject).xyz);
          out_v.texcoord2.xyz = u_xlat0.xyz;
          u_xlat1.xyz = (in_v.tangent.yyy * conv_mxt4x4_1(unity_ObjectToWorld).xyz);
          u_xlat1.xyz = ((conv_mxt4x4_0(unity_ObjectToWorld).xyz * in_v.tangent.xxx) + u_xlat1.xyz);
          u_xlat1.xyz = ((conv_mxt4x4_2(unity_ObjectToWorld).xyz * in_v.tangent.zzz) + u_xlat1.xyz);
          u_xlat1.xyz = normalize(u_xlat1.xyz);
          out_v.texcoord3.xyz = u_xlat1.xyz;
          u_xlat2.xyz = (u_xlat0.zxy * u_xlat1.yzx);
          u_xlat0.xyz = ((u_xlat0.yzx * u_xlat1.zxy) + (-u_xlat2.xyz));
          u_xlat0.xyz = (u_xlat0.xyz * in_v.tangent.www);
          out_v.texcoord4.xyz = normalize(u_xlat0.xyz);
          return out_v;
      }
      
      #define CODE_BLOCK_FRAGMENT
      float3 u_xlat0_d;
      float3 u_xlat16_0;
      float4 u_xlat16_1;
      float3 u_xlat2_d;
      float3 u_xlat3_d;
      float3 u_xlat16_3;
      float3 u_xlat16_4;
      float3 u_xlat16_5;
      float3 u_xlat16_7;
      float3 u_xlat16_10;
      float u_xlat12;
      int u_xlati12;
      int u_xlatb12;
      float u_xlat16_13;
      float u_xlat18;
      int u_xlati18;
      int u_xlatb18;
      int u_xlatb20;
      OUT_Data_Frag frag(v2f in_f)
      {
          OUT_Data_Frag out_f;
          u_xlat0_d.xy = TRANSFORM_TEX(in_f.texcoord.xy, _SAGMap);
          u_xlat16_0.xy = tex2D(_SAGMap, u_xlat0_d.xy).xy;
          u_xlat16_1.x = u_xlat16_0.y;
          #ifdef UNITY_ADRENO_ES3
          u_xlat16_1.x = min(max(u_xlat16_1.x, 0), 1);
          #else
          u_xlat16_1.x = clamp(u_xlat16_1.x, 0, 1);
          #endif
          u_xlat16_1.x = (u_xlat16_1.x + (-0.5));
          u_xlat16_1.x = (u_xlat16_1.x + (-_Alphabias));
          #ifdef UNITY_ADRENO_ES3
          u_xlatb12 = (u_xlat16_1.x<0);
          #else
          u_xlatb12 = (u_xlat16_1.x<0);
          #endif
          if(u_xlatb12)
          {
              discard;
          }
          u_xlat16_1.x = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
          u_xlat16_1.x = rsqrt(u_xlat16_1.x);
          u_xlat16_1.xyz = (u_xlat16_1.xxx * _WorldSpaceLightPos0.xyz);
          u_xlat2_d.xyz = normalize(in_f.texcoord2.xyz);
          u_xlat3_d.xyz = ((-in_f.texcoord1.xyz) + _WorldSpaceCameraPos.xyz);
          u_xlat3_d.xyz = normalize(u_xlat3_d.xyz);
          u_xlat12 = dot(u_xlat3_d.xyz, u_xlat2_d.xyz);
          #ifdef UNITY_ADRENO_ES3
          int cond = (0<u_xlat12);
          u_xlati18 = int((cond)?(4294967295):(uint(0)));
          #else
          u_xlati18 = int(((0<u_xlat12))?(4294967295):(uint(0)));
          #endif
          #ifdef UNITY_ADRENO_ES3
          int cond = (u_xlat12<0);
          u_xlati12 = int((cond)?(4294967295):(uint(0)));
          #else
          u_xlati12 = int(((u_xlat12<0))?(4294967295):(uint(0)));
          #endif
          u_xlati12 = ((-u_xlati18) + u_xlati12);
          u_xlat12 = float(u_xlati12);
          u_xlat2_d.xyz = (float3(u_xlat12, u_xlat12, u_xlat12) * u_xlat2_d.xyz);
          u_xlat16_1.x = dot(u_xlat2_d.xyz, u_xlat16_1.xyz);
          u_xlat16_1.x = max(u_xlat16_1.x, 0);
          u_xlat16_7.x = (u_xlat16_0.x + u_xlat16_0.x);
          out_f.color.w = (u_xlat16_0.y + (-_Alphabias));
          #ifdef UNITY_ADRENO_ES3
          out_f.color.w = min(max(out_f.color.w, 0), 1);
          #else
          out_f.color.w = clamp(out_f.color.w, 0, 1);
          #endif
          u_xlat16_13 = (u_xlat16_1.x * u_xlat16_7.x);
          u_xlat16_1.xyw = ((u_xlat16_7.xxx * u_xlat16_1.xxx) + float3(1, 0.814999998, 0.814999998));
          u_xlat16_13 = (u_xlat16_13 * _FallOffstep);
          u_xlat16_13 = floor(u_xlat16_13);
          u_xlat16_4.x = (_FallOffstep + (-1));
          u_xlat16_13 = (u_xlat16_13 / u_xlat16_4.x);
          u_xlat16_4.x = (u_xlat16_13 + 0.5);
          #ifdef UNITY_ADRENO_ES3
          u_xlat16_4.x = min(max(u_xlat16_4.x, 0), 1);
          #else
          u_xlat16_4.x = clamp(u_xlat16_4.x, 0, 1);
          #endif
          u_xlat16_4.x = (u_xlat16_4.x * _FallOffPower);
          u_xlat16_4.xyz = (u_xlat16_4.xxx * _FallOffColor.xyz);
          u_xlat0_d.xy = TRANSFORM_TEX(in_f.texcoord.xy, _FallOffColorMap);
          u_xlat16_0.xyz = tex2D(_FallOffColorMap, u_xlat0_d.xy).xyz;
          u_xlat0_d.xyz = (u_xlat16_0.xyz * u_xlat16_4.xyz);
          #ifdef UNITY_ADRENO_ES3
          u_xlat0_d.xyz = min(max(u_xlat0_d.xyz, 0), 1);
          #else
          u_xlat0_d.xyz = clamp(u_xlat0_d.xyz, 0, 1);
          #endif
          #ifdef UNITY_ADRENO_ES3
          u_xlatb18 = (0.5>=u_xlat16_13);
          #else
          u_xlatb18 = (0.5>=u_xlat16_13);
          #endif
          #ifdef UNITY_ADRENO_ES3
          u_xlatb20 = (u_xlat16_13>=0.5);
          #else
          u_xlatb20 = (u_xlat16_13>=0.5);
          #endif
          u_xlat16_13 = (u_xlatb20)?(1):(0);
          u_xlat16_4.x = (u_xlatb18)?(1):(0);
          u_xlat16_10.xyz = ((u_xlat16_4.xxx * u_xlat0_d.xyz) + float3(u_xlat16_13, u_xlat16_13, u_xlat16_13));
          u_xlat16_5.xyz = (u_xlat0_d.xyz + (-u_xlat16_10.xyz));
          u_xlat16_13 = (u_xlat16_13 * u_xlat16_4.x);
          u_xlat16_4.xyz = ((float3(u_xlat16_13, u_xlat16_13, u_xlat16_13) * u_xlat16_5.xyz) + u_xlat16_10.xyz);
          u_xlat16_4.xyz = min(u_xlat16_4.xyz, float3(1, 1, 1));
          u_xlat0_d.xy = TRANSFORM_TEX(in_f.texcoord.xy, _MainTex);
          u_xlat0_d.xyz = tex2D(_MainTex, u_xlat0_d.xy).xyz;
          u_xlat16_5.xyz = (u_xlat0_d.xyz * _MainColor.xyz);
          u_xlat16_4.xyz = (u_xlat16_4.xyz * u_xlat16_5.xyz);
          u_xlat16_4.xyz = (u_xlat16_4.xyz * float3(float3(_Hit, _Hit, _Hit)));
          u_xlat16_5.xyz = (u_xlat16_1.xww * _MainColor.xyz);
          #ifdef UNITY_ADRENO_ES3
          u_xlatb18 = (float4(0, 0, 0, 0).x != float4(_IsHit, _IsHit, _IsHit, _IsHit).x && float4(0, 0, 0, 0).y != float4(_IsHit, _IsHit, _IsHit, _IsHit).y && float4(0, 0, 0, 0).z != float4(_IsHit, _IsHit, _IsHit, _IsHit).z && float4(0, 0, 0, 0).w != float4(_IsHit, _IsHit, _IsHit, _IsHit).w);
          #else
          u_xlatb18 = (float4(0, 0, 0, 0).x != float4(_IsHit, _IsHit, _IsHit, _IsHit).x && float4(0, 0, 0, 0).y != float4(_IsHit, _IsHit, _IsHit, _IsHit).y && float4(0, 0, 0, 0).z != float4(_IsHit, _IsHit, _IsHit, _IsHit).z && float4(0, 0, 0, 0).w != float4(_IsHit, _IsHit, _IsHit, _IsHit).w);
          #endif
          u_xlat16_4.xyz = (int(u_xlatb18))?(u_xlat16_5.xyz):(u_xlat16_4.xyz);
          u_xlat16_7.xyz = (int(u_xlatb18))?(u_xlat16_1.xyw):(u_xlat0_d.xyz);
          u_xlat16_1.x = (u_xlat16_1.x * 0.5);
          #ifdef UNITY_ADRENO_ES3
          u_xlat16_1.x = min(max(u_xlat16_1.x, 0), 1);
          #else
          u_xlat16_1.x = clamp(u_xlat16_1.x, 0, 1);
          #endif
          u_xlat16_7.xyz = (u_xlat16_7.xyz * float3(_RimLightPower, _RimLightPower, _RimLightPower));
          u_xlat16_0.xyz = tex2D(_MatCap, in_f.texcoord7.xy).xyz;
          u_xlat0_d.xyz = (u_xlat16_0.xyz * float3(_ReflectPower, _ReflectPower, _ReflectPower));
          u_xlat16_5.xyz = ((u_xlat0_d.xyz * float3(2, 2, 2)) + u_xlat16_4.xyz);
          u_xlat16_5.xyz = (u_xlat16_5.xyz + float3(-1, (-1), (-1)));
          u_xlat0_d.xyz = ((-u_xlat16_4.xyz) + u_xlat16_5.xyz);
          u_xlat18 = _LerpS;
          #ifdef UNITY_ADRENO_ES3
          u_xlat18 = min(max(u_xlat18, 0), 1);
          #else
          u_xlat18 = clamp(u_xlat18, 0, 1);
          #endif
          u_xlat0_d.xyz = ((float3(u_xlat18, u_xlat18, u_xlat18) * u_xlat0_d.xyz) + u_xlat16_4.xyz);
          u_xlat16_4.x = dot(u_xlat2_d.xyz, u_xlat3_d.xyz);
          u_xlat18 = dot(u_xlat2_d.xyz, u_xlat3_d.xyz);
          u_xlat18 = max(u_xlat18, 0);
          u_xlat18 = ((-u_xlat18) + 1);
          u_xlat18 = log2(u_xlat18);
          u_xlat18 = (u_xlat18 * _FresnelPower);
          u_xlat18 = exp2(u_xlat18);
          u_xlat2_d.xyz = (float3(u_xlat18, u_xlat18, u_xlat18) * _FresnelColor.xyz);
          u_xlat16_4.x = ((-abs(u_xlat16_4.x)) + 1);
          u_xlat16_4.x = max(u_xlat16_4.x, 0.0199999996);
          u_xlat16_4.x = min(u_xlat16_4.x, 0.980000019);
          u_xlat16_4.x = (u_xlat16_1.x * u_xlat16_4.x);
          u_xlat16_4.y = 0.25;
          u_xlat3_d.xy = TRANSFORM_TEX(u_xlat16_4.xy, _RimLightSampler);
          u_xlat16_3.xyz = tex2D(_RimLightSampler, u_xlat3_d.xy).xyz;
          u_xlat3_d.xyz = (u_xlat16_7.xyz * u_xlat16_3.xyz);
          u_xlat0_d.xyz = ((_LightColor0.xyz * u_xlat0_d.xyz) + u_xlat3_d.xyz);
          u_xlat0_d.xyz = ((u_xlat2_d.xyz * float3(2, 2, 2)) + u_xlat0_d.xyz);
          out_f.color.xyz = u_xlat0_d.xyz;
          return out_f;
      }
      
      
      ENDCG
      
    } // end phase
    Pass // ind: 2, name: Outline
    {
      Name "Outline"
      Tags
      { 
        "IGNOREPROJECTOR" = "true"
        "QUEUE" = "Transparent"
        "Reflection" = "RenderReflectionTransparentBlend"
        "RenderType" = "Geometry"
        "SHADOWSUPPORT" = "true"
      }
      ZTest Less
      Cull Front
      Stencil
      { 
        Ref 0
        ReadMask 0
        WriteMask 0
        Pass Keep
        Fail Keep
        ZFail Keep
        PassFront Keep
        FailFront Keep
        ZFailFront Keep
        PassBack Keep
        FailBack Keep
        ZFailBack Keep
      } 
      Fog
      { 
        Mode  Off
      } 
      Blend SrcAlpha OneMinusSrcAlpha
      // m_ProgramMask = 6
      CGPROGRAM
      #pragma multi_compile SHADOWS_DEPTH
      //#pragma target 4.0
      
      #pragma vertex vert
      #pragma fragment frag
      
      #include "UnityCG.cginc"
      
      
      #define CODE_BLOCK_VERTEX
      //uniform float4x4 unity_ObjectToWorld;
      //uniform float4x4 unity_MatrixVP;
      uniform float _OutWidth;
      uniform float4 _SAGMap_ST;
      uniform float4 _OutLineColor;
      uniform float _OutLinePow;
      uniform float _Alphabias;
      uniform sampler2D _MainTex;
      uniform sampler2D _SAGMap;
      struct appdata_t
      {
          float4 vertex :POSITION0;
          float3 normal :NORMAL0;
          float2 texcoord :TEXCOORD0;
          float4 color :COLOR0;
      };
      
      struct OUT_Data_Vert
      {
          float2 texcoord :TEXCOORD0;
          float4 vertex :SV_POSITION;
      };
      
      struct v2f
      {
          float2 texcoord :TEXCOORD0;
      };
      
      struct OUT_Data_Frag
      {
          float4 color :SV_Target0;
      };
      
      float4 u_xlat0;
      float4 u_xlat1;
      OUT_Data_Vert vert(appdata_t in_v)
      {
          OUT_Data_Vert out_v;
          u_xlat0.x = (in_v.color.w * _OutWidth);
          u_xlat0.x = (u_xlat0.x * 0.00285000005);
          u_xlat0.xyz = ((in_v.normal.xyz * u_xlat0.xxx) + in_v.vertex.xyz);
          u_xlat0 = UnityObjectToClipPos(u_xlat0);
          out_v.vertex = (u_xlat0 + float4(0, 0, 9.99999975E-06, 0));
          out_v.texcoord.xy = in_v.texcoord.xy;
          return out_v;
      }
      
      #define CODE_BLOCK_FRAGMENT
      float3 u_xlat0_d;
      float u_xlat16_0;
      float3 u_xlat1_d;
      float3 u_xlatb1;
      float3 u_xlat16_2;
      float u_xlat9;
      OUT_Data_Frag frag(v2f in_f)
      {
          OUT_Data_Frag out_f;
          u_xlat0_d.xyz = tex2D(_MainTex, in_f.texcoord.xy).xyz;
          u_xlat9 = max(u_xlat0_d.y, u_xlat0_d.x);
          u_xlat9 = max(u_xlat0_d.z, u_xlat9);
          u_xlat9 = (u_xlat9 + (-0.00400000019));
          u_xlatb1.xyz = bool4(u_xlat0_d.xyzx >= float4(u_xlat9, u_xlat9, u_xlat9, u_xlat9)).xyz;
          u_xlat1_d.x = (u_xlatb1.x)?(float(1)):(0);
          u_xlat1_d.y = (u_xlatb1.y)?(float(1)):(0);
          u_xlat1_d.z = (u_xlatb1.z)?(float(1)):(0);
          u_xlat1_d.xyz = ((u_xlat1_d.xyz * u_xlat0_d.xyz) + (-u_xlat0_d.xyz));
          u_xlat1_d.xyz = ((u_xlat1_d.xyz * float3(0.600000024, 0.600000024, 0.600000024)) + u_xlat0_d.xyz);
          u_xlat16_2.xyz = (u_xlat1_d.xyz * float3(0.800000012, 0.800000012, 0.800000012));
          u_xlat0_d.xyz = (u_xlat0_d.xyz * u_xlat16_2.xyz);
          u_xlat0_d.xyz = (u_xlat0_d.xyz * _OutLineColor.xyz);
          u_xlat0_d.xyz = (u_xlat0_d.xyz * float3(_OutLinePow, _OutLinePow, _OutLinePow));
          out_f.color.xyz = u_xlat0_d.xyz;
          u_xlat0_d.xy = TRANSFORM_TEX(in_f.texcoord.xy, _SAGMap);
          u_xlat16_0 = tex2D(_SAGMap, u_xlat0_d.xy).y;
          out_f.color.w = (u_xlat16_0 + (-_Alphabias));
          #ifdef UNITY_ADRENO_ES3
          out_f.color.w = min(max(out_f.color.w, 0), 1);
          #else
          out_f.color.w = clamp(out_f.color.w, 0, 1);
          #endif
          return out_f;
      }
      
      
      ENDCG
      
    } // end phase
  }
  FallBack "Diffuse"
}
