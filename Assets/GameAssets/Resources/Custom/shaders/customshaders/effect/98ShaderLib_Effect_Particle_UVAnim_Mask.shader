Shader "98ShaderLib/Effect/Particle_UVAnim_Mask"
{
  Properties
  {
    [Header(CustomData_01_Z_Diss)] [Space] [Header(CustomData_02_ZW_MainUV)] [Space] [Header(Custom_Vertex_Streams_Pos_Col_UV_C1XYZW_C2XYZW)] [Space] [Space] [Toggle] _IsClampFinalColor ("Clamp Final Color?", float) = 0
    [HDR] _Color ("Color", Color) = (0.5,0.5,0.5,1)
    _MainTex ("Texures", 2D) = "white" {}
    _Mask ("Mask", 2D) = "white" {}
    [Enum(UnityEngine.Rendering.BlendMode)] [HideInInspector] _Dst ("Dst", float) = 5
    [Enum(Additive, 1, AlphaBlend, 10)] _Src ("Src", float) = 1
    [Main(g1, _KEYWORD, 3)] _UVAnimSetting ("UVScrolling", float) = 1
    [Sub(g1)] _U_Move_MainTex ("U_Move_MainTex", Range(-10, 10)) = 0
    [Sub(g1)] _V_Move_MainTex ("V_Move_MainTex", Range(-10, 10)) = 0
    [SubToggle(g1, _)] _ModifiedByCustomData_ZW ("ModifiedBy_CustomData2_ZW", float) = 0
    [Sub(g1)] _U_Move_Mask ("U_Move_Mask", Range(-10, 10)) = 0
    [Sub(g1)] _V_Move_Mask ("V_Move_Mask", Range(-10, 10)) = 0
    [Sub(g1)] _U_Move_DissolveTex ("U_Move_Dissove", Range(-10, 10)) = 0
    [Sub(g1)] _V_Move_DissolveTex ("V_Move_Dissove", Range(-10, 10)) = 0
    [Main(g2, _KEYWORD, 3)] _DissolveCtr ("Dissolve", float) = 1
    [Sub(g2)] _DissolveTex ("DissolveTex", 2D) = "wite" {}
    [Sub(g2)] [HDR] _OutlineColor ("OutLineColor", Color) = (1,1,1,1)
    [Sub(g2)] _DissolveValue ("DissolveValue", Range(0, 1)) = 1
    [SubToggle(g2, _)] _ModifiedByCustomData_Z ("ModifiedBy_CustomData1_Z", float) = 0
    [SubToggle(g2)] _OpenOutLine ("OpenOutline?", float) = 0
    [Sub(g2)] _OutlineWidth ("OutlineWigth", Range(0.001, 1)) = 0.001
    [Sub(g2)] _SoftValue ("SoftValue", Range(0, 1)) = 0
    [Main(g3, _KEYWORD, 3)] _NosieAppend ("NosieAppend", float) = 1
    [Sub(g3)] _NosieMask ("NosieMask", 2D) = "white" {}
    [Sub(g3)] _NosieMap ("NosieMap", 2D) = "white" {}
    [Sub(g3)] _NosieValue ("NosieValue", Range(0, 1)) = 0
    [Main(g4, _KEYWORD, 3)] _VertexOffset ("VertexOffset", float) = 1
    [Sub(g4)] _OffsetDir ("OffsetDir", Vector) = (0,0,0,0)
    [Sub(g4)] _OffsetSpeed ("OffsetSpeed", Range(0, 20)) = 0
    [Sub(g4)] _OffsetPower ("OffsetPower", Range(-100, 100)) = 0
    [Sub(g4)] _OffsetMap ("OffsetMap", 2D) = "white" {}
    [Sub(g4)] _PannerU ("PannerU", Range(-1, 1)) = 0
    [Sub(g4)] _PannerV ("PannerV", Range(-1, 1)) = 0
    _StencilComp ("Stencil Comparison", float) = 8
    _Stencil ("Stencil ID", float) = 0
    _StencilOp ("Stencil Operation", float) = 0
    _StencilWriteMask ("Stencil Write Mask", float) = 255
    _StencilReadMask ("Stencil Read Mask", float) = 255
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
      Blend Zero Zero
      ColorMask RGB
      // m_ProgramMask = 6
      CGPROGRAM
      //#pragma target 4.0
      
      #pragma vertex vert
      #pragma fragment frag
      
      #include "UnityCG.cginc"
      
      
      #define CODE_BLOCK_VERTEX
      //uniform float4 _Time;
      //uniform float4x4 unity_ObjectToWorld;
      //uniform float4x4 unity_MatrixVP;
      uniform float4 _OffsetDir;
      uniform float _OffsetSpeed;
      uniform float _OffsetPower;
      uniform float4 _OffsetMap_ST;
      uniform float _PannerU;
      uniform float _PannerV;
      uniform sampler2D _OffsetMap;
      uniform float4 _Color;
      uniform int _IsClampFinalColor;
      uniform float4 _MainTex_ST;
      uniform float4 _Mask_ST;
      uniform float _U_Move_MainTex;
      uniform float _V_Move_MainTex;
      uniform float _ModifiedByCustomData_ZW;
      uniform float _U_Move_Mask;
      uniform float _V_Move_Mask;
      uniform float _U_Move_DissolveTex;
      uniform float _V_Move_DissolveTex;
      uniform float4 _DissolveTex_ST;
      uniform float _DissolveValue;
      uniform float4 _OutlineColor;
      uniform float _OpenOutLine;
      uniform float _OutlineWidth;
      uniform float _SoftValue;
      uniform float _ModifiedByCustomData_Z;
      uniform float4 _NosieMap_ST;
      uniform float4 _NosieMask_ST;
      uniform float _NosieValue;
      uniform sampler2D _Mask;
      uniform sampler2D _NosieMask;
      uniform sampler2D _NosieMap;
      uniform sampler2D _MainTex;
      uniform sampler2D _DissolveTex;
      struct appdata_t
      {
          float4 vertex :POSITION0;
          float4 color :COLOR0;
          float2 texcoord :TEXCOORD0;
          float4 texcoord1 :TEXCOORD1;
          float4 texcoord2 :TEXCOORD2;
      };
      
      struct OUT_Data_Vert
      {
          float4 color :COLOR0;
          float2 texcoord :TEXCOORD0;
          float4 texcoord1 :TEXCOORD1;
          float4 texcoord2 :TEXCOORD2;
          float3 texcoord3 :TEXCOORD3;
          float3 texcoord4 :TEXCOORD4;
          float4 vertex :SV_POSITION;
      };
      
      struct v2f
      {
          float4 color :COLOR0;
          float2 texcoord :TEXCOORD0;
          float4 texcoord1 :TEXCOORD1;
          float4 texcoord2 :TEXCOORD2;
      };
      
      struct OUT_Data_Frag
      {
          float4 color :SV_Target0;
      };
      
      float4 u_xlat0;
      float4 u_xlat1;
      float2 u_xlat2;
      int u_xlatb6;
      OUT_Data_Vert vert(appdata_t in_v)
      {
          OUT_Data_Vert out_v;
          u_xlat0.x = (_Time.x * _OffsetSpeed);
          u_xlat0.x = frac(u_xlat0.x);
          u_xlat2.xy = TRANSFORM_TEX(in_v.texcoord.xy, _OffsetMap);
          u_xlat0.xy = ((float2(_PannerU, _PannerV) * u_xlat0.xx) + u_xlat2.xy);
          u_xlat0.xyz = tex2Dlod(_OffsetMap, float4(float3(u_xlat0.xy, 0), 0)).xyz;
          u_xlat0.xyz = (u_xlat0.xyz * _OffsetDir.xyz);
          u_xlat0.xyz = (u_xlat0.xyz * float3(float3(_OffsetPower, _OffsetPower, _OffsetPower)));
          #ifdef UNITY_ADRENO_ES3
          u_xlatb6 = (_OffsetSpeed>=9.99999975E-06);
          #else
          u_xlatb6 = (_OffsetSpeed>=9.99999975E-06);
          #endif
          u_xlat0.xyz = (int(u_xlatb6))?(u_xlat0.xyz):(float3(0, 0, 0));
          u_xlat0.xyz = (u_xlat0.xyz + in_v.vertex.xyz);
          out_v.vertex = UnityObjectToClipPos(u_xlat0);
          out_v.color = in_v.color;
          out_v.texcoord.xy = in_v.texcoord.xy;
          out_v.texcoord1 = in_v.texcoord1;
          out_v.texcoord2 = in_v.texcoord2;
          out_v.texcoord3.xyz = float3(0, 0, 0);
          out_v.texcoord4.xyz = float3(0, 0, 0);
          return out_v;
      }
      
      #define CODE_BLOCK_FRAGMENT
      float4 u_xlat0_d;
      float4 u_xlat16_0;
      float2 u_xlat1_d;
      float4 u_xlat16_1;
      float4 u_xlat16_2;
      float4 u_xlat3;
      float4 u_xlat16_3;
      float4 u_xlat16_4;
      float4 u_xlat16_5;
      float4 u_xlat16_6;
      float4 u_xlat16_7;
      float4 u_xlat8;
      int u_xlatb8;
      float2 u_xlat10;
      float u_xlat16_11;
      float2 u_xlat18;
      float2 u_xlatb18;
      float u_xlat16_20;
      int u_xlatb27;
      OUT_Data_Frag frag(v2f in_f)
      {
          OUT_Data_Frag out_f;
          u_xlat0_d.xy = ((_Time.yy * _NosieMap_ST.xy) + in_f.texcoord.xy);
          u_xlat0_d.xy = (u_xlat0_d.xy + _NosieMap_ST.zw);
          u_xlat16_0 = tex2D(_NosieMap, u_xlat0_d.xy);
          u_xlat1_d.xy = TRANSFORM_TEX(in_f.texcoord.xy, _NosieMask);
          u_xlat16_1 = tex2D(_NosieMask, u_xlat1_d.xy);
          u_xlat0_d = (u_xlat16_0 * u_xlat16_1);
          u_xlat16_2.xy = (u_xlat0_d.zw + u_xlat0_d.xy);
          u_xlat0_d.xy = ((u_xlat16_2.xy * float2(_NosieValue, _NosieValue)) + float2(0, (-0.5)));
          u_xlat18.x = dot(u_xlat0_d.xy, u_xlat0_d.xy);
          u_xlat18.x = rsqrt(u_xlat18.x);
          u_xlat0_d.xy = (u_xlat18.xx * u_xlat0_d.xy);
          #ifdef UNITY_ADRENO_ES3
          u_xlatb18.x = (_NosieValue>=9.99999975E-06);
          #else
          u_xlatb18.x = (_NosieValue>=9.99999975E-06);
          #endif
          u_xlat16_2.x = (u_xlatb18.x)?(1):(0);
          u_xlat0_d.xy = ((u_xlat16_2.xx * u_xlat0_d.xy) + in_f.texcoord.xy);
          u_xlat18.xy = ((float2(_U_Move_DissolveTex, _V_Move_DissolveTex) * _Time.yy) + u_xlat0_d.xy);
          u_xlat0_d.xy = ((float2(_U_Move_MainTex, _V_Move_MainTex) * _Time.yy) + u_xlat0_d.xy);
          u_xlat18.xy = TRANSFORM_TEX(u_xlat18.xy, _DissolveTex);
          u_xlat16_1 = tex2D(_DissolveTex, u_xlat18.xy);
          u_xlatb18.xy = bool4(float4(_ModifiedByCustomData_Z, _OpenOutLine, _ModifiedByCustomData_Z, _OpenOutLine) >= float4(9.99999975E-06, 0.00100000005, 9.99999975E-06, 0.00100000005)).xy;
          u_xlat18.x = (u_xlatb18.x)?(in_f.texcoord1.x):(_DissolveValue);
          u_xlat16_2.x = (u_xlatb18.y)?(1):(0);
          u_xlat16_11 = ((_OutlineWidth * 2) + u_xlat18.x);
          u_xlat16_3 = (u_xlat16_1 + (-float4(u_xlat16_11, u_xlat16_11, u_xlat16_11, u_xlat16_11)));
          u_xlat16_20 = ((_OutlineWidth * 3) + u_xlat18.x);
          u_xlat16_11 = ((-u_xlat16_11) + u_xlat16_20);
          u_xlat16_11 = (float(1) / u_xlat16_11);
          u_xlat16_3 = (float4(u_xlat16_11, u_xlat16_11, u_xlat16_11, u_xlat16_11) * u_xlat16_3);
          #ifdef UNITY_ADRENO_ES3
          u_xlat16_3 = min(max(u_xlat16_3, 0), 1);
          #else
          u_xlat16_3 = clamp(u_xlat16_3, 0, 1);
          #endif
          u_xlat16_4 = ((u_xlat16_3 * float4(-2, (-2), (-2), (-2))) + float4(3, 3, 3, 3));
          u_xlat16_3 = (u_xlat16_3 * u_xlat16_3);
          u_xlat16_5 = ((-u_xlat18.xxxx) + u_xlat16_1);
          u_xlat16_11 = (float(1) / _OutlineWidth);
          u_xlat16_5 = (float4(u_xlat16_11, u_xlat16_11, u_xlat16_11, u_xlat16_11) * u_xlat16_5);
          #ifdef UNITY_ADRENO_ES3
          u_xlat16_5 = min(max(u_xlat16_5, 0), 1);
          #else
          u_xlat16_5 = clamp(u_xlat16_5, 0, 1);
          #endif
          u_xlat16_6 = ((u_xlat16_5 * float4(-2, (-2), (-2), (-2))) + float4(3, 3, 3, 3));
          u_xlat16_5 = (u_xlat16_5 * u_xlat16_5);
          u_xlat16_7 = (u_xlat16_5 * u_xlat16_6);
          u_xlat16_11 = (((-u_xlat16_6.x) * u_xlat16_5.x) + 1);
          u_xlat16_3 = (((-u_xlat16_4) * u_xlat16_3) + u_xlat16_7);
          u_xlat3 = (u_xlat16_3 * _OutlineColor);
          u_xlat3 = (u_xlat16_1 * u_xlat3);
          u_xlat8.w = (_Time.y * _V_Move_Mask);
          u_xlat8.x = (_Time.y * _U_Move_Mask);
          u_xlat8.xy = (u_xlat8.xw + in_f.texcoord.xy);
          u_xlat8.xy = TRANSFORM_TEX(u_xlat8.xy, _Mask);
          u_xlat16_4 = tex2D(_Mask, u_xlat8.xy);
          u_xlat3 = (u_xlat3 * u_xlat16_4);
          u_xlat3 = (u_xlat16_2.xxxx * u_xlat3);
          u_xlat3 = (u_xlat16_1.wwww * u_xlat3);
          u_xlat16_2.x = length(u_xlat16_1);
          u_xlat3 = (u_xlat16_2.xxxx * u_xlat3);
          #ifdef UNITY_ADRENO_ES3
          u_xlat3 = min(max(u_xlat3, 0), 1);
          #else
          u_xlat3 = clamp(u_xlat3, 0, 1);
          #endif
          #ifdef UNITY_ADRENO_ES3
          u_xlatb27 = (_ModifiedByCustomData_ZW>=9.99999975E-06);
          #else
          u_xlatb27 = (_ModifiedByCustomData_ZW>=9.99999975E-06);
          #endif
          u_xlat10.xy = (int(u_xlatb27))?(in_f.texcoord2.xy):(float2(0, 0));
          u_xlat0_d.xy = (u_xlat0_d.xy + u_xlat10.xy);
          u_xlat0_d.xy = TRANSFORM_TEX(u_xlat0_d.xy, _MainTex);
          u_xlat16_5 = tex2D(_MainTex, u_xlat0_d.xy);
          u_xlat16_2.xzw = (u_xlat16_5.xyz * _Color.xyz);
          u_xlat16_2.xzw = (u_xlat16_4.xyz * u_xlat16_2.xzw);
          u_xlat16_6.xyz = (u_xlat16_2.xzw * float3(2, 2, 2));
          u_xlat16_6.w = 2;
          u_xlat3 = ((u_xlat16_6 * in_f.color) + u_xlat3);
          u_xlat16_2.x = ((-_SoftValue) + 1);
          u_xlat16_20 = ((-u_xlat16_2.x) + (-1.5));
          u_xlat16_20 = ((u_xlat18.x * u_xlat16_20) + u_xlat16_2.x);
          u_xlat16_2.x = ((u_xlat16_1.x * u_xlat16_2.x) + (-u_xlat16_20));
          #ifdef UNITY_ADRENO_ES3
          u_xlat16_2.x = min(max(u_xlat16_2.x, 0), 1);
          #else
          u_xlat16_2.x = clamp(u_xlat16_2.x, 0, 1);
          #endif
          u_xlat16_2.x = (u_xlat16_4.w * u_xlat16_2.x);
          u_xlat16_2.x = (u_xlat16_5.w * u_xlat16_2.x);
          u_xlat16_2.x = (u_xlat16_11 * u_xlat16_2.x);
          u_xlat0_d.x = (u_xlat16_2.x * in_f.color.w);
          u_xlat16_0 = (u_xlat0_d.xxxx * u_xlat3);
          u_xlat16_1 = u_xlat16_0;
          #ifdef UNITY_ADRENO_ES3
          u_xlat16_1 = min(max(u_xlat16_1, 0), 1);
          #else
          u_xlat16_1 = clamp(u_xlat16_1, 0, 1);
          #endif
          u_xlat8.x = float(_IsClampFinalColor);
          #ifdef UNITY_ADRENO_ES3
          u_xlatb8 = (u_xlat8.x>=0.00100000005);
          #else
          u_xlatb8 = (u_xlat8.x>=0.00100000005);
          #endif
          u_xlat16_1.xyz = (int(u_xlatb8))?(u_xlat16_1.xyz):(u_xlat16_0.xyz);
          out_f.color = u_xlat16_1;
          return out_f;
      }
      
      
      ENDCG
      
    } // end phase
  }
  FallBack "Unlit"
}
