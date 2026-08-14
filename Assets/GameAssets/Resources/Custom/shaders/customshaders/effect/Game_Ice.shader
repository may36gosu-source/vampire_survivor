Shader "Game/Ice"
{
  Properties
  {
    [HDR] _TintColor ("Tint Color", Color) = (0.5,0.5,0.5,0.5)
    _MainTex ("RGB+A", 2D) = "white" {}
    _MaskTex ("R:反射强度 G:无用 B:光滑度", 2D) = "white" {}
    _BumpTex ("法线", 2D) = "white" {}
    _BumpScale ("BumpScale", Range(0, 3)) = 1
    _ReflectStrength ("反射强度", Range(0, 1)) = 0.7
    _Matcap ("金属matcap纹理", 2D) = "white" {}
    _MatcapScale ("MatcapScale", Range(0, 3)) = 1
    _MatcapAlphaStrength ("金属反射透明度", Range(1, 30)) = 3
    [HDR] _FresnelColor ("FresnelColor", Color) = (0.5,0.5,0.5,0.5)
    _FresnelStrength ("菲尼尔", Range(0, 9)) = 2
  }
  SubShader
  {
    Tags
    { 
      "IGNOREPROJECTOR" = "true"
      "PreviewType" = "Plane"
      "QUEUE" = "Transparent"
      "RenderType" = "Transparent"
    }
    Pass // ind: 1, name: 
    {
      Tags
      { 
        "IGNOREPROJECTOR" = "true"
        "PreviewType" = "Plane"
        "QUEUE" = "Transparent"
        "RenderType" = "Transparent"
      }
      Blend SrcAlpha OneMinusSrcAlpha
      // m_ProgramMask = 6
      CGPROGRAM
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
      uniform float4 _MainTex_ST;
      uniform float4 _TintColor;
      uniform float _BumpScale;
      uniform float _MatcapScale;
      uniform float _ReflectStrength;
      uniform float _MatcapAlphaStrength;
      uniform float _FresnelStrength;
      uniform float4 _FresnelColor;
      uniform sampler2D _MaskTex;
      uniform sampler2D _MainTex;
      uniform sampler2D _BumpTex;
      uniform sampler2D _Matcap;
      struct appdata_t
      {
          float4 vertex :POSITION0;
          float3 normal :NORMAL0;
          float4 color :COLOR0;
          float2 texcoord :TEXCOORD0;
      };
      
      struct OUT_Data_Vert
      {
          float4 color :COLOR0;
          float2 texcoord :TEXCOORD0;
          float3 texcoord3 :TEXCOORD3;
          float3 texcoord4 :TEXCOORD4;
          float4 vertex :SV_POSITION;
      };
      
      struct v2f
      {
          float4 color :COLOR0;
          float2 texcoord :TEXCOORD0;
          float3 texcoord3 :TEXCOORD3;
          float3 texcoord4 :TEXCOORD4;
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
          u_xlat0 = mul(unity_ObjectToWorld, float4(in_v.vertex.xyz,1.0));
          out_v.vertex = mul(unity_MatrixVP, u_xlat0);
          out_v.color = in_v.color;
          out_v.texcoord.xy = TRANSFORM_TEX(in_v.texcoord.xy, _MainTex);
          out_v.texcoord3.x = dot(in_v.normal.xyz, conv_mxt4x4_0(unity_WorldToObject).xyz);
          out_v.texcoord3.y = dot(in_v.normal.xyz, conv_mxt4x4_1(unity_WorldToObject).xyz);
          out_v.texcoord3.z = dot(in_v.normal.xyz, conv_mxt4x4_2(unity_WorldToObject).xyz);
          u_xlat1.xyz = (u_xlat0.yyy * conv_mxt4x4_1(unity_MatrixV).xyz);
          u_xlat1.xyz = ((conv_mxt4x4_0(unity_MatrixV).xyz * u_xlat0.xxx) + u_xlat1.xyz);
          u_xlat0.xyz = ((conv_mxt4x4_2(unity_MatrixV).xyz * u_xlat0.zzz) + u_xlat1.xyz);
          out_v.texcoord4.xyz = ((conv_mxt4x4_3(unity_MatrixV).xyz * u_xlat0.www) + u_xlat0.xyz);
          return out_v;
      }
      
      #define CODE_BLOCK_FRAGMENT
      float4 u_xlat0_d;
      float4 u_xlat1_d;
      float4 u_xlat16_1;
      float3 u_xlat2;
      float4 u_xlat16_2;
      float3 u_xlat16_3;
      float4 u_xlat4;
      float u_xlat11;
      float2 u_xlat16_11;
      float u_xlat15;
      OUT_Data_Frag frag(v2f in_f)
      {
          OUT_Data_Frag out_f;
          u_xlat0_d.x = dot(in_f.texcoord3.xyz, in_f.texcoord3.xyz);
          u_xlat0_d.x = rsqrt(u_xlat0_d.x);
          u_xlat0_d.xyz = (u_xlat0_d.xxx * in_f.texcoord3.xyz);
          u_xlat1_d = (u_xlat0_d.yyyy * conv_mxt4x4_1(unity_MatrixV).zxyz);
          u_xlat1_d = ((conv_mxt4x4_0(unity_MatrixV).zxyz * u_xlat0_d.xxxx) + u_xlat1_d);
          u_xlat0_d = ((conv_mxt4x4_2(unity_MatrixV).zxyz * u_xlat0_d.zzzz) + u_xlat1_d);
          u_xlat1_d.x = dot(in_f.texcoord4.xyz, in_f.texcoord4.xyz);
          u_xlat1_d.x = rsqrt(u_xlat1_d.x);
          u_xlat1_d = (u_xlat1_d.xxxx * in_f.texcoord4.yzzx);
          u_xlat2.xy = (u_xlat0_d.zw * u_xlat1_d.zw);
          u_xlat2.xy = ((u_xlat1_d.yx * u_xlat0_d.yx) + (-u_xlat2.yx));
          u_xlat0_d.x = dot(u_xlat0_d.zwy, u_xlat1_d.xzw);
          u_xlat0_d.x = ((-abs(u_xlat0_d.x)) + 1);
          u_xlat0_d.x = log2(u_xlat0_d.x);
          u_xlat0_d.x = (u_xlat0_d.x * _FresnelStrength);
          u_xlat0_d.x = exp2(u_xlat0_d.x);
          u_xlat0_d.xyz = (u_xlat0_d.xxx * _FresnelColor.xyz);
          u_xlat1_d.xy = ((u_xlat2.xy * float2(-0.5, 0.5)) + float2(0.5, 0.5));
          u_xlat16_11.xy = tex2D(_BumpTex, in_f.texcoord.xy).xy;
          u_xlat16_3.xy = ((u_xlat16_11.xy * float2(2, 2)) + float2(-1, (-1)));
          u_xlat1_d.xy = ((u_xlat16_3.xy * float2(_BumpScale, _BumpScale)) + u_xlat1_d.xy);
          u_xlat16_11.xy = tex2D(_MaskTex, in_f.texcoord.xy).xz;
          u_xlat15 = ((-u_xlat16_11.y) + 1);
          u_xlat11 = (u_xlat16_11.x * _ReflectStrength);
          u_xlat15 = (u_xlat15 * 7);
          u_xlat16_1.xyw = tex2Dlod(_Matcap, float4(float3(u_xlat1_d.xy, 0), u_xlat15)).xyz;
          u_xlat16_2 = tex2D(_MainTex, in_f.texcoord.xy);
          u_xlat16_3.xyz = (u_xlat16_2.xyz * in_f.color.xyz);
          u_xlat2.xyz = ((u_xlat16_1.xyw * float3(float3(_MatcapScale, _MatcapScale, _MatcapScale))) + (-u_xlat16_3.xyz));
          u_xlat15 = (u_xlat16_1.x * _MatcapScale);
          u_xlat15 = log2(u_xlat15);
          u_xlat15 = (u_xlat15 * _MatcapAlphaStrength);
          u_xlat15 = exp2(u_xlat15);
          u_xlat4.w = ((u_xlat16_2.w * _TintColor.w) + u_xlat15);
          #ifdef UNITY_ADRENO_ES3
          u_xlat4.w = min(max(u_xlat4.w, 0), 1);
          #else
          u_xlat4.w = clamp(u_xlat4.w, 0, 1);
          #endif
          u_xlat1_d.xyz = ((float3(u_xlat11, u_xlat11, u_xlat11) * u_xlat2.xyz) + u_xlat16_3.xyz);
          u_xlat4.xyz = ((u_xlat1_d.xyz * _TintColor.xyz) + u_xlat0_d.xyz);
          out_f.color = u_xlat4;
          return out_f;
      }
      
      
      ENDCG
      
    } // end phase
  }
  FallBack Off
}
