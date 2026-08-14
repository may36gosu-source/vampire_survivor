Shader "magesbox/Erosion_add_erosion_UV_Mask"
{
  Properties
  {
    _Texure ("Texure", 2D) = "white" {}
    _U_Move ("U_Move", float) = 0
    _V_Move ("V_Move", float) = 0
    [HDR] _Color ("Color", Color) = (0.5,0.5,0.5,1)
    _Erosion ("Erosion", 2D) = "white" {}
    _Soft_Value ("Soft_Value", float) = 0
    _U_Erosion ("U_Erosion", float) = 0
    _V_Erosion ("V_Erosion", float) = 0
    _Mask ("Mask", 2D) = "white" {}
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
      uniform float4 _Texure_ST;
      uniform float4 _Color;
      uniform float4 _Erosion_ST;
      uniform float _Soft_Value;
      uniform float _U_Erosion;
      uniform float _V_Erosion;
      uniform float _U_Move;
      uniform float _V_Move;
      uniform float4 _Mask_ST;
      uniform sampler2D _Texure;
      uniform sampler2D _Mask;
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
      float4 u_xlat0_d;
      float4 u_xlat16_0;
      float2 u_xlat1_d;
      float3 u_xlat16_1;
      float2 u_xlat4;
      float u_xlat16_4;
      OUT_Data_Frag frag(v2f in_f)
      {
          OUT_Data_Frag out_f;
          u_xlat0_d.xyz = (_Time.yyy * float3(_U_Move, _U_Erosion, _V_Erosion));
          u_xlat0_d.w = (_Time.y * _V_Move);
          u_xlat0_d = (u_xlat0_d.xwyz + in_f.texcoord.xyxy);
          u_xlat0_d.xy = TRANSFORM_TEX(u_xlat0_d.xy, _Texure);
          u_xlat4.xy = TRANSFORM_TEX(u_xlat0_d.zw, _Erosion);
          u_xlat16_4 = tex2D(_Erosion, u_xlat4.xy).x;
          u_xlat16_0.xyw = tex2D(_Texure, u_xlat0_d.xy).xyz;
          u_xlat0_d.xyw = (u_xlat16_0.xyw * _Color.xyz);
          u_xlat0_d.xyw = (u_xlat0_d.xyw * in_f.color.xyz);
          u_xlat1_d.xy = TRANSFORM_TEX(in_f.texcoord.xy, _Mask);
          u_xlat16_1.xyz = tex2D(_Mask, u_xlat1_d.xy).xyz;
          u_xlat0_d.xyw = (u_xlat0_d.xyw * u_xlat16_1.xyz);
          u_xlat1_d.x = ((-_Soft_Value) + (-1.5));
          u_xlat1_d.x = ((in_f.texcoord1.x * u_xlat1_d.x) + _Soft_Value);
          u_xlat4.x = ((u_xlat16_4 * _Soft_Value) + (-u_xlat1_d.x));
          #ifdef UNITY_ADRENO_ES3
          u_xlat4.x = min(max(u_xlat4.x, 0), 1);
          #else
          u_xlat4.x = clamp(u_xlat4.x, 0, 1);
          #endif
          out_f.color.xyz = (u_xlat4.xxx * u_xlat0_d.xyw);
          out_f.color.w = 1;
          return out_f;
      }
      
      
      ENDCG
      
    } // end phase
  }
  FallBack "Diffuse"
}
