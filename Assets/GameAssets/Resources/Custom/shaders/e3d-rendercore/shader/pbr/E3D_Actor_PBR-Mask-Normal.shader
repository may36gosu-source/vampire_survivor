Shader "E3D/Actor/PBR-Mask-Normal"
{
  Properties
  {
    _AlbedoMap ("AlbedoMap", 2D) = "white" {}
    _BaseColor ("BaseColor", Color) = (1,1,1,0)
    _NormalMap ("NormalMap", 2D) = "bump" {}
    _MaskMap ("MaskMap", 2D) = "white" {}
    [HDR] _MaxColor ("MaxColor", Color) = (1,1,1,1)
    _Smooth ("Smooth", Range(0, 2)) = 1
    _Metallic ("Metallic", Range(0, 2)) = 1
    _SideLightColor ("SideLightColor", Color) = (0.8439122,0.9225554,0.9485294,1)
    _SideLightScale ("SideLightScale", Range(0, 1)) = 0.6
    [HideInInspector] _texcoord ("", 2D) = "white" {}
    [HideInInspector] __dirty ("", float) = 1
  }
  SubShader
  {
    Tags
    { 
      "QUEUE" = "Geometry+0"
      "RenderType" = "Opaque"
    }
    Pass // ind: 1, name: FORWARD
    {
      Name "FORWARD"
      Tags
      { 
        "LIGHTMODE" = "FORWARDBASE"
        "QUEUE" = "Geometry+0"
        "RenderType" = "Opaque"
        "SHADOWSUPPORT" = "true"
      }
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
      //uniform float4 unity_WorldTransformParams;
      //uniform float4x4 unity_MatrixVP;
      uniform float4 _texcoord_ST;
      //uniform float3 _WorldSpaceCameraPos;
      //uniform float4 _WorldSpaceLightPos0;
      //uniform float4 unity_SpecCube0_HDR;
      uniform float4 _LightColor0;
      uniform float _SideLightScale;
      uniform float4 _SideLightColor;
      uniform float4 _BaseColor;
      uniform float4 _AlbedoMap_ST;
      uniform float4 _NormalMap_ST;
      uniform float4 _MaskMap_ST;
      uniform float _Metallic;
      uniform float _Smooth;
      uniform float4 _MaxColor;
      uniform sampler2D _AlbedoMap;
      uniform sampler2D _NormalMap;
      uniform sampler2D _MaskMap;
      uniform sampler2D unity_NHxRoughness;
      //uniform samplerCUBE unity_SpecCube0;
      struct appdata_t
      {
          float4 vertex :POSITION0;
          float4 tangent :TANGENT0;
          float3 normal :NORMAL0;
          float4 texcoord :TEXCOORD0;
      };
      
      struct OUT_Data_Vert
      {
          float2 texcoord :TEXCOORD0;
          float4 texcoord1 :TEXCOORD1;
          float4 texcoord2 :TEXCOORD2;
          float4 texcoord3 :TEXCOORD3;
          float4 texcoord6 :TEXCOORD6;
          float4 texcoord7 :TEXCOORD7;
          float4 vertex :SV_POSITION;
      };
      
      struct v2f
      {
          float2 texcoord :TEXCOORD0;
          float4 texcoord1 :TEXCOORD1;
          float4 texcoord2 :TEXCOORD2;
          float4 texcoord3 :TEXCOORD3;
      };
      
      struct OUT_Data_Frag
      {
          float4 color :SV_Target0;
      };
      
      float4 u_xlat0;
      float4 u_xlat1;
      float4 u_xlat2;
      float3 u_xlat3;
      OUT_Data_Vert vert(appdata_t in_v)
      {
          OUT_Data_Vert out_v;
          u_xlat0 = (in_v.vertex.yyyy * conv_mxt4x4_1(unity_ObjectToWorld));
          u_xlat0 = ((conv_mxt4x4_0(unity_ObjectToWorld) * in_v.vertex.xxxx) + u_xlat0);
          u_xlat0 = ((conv_mxt4x4_2(unity_ObjectToWorld) * in_v.vertex.zzzz) + u_xlat0);
          u_xlat1 = (u_xlat0 + conv_mxt4x4_3(unity_ObjectToWorld));
          u_xlat0.xyz = ((conv_mxt4x4_3(unity_ObjectToWorld).xyz * in_v.vertex.www) + u_xlat0.xyz);
          out_v.vertex = mul(unity_MatrixVP, u_xlat1);
          out_v.texcoord.xy = TRANSFORM_TEX(in_v.texcoord.xy, _texcoord);
          out_v.texcoord1.w = u_xlat0.x;
          u_xlat1.y = dot(in_v.normal.xyz, conv_mxt4x4_0(unity_WorldToObject).xyz);
          u_xlat1.z = dot(in_v.normal.xyz, conv_mxt4x4_1(unity_WorldToObject).xyz);
          u_xlat1.x = dot(in_v.normal.xyz, conv_mxt4x4_2(unity_WorldToObject).xyz);
          u_xlat0.x = dot(u_xlat1.xyz, u_xlat1.xyz);
          u_xlat0.x = rsqrt(u_xlat0.x);
          u_xlat1.xyz = (u_xlat0.xxx * u_xlat1.xyz);
          u_xlat2.xyz = (in_v.tangent.yyy * conv_mxt4x4_1(unity_ObjectToWorld).yzx);
          u_xlat2.xyz = ((conv_mxt4x4_0(unity_ObjectToWorld).yzx * in_v.tangent.xxx) + u_xlat2.xyz);
          u_xlat2.xyz = ((conv_mxt4x4_2(unity_ObjectToWorld).yzx * in_v.tangent.zzz) + u_xlat2.xyz);
          u_xlat0.x = dot(u_xlat2.xyz, u_xlat2.xyz);
          u_xlat0.x = rsqrt(u_xlat0.x);
          u_xlat2.xyz = (u_xlat0.xxx * u_xlat2.xyz);
          u_xlat3.xyz = (u_xlat1.xyz * u_xlat2.xyz);
          u_xlat3.xyz = ((u_xlat1.zxy * u_xlat2.yzx) + (-u_xlat3.xyz));
          u_xlat0.x = (in_v.tangent.w * unity_WorldTransformParams.w);
          u_xlat3.xyz = (u_xlat0.xxx * u_xlat3.xyz);
          out_v.texcoord1.y = u_xlat3.x;
          out_v.texcoord1.x = u_xlat2.z;
          out_v.texcoord1.z = u_xlat1.y;
          out_v.texcoord2.x = u_xlat2.x;
          out_v.texcoord3.x = u_xlat2.y;
          out_v.texcoord2.z = u_xlat1.z;
          out_v.texcoord3.z = u_xlat1.x;
          out_v.texcoord2.w = u_xlat0.y;
          out_v.texcoord3.w = u_xlat0.z;
          out_v.texcoord2.y = u_xlat3.y;
          out_v.texcoord3.y = u_xlat3.z;
          out_v.texcoord6 = float4(0, 0, 0, 0);
          out_v.texcoord7 = float4(0, 0, 0, 0);
          return out_v;
      }
      
      #define CODE_BLOCK_FRAGMENT
      float3 u_xlat0_d;
      float2 u_xlat16_0;
      float3 u_xlat1_d;
      float3 u_xlat16_1;
      int u_xlatb1;
      float4 u_xlat16_2;
      float3 u_xlat3_d;
      float3 u_xlat4;
      float3 u_xlat16_4;
      float3 u_xlat16_5;
      float3 u_xlat16_6;
      float3 u_xlat7;
      float3 u_xlat16_8;
      float3 u_xlat16_9;
      float3 u_xlat16_12;
      float2 u_xlat20;
      float u_xlat30;
      float u_xlat16_35;
      float u_xlat16_36;
      OUT_Data_Frag frag(v2f in_f)
      {
          OUT_Data_Frag out_f;
          u_xlat0_d.xy = TRANSFORM_TEX(in_f.texcoord.xy, _MaskMap);
          u_xlat16_0.xy = tex2D(_MaskMap, u_xlat0_d.xy).xy;
          u_xlat1_d.z = (((-u_xlat16_0.y) * _Smooth) + 1);
          u_xlat16_2.x = (((-u_xlat1_d.z) * 0.699999988) + 1.70000005);
          u_xlat16_2.x = (u_xlat1_d.z * u_xlat16_2.x);
          u_xlat16_2.x = (u_xlat16_2.x * 6);
          u_xlat3_d.x = in_f.texcoord1.w;
          u_xlat3_d.y = in_f.texcoord2.w;
          u_xlat3_d.z = in_f.texcoord3.w;
          u_xlat3_d.xyz = ((-u_xlat3_d.xyz) + _WorldSpaceCameraPos.xyz);
          u_xlat20.x = dot(u_xlat3_d.xyz, u_xlat3_d.xyz);
          u_xlat20.x = rsqrt(u_xlat20.x);
          u_xlat3_d.xyz = (u_xlat20.xxx * u_xlat3_d.xyz);
          u_xlat20.xy = TRANSFORM_TEX(in_f.texcoord.xy, _NormalMap);
          u_xlat16_4.xyz = tex2D(_NormalMap, u_xlat20.xy).xyz;
          u_xlat16_12.xyz = ((u_xlat16_4.xyz * float3(2, 2, 2)) + float3(-1, (-1), (-1)));
          u_xlat16_5.x = dot(in_f.texcoord1.xyz, u_xlat16_12.xyz);
          u_xlat16_5.y = dot(in_f.texcoord2.xyz, u_xlat16_12.xyz);
          u_xlat16_5.z = dot(in_f.texcoord3.xyz, u_xlat16_12.xyz);
          u_xlat16_12.x = dot((-u_xlat3_d.xyz), u_xlat16_5.xyz);
          u_xlat16_12.x = (u_xlat16_12.x + u_xlat16_12.x);
          u_xlat16_12.xyz = ((u_xlat16_5.xyz * (-u_xlat16_12.xxx)) + (-u_xlat3_d.xyz));
          u_xlat16_2 = UNITY_SAMPLE_TEXCUBE(unity_SpecCube0, float4(u_xlat16_12.xyz, u_xlat16_2.x));
          u_xlat16_35 = (u_xlat16_2.w + (-1));
          u_xlat16_35 = ((unity_SpecCube0_HDR.w * u_xlat16_35) + 1);
          u_xlat16_35 = (u_xlat16_35 * unity_SpecCube0_HDR.x);
          u_xlat16_6.xyz = (u_xlat16_2.xyz * float3(u_xlat16_35, u_xlat16_35, u_xlat16_35));
          u_xlat20.x = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
          u_xlat20.x = rsqrt(u_xlat20.x);
          u_xlat4.xyz = (u_xlat20.xxx * u_xlat16_5.xyz);
          u_xlat20.x = dot(u_xlat3_d.xyz, u_xlat4.xyz);
          u_xlat30 = u_xlat20.x;
          #ifdef UNITY_ADRENO_ES3
          u_xlat30 = min(max(u_xlat30, 0), 1);
          #else
          u_xlat30 = clamp(u_xlat30, 0, 1);
          #endif
          u_xlat20.x = (u_xlat20.x + u_xlat20.x);
          u_xlat7.xyz = ((u_xlat4.xyz * (-u_xlat20.xxx)) + u_xlat3_d.xyz);
          u_xlat20.x = dot(u_xlat4.xyz, _WorldSpaceLightPos0.xyz);
          #ifdef UNITY_ADRENO_ES3
          u_xlat20.x = min(max(u_xlat20.x, 0), 1);
          #else
          u_xlat20.x = clamp(u_xlat20.x, 0, 1);
          #endif
          u_xlat16_5.xyz = (u_xlat20.xxx * _LightColor0.xyz);
          u_xlat20.x = dot(u_xlat7.xyz, _WorldSpaceLightPos0.xyz);
          u_xlat20.x = (u_xlat20.x * u_xlat20.x);
          u_xlat1_d.x = (u_xlat20.x * u_xlat20.x);
          u_xlat20.x = tex2D(unity_NHxRoughness, u_xlat1_d.xz).x;
          u_xlat20.x = (u_xlat20.x * 16);
          u_xlat16_35 = ((-u_xlat30) + 1);
          u_xlat30 = (u_xlat16_35 * u_xlat16_35);
          u_xlat30 = (u_xlat16_35 * u_xlat30);
          u_xlat30 = (u_xlat16_35 * u_xlat30);
          u_xlat0_d.x = (u_xlat16_0.x * _Metallic);
          u_xlat16_35 = (((-u_xlat0_d.x) * 0.779083729) + 0.779083729);
          u_xlat16_36 = ((-u_xlat16_35) + 1);
          u_xlat16_36 = ((u_xlat16_0.y * _Smooth) + u_xlat16_36);
          #ifdef UNITY_ADRENO_ES3
          u_xlat16_36 = min(max(u_xlat16_36, 0), 1);
          #else
          u_xlat16_36 = clamp(u_xlat16_36, 0, 1);
          #endif
          u_xlat1_d.xy = TRANSFORM_TEX(in_f.texcoord.xy, _AlbedoMap);
          u_xlat16_1.xyz = tex2D(_AlbedoMap, u_xlat1_d.xy).xyz;
          u_xlat16_8.xyz = ((_BaseColor.xyz * u_xlat16_1.xyz) + float3(-0.220916301, (-0.220916301), (-0.220916301)));
          u_xlat1_d.xyz = (u_xlat16_1.xyz * _BaseColor.xyz);
          u_xlat16_8.xyz = ((u_xlat0_d.xxx * u_xlat16_8.xyz) + float3(0.220916301, 0.220916301, 0.220916301));
          u_xlat16_9.xyz = (float3(u_xlat16_36, u_xlat16_36, u_xlat16_36) + (-u_xlat16_8.xyz));
          u_xlat16_9.xyz = ((float3(u_xlat30, u_xlat30, u_xlat30) * u_xlat16_9.xyz) + u_xlat16_8.xyz);
          u_xlat16_8.xyz = (u_xlat20.xxx * u_xlat16_8.xyz);
          u_xlat16_8.xyz = ((u_xlat1_d.xyz * float3(u_xlat16_35, u_xlat16_35, u_xlat16_35)) + u_xlat16_8.xyz);
          u_xlat16_6.xyz = (u_xlat16_6.xyz * u_xlat16_9.xyz);
          u_xlat16_5.xyz = ((u_xlat16_8.xyz * u_xlat16_5.xyz) + u_xlat16_6.xyz);
          u_xlat0_d.xyz = max(u_xlat16_5.xyz, float3(0, 0, 0));
          u_xlat0_d.xyz = min(u_xlat0_d.xyz, _MaxColor.xyz);
          u_xlat1_d.x = in_f.texcoord1.z;
          u_xlat1_d.y = in_f.texcoord2.z;
          u_xlat1_d.z = in_f.texcoord3.z;
          u_xlat30 = dot(u_xlat1_d.xyz, u_xlat3_d.xyz);
          u_xlat30 = ((-u_xlat30) + 1);
          u_xlat1_d.x = (u_xlat30 * u_xlat30);
          u_xlat1_d.x = (u_xlat1_d.x * u_xlat1_d.x);
          u_xlat30 = (u_xlat30 * u_xlat1_d.x);
          u_xlat30 = (u_xlat30 * _SideLightScale);
          #ifdef UNITY_ADRENO_ES3
          u_xlatb1 = (_LightColor0.w==0);
          #else
          u_xlatb1 = (_LightColor0.w==0);
          #endif
          u_xlat1_d.x = (u_xlatb1)?((-0.400000006)):(0.899999976);
          u_xlat30 = (u_xlat30 * u_xlat1_d.x);
          u_xlat30 = (u_xlat30 * 1.66666663);
          u_xlat1_d.xyz = (float3(u_xlat30, u_xlat30, u_xlat30) * _SideLightColor.xyz);
          #ifdef UNITY_ADRENO_ES3
          u_xlat1_d.xyz = min(max(u_xlat1_d.xyz, 0), 1);
          #else
          u_xlat1_d.xyz = clamp(u_xlat1_d.xyz, 0, 1);
          #endif
          u_xlat0_d.xyz = (u_xlat0_d.xyz + u_xlat1_d.xyz);
          out_f.color.xyz = u_xlat0_d.xyz;
          out_f.color.w = 1;
          return out_f;
      }
      
      
      ENDCG
      
    } // end phase
    Pass // ind: 2, name: FORWARD
    {
      Name "FORWARD"
      Tags
      { 
        "LIGHTMODE" = "FORWARDADD"
        "QUEUE" = "Geometry+0"
        "RenderType" = "Opaque"
        "SHADOWSUPPORT" = "true"
      }
      ZWrite Off
      Blend One One
      // m_ProgramMask = 6
      CGPROGRAM
      #pragma multi_compile POINT
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
      //uniform float4 unity_WorldTransformParams;
      //uniform float4x4 unity_MatrixVP;
      uniform float4x4 unity_WorldToLight;
      uniform float4 _texcoord_ST;
      //uniform float3 _WorldSpaceCameraPos;
      //uniform float4 _WorldSpaceLightPos0;
      uniform float4 _LightColor0;
      uniform float _SideLightScale;
      uniform float4 _SideLightColor;
      uniform float4 _BaseColor;
      uniform float4 _AlbedoMap_ST;
      uniform float4 _NormalMap_ST;
      uniform float4 _MaskMap_ST;
      uniform float _Metallic;
      uniform float _Smooth;
      uniform float4 _MaxColor;
      uniform sampler2D _LightTexture0;
      uniform sampler2D _AlbedoMap;
      uniform sampler2D _NormalMap;
      uniform sampler2D _MaskMap;
      uniform sampler2D unity_NHxRoughness;
      struct appdata_t
      {
          float4 vertex :POSITION0;
          float4 tangent :TANGENT0;
          float3 normal :NORMAL0;
          float4 texcoord :TEXCOORD0;
      };
      
      struct OUT_Data_Vert
      {
          float2 texcoord :TEXCOORD0;
          float3 texcoord1 :TEXCOORD1;
          float3 texcoord2 :TEXCOORD2;
          float3 texcoord3 :TEXCOORD3;
          float3 texcoord4 :TEXCOORD4;
          float3 texcoord5 :TEXCOORD5;
          float4 texcoord6 :TEXCOORD6;
          float4 vertex :SV_POSITION;
      };
      
      struct v2f
      {
          float2 texcoord :TEXCOORD0;
          float3 texcoord1 :TEXCOORD1;
          float3 texcoord2 :TEXCOORD2;
          float3 texcoord3 :TEXCOORD3;
          float3 texcoord4 :TEXCOORD4;
      };
      
      struct OUT_Data_Frag
      {
          float4 color :SV_Target0;
      };
      
      float4 u_xlat0;
      float4 u_xlat1;
      float4 u_xlat2;
      float3 u_xlat3;
      float u_xlat13;
      OUT_Data_Vert vert(appdata_t in_v)
      {
          OUT_Data_Vert out_v;
          out_v.vertex = UnityObjectToClipPos(in_v.vertex);
          out_v.texcoord.xy = TRANSFORM_TEX(in_v.texcoord.xy, _texcoord);
          u_xlat1.y = dot(in_v.normal.xyz, conv_mxt4x4_0(unity_WorldToObject).xyz);
          u_xlat1.z = dot(in_v.normal.xyz, conv_mxt4x4_1(unity_WorldToObject).xyz);
          u_xlat1.x = dot(in_v.normal.xyz, conv_mxt4x4_2(unity_WorldToObject).xyz);
          u_xlat1.xyz = normalize(u_xlat1.xyz);
          u_xlat2.xyz = (in_v.tangent.yyy * conv_mxt4x4_1(unity_ObjectToWorld).yzx);
          u_xlat2.xyz = ((conv_mxt4x4_0(unity_ObjectToWorld).yzx * in_v.tangent.xxx) + u_xlat2.xyz);
          u_xlat2.xyz = ((conv_mxt4x4_2(unity_ObjectToWorld).yzx * in_v.tangent.zzz) + u_xlat2.xyz);
          u_xlat2.xyz = normalize(u_xlat2.xyz);
          u_xlat3.xyz = (u_xlat1.xyz * u_xlat2.xyz);
          u_xlat3.xyz = ((u_xlat1.zxy * u_xlat2.yzx) + (-u_xlat3.xyz));
          u_xlat13 = (in_v.tangent.w * unity_WorldTransformParams.w);
          u_xlat3.xyz = (float3(u_xlat13, u_xlat13, u_xlat13) * u_xlat3.xyz);
          out_v.texcoord1.y = u_xlat3.x;
          out_v.texcoord1.x = u_xlat2.z;
          out_v.texcoord1.z = u_xlat1.y;
          out_v.texcoord2.x = u_xlat2.x;
          out_v.texcoord3.x = u_xlat2.y;
          out_v.texcoord2.z = u_xlat1.z;
          out_v.texcoord3.z = u_xlat1.x;
          out_v.texcoord2.y = u_xlat3.y;
          out_v.texcoord3.y = u_xlat3.z;
          out_v.texcoord4.xyz = ((conv_mxt4x4_3(unity_ObjectToWorld).xyz * in_v.vertex.www) + u_xlat0.xyz);
          u_xlat0 = ((conv_mxt4x4_3(unity_ObjectToWorld) * in_v.vertex.wwww) + u_xlat0);
          u_xlat1.xyz = (u_xlat0.yyy * conv_mxt4x4_1(unity_WorldToLight).xyz);
          u_xlat1.xyz = ((conv_mxt4x4_0(unity_WorldToLight).xyz * u_xlat0.xxx) + u_xlat1.xyz);
          u_xlat0.xyz = ((conv_mxt4x4_2(unity_WorldToLight).xyz * u_xlat0.zzz) + u_xlat1.xyz);
          out_v.texcoord5.xyz = ((conv_mxt4x4_3(unity_WorldToLight).xyz * u_xlat0.www) + u_xlat0.xyz);
          out_v.texcoord6 = float4(0, 0, 0, 0);
          return out_v;
      }
      
      #define CODE_BLOCK_FRAGMENT
      float3 u_xlat0_d;
      float3 u_xlat16_0;
      float3 u_xlat16_1;
      float3 u_xlat16_2;
      float3 u_xlat3_d;
      float3 u_xlat4;
      float3 u_xlat16_4;
      float3 u_xlat5;
      float3 u_xlat16_6;
      float3 u_xlat7;
      float2 u_xlat16_7;
      float u_xlat14;
      float u_xlat21;
      float u_xlat16_22;
      OUT_Data_Frag frag(v2f in_f)
      {
          OUT_Data_Frag out_f;
          u_xlat0_d.xy = TRANSFORM_TEX(in_f.texcoord.xy, _NormalMap);
          u_xlat16_0.xyz = tex2D(_NormalMap, u_xlat0_d.xy).xyz;
          u_xlat16_1.xyz = ((u_xlat16_0.xyz * float3(2, 2, 2)) + float3(-1, (-1), (-1)));
          u_xlat16_2.x = dot(in_f.texcoord1.xyz, u_xlat16_1.xyz);
          u_xlat16_2.y = dot(in_f.texcoord2.xyz, u_xlat16_1.xyz);
          u_xlat16_2.z = dot(in_f.texcoord3.xyz, u_xlat16_1.xyz);
          u_xlat0_d.x = dot(u_xlat16_2.xyz, u_xlat16_2.xyz);
          u_xlat0_d.x = rsqrt(u_xlat0_d.x);
          u_xlat0_d.xyz = (u_xlat0_d.xxx * u_xlat16_2.xyz);
          u_xlat3_d.xyz = ((-in_f.texcoord4.xyz) + _WorldSpaceCameraPos.xyz);
          u_xlat3_d.xyz = normalize(u_xlat3_d.xyz);
          u_xlat21 = dot(u_xlat3_d.xyz, u_xlat0_d.xyz);
          u_xlat21 = (u_xlat21 + u_xlat21);
          u_xlat4.xyz = ((u_xlat0_d.xyz * (-float3(u_xlat21, u_xlat21, u_xlat21))) + u_xlat3_d.xyz);
          u_xlat5.xyz = ((-in_f.texcoord4.xyz) + _WorldSpaceLightPos0.xyz);
          u_xlat5.xyz = normalize(u_xlat5.xyz);
          u_xlat21 = dot(u_xlat4.xyz, u_xlat5.xyz);
          u_xlat0_d.x = dot(u_xlat0_d.xyz, u_xlat5.xyz);
          #ifdef UNITY_ADRENO_ES3
          u_xlat0_d.x = min(max(u_xlat0_d.x, 0), 1);
          #else
          u_xlat0_d.x = clamp(u_xlat0_d.x, 0, 1);
          #endif
          u_xlat7.x = (u_xlat21 * u_xlat21);
          u_xlat4.x = (u_xlat7.x * u_xlat7.x);
          u_xlat7.xy = TRANSFORM_TEX(in_f.texcoord.xy, _MaskMap);
          u_xlat16_7.xy = tex2D(_MaskMap, u_xlat7.xy).xy;
          u_xlat4.y = (((-u_xlat16_7.y) * _Smooth) + 1);
          u_xlat7.x = (u_xlat16_7.x * _Metallic);
          u_xlat14 = tex2D(unity_NHxRoughness, u_xlat4.xy).x;
          u_xlat14 = (u_xlat14 * 16);
          u_xlat4.xy = TRANSFORM_TEX(in_f.texcoord.xy, _AlbedoMap);
          u_xlat16_4.xyz = tex2D(_AlbedoMap, u_xlat4.xy).xyz;
          u_xlat16_1.xyz = ((_BaseColor.xyz * u_xlat16_4.xyz) + float3(-0.220916301, (-0.220916301), (-0.220916301)));
          u_xlat4.xyz = (u_xlat16_4.xyz * _BaseColor.xyz);
          u_xlat16_1.xyz = ((u_xlat7.xxx * u_xlat16_1.xyz) + float3(0.220916301, 0.220916301, 0.220916301));
          u_xlat16_22 = (((-u_xlat7.x) * 0.779083729) + 0.779083729);
          u_xlat16_1.xyz = (float3(u_xlat14, u_xlat14, u_xlat14) * u_xlat16_1.xyz);
          u_xlat16_1.xyz = ((u_xlat4.xyz * float3(u_xlat16_22, u_xlat16_22, u_xlat16_22)) + u_xlat16_1.xyz);
          u_xlat7.xyz = (in_f.texcoord4.yyy * conv_mxt4x4_1(unity_WorldToLight).xyz);
          u_xlat7.xyz = ((conv_mxt4x4_0(unity_WorldToLight).xyz * in_f.texcoord4.xxx) + u_xlat7.xyz);
          u_xlat7.xyz = ((conv_mxt4x4_2(unity_WorldToLight).xyz * in_f.texcoord4.zzz) + u_xlat7.xyz);
          u_xlat7.xyz = (u_xlat7.xyz + conv_mxt4x4_3(unity_WorldToLight).xyz);
          u_xlat7.x = dot(u_xlat7.xyz, u_xlat7.xyz);
          u_xlat7.x = tex2D(_LightTexture0, u_xlat7.xx).x;
          u_xlat16_2.xyz = (u_xlat7.xxx * _LightColor0.xyz);
          u_xlat16_6.xyz = (u_xlat0_d.xxx * u_xlat16_2.xyz);
          u_xlat16_1.xyz = (u_xlat16_1.xyz * u_xlat16_6.xyz);
          u_xlat0_d.xyz = max(u_xlat16_1.xyz, float3(0, 0, 0));
          u_xlat0_d.xyz = min(u_xlat0_d.xyz, _MaxColor.xyz);
          u_xlat4.x = in_f.texcoord1.z;
          u_xlat4.y = in_f.texcoord2.z;
          u_xlat4.z = in_f.texcoord3.z;
          u_xlat21 = dot(u_xlat4.xyz, u_xlat3_d.xyz);
          u_xlat21 = ((-u_xlat21) + 1);
          u_xlat3_d.x = (u_xlat21 * u_xlat21);
          u_xlat3_d.x = (u_xlat3_d.x * u_xlat3_d.x);
          u_xlat21 = (u_xlat21 * u_xlat3_d.x);
          u_xlat21 = (u_xlat21 * _SideLightScale);
          u_xlat16_1.xyz = (_LightColor0.xyz + float3(9.99999997E-07, 9.99999997E-07, 9.99999997E-07));
          u_xlat16_1.xyz = (u_xlat16_2.xyz / u_xlat16_1.xyz);
          u_xlat3_d.x = max(u_xlat16_1.y, u_xlat16_1.x);
          u_xlat3_d.x = max(u_xlat16_1.z, u_xlat3_d.x);
          u_xlat3_d.x = ((u_xlat3_d.x * 1.29999995) + (-0.400000006));
          u_xlat21 = (u_xlat21 * u_xlat3_d.x);
          u_xlat21 = (u_xlat21 * 1.66666663);
          u_xlat3_d.xyz = (float3(u_xlat21, u_xlat21, u_xlat21) * _SideLightColor.xyz);
          #ifdef UNITY_ADRENO_ES3
          u_xlat3_d.xyz = min(max(u_xlat3_d.xyz, 0), 1);
          #else
          u_xlat3_d.xyz = clamp(u_xlat3_d.xyz, 0, 1);
          #endif
          u_xlat0_d.xyz = (u_xlat0_d.xyz + u_xlat3_d.xyz);
          out_f.color.xyz = u_xlat0_d.xyz;
          out_f.color.w = 1;
          return out_f;
      }
      
      
      ENDCG
      
    } // end phase
    Pass // ind: 3, name: ShadowCaster
    {
      Name "ShadowCaster"
      Tags
      { 
        "LIGHTMODE" = "SHADOWCASTER"
        "QUEUE" = "Geometry+0"
        "RenderType" = "Opaque"
        "SHADOWSUPPORT" = "true"
      }
      // m_ProgramMask = 6
      CGPROGRAM
      #pragma multi_compile SHADOWS_DEPTH UNITY_PASS_SHADOWCASTER
      //#pragma target 4.0
      
      #pragma vertex vert
      #pragma fragment frag
      
      #include "UnityCG.cginc"
      #define conv_mxt4x4_0(mat4x4) float4(mat4x4[0].x,mat4x4[1].x,mat4x4[2].x,mat4x4[3].x)
      #define conv_mxt4x4_1(mat4x4) float4(mat4x4[0].y,mat4x4[1].y,mat4x4[2].y,mat4x4[3].y)
      #define conv_mxt4x4_2(mat4x4) float4(mat4x4[0].z,mat4x4[1].z,mat4x4[2].z,mat4x4[3].z)
      #define conv_mxt4x4_3(mat4x4) float4(mat4x4[0].w,mat4x4[1].w,mat4x4[2].w,mat4x4[3].w)
      
      
      #define CODE_BLOCK_VERTEX
      //uniform float4 _WorldSpaceLightPos0;
      //uniform float4 unity_LightShadowBias;
      //uniform float4x4 unity_ObjectToWorld;
      //uniform float4x4 unity_WorldToObject;
      //uniform float4 unity_WorldTransformParams;
      //uniform float4x4 unity_MatrixVP;
      struct appdata_t
      {
          float4 vertex :POSITION0;
          float4 tangent :TANGENT0;
          float3 normal :NORMAL0;
          float4 texcoord :TEXCOORD0;
      };
      
      struct OUT_Data_Vert
      {
          float2 texcoord1 :TEXCOORD1;
          float4 texcoord2 :TEXCOORD2;
          float4 texcoord3 :TEXCOORD3;
          float4 texcoord4 :TEXCOORD4;
          float4 vertex :SV_POSITION;
      };
      
      struct v2f
      {
          float2 texcoord1 :TEXCOORD1;
          float4 texcoord2 :TEXCOORD2;
          float4 texcoord3 :TEXCOORD3;
          float4 texcoord4 :TEXCOORD4;
          float4 vertex :Position;
      };
      
      struct OUT_Data_Frag
      {
          float4 color :SV_Target0;
      };
      
      float4 u_xlat0;
      float4 u_xlat1;
      float3 u_xlat2;
      float3 u_xlat16_3;
      float u_xlat8;
      float u_xlat12;
      float u_xlat13;
      int u_xlatb13;
      OUT_Data_Vert vert(appdata_t in_v)
      {
          OUT_Data_Vert out_v;
          u_xlat0 = mul(unity_ObjectToWorld, in_v.vertex);
          u_xlat1.xyz = (((-u_xlat0.xyz) * _WorldSpaceLightPos0.www) + _WorldSpaceLightPos0.xyz);
          u_xlat1.xyz = normalize(u_xlat1.xyz);
          u_xlat2.x = dot(in_v.normal.xyz, conv_mxt4x4_0(unity_WorldToObject).xyz);
          u_xlat2.y = dot(in_v.normal.xyz, conv_mxt4x4_1(unity_WorldToObject).xyz);
          u_xlat2.z = dot(in_v.normal.xyz, conv_mxt4x4_2(unity_WorldToObject).xyz);
          u_xlat2.xyz = normalize(u_xlat2.xyz);
          u_xlat1.x = dot(u_xlat2.xyz, u_xlat1.xyz);
          u_xlat1.x = (((-u_xlat1.x) * u_xlat1.x) + 1);
          u_xlat1.x = sqrt(u_xlat1.x);
          u_xlat1.x = (u_xlat1.x * unity_LightShadowBias.z);
          u_xlat1.xyz = (((-u_xlat2.xyz) * u_xlat1.xxx) + u_xlat0.xyz);
          #ifdef UNITY_ADRENO_ES3
          u_xlatb13 = (unity_LightShadowBias.z!=0);
          #else
          u_xlatb13 = (unity_LightShadowBias.z!=0);
          #endif
          u_xlat0.xyz = (int(u_xlatb13))?(u_xlat1.xyz):(u_xlat0.xyz);
          u_xlat0 = mul(unity_MatrixVP, u_xlat0);
          u_xlat1.x = (unity_LightShadowBias.x / u_xlat0.w);
          #ifdef UNITY_ADRENO_ES3
          u_xlat1.x = min(max(u_xlat1.x, 0), 1);
          #else
          u_xlat1.x = clamp(u_xlat1.x, 0, 1);
          #endif
          u_xlat8 = (u_xlat0.z + u_xlat1.x);
          u_xlat1.x = max((-u_xlat0.w), u_xlat8);
          out_v.vertex.xyw = u_xlat0.xyw;
          u_xlat0.x = ((-u_xlat8) + u_xlat1.x);
          out_v.vertex.z = ((unity_LightShadowBias.y * u_xlat0.x) + u_xlat8);
          out_v.texcoord1.xy = in_v.texcoord.xy;
          u_xlat0.xyz = (in_v.tangent.yyy * conv_mxt4x4_1(unity_ObjectToWorld).yzx);
          u_xlat0.xyz = ((conv_mxt4x4_0(unity_ObjectToWorld).yzx * in_v.tangent.xxx) + u_xlat0.xyz);
          u_xlat0.xyz = ((conv_mxt4x4_2(unity_ObjectToWorld).yzx * in_v.tangent.zzz) + u_xlat0.xyz);
          u_xlat0.xyz = normalize(u_xlat0.xyz);
          u_xlat16_3.xyz = (u_xlat0.xyz * u_xlat2.zxy);
          u_xlat16_3.xyz = ((u_xlat2.yzx * u_xlat0.yzx) + (-u_xlat16_3.xyz));
          u_xlat12 = (in_v.tangent.w * unity_WorldTransformParams.w);
          u_xlat16_3.xyz = (float3(u_xlat12, u_xlat12, u_xlat12) * u_xlat16_3.xyz);
          out_v.texcoord2.y = u_xlat16_3.x;
          out_v.texcoord2.z = u_xlat2.x;
          u_xlat1.xyz = (in_v.vertex.yyy * conv_mxt4x4_1(unity_ObjectToWorld).xyz);
          u_xlat1.xyz = ((conv_mxt4x4_0(unity_ObjectToWorld).xyz * in_v.vertex.xxx) + u_xlat1.xyz);
          u_xlat1.xyz = ((conv_mxt4x4_2(unity_ObjectToWorld).xyz * in_v.vertex.zzz) + u_xlat1.xyz);
          u_xlat1.xyz = ((conv_mxt4x4_3(unity_ObjectToWorld).xyz * in_v.vertex.www) + u_xlat1.xyz);
          out_v.texcoord2.w = u_xlat1.x;
          out_v.texcoord2.x = u_xlat0.z;
          out_v.texcoord3.x = u_xlat0.x;
          out_v.texcoord4.x = u_xlat0.y;
          out_v.texcoord3.z = u_xlat2.y;
          out_v.texcoord4.z = u_xlat2.z;
          out_v.texcoord3.w = u_xlat1.y;
          out_v.texcoord4.w = u_xlat1.z;
          out_v.texcoord3.y = u_xlat16_3.y;
          out_v.texcoord4.y = u_xlat16_3.z;
          return out_v;
      }
      
      #define CODE_BLOCK_FRAGMENT
      OUT_Data_Frag frag(v2f in_f)
      {
          OUT_Data_Frag out_f;
          out_f.color = float4(0, 0, 0, 0);
          return out_f;
      }
      
      
      ENDCG
      
    } // end phase
  }
  FallBack "Diffuse"
}
