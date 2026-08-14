Shader "Xffect/displacement/screen"
{
  Properties
  {
    _DispMap ("Displacement Map (RG)", 2D) = "white" {}
    _MaskTex ("Mask (R)", 2D) = "white" {}
    _DispScrollSpeedX ("Map Scroll Speed X", float) = 0
    _DispScrollSpeedY ("Map Scroll Speed Y", float) = 0
    _StrengthX ("Displacement Strength X", float) = 1
    _StrengthY ("Displacement Strength Y", float) = -1
  }
  SubShader
  {
    Tags
    { 
      "QUEUE" = "Transparent+99"
      "RenderType" = "Transparent"
    }
    Pass // ind: 1, name: 
    {
      Tags
      { 
      }
      ZClip Off
      ZWrite Off
      Cull Off
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
      // m_ProgramMask = 0
      
    } // end phase
    Pass // ind: 2, name: BASE
    {
      Name "BASE"
      Tags
      { 
        "LIGHTMODE" = "ALWAYS"
        "QUEUE" = "Transparent+99"
        "RenderType" = "Transparent"
      }
      ZTest Always
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
      uniform float4 _DispMap_ST;
      //uniform float4 _Time;
      uniform float _StrengthX;
      uniform float _StrengthY;
      uniform float _DispScrollSpeedY;
      uniform float _DispScrollSpeedX;
      uniform sampler2D _DispMap;
      uniform sampler2D _GrabTexture;
      uniform sampler2D _MaskTex;
      struct appdata_t
      {
          float4 vertex :POSITION0;
          float4 color :COLOR0;
          float2 texcoord :TEXCOORD0;
          float2 texcoord1 :TEXCOORD1;
      };
      
      struct OUT_Data_Vert
      {
          float4 color :COLOR0;
          float2 texcoord :TEXCOORD0;
          float2 texcoord1 :TEXCOORD1;
          float4 texcoord2 :TEXCOORD2;
          float4 vertex :SV_POSITION;
      };
      
      struct v2f
      {
          float4 color :COLOR0;
          float2 texcoord :TEXCOORD0;
          float2 texcoord1 :TEXCOORD1;
          float4 texcoord2 :TEXCOORD2;
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
          u_xlat0 = UnityObjectToClipPos(in_v.vertex);
          out_v.vertex = u_xlat0;
          out_v.color = in_v.color;
          out_v.texcoord.xy = TRANSFORM_TEX(in_v.texcoord.xy, _DispMap);
          out_v.texcoord1.xy = in_v.texcoord1.xy;
          u_xlat0.xy = (u_xlat0.ww + u_xlat0.xy);
          out_v.texcoord2.zw = u_xlat0.zw;
          out_v.texcoord2.xy = (u_xlat0.xy * float2(0.5, 0.5));
          return out_v;
      }
      
      #define CODE_BLOCK_FRAGMENT
      float2 u_xlat0_d;
      float3 u_xlat16_0;
      float2 u_xlat16_1;
      OUT_Data_Frag frag(v2f in_f)
      {
          OUT_Data_Frag out_f;
          u_xlat0_d.xy = ((_Time.yy * float2(_DispScrollSpeedX, _DispScrollSpeedY)) + in_f.texcoord.xy);
          u_xlat16_0.xy = tex2D(_DispMap, u_xlat0_d.xy).xy;
          u_xlat16_1.xy = (u_xlat16_0.xy * float2(_StrengthX, _StrengthY));
          u_xlat0_d.xy = ((u_xlat16_1.xy * in_f.texcoord1.xx) + in_f.texcoord2.xy);
          u_xlat0_d.xy = (u_xlat0_d.xy / in_f.texcoord2.ww);
          u_xlat16_0.xyz = tex2D(_GrabTexture, u_xlat0_d.xy).xyz;
          out_f.color.xyz = u_xlat16_0.xyz;
          u_xlat16_0.x = tex2D(_MaskTex, in_f.texcoord.xy).x;
          out_f.color.w = (u_xlat16_0.x * in_f.color.w);
          return out_f;
      }
      
      
      ENDCG
      
    } // end phase
  }
  SubShader
  {
    Tags
    { 
      "QUEUE" = "Transparent+99"
      "RenderType" = "Transparent"
    }
    Pass // ind: 1, name: BASE
    {
      Name "BASE"
      Tags
      { 
        "QUEUE" = "Transparent+99"
        "RenderType" = "Transparent"
      }
      ZTest Always
      ZWrite Off
      Cull Off
      Fog
      { 
        Mode  Off
      } 
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
      uniform sampler2D _MainTex;
      struct appdata_t
      {
          float3 vertex :POSITION0;
          float4 color :COLOR0;
          float3 texcoord :TEXCOORD0;
      };
      
      struct OUT_Data_Vert
      {
          float4 color :COLOR0;
          float2 texcoord :TEXCOORD0;
          float4 vertex :SV_POSITION;
      };
      
      struct v2f
      {
          float4 color :COLOR0;
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
          out_v.color = in_v.color;
          #ifdef UNITY_ADRENO_ES3
          out_v.color = min(max(out_v.color, 0), 1);
          #else
          out_v.color = clamp(out_v.color, 0, 1);
          #endif
          out_v.texcoord.xy = TRANSFORM_TEX(in_v.texcoord.xy, _MainTex);
          out_v.vertex = UnityObjectToClipPos(float4(in_v.vertex, 0));
          return out_v;
      }
      
      #define CODE_BLOCK_FRAGMENT
      float4 u_xlat16_0;
      float3 u_xlat16_1;
      OUT_Data_Frag frag(v2f in_f)
      {
          OUT_Data_Frag out_f;
          u_xlat16_0 = tex2D(_MainTex, in_f.texcoord.xy);
          u_xlat16_1.xyz = (u_xlat16_0.xyz * in_f.color.xyz);
          out_f.color.w = (u_xlat16_0.w * in_f.color.w);
          out_f.color.xyz = (u_xlat16_1.xyz + u_xlat16_1.xyz);
          return out_f;
      }
      
      
      ENDCG
      
    } // end phase
  }
  FallBack Off
}
