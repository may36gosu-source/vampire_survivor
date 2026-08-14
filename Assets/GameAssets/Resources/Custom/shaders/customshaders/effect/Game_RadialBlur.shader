Shader "Game/RadialBlur"
{
  Properties
  {
    _Size ("Size", Range(0, 0.1)) = 0.01
    _Curve ("_Curve", Range(-1, 1)) = 0
    _SamplerCount ("SamplerCount", Range(1, 10)) = 5
    _Power ("Power", Range(0, 1)) = 1
    _Center ("Center", Vector) = (0.5,0.5,0,0)
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
      //uniform float4 _ProjectionParams;
      //uniform float4x4 unity_ObjectToWorld;
      //uniform float4x4 unity_MatrixVP;
      uniform int _SamplerCount;
      uniform float _Size;
      uniform float _Power;
      uniform float4 _Center;
      uniform sampler2D _GrabTexture;
      struct appdata_t
      {
          float4 vertex :POSITION0;
      };
      
      struct OUT_Data_Vert
      {
          float4 texcoord :TEXCOORD0;
          float4 vertex :SV_POSITION;
      };
      
      struct v2f
      {
          float4 texcoord :TEXCOORD0;
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
          u_xlat1.x = (u_xlat0.y * _ProjectionParams.x);
          u_xlat1.w = (u_xlat1.x * 0.5);
          u_xlat1.xz = (u_xlat0.xw * float2(0.5, 0.5));
          out_v.texcoord.xy = (u_xlat1.zz + u_xlat1.xw);
          out_v.texcoord.zw = u_xlat0.zw;
          out_v.vertex = u_xlat0;
          return out_v;
      }
      
      #define CODE_BLOCK_FRAGMENT
      float2 u_xlat0_d;
      float2 u_xlat1_d;
      float3 u_xlat16_2;
      float3 u_xlat16_3;
      float2 u_xlat8;
      int u_xlati9;
      int u_xlatb13;
      float u_xlat16_14;
      OUT_Data_Frag frag(v2f in_f)
      {
          OUT_Data_Frag out_f;
          u_xlat0_d.xy = (in_f.texcoord.xy / in_f.texcoord.ww);
          u_xlat8.xy = ((-u_xlat0_d.xy) + _Center.xy);
          u_xlat8.xy = (u_xlat8.xy * float2(_Size, _Size));
          u_xlat1_d.xy = u_xlat0_d.xy;
          u_xlat16_2.x = float(0);
          u_xlat16_2.y = float(0);
          u_xlat16_2.z = float(0);
          int u_xlati_loop_1 = 0;
          while((u_xlati_loop_1<_SamplerCount))
          {
              u_xlat16_3.xyz = tex2D(_GrabTexture, u_xlat1_d.xy).xyz;
              u_xlat1_d.xy = ((float2(float2(_Power, _Power)) * u_xlat8.xy) + u_xlat1_d.xy);
              u_xlat16_2.xyz = (u_xlat16_2.xyz + u_xlat16_3.xyz);
              u_xlati_loop_1 = (u_xlati_loop_1 + 1);
          }
          u_xlat16_14 = float(_SamplerCount);
          u_xlat16_2.xyz = (u_xlat16_2.xyz / float3(u_xlat16_14, u_xlat16_14, u_xlat16_14));
          out_f.color.xyz = u_xlat16_2.xyz;
          out_f.color.w = 1;
          return out_f;
      }
      
      
      ENDCG
      
    } // end phase
  }
  FallBack "Diffuse"
}
