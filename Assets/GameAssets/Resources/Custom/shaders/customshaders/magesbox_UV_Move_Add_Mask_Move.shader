Shader "magesbox/UV_Move_Add_Mask_Move"
{
  Properties
  {
    _Texures ("Texures", 2D) = "white" {}
    [HDR] _Color ("Color", Color) = (0.5,0.5,0.5,1)
    _Mask ("Mask", 2D) = "white" {}
    _U_Move ("U_Move", float) = 0
    _V_Move ("V_Move", float) = 0
    _U_Move_Mask ("U_Move_Mask", float) = 0
    _V_Move_Mask ("V_Move_Mask", float) = 0
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
      //uniform float4 _Time;
      uniform float4 _Texures_ST;
      uniform float4 _Color;
      uniform float4 _Mask_ST;
      uniform float _U_Move;
      uniform float _V_Move;
      uniform float _U_Move_Mask;
      uniform float _V_Move_Mask;
      uniform sampler2D _Texures;
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
          out_v.color = in_v.color;
          return out_v;
      }
      
      #define CODE_BLOCK_FRAGMENT
      float4 u_xlat0_d;
      float3 u_xlat16_0;
      float3 u_xlat16_1;
      float2 u_xlat4;
      OUT_Data_Frag frag(v2f in_f)
      {
          OUT_Data_Frag out_f;
          u_xlat0_d = ((float4(_U_Move, _V_Move, _U_Move_Mask, _V_Move_Mask) * _Time.yyyy) + in_f.texcoord.xyxy);
          u_xlat0_d.xy = TRANSFORM_TEX(u_xlat0_d.xy, _Texures);
          u_xlat4.xy = TRANSFORM_TEX(u_xlat0_d.zw, _Mask);
          u_xlat16_1.xyz = tex2D(_Mask, u_xlat4.xy).xyz;
          u_xlat16_0.xyz = tex2D(_Texures, u_xlat0_d.xy).xyz;
          u_xlat0_d.xyz = (u_xlat16_0.xyz * _Color.xyz);
          u_xlat0_d.xyz = (u_xlat0_d.xyz * in_f.color.xyz);
          out_f.color.xyz = (u_xlat16_1.xyz * u_xlat0_d.xyz);
          out_f.color.w = 1;
          return out_f;
      }
      
      
      ENDCG
      
    } // end phase
  }
  FallBack Off
}
