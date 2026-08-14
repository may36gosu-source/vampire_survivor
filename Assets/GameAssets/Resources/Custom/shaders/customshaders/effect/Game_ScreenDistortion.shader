Shader "Game/ScreenDistortion"
{
  Properties
  {
    _DispMap ("Displacement Map (RG)", 2D) = "white" {}
    _MaskTex ("Mask (R)", 2D) = "white" {}
    _Polar ("极坐标", float) = 0
    _DispScrollSpeedX ("Map Scroll Speed X", float) = 0
    _DispScrollSpeedY ("Map Scroll Speed Y", float) = 0
    _StrengthX ("Displacement Strength X", float) = 1
    _StrengthY ("Displacement Strength Y", float) = -1
  }
  SubShader
  {
    Tags
    { 
      "IGNOREPROJECTOR" = "true"
      "QUEUE" = "Transparent+5"
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
    Pass // ind: 2, name: 
    {
      Tags
      { 
        "IGNOREPROJECTOR" = "true"
        "QUEUE" = "Transparent+5"
        "RenderType" = "Transparent"
      }
      ZTest Always
      ZWrite Off
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
      uniform float4 _DispMap_ST;
      //uniform float4 _Time;
      uniform float _StrengthX;
      uniform float _StrengthY;
      uniform float _DispScrollSpeedY;
      uniform float _DispScrollSpeedX;
      uniform int _Polar;
      uniform sampler2D _DispMap;
      uniform sampler2D _MaskTex;
      uniform sampler2D _GrabTexture;
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
      float2 u_xlat16_0;
      int u_xlatb0;
      float u_xlat1_d;
      int u_xlatb1;
      float u_xlat2;
      int u_xlatb3;
      float2 u_xlat4;
      float u_xlat16_4;
      float u_xlat6;
      int u_xlatb6;
      OUT_Data_Frag frag(v2f in_f)
      {
          OUT_Data_Frag out_f;
          u_xlat0_d.x = float(_Polar);
          #ifdef UNITY_ADRENO_ES3
          u_xlatb0 = (0.100000001<u_xlat0_d.x);
          #else
          u_xlatb0 = (0.100000001<u_xlat0_d.x);
          #endif
          if(u_xlatb0)
          {
              u_xlat0_d.xy = (in_f.texcoord.xy + float2(-0.5, (-0.5)));
              u_xlat4.x = min(abs(u_xlat0_d.x), abs(u_xlat0_d.y));
              u_xlat6 = max(abs(u_xlat0_d.x), abs(u_xlat0_d.y));
              u_xlat6 = (float(1) / u_xlat6);
              u_xlat4.x = (u_xlat6 * u_xlat4.x);
              u_xlat6 = (u_xlat4.x * u_xlat4.x);
              u_xlat1_d = ((u_xlat6 * 0.0208350997) + (-0.0851330012));
              u_xlat1_d = ((u_xlat6 * u_xlat1_d) + 0.180141002);
              u_xlat1_d = ((u_xlat6 * u_xlat1_d) + (-0.330299497));
              u_xlat6 = ((u_xlat6 * u_xlat1_d) + 0.999866009);
              u_xlat1_d = (u_xlat6 * u_xlat4.x);
              #ifdef UNITY_ADRENO_ES3
              u_xlatb3 = (abs(u_xlat0_d.x)<abs(u_xlat0_d.y));
              #else
              u_xlatb3 = (abs(u_xlat0_d.x)<abs(u_xlat0_d.y));
              #endif
              u_xlat1_d = ((u_xlat1_d * (-2)) + 1.57079637);
              u_xlat1_d = (u_xlatb3)?(u_xlat1_d):(float(0));
              u_xlat4.x = ((u_xlat4.x * u_xlat6) + u_xlat1_d);
              #ifdef UNITY_ADRENO_ES3
              u_xlatb6 = (u_xlat0_d.x<(-u_xlat0_d.x));
              #else
              u_xlatb6 = (u_xlat0_d.x<(-u_xlat0_d.x));
              #endif
              u_xlat6 = (u_xlatb6)?((-3.14159274)):(float(0));
              u_xlat4.x = (u_xlat6 + u_xlat4.x);
              u_xlat6 = min(u_xlat0_d.x, u_xlat0_d.y);
              u_xlat1_d = max(u_xlat0_d.x, u_xlat0_d.y);
              #ifdef UNITY_ADRENO_ES3
              u_xlatb6 = (u_xlat6<(-u_xlat6));
              #else
              u_xlatb6 = (u_xlat6<(-u_xlat6));
              #endif
              #ifdef UNITY_ADRENO_ES3
              u_xlatb1 = (u_xlat1_d>=(-u_xlat1_d));
              #else
              u_xlatb1 = (u_xlat1_d>=(-u_xlat1_d));
              #endif
              u_xlatb6 = (u_xlatb6 && u_xlatb1);
              u_xlat4.x = (u_xlatb6)?((-u_xlat4.x)):(u_xlat4.x);
              u_xlat4.x = ((u_xlat4.x * 0.159154952) + 0.5);
              u_xlat6 = frac(_Time.x);
              u_xlat0_d.x = length(u_xlat0_d.xy);
              u_xlat2 = (u_xlat6 * _DispScrollSpeedX);
              u_xlat0_d.x = ((u_xlat0_d.x * 2) + (-u_xlat2));
              u_xlat0_d.y = ((u_xlat6 * _DispScrollSpeedY) + u_xlat4.x);
              u_xlat16_0.xy = tex2D(_DispMap, u_xlat0_d.xy).xy;
          }
          else
          {
              u_xlat4.xy = ((_Time.yy * float2(_DispScrollSpeedX, _DispScrollSpeedY)) + in_f.texcoord.xy);
              u_xlat16_0.xy = tex2D(_DispMap, u_xlat4.xy).xy;
          }
          u_xlat0_d.xy = (u_xlat16_0.xy * float2(_StrengthX, _StrengthY));
          u_xlat0_d.xy = (u_xlat0_d.xy * in_f.texcoord1.xx);
          u_xlat16_4 = tex2D(_MaskTex, in_f.texcoord.xy).w;
          u_xlat4.x = (u_xlat16_4 * in_f.color.w);
          u_xlat0_d.xy = ((u_xlat0_d.xy * u_xlat4.xx) + in_f.texcoord2.xy);
          u_xlat0_d.xy = (u_xlat0_d.xy / in_f.texcoord2.ww);
          out_f.color = tex2D(_GrabTexture, u_xlat0_d.xy);
          return out_f;
      }
      
      
      ENDCG
      
    } // end phase
  }
  FallBack "Diffuse"
}
