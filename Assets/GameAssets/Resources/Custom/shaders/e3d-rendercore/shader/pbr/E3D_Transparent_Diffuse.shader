Shader "E3D/Transparent/Diffuse"
{
  Properties
  {
    _Color ("Main Color", Color) = (1,1,1,1)
    _MainTex ("Base (RGB) Trans (A)", 2D) = "white" {}
    [Header(Ambient Light)] [Toggle] _UseUnitySH ("使用原生环境光?", float) = 0
    _SkyColor ("SkyColor", Color) = (1,0.9103,0.9103,1)
    _EquatorColor ("EquatorColor", Color) = (1,0.7689,0.75,1)
    _GroundColor ("GroundColor", Color) = (0.7169,0,0.1329,1)
    [HideInInspector] custom_SHAr ("A", Vector) = (0.0001,0.3461,0.0509,0.6692)
    [HideInInspector] custom_SHAg ("B", Vector) = (0.0001,0.3461,0.0509,0.6692)
    [HideInInspector] custom_SHAb ("C", Vector) = (0.0001,0.3461,0.0509,0.6692)
    [HideInInspector] custom_SHBr ("D", Vector) = (0,-0.0586,0.0051,-0.0001)
    [HideInInspector] custom_SHBg ("E", Vector) = (0,-0.0586,0.0051,-0.0001)
    [HideInInspector] custom_SHBb ("F", Vector) = (0,-0.0586,0.0051,-0.0001)
    [HideInInspector] custom_SHC ("G", Vector) = (0.0266,0.0266,0.0266,1)
  }
  SubShader
  {
    Tags
    { 
      "QUEUE" = "Transparent"
      "RenderType" = "Transparent"
    }
    LOD 200
    Pass // ind: 1, name: FORWARD
    {
      Name "FORWARD"
      Tags
      { 
        "LIGHTMODE" = "FORWARDBASE"
        "QUEUE" = "Transparent"
        "RenderType" = "Transparent"
      }
      LOD 200
      ZWrite Off
      Blend SrcAlpha OneMinusSrcAlpha
      ColorMask RGB
      // m_ProgramMask = 6
      CGPROGRAM
      #pragma multi_compile DIRECTIONAL LIGHTPROBE_SH
      //#pragma target 4.0
      
      #pragma vertex vert
      #pragma fragment frag
      
      #include "UnityCG.cginc"
      #define conv_mxt4x4_0(mat4x4) float4(mat4x4[0].x,mat4x4[1].x,mat4x4[2].x,mat4x4[3].x)
      #define conv_mxt4x4_1(mat4x4) float4(mat4x4[0].y,mat4x4[1].y,mat4x4[2].y,mat4x4[3].y)
      #define conv_mxt4x4_2(mat4x4) float4(mat4x4[0].z,mat4x4[1].z,mat4x4[2].z,mat4x4[3].z)
      #define conv_mxt4x4_3(mat4x4) float4(mat4x4[0].w,mat4x4[1].w,mat4x4[2].w,mat4x4[3].w)
      
      
      #define CODE_BLOCK_VERTEX
      //uniform float4 unity_SHAr;
      //uniform float4 unity_SHAg;
      //uniform float4 unity_SHAb;
      //uniform float4 unity_SHBr;
      //uniform float4 unity_SHBg;
      //uniform float4 unity_SHBb;
      //uniform float4 unity_SHC;
      //uniform float4x4 unity_ObjectToWorld;
      //uniform float4x4 unity_WorldToObject;
      //uniform float4x4 unity_MatrixVP;
      uniform float4 _MainTex_ST;
      //uniform float4 _WorldSpaceLightPos0;
      uniform float4 _LightColor0;
      uniform float4 custom_SHAr;
      uniform float4 custom_SHAg;
      uniform float4 custom_SHAb;
      uniform float4 custom_SHBr;
      uniform float4 custom_SHBg;
      uniform float4 custom_SHBb;
      uniform float4 custom_SHC;
      uniform float4 _SkyColor;
      uniform float4 _EquatorColor;
      uniform float4 _GroundColor;
      uniform float4 _Color;
      uniform sampler2D _MainTex;
      struct appdata_t
      {
          float4 vertex :POSITION0;
          float3 normal :NORMAL0;
          float4 texcoord :TEXCOORD0;
      };
      
      struct OUT_Data_Vert
      {
          float2 texcoord :TEXCOORD0;
          float3 texcoord1 :TEXCOORD1;
          float3 texcoord2 :TEXCOORD2;
          float3 texcoord3 :TEXCOORD3;
          float4 vertex :SV_POSITION;
      };
      
      struct v2f
      {
          float2 texcoord :TEXCOORD0;
          float3 texcoord1 :TEXCOORD1;
      };
      
      struct OUT_Data_Frag
      {
          float4 color :SV_Target0;
      };
      
      float4 u_xlat0;
      float4 u_xlat1;
      float4 u_xlat16_1;
      float3 u_xlat16_2;
      float3 u_xlat16_3;
      float u_xlat12;
      OUT_Data_Vert vert(appdata_t in_v)
      {
          OUT_Data_Vert out_v;
          u_xlat0 = (in_v.vertex.yyyy * conv_mxt4x4_1(unity_ObjectToWorld));
          u_xlat0 = ((conv_mxt4x4_0(unity_ObjectToWorld) * in_v.vertex.xxxx) + u_xlat0);
          u_xlat0 = ((conv_mxt4x4_2(unity_ObjectToWorld) * in_v.vertex.zzzz) + u_xlat0);
          u_xlat1 = (u_xlat0 + conv_mxt4x4_3(unity_ObjectToWorld));
          out_v.texcoord2.xyz = ((conv_mxt4x4_3(unity_ObjectToWorld).xyz * in_v.vertex.www) + u_xlat0.xyz);
          out_v.vertex = mul(unity_MatrixVP, u_xlat1);
          out_v.texcoord.xy = TRANSFORM_TEX(in_v.texcoord.xy, _MainTex);
          u_xlat0.x = dot(in_v.normal.xyz, conv_mxt4x4_0(unity_WorldToObject).xyz);
          u_xlat0.y = dot(in_v.normal.xyz, conv_mxt4x4_1(unity_WorldToObject).xyz);
          u_xlat0.z = dot(in_v.normal.xyz, conv_mxt4x4_2(unity_WorldToObject).xyz);
          u_xlat0.xyz = normalize(u_xlat0.xyz);
          out_v.texcoord1.xyz = u_xlat0.xyz;
          u_xlat16_2.x = (u_xlat0.y * u_xlat0.y);
          u_xlat16_2.x = ((u_xlat0.x * u_xlat0.x) + (-u_xlat16_2.x));
          u_xlat16_1 = (u_xlat0.yzzx * u_xlat0.xyzz);
          u_xlat16_3.x = dot(unity_SHBr, u_xlat16_1);
          u_xlat16_3.y = dot(unity_SHBg, u_xlat16_1);
          u_xlat16_3.z = dot(unity_SHBb, u_xlat16_1);
          u_xlat16_2.xyz = ((unity_SHC.xyz * u_xlat16_2.xxx) + u_xlat16_3.xyz);
          u_xlat0.w = 1;
          u_xlat16_3.x = dot(unity_SHAr, u_xlat0);
          u_xlat16_3.y = dot(unity_SHAg, u_xlat0);
          u_xlat16_3.z = dot(unity_SHAb, u_xlat0);
          u_xlat16_2.xyz = (u_xlat16_2.xyz + u_xlat16_3.xyz);
          u_xlat16_2.xyz = max(u_xlat16_2.xyz, float3(0, 0, 0));
          u_xlat0.xyz = log2(u_xlat16_2.xyz);
          u_xlat0.xyz = (u_xlat0.xyz * float3(0.416666657, 0.416666657, 0.416666657));
          u_xlat0.xyz = exp2(u_xlat0.xyz);
          u_xlat0.xyz = ((u_xlat0.xyz * float3(1.05499995, 1.05499995, 1.05499995)) + float3(-0.0549999997, (-0.0549999997), (-0.0549999997)));
          u_xlat0.xyz = max(u_xlat0.xyz, float3(0, 0, 0));
          out_v.texcoord3.xyz = u_xlat0.xyz;
          return out_v;
      }
      
      #define CODE_BLOCK_FRAGMENT
      float4 u_xlat0_d;
      float4 u_xlat1_d;
      float4 u_xlat16_1_d;
      float3 u_xlat2;
      float3 u_xlat16_3_d;
      float3 u_xlat16_4;
      float u_xlat15;
      float u_xlat16_18;
      OUT_Data_Frag frag(v2f in_f)
      {
          OUT_Data_Frag out_f;
          u_xlat0_d = (in_f.texcoord1.yzzx * in_f.texcoord1.xyzz);
          u_xlat1_d.x = dot(custom_SHBr, u_xlat0_d);
          u_xlat1_d.y = dot(custom_SHBg, u_xlat0_d);
          u_xlat1_d.z = dot(custom_SHBb, u_xlat0_d);
          u_xlat0_d.xyz = in_f.texcoord1.xyz;
          u_xlat0_d.w = 1;
          u_xlat2.x = dot(custom_SHAr, u_xlat0_d);
          u_xlat2.y = dot(custom_SHAg, u_xlat0_d);
          u_xlat2.z = dot(custom_SHAb, u_xlat0_d);
          u_xlat0_d.xyz = (u_xlat1_d.xyz + u_xlat2.xyz);
          u_xlat15 = (in_f.texcoord1.y * in_f.texcoord1.y);
          u_xlat15 = ((in_f.texcoord1.x * in_f.texcoord1.x) + (-u_xlat15));
          u_xlat0_d.xyz = ((custom_SHC.xyz * float3(u_xlat15, u_xlat15, u_xlat15)) + u_xlat0_d.xyz);
          u_xlat0_d.xyz = max(u_xlat0_d.xyz, float3(0, 0, 0));
          u_xlat0_d.xyz = ((-u_xlat0_d.xyz) + float3(1, 1, 1));
          u_xlat1_d.xyz = ((-_SkyColor.xyz) + _EquatorColor.xyz);
          u_xlat1_d.xyz = ((u_xlat0_d.xyz * u_xlat1_d.xyz) + _SkyColor.xyz);
          u_xlat2.xyz = ((-u_xlat1_d.xyz) + _GroundColor.xyz);
          u_xlat0_d.xyz = ((u_xlat0_d.xyz * u_xlat2.xyz) + u_xlat1_d.xyz);
          u_xlat16_1_d = tex2D(_MainTex, in_f.texcoord.xy);
          u_xlat1_d = (u_xlat16_1_d * _Color);
          u_xlat16_3_d.xyz = (u_xlat0_d.xyz * u_xlat1_d.xyz);
          u_xlat16_18 = dot(in_f.texcoord1.xyz, _WorldSpaceLightPos0.xyz);
          u_xlat16_18 = max(u_xlat16_18, 0);
          u_xlat16_4.xyz = (u_xlat1_d.xyz * _LightColor0.xyz);
          out_f.color.w = u_xlat1_d.w;
          out_f.color.xyz = ((u_xlat16_4.xyz * float3(u_xlat16_18, u_xlat16_18, u_xlat16_18)) + u_xlat16_3_d.xyz);
          return out_f;
      }
      
      
      ENDCG
      
    } // end phase
  }
  FallBack Off
}
