Shader "magesbox/UV_Move_Add_UV"
{
  Properties
  {
    _Texures ("Texures", 2D) = "white" {}
    [HDR] _Color ("Color", Color) = (0.5,0.5,0.5,1)
    _Mask ("Mask", 2D) = "white" {}
    [HideInInspector] _Cutoff ("Alpha cutoff", Range(0, 1)) = 0.5
    [Enum(Disable,0,LessEqual,4,GreaterEqual,7)] _ZTest ("ZTest", float) = 4
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
      Blend One One
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
      uniform float4 _Texures_ST;
      uniform float4 _Color;
      uniform float4 _Mask_ST;
      uniform sampler2D _Texures;
      uniform sampler2D _Mask;
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
      float3 u_xlat0_d;
      float3 u_xlat16_0;
      float2 u_xlat1_d;
      float4 u_xlat16_1;
      OUT_Data_Frag frag(v2f in_f)
      {
          OUT_Data_Frag out_f;
          u_xlat0_d.xy = (in_f.texcoord.xy + in_f.texcoord1.zw);
          u_xlat0_d.xy = TRANSFORM_TEX(u_xlat0_d.xy, _Texures);
          u_xlat16_0.xyz = tex2D(_Texures, u_xlat0_d.xy).xyz;
          u_xlat0_d.xyz = (u_xlat16_0.xyz * _Color.xyz);
          u_xlat0_d.xyz = (u_xlat0_d.xyz * in_f.color.xyz);
          u_xlat1_d.xy = TRANSFORM_TEX(in_f.texcoord.xy, _Mask);
          u_xlat16_1 = tex2D(_Mask, u_xlat1_d.xy);
          out_f.color.xyz = (u_xlat0_d.xyz * u_xlat16_1.xyz);
          u_xlat0_d.x = (u_xlat16_1.w * _Color.w);
          out_f.color.w = (u_xlat0_d.x * in_f.color.w);
          return out_f;
      }
      
      
      ENDCG
      
    } // end phase
  }
  FallBack "Diffuse"
}
