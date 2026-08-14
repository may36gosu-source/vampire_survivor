Shader "magesbox/UV_Move_alp"
{
  Properties
  {
    [Toggle] _UseVertexColor ("使用顶点色", Range(0, 1)) = 1
    _texures ("texures", 2D) = "white" {}
    [HDR] _color ("color", Color) = (0.5,0.5,0.5,1)
    _Mask ("Mask", 2D) = "white" {}
    _U_move ("U_move", float) = 0
    _V_move ("V_move", float) = 0
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
      uniform float _UseVertexColor;
      //uniform float4 _Time;
      uniform float4 _texures_ST;
      uniform float4 _color;
      uniform float4 _Mask_ST;
      uniform float _U_move;
      uniform float _V_move;
      uniform sampler2D _texures;
      uniform sampler2D _Mask;
      struct appdata_t
      {
          float4 vertex :POSITION0;
          float2 texcoord :TEXCOORD0;
          float4 color :COLOR0;
      };
      
      struct OUT_Data_Vert
      {
          float2 texcoord :TEXCOORD0;
          float4 color :COLOR0;
          float4 vertex :SV_POSITION;
      };
      
      struct v2f
      {
          float2 texcoord :TEXCOORD0;
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
          u_xlat0 = (in_v.color + float4(-1, (-1), (-1), (-1)));
          out_v.color = ((float4(float4(_UseVertexColor, _UseVertexColor, _UseVertexColor, _UseVertexColor)) * u_xlat0) + float4(1, 1, 1, 1));
          return out_v;
      }
      
      #define CODE_BLOCK_FRAGMENT
      float4 u_xlat0_d;
      float4 u_xlat16_0;
      float2 u_xlat1_d;
      float4 u_xlat16_1;
      OUT_Data_Frag frag(v2f in_f)
      {
          OUT_Data_Frag out_f;
          u_xlat0_d.xy = ((float2(_U_move, _V_move) * _Time.yy) + in_f.texcoord.xy);
          u_xlat0_d.xy = TRANSFORM_TEX(u_xlat0_d.xy, _texures);
          u_xlat16_0 = tex2D(_texures, u_xlat0_d.xy);
          u_xlat16_0.w = (u_xlat16_0.w * _color.w);
          u_xlat0_d = (u_xlat16_0 * in_f.color);
          u_xlat0_d.xyz = (u_xlat0_d.xyz * _color.xyz);
          u_xlat1_d.xy = TRANSFORM_TEX(in_f.texcoord.xy, _Mask);
          u_xlat16_1 = tex2D(_Mask, u_xlat1_d.xy);
          out_f.color = (u_xlat0_d * u_xlat16_1);
          return out_f;
      }
      
      
      ENDCG
      
    } // end phase
  }
  FallBack "Diffuse"
}
