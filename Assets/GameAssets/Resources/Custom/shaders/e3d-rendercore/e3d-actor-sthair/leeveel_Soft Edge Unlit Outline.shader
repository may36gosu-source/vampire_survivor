Shader "leeveel/Soft Edge Unlit Outline"
{
  Properties
  {
    _Color ("Main Color", Color) = (1,1,1,1)
    _MainTex ("Base (RGB) Alpha (A)", 2D) = "white" {}
    _Cutoff ("Base Alpha cutoff", Range(0, 0.9)) = 0.9
    [Enum(UnityEngine.Rendering.CullMode)] _Cull ("Cull Mode", float) = 2
    [Header(IsSelected)] [Toggle] _IsSelected ("INVALID_UTF8_STRING", Range(0, 1)) = 0
    _OutlineWidth ("Outline Width", Range(0, 10)) = 1
    _OutlineColor ("Outline Color", Color) = (1,1,1,1)
  }
  SubShader
  {
    Tags
    { 
      "IGNOREPROJECTOR" = "true"
      "QUEUE" = "AlphaTest"
      "RenderType" = "TransparentCutout"
    }
    Pass // ind: 1, name: 
    {
      Tags
      { 
        "IGNOREPROJECTOR" = "true"
        "QUEUE" = "AlphaTest"
        "RenderType" = "TransparentCutout"
      }
      Cull Off
      // m_ProgramMask = 6
      CGPROGRAM
      //#pragma target 4.0
      
      #pragma vertex vert
      #pragma fragment frag
      
      #include "UnityCG.cginc"
      
      
      #define CODE_BLOCK_VERTEX
      //uniform float4x4 unity_ObjectToWorld;
      //uniform float4x4 unity_MatrixVP;
      uniform float4 _MainTex_ST;
      uniform float _Cutoff;
      uniform float4 _Color;
      uniform float4 _MainTex_TexelSize;
      uniform float _OutlineWidth;
      uniform float3 _OutlineColor;
      uniform float _IsSelected;
      uniform sampler2D _MainTex;
      struct appdata_t
      {
          float4 vertex :POSITION0;
          float4 color :COLOR0;
          float2 texcoord :TEXCOORD0;
      };
      
      struct OUT_Data_Vert
      {
          float4 color :COLOR0;
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
          out_v.vertex = UnityObjectToClipPos(in_v.vertex);
          out_v.color = in_v.color;
          out_v.texcoord.xy = TRANSFORM_TEX(in_v.texcoord.xy, _MainTex);
          return out_v;
      }
      
      #define CODE_BLOCK_FRAGMENT
      float4 u_xlat0_d;
      float4 u_xlat16_0;
      float4 u_xlat1_d;
      float4 u_xlat16_1;
      float4 u_xlat2;
      float u_xlat16_2;
      int u_xlatb2;
      float3 u_xlat5;
      float u_xlat16_5;
      float u_xlat16_8;
      OUT_Data_Frag frag(v2f in_f)
      {
          OUT_Data_Frag out_f;
          u_xlat16_0 = tex2D(_MainTex, in_f.texcoord.xy);
          u_xlat16_1.x = ((_Color.w * u_xlat16_0.w) + (-_Cutoff));
          #ifdef UNITY_ADRENO_ES3
          u_xlatb2 = (u_xlat16_1.x<0);
          #else
          u_xlatb2 = (u_xlat16_1.x<0);
          #endif
          if(u_xlatb2)
          {
              discard;
          }
          u_xlat1_d = (float4(_OutlineWidth, _OutlineWidth, _OutlineWidth, _OutlineWidth) * float4(-1, 0, 1, 0));
          u_xlat2 = ((u_xlat1_d.wzyx * _MainTex_TexelSize.xyxy) + in_f.texcoord.xyxy);
          u_xlat1_d = ((u_xlat1_d * _MainTex_TexelSize.xyxy) + in_f.texcoord.xyxy);
          u_xlat16_2 = tex2D(_MainTex, u_xlat2.xy).w;
          u_xlat16_5 = tex2D(_MainTex, u_xlat2.zw).w;
          u_xlat2.x = (u_xlat16_5 * u_xlat16_2);
          u_xlat16_5 = tex2D(_MainTex, u_xlat1_d.xy).w;
          u_xlat16_8 = tex2D(_MainTex, u_xlat1_d.zw).w;
          u_xlat2.x = (u_xlat16_5 * u_xlat2.x);
          u_xlat2.x = (u_xlat16_8 * u_xlat2.x);
          u_xlat5.xyz = ((_Color.xyz * u_xlat16_0.xyz) + (-_OutlineColor.xyz));
          u_xlat2.xyz = ((u_xlat2.xxx * u_xlat5.xyz) + _OutlineColor.xyz);
          u_xlat16_1.xyz = (((-_Color.xyz) * u_xlat16_0.xyz) + u_xlat2.xyz);
          u_xlat0_d = (u_xlat16_0 * _Color);
          u_xlat16_1.w = 0;
          out_f.color = ((float4(float4(_IsSelected, _IsSelected, _IsSelected, _IsSelected)) * u_xlat16_1) + u_xlat0_d);
          return out_f;
      }
      
      
      ENDCG
      
    } // end phase
    Pass // ind: 2, name: 
    {
      Tags
      { 
        "IGNOREPROJECTOR" = "true"
        "QUEUE" = "AlphaTest"
        "RenderType" = "TransparentCutout"
        "RequireOption" = "SoftVegetation"
      }
      ZWrite Off
      Cull Off
      Blend SrcAlpha OneMinusSrcAlpha
      // m_ProgramMask = 6
      CGPROGRAM
      //#pragma target 4.0
      
      #pragma vertex vert
      #pragma fragment frag
      
      #include "UnityCG.cginc"
      
      
      #define CODE_BLOCK_VERTEX
      //uniform float4x4 unity_ObjectToWorld;
      //uniform float4x4 unity_MatrixVP;
      uniform float4 _MainTex_ST;
      uniform float _Cutoff;
      uniform float4 _Color;
      uniform sampler2D _MainTex;
      struct appdata_t
      {
          float4 vertex :POSITION0;
          float4 color :COLOR0;
          float2 texcoord :TEXCOORD0;
      };
      
      struct OUT_Data_Vert
      {
          float4 color :COLOR0;
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
          out_v.vertex = UnityObjectToClipPos(in_v.vertex);
          out_v.color = in_v.color;
          out_v.texcoord.xy = TRANSFORM_TEX(in_v.texcoord.xy, _MainTex);
          return out_v;
      }
      
      #define CODE_BLOCK_FRAGMENT
      float4 u_xlat0_d;
      float4 u_xlat16_0;
      int u_xlatb0;
      float u_xlat1_d;
      OUT_Data_Frag frag(v2f in_f)
      {
          OUT_Data_Frag out_f;
          u_xlat16_0 = tex2D(_MainTex, in_f.texcoord.xy);
          u_xlat1_d = ((_Color.w * u_xlat16_0.w) + (-_Cutoff));
          u_xlat0_d = (u_xlat16_0 * _Color);
          out_f.color = u_xlat0_d;
          #ifdef UNITY_ADRENO_ES3
          u_xlatb0 = ((-u_xlat1_d)<0);
          #else
          u_xlatb0 = ((-u_xlat1_d)<0);
          #endif
          if(u_xlatb0)
          {
              discard;
          }
          return out_f;
      }
      
      
      ENDCG
      
    } // end phase
  }
  FallBack Off
}
