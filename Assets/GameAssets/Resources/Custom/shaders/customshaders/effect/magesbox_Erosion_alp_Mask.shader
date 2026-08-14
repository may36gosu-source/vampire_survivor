Shader "magesbox/Erosion_alp_Mask"
{
  Properties
  {
    _Texure ("Texure", 2D) = "white" {}
    [HDR] _Color ("Color", Color) = (0.5,0.5,0.5,1)
    _Erosion ("Erosion", 2D) = "white" {}
    _Soft_Value ("Soft_Value", float) = 0
    [HideInInspector] _Cutoff ("Alpha cutoff", Range(0, 1)) = 0.5
    [Enum(Disable,0,LessEqual,4,GreaterEqual,7)] _ZTest ("ZTest", float) = 4
    _StencilComp ("Stencil Comparison", float) = 8
    _Stencil ("Stencil ID", float) = 0
    _StencilOp ("Stencil Operation", float) = 0
    _StencilWriteMask ("Stencil Write Mask", float) = 255
    _StencilReadMask ("Stencil Read Mask", float) = 255
    _ColorMask ("Color Mask", float) = 15
  }
  SubShader
  {
    Tags
    { 
      "IGNOREPROJECTOR" = "true"
      "QUEUE" = "Transparent"
      "RenderType" = "Transparent"
    }
    Pass // ind: 1, name: FORWARD
    {
      Name "FORWARD"
      Tags
      { 
        "IGNOREPROJECTOR" = "true"
        "LIGHTMODE" = "FORWARDBASE"
        "QUEUE" = "Transparent"
        "RenderType" = "Transparent"
        "SHADOWSUPPORT" = "true"
      }
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
      Blend SrcAlpha OneMinusSrcAlpha
      // m_ProgramMask = 6
      CGPROGRAM
      #pragma multi_compile DIRECTIONAL
      //#pragma target 4.0
      
      #pragma vertex vert
      #pragma fragment frag
      
      #include "UnityCG.cginc"
      
      
      #define CODE_BLOCK_VERTEX
      //uniform float4x4 unity_ObjectToWorld;
      //uniform float4x4 unity_MatrixVP;
      uniform float4 _Texure_ST;
      uniform float4 _Color;
      uniform float4 _Erosion_ST;
      uniform float _Soft_Value;
      uniform sampler2D _Texure;
      uniform sampler2D _Erosion;
      struct appdata_t
      {
          float4 vertex :POSITION0;
          float2 texcoord :TEXCOORD0;
          float4 texcoord1 :TEXCOORD1;
          float4 color :COLOR0;
      };
      
      struct OUT_Data_Vert
      {
          float2 texcoord :TEXCOORD0;
          float4 texcoord1 :TEXCOORD1;
          float4 color :COLOR0;
          float4 vertex :SV_POSITION;
      };
      
      struct v2f
      {
          float2 texcoord :TEXCOORD0;
          float4 texcoord1 :TEXCOORD1;
          float4 color :COLOR0;
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
          out_v.texcoord.xy = in_v.texcoord.xy;
          out_v.texcoord1 = in_v.texcoord1;
          out_v.color = in_v.color;
          return out_v;
      }
      
      #define CODE_BLOCK_FRAGMENT
      float2 u_xlat0_d;
      float u_xlat16_0;
      float3 u_xlat1_d;
      float4 u_xlat16_1;
      float3 u_xlat2;
      OUT_Data_Frag frag(v2f in_f)
      {
          OUT_Data_Frag out_f;
          u_xlat0_d.xy = TRANSFORM_TEX(in_f.texcoord.xy, _Erosion);
          u_xlat16_0 = tex2D(_Erosion, u_xlat0_d.xy).x;
          u_xlat2.x = ((-_Soft_Value) + (-1.5));
          u_xlat2.x = ((in_f.texcoord1.x * u_xlat2.x) + _Soft_Value);
          u_xlat0_d.x = ((u_xlat16_0 * _Soft_Value) + (-u_xlat2.x));
          #ifdef UNITY_ADRENO_ES3
          u_xlat0_d.x = min(max(u_xlat0_d.x, 0), 1);
          #else
          u_xlat0_d.x = clamp(u_xlat0_d.x, 0, 1);
          #endif
          u_xlat2.xyz = (u_xlat0_d.xxx * in_f.color.xyz);
          u_xlat1_d.xy = TRANSFORM_TEX(in_f.texcoord.xy, _Texure);
          u_xlat16_1 = tex2D(_Texure, u_xlat1_d.xy);
          u_xlat1_d.xyz = (u_xlat16_1.xyz * _Color.xyz);
          out_f.color.xyz = (u_xlat2.xyz * u_xlat1_d.xyz);
          u_xlat2.x = (in_f.color.w * _Color.w);
          u_xlat2.x = (u_xlat16_1.w * u_xlat2.x);
          out_f.color.w = (u_xlat0_d.x * u_xlat2.x);
          return out_f;
      }
      
      
      ENDCG
      
    } // end phase
  }
  FallBack "Diffuse"
}
