Shader "TF/ScenePannerAlpha_Mask"
{
  Properties
  {
    _MaskMap ("MaskMap", 2D) = "white" {}
    _Alpha ("Alpha", 2D) = "white" {}
    _Alphabias ("Alphabias", Range(0, 1)) = 0
    _Color01 ("Color01", Color) = (0.5,0.5,0.5,1)
    _ColorPower01 ("ColorPower01", float) = 2
    _MainTex01 ("MainTex01", 2D) = "black" {}
    _USpeed ("USpeed", float) = 1
    _Vspeed ("Vspeed", float) = 1
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
      "QUEUE" = "Transparent+1"
      "RenderType" = "Transparent"
    }
    Pass // ind: 1, name: ForwardBase
    {
      Name "ForwardBase"
      Tags
      { 
        "IGNOREPROJECTOR" = "true"
        "LIGHTMODE" = "FORWARDBASE"
        "QUEUE" = "Transparent+1"
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
      Fog
      { 
        Mode  Off
      } 
      Blend SrcAlpha One
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
      uniform float4 _MainTex01_ST;
      uniform float4 _MaskMap_ST;
      uniform float _Alphabias;
      uniform float _USpeed;
      uniform float _Vspeed;
      uniform float4 _Color01;
      uniform float _ColorPower01;
      uniform sampler2D _MainTex01;
      uniform sampler2D _MaskMap;
      uniform sampler2D _Alpha;
      struct appdata_t
      {
          float4 vertex :POSITION0;
          float2 texcoord :TEXCOORD0;
      };
      
      struct OUT_Data_Vert
      {
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
          out_v.texcoord.xy = in_v.texcoord.xy;
          return out_v;
      }
      
      #define CODE_BLOCK_FRAGMENT
      float2 u_xlat0_d;
      float u_xlat16_0;
      float4 u_xlat1_d;
      float3 u_xlat16_1;
      float2 u_xlat2;
      float u_xlat16_6;
      OUT_Data_Frag frag(v2f in_f)
      {
          OUT_Data_Frag out_f;
          u_xlat0_d.xy = TRANSFORM_TEX(in_f.texcoord.xy, _MaskMap);
          u_xlat16_0 = tex2D(_MaskMap, u_xlat0_d.xy).x;
          u_xlat2.xy = ((_Time.xx * float2(_USpeed, _Vspeed)) + in_f.texcoord.xy);
          u_xlat2.xy = TRANSFORM_TEX(u_xlat2.xy, _MainTex01);
          u_xlat16_6 = tex2D(_Alpha, u_xlat2.xy).x;
          u_xlat16_1.xyz = tex2D(_MainTex01, u_xlat2.xy).xyz;
          u_xlat1_d.xyz = (u_xlat16_1.xyz * _Color01.xyz);
          u_xlat1_d.xyz = (u_xlat1_d.xyz * float3(_ColorPower01, _ColorPower01, _ColorPower01));
          u_xlat2.x = (u_xlat16_6 + (-_Alphabias));
          #ifdef UNITY_ADRENO_ES3
          u_xlat2.x = min(max(u_xlat2.x, 0), 1);
          #else
          u_xlat2.x = clamp(u_xlat2.x, 0, 1);
          #endif
          u_xlat1_d.w = (u_xlat16_0 * u_xlat2.x);
          out_f.color = u_xlat1_d;
          return out_f;
      }
      
      
      ENDCG
      
    } // end phase
  }
  FallBack "Diffuse"
}
