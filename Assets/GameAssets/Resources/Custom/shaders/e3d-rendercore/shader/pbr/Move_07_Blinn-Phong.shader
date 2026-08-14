Shader "Move/07_Blinn-Phong"
{
  Properties
  {
    _Color ("Color", Color) = (0.5,0.5,0.5,1)
    _MainTex ("MainTex", 2D) = "white" {}
    _BumpMap ("BumpMap", 2D) = "bump" {}
    _RimLightColor ("RimLightColor", Color) = (0.5,0.5,0.5,1)
    _RimLightPower ("RimLightPower", float) = 5
    _SpecPower ("SpecPower", float) = 1
    _SpecColor ("SpecColor", Color) = (1,1,1,1)
    _ReflectionColor ("ReflectionColor", Color) = (0.5,0.5,0.5,1)
    _SpecRGBGlossA ("Spec(RGB)Gloss(A)", 2D) = "white" {}
    _GlossAdd ("GlossAdd", float) = 0.25
    _GlowColor ("GlowColor", Color) = (0.5,0.5,0.5,1)
    _GlowTexture ("GlowTexture", 2D) = "black" {}
    _Reflection ("Reflection", Cube) = "_Skybox" {}
    _ReflectionAdd ("Reflection Add", float) = 1
  }
  SubShader
  {
    Tags
    { 
      "RenderType" = "Opaque"
    }
    LOD 100
    Pass // ind: 1, name: FORWARD
    {
      Name "FORWARD"
      Tags
      { 
        "LIGHTMODE" = "FORWARDBASE"
        "RenderType" = "Opaque"
        "SHADOWSUPPORT" = "true"
      }
      LOD 100
      // m_ProgramMask = 6
      CGPROGRAM
      #pragma multi_compile DIRECTIONAL
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
      //uniform float4 glstate_lightmodel_ambient;
      uniform float4 _LightColor0;
      uniform float4 _Color;
      uniform float4 _MainTex_ST;
      uniform float4 _GlowColor;
      uniform float4 _GlowTexture_ST;
      uniform float4 _BumpMap_ST;
      uniform float4 _RimLightColor;
      uniform float _RimLightPower;
      uniform float _SpecPower;
      uniform float4 _SpecColor;
      uniform float _ReflectionAdd;
      uniform float4 _ReflectionColor;
      uniform float4 _SpecRGBGlossA_ST;
      uniform float _GlossAdd;
      uniform sampler2D _BumpMap;
      uniform sampler2D _SpecRGBGlossA;
      uniform samplerCUBE _Reflection;
      uniform sampler2D _MainTex;
      uniform sampler2D _GlowTexture;
      struct appdata_t
      {
          float4 vertex :POSITION0;
          float3 normal :NORMAL0;
          float4 tangent :TANGENT0;
          float2 texcoord :TEXCOORD0;
      };
      
      struct OUT_Data_Vert
      {
          float2 texcoord :TEXCOORD0;
          float4 texcoord1 :TEXCOORD1;
          float3 texcoord2 :TEXCOORD2;
          float3 texcoord3 :TEXCOORD3;
          float3 texcoord4 :TEXCOORD4;
          float4 vertex :SV_POSITION;
      };
      
      struct v2f
      {
          float2 texcoord :TEXCOORD0;
          float4 texcoord1 :TEXCOORD1;
          float3 texcoord2 :TEXCOORD2;
          float3 texcoord3 :TEXCOORD3;
          float3 texcoord4 :TEXCOORD4;
      };
      
      struct OUT_Data_Frag
      {
          float4 color :SV_Target0;
      };
      
      float4 u_xlat0;
      float4 u_xlat1;
      float3 u_xlat2;
      float u_xlat9;
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
          u_xlat0.xyz = normalize(u_xlat0.xyz);
          out_v.texcoord2.xyz = u_xlat0.xyz;
          u_xlat1.xyz = (in_v.tangent.yyy * conv_mxt4x4_1(unity_ObjectToWorld).xyz);
          u_xlat1.xyz = ((conv_mxt4x4_0(unity_ObjectToWorld).xyz * in_v.tangent.xxx) + u_xlat1.xyz);
          u_xlat1.xyz = ((conv_mxt4x4_2(unity_ObjectToWorld).xyz * in_v.tangent.zzz) + u_xlat1.xyz);
          u_xlat1.xyz = normalize(u_xlat1.xyz);
          out_v.texcoord3.xyz = u_xlat1.xyz;
          u_xlat2.xyz = (u_xlat0.zxy * u_xlat1.yzx);
          u_xlat0.xyz = ((u_xlat0.yzx * u_xlat1.zxy) + (-u_xlat2.xyz));
          u_xlat0.xyz = (u_xlat0.xyz * in_v.tangent.www);
          out_v.texcoord4.xyz = normalize(u_xlat0.xyz);
          return out_v;
      }
      
      #define CODE_BLOCK_FRAGMENT
      float3 u_xlat0_d;
      float3 u_xlat1_d;
      float4 u_xlat16_1;
      float3 u_xlat2_d;
      float3 u_xlat16_2;
      float3 u_xlat16_3;
      float3 u_xlat4;
      float3 u_xlat5;
      float3 u_xlat16_5;
      float3 u_xlat6;
      float3 u_xlat7;
      int u_xlatb7;
      float u_xlat14;
      float u_xlat22;
      float u_xlat23;
      OUT_Data_Frag frag(v2f in_f)
      {
          OUT_Data_Frag out_f;
          u_xlat0_d.x = (_GlossAdd + (-0.5));
          u_xlat0_d.x = (((-u_xlat0_d.x) * 2) + 1);
          u_xlat7.xy = TRANSFORM_TEX(in_f.texcoord.xy, _SpecRGBGlossA);
          u_xlat16_1 = tex2D(_SpecRGBGlossA, u_xlat7.xy);
          u_xlat7.x = ((-u_xlat16_1.w) + 1);
          u_xlat0_d.x = (((-u_xlat0_d.x) * u_xlat7.x) + 1);
          #ifdef UNITY_ADRENO_ES3
          u_xlatb7 = (0.5<_GlossAdd);
          #else
          u_xlatb7 = (0.5<_GlossAdd);
          #endif
          u_xlat14 = dot(u_xlat16_1.ww, float2(_GlossAdd, _GlossAdd));
          u_xlat1_d.xyz = (u_xlat16_1.xyz * _ReflectionColor.xyz);
          u_xlat0_d.x = (u_xlatb7)?(u_xlat0_d.x):(u_xlat14);
          #ifdef UNITY_ADRENO_ES3
          u_xlat0_d.x = min(max(u_xlat0_d.x, 0), 1);
          #else
          u_xlat0_d.x = clamp(u_xlat0_d.x, 0, 1);
          #endif
          u_xlat7.x = dot(in_f.texcoord2.xyz, in_f.texcoord2.xyz);
          u_xlat7.x = rsqrt(u_xlat7.x);
          u_xlat7.xyz = (u_xlat7.xxx * in_f.texcoord2.xyz);
          u_xlat2_d.xy = TRANSFORM_TEX(in_f.texcoord.xy, _BumpMap);
          u_xlat16_2.xyz = tex2D(_BumpMap, u_xlat2_d.xy).xyz;
          u_xlat16_3.xyz = ((u_xlat16_2.xyz * float3(2, 2, 2)) + float3(-1, (-1), (-1)));
          u_xlat2_d.xyz = (u_xlat16_3.yyy * in_f.texcoord4.xyz);
          u_xlat2_d.xyz = ((u_xlat16_3.xxx * in_f.texcoord3.xyz) + u_xlat2_d.xyz);
          u_xlat7.xyz = ((u_xlat16_3.zzz * u_xlat7.xyz) + u_xlat2_d.xyz);
          u_xlat22 = dot(u_xlat7.xyz, u_xlat7.xyz);
          u_xlat22 = rsqrt(u_xlat22);
          u_xlat7.xyz = (u_xlat7.xyz * float3(u_xlat22, u_xlat22, u_xlat22));
          u_xlat2_d.xyz = ((-in_f.texcoord1.xyz) + _WorldSpaceCameraPos.xyz);
          u_xlat4.xyz = normalize(u_xlat2_d.xyz);
          u_xlat23 = dot((-u_xlat4.xyz), u_xlat7.xyz);
          u_xlat23 = (u_xlat23 + u_xlat23);
          u_xlat5.xyz = ((u_xlat7.xyz * (-float3(u_xlat23, u_xlat23, u_xlat23))) + (-u_xlat4.xyz));
          u_xlat23 = dot(u_xlat7.xyz, u_xlat4.xyz);
          u_xlat23 = max(u_xlat23, 0);
          u_xlat23 = ((-u_xlat23) + 1);
          u_xlat23 = log2(u_xlat23);
          u_xlat23 = (u_xlat23 * _RimLightPower);
          u_xlat23 = exp2(u_xlat23);
          u_xlat4.xyz = (float3(u_xlat23, u_xlat23, u_xlat23) * _RimLightColor.xyz);
          u_xlat16_5.xyz = texCUBE(_Reflection, u_xlat5.xyz).xyz;
          u_xlat5.xyz = (u_xlat0_d.xxx * u_xlat16_5.xyz);
          u_xlat0_d.x = ((u_xlat0_d.x * 10) + 1);
          u_xlat0_d.x = exp2(u_xlat0_d.x);
          u_xlat5.xyz = (u_xlat5.xyz * float3(_ReflectionAdd, _ReflectionAdd, _ReflectionAdd));
          u_xlat5.xyz = (u_xlat5.xyz * _ReflectionColor.xyz);
          u_xlat6.xyz = (float3(float3(_SpecPower, _SpecPower, _SpecPower)) * _SpecColor.xyz);
          u_xlat1_d.xyz = (u_xlat1_d.xyz * u_xlat6.xyz);
          u_xlat5.xyz = (u_xlat1_d.xyz * u_xlat5.xyz);
          u_xlat16_3.x = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
          u_xlat16_3.x = rsqrt(u_xlat16_3.x);
          u_xlat16_3.xyz = (u_xlat16_3.xxx * _WorldSpaceLightPos0.xyz);
          u_xlat2_d.xyz = ((u_xlat2_d.xyz * float3(u_xlat22, u_xlat22, u_xlat22)) + u_xlat16_3.xyz);
          u_xlat22 = dot(u_xlat7.xyz, u_xlat16_3.xyz);
          u_xlat22 = max(u_xlat22, 0);
          u_xlat2_d.xyz = normalize(u_xlat2_d.xyz);
          u_xlat7.x = dot(u_xlat2_d.xyz, u_xlat7.xyz);
          u_xlat7.x = max(u_xlat7.x, 0);
          u_xlat7.x = log2(u_xlat7.x);
          u_xlat0_d.x = (u_xlat7.x * u_xlat0_d.x);
          u_xlat0_d.x = exp2(u_xlat0_d.x);
          u_xlat0_d.xyz = (u_xlat0_d.xxx * _LightColor0.xyz);
          u_xlat0_d.xyz = ((u_xlat0_d.xyz * u_xlat1_d.xyz) + u_xlat5.xyz);
          u_xlat1_d.xyz = ((glstate_lightmodel_ambient.xyz * float3(2, 2, 2)) + u_xlat4.xyz);
          u_xlat1_d.xyz = ((float3(u_xlat22, u_xlat22, u_xlat22) * _LightColor0.xyz) + u_xlat1_d.xyz);
          u_xlat2_d.xy = TRANSFORM_TEX(in_f.texcoord.xy, _MainTex);
          u_xlat16_2.xyz = tex2D(_MainTex, u_xlat2_d.xy).xyz;
          u_xlat2_d.xyz = ((_Color.xyz * u_xlat16_2.xyz) + u_xlat4.xyz);
          u_xlat0_d.xyz = ((u_xlat1_d.xyz * u_xlat2_d.xyz) + u_xlat0_d.xyz);
          u_xlat1_d.xy = TRANSFORM_TEX(in_f.texcoord.xy, _GlowTexture);
          u_xlat16_1.xyz = tex2D(_GlowTexture, u_xlat1_d.xy).xyz;
          out_f.color.xyz = ((u_xlat16_1.xyz * _GlowColor.xyz) + u_xlat0_d.xyz);
          out_f.color.w = 1;
          return out_f;
      }
      
      
      ENDCG
      
    } // end phase
    Pass // ind: 2, name: FORWARD_DELTA
    {
      Name "FORWARD_DELTA"
      Tags
      { 
        "LIGHTMODE" = "FORWARDADD"
        "RenderType" = "Opaque"
        "SHADOWSUPPORT" = "true"
      }
      LOD 100
      Blend One One
      // m_ProgramMask = 6
      CGPROGRAM
      #pragma multi_compile POINT
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
      uniform float4x4 unity_WorldToLight;
      //uniform float3 _WorldSpaceCameraPos;
      //uniform float4 _WorldSpaceLightPos0;
      uniform float4 _LightColor0;
      uniform float4 _Color;
      uniform float4 _MainTex_ST;
      uniform float4 _BumpMap_ST;
      uniform float4 _RimLightColor;
      uniform float _RimLightPower;
      uniform float _SpecPower;
      uniform float4 _SpecColor;
      uniform float4 _ReflectionColor;
      uniform float4 _SpecRGBGlossA_ST;
      uniform float _GlossAdd;
      uniform sampler2D _BumpMap;
      uniform sampler2D _LightTexture0;
      uniform sampler2D _SpecRGBGlossA;
      uniform sampler2D _MainTex;
      struct appdata_t
      {
          float4 vertex :POSITION0;
          float3 normal :NORMAL0;
          float4 tangent :TANGENT0;
          float2 texcoord :TEXCOORD0;
      };
      
      struct OUT_Data_Vert
      {
          float2 texcoord :TEXCOORD0;
          float4 texcoord1 :TEXCOORD1;
          float3 texcoord2 :TEXCOORD2;
          float3 texcoord3 :TEXCOORD3;
          float3 texcoord4 :TEXCOORD4;
          float3 texcoord5 :TEXCOORD5;
          float4 vertex :SV_POSITION;
      };
      
      struct v2f
      {
          float2 texcoord :TEXCOORD0;
          float4 texcoord1 :TEXCOORD1;
          float3 texcoord2 :TEXCOORD2;
          float3 texcoord3 :TEXCOORD3;
          float3 texcoord4 :TEXCOORD4;
          float3 texcoord5 :TEXCOORD5;
      };
      
      struct OUT_Data_Frag
      {
          float4 color :SV_Target0;
      };
      
      float4 u_xlat0;
      float4 u_xlat1;
      float4 u_xlat2;
      float3 u_xlat3;
      float u_xlat13;
      OUT_Data_Vert vert(appdata_t in_v)
      {
          OUT_Data_Vert out_v;
          u_xlat0 = (in_v.vertex.yyyy * conv_mxt4x4_1(unity_ObjectToWorld));
          u_xlat0 = ((conv_mxt4x4_0(unity_ObjectToWorld) * in_v.vertex.xxxx) + u_xlat0);
          u_xlat0 = ((conv_mxt4x4_2(unity_ObjectToWorld) * in_v.vertex.zzzz) + u_xlat0);
          u_xlat1 = (u_xlat0 + conv_mxt4x4_3(unity_ObjectToWorld));
          u_xlat0 = ((conv_mxt4x4_3(unity_ObjectToWorld) * in_v.vertex.wwww) + u_xlat0);
          out_v.vertex = mul(unity_MatrixVP, u_xlat1);
          out_v.texcoord.xy = in_v.texcoord.xy;
          out_v.texcoord1 = u_xlat0;
          u_xlat1.x = dot(in_v.normal.xyz, conv_mxt4x4_0(unity_WorldToObject).xyz);
          u_xlat1.y = dot(in_v.normal.xyz, conv_mxt4x4_1(unity_WorldToObject).xyz);
          u_xlat1.z = dot(in_v.normal.xyz, conv_mxt4x4_2(unity_WorldToObject).xyz);
          u_xlat1.xyz = normalize(u_xlat1.xyz);
          out_v.texcoord2.xyz = u_xlat1.xyz;
          u_xlat2.xyz = (in_v.tangent.yyy * conv_mxt4x4_1(unity_ObjectToWorld).xyz);
          u_xlat2.xyz = ((conv_mxt4x4_0(unity_ObjectToWorld).xyz * in_v.tangent.xxx) + u_xlat2.xyz);
          u_xlat2.xyz = ((conv_mxt4x4_2(unity_ObjectToWorld).xyz * in_v.tangent.zzz) + u_xlat2.xyz);
          u_xlat2.xyz = normalize(u_xlat2.xyz);
          out_v.texcoord3.xyz = u_xlat2.xyz;
          u_xlat3.xyz = (u_xlat1.zxy * u_xlat2.yzx);
          u_xlat1.xyz = ((u_xlat1.yzx * u_xlat2.zxy) + (-u_xlat3.xyz));
          u_xlat1.xyz = (u_xlat1.xyz * in_v.tangent.www);
          out_v.texcoord4.xyz = normalize(u_xlat1.xyz);
          u_xlat1.xyz = (u_xlat0.yyy * conv_mxt4x4_1(unity_WorldToLight).xyz);
          u_xlat1.xyz = ((conv_mxt4x4_0(unity_WorldToLight).xyz * u_xlat0.xxx) + u_xlat1.xyz);
          u_xlat0.xyz = ((conv_mxt4x4_2(unity_WorldToLight).xyz * u_xlat0.zzz) + u_xlat1.xyz);
          out_v.texcoord5.xyz = ((conv_mxt4x4_3(unity_WorldToLight).xyz * u_xlat0.www) + u_xlat0.xyz);
          return out_v;
      }
      
      #define CODE_BLOCK_FRAGMENT
      float3 u_xlat0_d;
      float3 u_xlat1_d;
      float4 u_xlat16_1;
      float3 u_xlat2_d;
      float3 u_xlat16_2;
      float3 u_xlat16_3;
      float3 u_xlat4;
      float3 u_xlat16_4;
      float3 u_xlat5;
      float3 u_xlat6;
      int u_xlatb6;
      float3 u_xlat8;
      float u_xlat12;
      float u_xlat19;
      OUT_Data_Frag frag(v2f in_f)
      {
          OUT_Data_Frag out_f;
          u_xlat0_d.x = (_GlossAdd + (-0.5));
          u_xlat0_d.x = (((-u_xlat0_d.x) * 2) + 1);
          u_xlat6.xy = TRANSFORM_TEX(in_f.texcoord.xy, _SpecRGBGlossA);
          u_xlat16_1 = tex2D(_SpecRGBGlossA, u_xlat6.xy);
          u_xlat6.x = ((-u_xlat16_1.w) + 1);
          u_xlat0_d.x = (((-u_xlat0_d.x) * u_xlat6.x) + 1);
          #ifdef UNITY_ADRENO_ES3
          u_xlatb6 = (0.5<_GlossAdd);
          #else
          u_xlatb6 = (0.5<_GlossAdd);
          #endif
          u_xlat12 = dot(u_xlat16_1.ww, float2(_GlossAdd, _GlossAdd));
          u_xlat1_d.xyz = (u_xlat16_1.xyz * _ReflectionColor.xyz);
          u_xlat0_d.x = (u_xlatb6)?(u_xlat0_d.x):(u_xlat12);
          #ifdef UNITY_ADRENO_ES3
          u_xlat0_d.x = min(max(u_xlat0_d.x, 0), 1);
          #else
          u_xlat0_d.x = clamp(u_xlat0_d.x, 0, 1);
          #endif
          u_xlat0_d.x = ((u_xlat0_d.x * 10) + 1);
          u_xlat0_d.x = exp2(u_xlat0_d.x);
          u_xlat6.x = dot(in_f.texcoord2.xyz, in_f.texcoord2.xyz);
          u_xlat6.x = rsqrt(u_xlat6.x);
          u_xlat6.xyz = (u_xlat6.xxx * in_f.texcoord2.xyz);
          u_xlat2_d.xy = TRANSFORM_TEX(in_f.texcoord.xy, _BumpMap);
          u_xlat16_2.xyz = tex2D(_BumpMap, u_xlat2_d.xy).xyz;
          u_xlat16_3.xyz = ((u_xlat16_2.xyz * float3(2, 2, 2)) + float3(-1, (-1), (-1)));
          u_xlat2_d.xyz = (u_xlat16_3.yyy * in_f.texcoord4.xyz);
          u_xlat2_d.xyz = ((u_xlat16_3.xxx * in_f.texcoord3.xyz) + u_xlat2_d.xyz);
          u_xlat6.xyz = ((u_xlat16_3.zzz * u_xlat6.xyz) + u_xlat2_d.xyz);
          u_xlat19 = dot(u_xlat6.xyz, u_xlat6.xyz);
          u_xlat19 = rsqrt(u_xlat19);
          u_xlat6.xyz = (u_xlat6.xyz * float3(u_xlat19, u_xlat19, u_xlat19));
          u_xlat2_d.xyz = ((_WorldSpaceLightPos0.www * (-in_f.texcoord1.xyz)) + _WorldSpaceLightPos0.xyz);
          u_xlat2_d.xyz = normalize(u_xlat2_d.xyz);
          u_xlat4.xyz = ((-in_f.texcoord1.xyz) + _WorldSpaceCameraPos.xyz);
          u_xlat19 = dot(u_xlat4.xyz, u_xlat4.xyz);
          u_xlat19 = rsqrt(u_xlat19);
          u_xlat5.xyz = ((u_xlat4.xyz * float3(u_xlat19, u_xlat19, u_xlat19)) + u_xlat2_d.xyz);
          u_xlat2_d.x = dot(u_xlat6.xyz, u_xlat2_d.xyz);
          u_xlat2_d.x = max(u_xlat2_d.x, 0);
          u_xlat8.xyz = (float3(u_xlat19, u_xlat19, u_xlat19) * u_xlat4.xyz);
          u_xlat19 = dot(u_xlat6.xyz, u_xlat8.xyz);
          u_xlat19 = max(u_xlat19, 0);
          u_xlat19 = ((-u_xlat19) + 1);
          u_xlat19 = log2(u_xlat19);
          u_xlat19 = (u_xlat19 * _RimLightPower);
          u_xlat19 = exp2(u_xlat19);
          u_xlat8.xyz = (float3(u_xlat19, u_xlat19, u_xlat19) * _RimLightColor.xyz);
          u_xlat4.xyz = normalize(u_xlat5.xyz);
          u_xlat6.x = dot(u_xlat4.xyz, u_xlat6.xyz);
          u_xlat6.x = max(u_xlat6.x, 0);
          u_xlat6.x = log2(u_xlat6.x);
          u_xlat0_d.x = (u_xlat6.x * u_xlat0_d.x);
          u_xlat0_d.x = exp2(u_xlat0_d.x);
          u_xlat6.x = dot(in_f.texcoord5.xyz, in_f.texcoord5.xyz);
          u_xlat6.x = tex2D(_LightTexture0, u_xlat6.xx).x;
          u_xlat6.xyz = (u_xlat6.xxx * _LightColor0.xyz);
          u_xlat4.xyz = (u_xlat0_d.xxx * u_xlat6.xyz);
          u_xlat0_d.xyz = (u_xlat6.xyz * u_xlat2_d.xxx);
          u_xlat5.xyz = (float3(float3(_SpecPower, _SpecPower, _SpecPower)) * _SpecColor.xyz);
          u_xlat1_d.xyz = (u_xlat1_d.xyz * u_xlat5.xyz);
          u_xlat1_d.xyz = (u_xlat1_d.xyz * u_xlat4.xyz);
          u_xlat4.xy = TRANSFORM_TEX(in_f.texcoord.xy, _MainTex);
          u_xlat16_4.xyz = tex2D(_MainTex, u_xlat4.xy).xyz;
          u_xlat2_d.xyz = ((_Color.xyz * u_xlat16_4.xyz) + u_xlat8.xyz);
          out_f.color.xyz = ((u_xlat0_d.xyz * u_xlat2_d.xyz) + u_xlat1_d.xyz);
          out_f.color.w = 0;
          return out_f;
      }
      
      
      ENDCG
      
    } // end phase
  }
  FallBack "Diffuse"
}
