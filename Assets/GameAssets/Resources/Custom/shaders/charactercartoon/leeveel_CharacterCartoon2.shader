Shader "leeveel/CharacterCartoon2"
{
  Properties
  {
    [Header(Base)] _MainColor ("MainColor", Color) = (1,1,1,1)
    _MainTex ("MainTex", 2D) = "white" {}
    [Header(Shadow)] _AOStrength ("AO强度", Range(0, 1)) = 1
    _LightArea ("光照区域大小", Range(0, 1)) = 0.363
    _ShadowSmooth ("明暗过渡", Range(0.01, 0.5)) = 0.01
    _ColorShadow ("暗光面颜色", Color) = (0.5,0.5,0.5,1)
    _ShadowSaturation ("暗光面饱和度", Range(0, 5)) = 1
    [Toggle] _UseShadowMap ("使用自阴影贴图", Range(0, 1)) = 0
    _ShadowTex ("ShadowMap", 2D) = "white" {}
    [Header(Hit)] [Toggle] _IsHit ("是否受击", Range(0, 1)) = 0
    _HitColor ("受击颜色", Color) = (1,1,1,1)
    _HitIntensity ("受击强度", Range(1, 8)) = 5
    [Header(Outline)] _OutlineColor ("描边颜色", Color) = (0,0,0,0)
    _OutlineWidth ("描边宽度", Range(0, 1)) = 0.1
    _UnifomWidth ("宽度统一", Range(0, 1)) = 0.5
  }
  SubShader
  {
    Tags
    { 
    }
    Pass // ind: 1, name: ForwardBase
    {
      Name "ForwardBase"
      Tags
      { 
        "LIGHTMODE" = "FORWARDBASE"
      }
      Fog
      { 
        Mode  Off
      } 
      // m_ProgramMask = 6
      CGPROGRAM
      //#pragma target 4.0
      
      #pragma vertex vert
      #pragma fragment frag
      
      #include "UnityCG.cginc"
      #define conv_mxt4x4_0(mat4x4) float4(mat4x4[0].x,mat4x4[1].x,mat4x4[2].x,mat4x4[3].x)
      #define conv_mxt4x4_1(mat4x4) float4(mat4x4[0].y,mat4x4[1].y,mat4x4[2].y,mat4x4[3].y)
      #define conv_mxt4x4_2(mat4x4) float4(mat4x4[0].z,mat4x4[1].z,mat4x4[2].z,mat4x4[3].z)
      #define conv_mxt4x4_3(mat4x4) float4(mat4x4[0].w,mat4x4[1].w,mat4x4[2].w,mat4x4[3].w)
      
      
      #define CODE_BLOCK_VERTEX
      //uniform float4x4 unity_ObjectToWorld;
      //uniform float4x4 unity_WorldToObject;
      //uniform float4x4 unity_MatrixVP;
      //uniform float3 _WorldSpaceCameraPos;
      //uniform float4 _WorldSpaceLightPos0;
      uniform float4 _LightColor0;
      uniform float4 _MainColor;
      uniform float4 _MainTex_ST;
      uniform float4 _ShadowTex_ST;
      uniform float _AOStrength;
      uniform float _UseShadowMap;
      uniform float _IsHit;
      uniform float3 _HitColor;
      uniform float _HitIntensity;
      uniform float4 _ColorShadow;
      uniform float _LightArea;
      uniform float _ShadowSaturation;
      uniform float _ShadowSmooth;
      uniform sampler2D _MainTex;
      uniform sampler2D _ShadowTex;
      struct appdata_t
      {
          float4 vertex :POSITION0;
          float3 normal :NORMAL0;
          float2 texcoord :TEXCOORD0;
      };
      
      struct OUT_Data_Vert
      {
          float2 texcoord :TEXCOORD0;
          float4 texcoord1 :TEXCOORD1;
          float3 texcoord2 :TEXCOORD2;
          float4 vertex :SV_POSITION;
      };
      
      struct v2f
      {
          float2 texcoord :TEXCOORD0;
          float4 texcoord1 :TEXCOORD1;
          float3 texcoord2 :TEXCOORD2;
      };
      
      struct OUT_Data_Frag
      {
          float4 color :SV_Target0;
      };
      
      float4 u_xlat0;
      float4 u_xlat1;
      float u_xlat6;
      OUT_Data_Vert vert(appdata_t in_v)
      {
          OUT_Data_Vert out_v;
          u_xlat0 = (in_v.vertex.yyyy * conv_mxt4x4_1(unity_ObjectToWorld));
          u_xlat0 = ((conv_mxt4x4_0(unity_ObjectToWorld) * in_v.vertex.xxxx) + u_xlat0);
          u_xlat0 = ((conv_mxt4x4_2(unity_ObjectToWorld) * in_v.vertex.zzzz) + u_xlat0);
          u_xlat1 = (u_xlat0 + conv_mxt4x4_3(unity_ObjectToWorld));
          out_v.texcoord1 = ((conv_mxt4x4_3(unity_ObjectToWorld) * in_v.vertex.wwww) + u_xlat0);
          out_v.vertex = mul(unity_MatrixVP, u_xlat1);
          out_v.texcoord.xy = in_v.texcoord.xy;
          u_xlat0.x = dot(in_v.normal.xyz, conv_mxt4x4_0(unity_WorldToObject).xyz);
          u_xlat0.y = dot(in_v.normal.xyz, conv_mxt4x4_1(unity_WorldToObject).xyz);
          u_xlat0.z = dot(in_v.normal.xyz, conv_mxt4x4_2(unity_WorldToObject).xyz);
          out_v.texcoord2.xyz = normalize(u_xlat0.xyz);
          return out_v;
      }
      
      #define CODE_BLOCK_FRAGMENT
      float3 u_xlat0_d;
      float3 u_xlat16_0;
      float3 u_xlat1_d;
      float4 u_xlat16_1;
      float3 u_xlat16_2;
      float3 u_xlat3;
      float3 u_xlat4;
      float u_xlat16_7;
      float u_xlat15;
      float u_xlat16;
      OUT_Data_Frag frag(v2f in_f)
      {
          OUT_Data_Frag out_f;
          u_xlat0_d.xy = TRANSFORM_TEX(in_f.texcoord.xy, _ShadowTex);
          u_xlat16_0.xyz = tex2D(_ShadowTex, u_xlat0_d.xy).xyz;
          u_xlat1_d.xy = TRANSFORM_TEX(in_f.texcoord.xy, _MainTex);
          u_xlat16_1 = tex2D(_MainTex, u_xlat1_d.xy);
          u_xlat16_2.x = dot(float3(0.215399995, 0.715399981, 0.0720999986), u_xlat16_1.xyz);
          u_xlat3.xyz = (u_xlat16_1.xyz + (-u_xlat16_2.xxx));
          u_xlat3.xyz = ((u_xlat3.xyz * float3(2, 2, 2)) + u_xlat16_2.xxx);
          u_xlat3.xyz = ((-u_xlat16_1.xyz) + u_xlat3.xyz);
          u_xlat15 = ((u_xlat16_1.w * 2) + (-1));
          u_xlat15 = ((_AOStrength * u_xlat15) + 1);
          #ifdef UNITY_ADRENO_ES3
          u_xlat15 = min(max(u_xlat15, 0), 1);
          #else
          u_xlat15 = clamp(u_xlat15, 0, 1);
          #endif
          u_xlat16_2.x = ((u_xlat15 * 0.699999988) + 0.300000012);
          u_xlat16 = (u_xlat16_2.x * _ShadowSaturation);
          u_xlat3.xyz = ((float3(u_xlat16, u_xlat16, u_xlat16) * u_xlat3.xyz) + u_xlat16_1.xyz);
          u_xlat3.xyz = (u_xlat3.xyz * _ColorShadow.xyz);
          u_xlat3.xyz = (u_xlat3.xyz * _LightColor0.xyz);
          u_xlat0_d.xyz = ((u_xlat16_0.xyz * _MainColor.xyz) + (-u_xlat3.xyz));
          u_xlat0_d.xyz = ((float3(_UseShadowMap, _UseShadowMap, _UseShadowMap) * u_xlat0_d.xyz) + u_xlat3.xyz);
          u_xlat3.xyz = normalize(_WorldSpaceLightPos0.xyz);
          u_xlat4.xyz = normalize(in_f.texcoord2.xyz);
          u_xlat16_2.x = dot(u_xlat4.xyz, u_xlat3.xyz);
          u_xlat16_2.x = ((u_xlat16_2.x * 0.5) + 0.5);
          u_xlat16 = (u_xlat16_2.x + (-_LightArea));
          u_xlat3.x = (float(1) / _ShadowSmooth);
          u_xlat16 = (u_xlat16 * u_xlat3.x);
          #ifdef UNITY_ADRENO_ES3
          u_xlat16 = min(max(u_xlat16, 0), 1);
          #else
          u_xlat16 = clamp(u_xlat16, 0, 1);
          #endif
          u_xlat3.x = ((u_xlat16 * (-2)) + 3);
          u_xlat16 = (u_xlat16 * u_xlat16);
          u_xlat16 = (u_xlat16 * u_xlat3.x);
          u_xlat3.x = (u_xlat15 * u_xlat16);
          u_xlat15 = (((-u_xlat16) * u_xlat15) + 1);
          u_xlat1_d.xyz = (u_xlat16_1.xyz * u_xlat3.xxx);
          u_xlat1_d.xyz = (u_xlat1_d.xyz * _LightColor0.xyz);
          u_xlat1_d.xyz = (u_xlat1_d.xyz * _MainColor.xyz);
          u_xlat0_d.xyz = ((u_xlat0_d.xyz * float3(u_xlat15, u_xlat15, u_xlat15)) + u_xlat1_d.xyz);
          u_xlat1_d.xyz = ((-in_f.texcoord1.xyz) + _WorldSpaceCameraPos.xyz);
          u_xlat1_d.xyz = normalize(u_xlat1_d.xyz);
          u_xlat16_2.x = dot(u_xlat4.xyz, u_xlat1_d.xyz);
          u_xlat16_2.x = max(u_xlat16_2.x, 0);
          u_xlat16_2.x = ((-u_xlat16_2.x) + 1);
          u_xlat16_2.x = log2(u_xlat16_2.x);
          u_xlat16_7 = ((-_HitIntensity) + 8);
          u_xlat16_2.x = (u_xlat16_2.x * u_xlat16_7);
          u_xlat16_2.x = exp2(u_xlat16_2.x);
          u_xlat16_2.xyz = (u_xlat16_2.xxx * _HitColor.xyz);
          u_xlat0_d.xyz = ((float3(float3(_IsHit, _IsHit, _IsHit)) * u_xlat16_2.xyz) + u_xlat0_d.xyz);
          out_f.color.xyz = u_xlat0_d.xyz;
          out_f.color.w = 1;
          return out_f;
      }
      
      
      ENDCG
      
    } // end phase
    Pass // ind: 2, name: Outline
    {
      Name "Outline"
      Tags
      { 
      }
      Cull Front
      // m_ProgramMask = 6
      CGPROGRAM
      //#pragma target 4.0
      
      #pragma vertex vert
      #pragma fragment frag
      
      #include "UnityCG.cginc"
      #define conv_mxt4x4_0(mat4x4) float4(mat4x4[0].x,mat4x4[1].x,mat4x4[2].x,mat4x4[3].x)
      #define conv_mxt4x4_1(mat4x4) float4(mat4x4[0].y,mat4x4[1].y,mat4x4[2].y,mat4x4[3].y)
      #define conv_mxt4x4_2(mat4x4) float4(mat4x4[0].z,mat4x4[1].z,mat4x4[2].z,mat4x4[3].z)
      #define conv_mxt4x4_3(mat4x4) float4(mat4x4[0].w,mat4x4[1].w,mat4x4[2].w,mat4x4[3].w)
      
      
      #define CODE_BLOCK_VERTEX
      //uniform float3 _WorldSpaceCameraPos;
      //uniform float4x4 unity_ObjectToWorld;
      //uniform float4x4 unity_MatrixVP;
      uniform float _OutlineWidth;
      uniform float _UnifomWidth;
      uniform float3 _OutlineColor;
      struct appdata_t
      {
          float4 vertex :POSITION0;
          float3 normal :NORMAL0;
          float4 color :COLOR0;
      };
      
      struct OUT_Data_Vert
      {
          float4 vertex :SV_POSITION;
      };
      
      struct v2f
      {
          float4 vertex :Position;
      };
      
      struct OUT_Data_Frag
      {
          float4 color :SV_Target0;
      };
      
      float4 u_xlat0;
      float4 u_xlat1;
      float3 u_xlat2;
      float u_xlat6;
      OUT_Data_Vert vert(appdata_t in_v)
      {
          OUT_Data_Vert out_v;
          u_xlat0.xyz = (in_v.vertex.yyy * conv_mxt4x4_1(unity_ObjectToWorld).xyz);
          u_xlat0.xyz = ((conv_mxt4x4_0(unity_ObjectToWorld).xyz * in_v.vertex.xxx) + u_xlat0.xyz);
          u_xlat0.xyz = ((conv_mxt4x4_2(unity_ObjectToWorld).xyz * in_v.vertex.zzz) + u_xlat0.xyz);
          u_xlat0.xyz = ((conv_mxt4x4_3(unity_ObjectToWorld).xyz * in_v.vertex.www) + u_xlat0.xyz);
          u_xlat0.xyz = ((-u_xlat0.xyz) + _WorldSpaceCameraPos.xyz);
          u_xlat0.x = length(u_xlat0.xyz);
          u_xlat0.x = (u_xlat0.x + (-1));
          u_xlat0.x = ((_UnifomWidth * u_xlat0.x) + 1);
          u_xlat2.x = dot(in_v.normal.xyz, in_v.normal.xyz);
          u_xlat2.x = rsqrt(u_xlat2.x);
          u_xlat2.xyz = (u_xlat2.xxx * in_v.normal.xyz);
          u_xlat2.xyz = (u_xlat2.xyz * float3(float3(_OutlineWidth, _OutlineWidth, _OutlineWidth)));
          u_xlat0.xyz = (u_xlat0.xxx * u_xlat2.xyz);
          u_xlat6 = max(in_v.color.z, in_v.color.y);
          u_xlat6 = max(u_xlat6, in_v.color.x);
          u_xlat0.xyz = (float3(u_xlat6, u_xlat6, u_xlat6) * u_xlat0.xyz);
          u_xlat0.xyz = ((u_xlat0.xyz * float3(0.00999999978, 0.00999999978, 0.00999999978)) + in_v.vertex.xyz);
          out_v.vertex = UnityObjectToClipPos(u_xlat0);
          return out_v;
      }
      
      #define CODE_BLOCK_FRAGMENT
      OUT_Data_Frag frag(v2f in_f)
      {
          OUT_Data_Frag out_f;
          out_f.color.xyz = _OutlineColor.xyz;
          out_f.color.w = 1;
          return out_f;
      }
      
      
      ENDCG
      
    } // end phase
  }
  FallBack Off
}
