Shader "TF/SimpleAlphaPanner"
{
  Properties
  {
    _Color01 ("Color01", Color) = (0.5,0.5,0.5,1)
    _ColorPower01 ("ColorPower01", float) = 2
    _MainTex01 ("MainTex01", 2D) = "black" {}
    _USpeed ("USpeed", float) = 1
    _Vspeed ("Vspeed", float) = 1
    _Mask1 ("Mask1", 2D) = "white" {}
    _AlphaBias ("AlphaBias", Range(0, 1)) = 0
    _ClipBias ("ClipBias", Range(0, 1)) = 0
    [HideInInspector] _Cutoff ("Alpha cutoff", Range(0, 1)) = 0.5
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
      Cull Off
      Fog
      { 
        Mode  Off
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
      //uniform float4 _Time;
      uniform float4 _MainTex01_ST;
      uniform float _USpeed;
      uniform float _Vspeed;
      uniform float4 _Color01;
      uniform float _ColorPower01;
      uniform float4 _Mask1_ST;
      uniform float _AlphaBias;
      uniform float _ClipBias;
      uniform sampler2D _Mask1;
      uniform sampler2D _MainTex01;
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
      int u_xlatb0;
      float4 u_xlat1_d;
      float3 u_xlat16_1;
      float2 u_xlat4;
      OUT_Data_Frag frag(v2f in_f)
      {
          OUT_Data_Frag out_f;
          u_xlat0_d.xy = ((_Time.xx * float2(_USpeed, _Vspeed)) + in_f.texcoord.xy);
          u_xlat4.xy = TRANSFORM_TEX(u_xlat0_d.xy, _Mask1);
          u_xlat0_d.xy = TRANSFORM_TEX(u_xlat0_d.xy, _MainTex01);
          u_xlat16_1.xyz = tex2D(_MainTex01, u_xlat0_d.xy).xyz;
          u_xlat1_d.xyz = (u_xlat16_1.xyz * _Color01.xyz);
          u_xlat1_d.xyz = (u_xlat1_d.xyz * float3(_ColorPower01, _ColorPower01, _ColorPower01));
          u_xlat16_0 = tex2D(_Mask1, u_xlat4.xy).x;
          u_xlat0_d.xy = float2((float2(u_xlat16_0, u_xlat16_0) + (-float2(_ClipBias, _AlphaBias))));
          u_xlat0_d.x = (u_xlat0_d.x + (-0.5));
          u_xlat1_d.w = u_xlat0_d.y;
          out_f.color = u_xlat1_d;
          #ifdef UNITY_ADRENO_ES3
          u_xlatb0 = (u_xlat0_d.x<0);
          #else
          u_xlatb0 = (u_xlat0_d.x<0);
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
  FallBack "Diffuse"
}
