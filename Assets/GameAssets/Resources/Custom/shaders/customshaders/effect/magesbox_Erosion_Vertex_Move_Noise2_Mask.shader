Shader "magesbox/Erosion_Vertex_Move_Noise2_Mask"
{
  Properties
  {
    [Foldout(1, 1,0, 1)] _BaseShowFlag ("基础设置_Foldout", float) = 1
    [Enum(UnityEngine.Rendering.CullMode)] _Cullmode ("Cull Mode", float) = 0
    [Enum(Add,1,Alpha,5)] _Blend1 ("混合参数1", float) = 1
    [Enum(Add,1,Alpha,10)] _Blend2 ("混合参数2", float) = 1
    [Enum(Disable,0,LessEqual,4,GreaterEqual,7)] _ZTest ("ZTest", float) = 0
    [HDR] _Color ("Color", Color) = (0.5,0.5,0.5,1)
    _Texure ("Main Texure", 2D) = "white" {}
    [Foldout(1,1,1,1)] _DirectUVToggle ("直接uv模式_Foldout", float) = 0
    _VertexMove ("顶点移动强度", float) = 0
    _MainTexUVOffset ("主纹理uv偏移,顶点扰动强度", Vector) = (0,0,0,0)
    _DissolveCutoff ("溶解强度", Range(0, 1)) = 0
    [Foldout(1, 1,0, 1)] _DistortUIShowFlag ("扭曲_Foldout", float) = 1
    _DistortTex ("扭曲纹理", 2D) = "block" {}
    _MainTexDistortParam ("扭曲主纹理:U速度, V速度, 强度", Vector) = (0,0,0.2,1)
    [Foldout(1,1,1,1)] _DissolveToggle ("溶解_Foldout", float) = 1
    _Soft_Value ("Soft_Value", float) = 0
    _Erosion_Texure ("溶解纹理", 2D) = "white" {}
    _Erosion_U_Move ("溶解_U_流动", float) = 0
    _Erosion_V_Move ("溶解_V_流动", float) = 0
    [Foldout(1,1,1,1)] _ErosionNoiseToggle ("溶解扰动_Foldout", float) = 0
    _ErosionTexDistortParam ("扰动:U, V, 强度", Vector) = (0,0,0.2,1)
    [Foldout(1,1,1,1)] _DissolveEdgeToggle ("溶解叠加边缘色_Foldout", float) = 0
    _Dissolve_Edge ("边缘宽度", Range(0, 1)) = 0.1
    [HDR] _Dissolve_EdgeColor ("边缘颜色", Color) = (1,1,1,1)
    [Foldout(1, 1,1, 1)] _Distort1Toggle ("Mask1_Foldout", float) = 0
    _Mask ("Mask", 2D) = "white" {}
    _U_Move ("MASK_U_流动速度", float) = 0
    _V_Move ("MASK_V_流动速度", float) = 0
    _MaskTexDistortParam ("扭曲Mask:U, V, 强度", Vector) = (0,0,0.2,1)
    [Foldout(1,1,1,1)] _Distort2Toggle ("Mask2_Foldout", float) = 0
    _Mask2 ("Mask2", 2D) = "white" {}
    _U2_Move ("MASK2_U_流动速度", float) = 0
    _V2_Move ("MASK2_V_流动速度", float) = 0
    _Mask2TexDistortParam ("扭曲Mask2:U, V, 强度", Vector) = (0,0,0.2,1)
    [Foldout(1,1,1,1)] _FresnelToggle ("菲尼尔_Foldout", float) = 0
    _FresnelIntensity ("强度", Range(0.0001, 50)) = 1
    [Toggle] _FresnelReverse ("反向", float) = 0
    [Foldout(1, 1,0, 1)] _OtherUIShowFlag ("其他参数_Foldout", float) = 1
    _Vertex_Move ("Vertex_Move", 2D) = "white" {}
    _Vertex_offset ("Vertex_offset", Vector) = (0,0,0,0)
    _Vertex_U_Move ("Vertex_U_Move", float) = 0
    _Vertex_V_Move ("Vertex_V_Move", float) = 0
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
      //uniform float4 _Time;
      //uniform float4x4 unity_ObjectToWorld;
      //uniform float4x4 unity_WorldToObject;
      //uniform float4x4 unity_MatrixVP;
      uniform float4 _Vertex_Move_ST;
      uniform float4 _Vertex_offset;
      uniform float _Vertex_U_Move;
      uniform float _Vertex_V_Move;
      uniform sampler2D _Vertex_Move;
      uniform float4 _Texure_ST;
      uniform float4 _DistortTex_ST;
      uniform float4 _MainTexDistortParam;
      uniform float4 _Color;
      uniform sampler2D _DistortTex;
      uniform sampler2D _Texure;
      struct appdata_t
      {
          float4 vertex :POSITION0;
          float3 normal :NORMAL0;
          float2 texcoord :TEXCOORD0;
          float4 texcoord1 :TEXCOORD1;
          float4 color :COLOR0;
      };
      
      struct OUT_Data_Vert
      {
          float2 texcoord :TEXCOORD0;
          float4 texcoord1 :TEXCOORD1;
          float4 texcoord2 :TEXCOORD2;
          float3 texcoord3 :TEXCOORD3;
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
      float u_xlat6;
      OUT_Data_Vert vert(appdata_t in_v)
      {
          OUT_Data_Vert out_v;
          u_xlat0.xy = ((float2(_Vertex_U_Move, _Vertex_V_Move) * _Time.yy) + in_v.texcoord.xy);
          u_xlat0.xy = TRANSFORM_TEX(u_xlat0.xy, _Vertex_Move);
          u_xlat0.xyz = tex2Dlod(_Vertex_Move, float4(float3(u_xlat0.xy, 0), 0)).xyz;
          u_xlat0.xyz = (u_xlat0.xyz * in_v.normal.xyz);
          u_xlat0.xyz = (u_xlat0.xyz * in_v.texcoord1.www);
          u_xlat0.xyz = ((u_xlat0.xyz * _Vertex_offset.xyz) + in_v.vertex.xyz);
          u_xlat1 = (u_xlat0.yyyy * conv_mxt4x4_1(unity_ObjectToWorld));
          u_xlat1 = ((conv_mxt4x4_0(unity_ObjectToWorld) * u_xlat0.xxxx) + u_xlat1);
          u_xlat0 = ((conv_mxt4x4_2(unity_ObjectToWorld) * u_xlat0.zzzz) + u_xlat1);
          u_xlat1 = (u_xlat0 + conv_mxt4x4_3(unity_ObjectToWorld));
          out_v.texcoord2 = ((conv_mxt4x4_3(unity_ObjectToWorld) * in_v.vertex.wwww) + u_xlat0);
          out_v.vertex = mul(unity_MatrixVP, u_xlat1);
          out_v.texcoord.xy = in_v.texcoord.xy;
          out_v.texcoord1 = in_v.texcoord1;
          u_xlat0.x = dot(in_v.normal.xyz, conv_mxt4x4_0(unity_WorldToObject).xyz);
          u_xlat0.y = dot(in_v.normal.xyz, conv_mxt4x4_1(unity_WorldToObject).xyz);
          u_xlat0.z = dot(in_v.normal.xyz, conv_mxt4x4_2(unity_WorldToObject).xyz);
          out_v.texcoord3.xyz = normalize(u_xlat0.xyz);
          out_v.color = in_v.color;
          return out_v;
      }
      
      #define CODE_BLOCK_FRAGMENT
      float3 u_xlat0_d;
      float4 u_xlat16_0;
      float2 u_xlat1_d;
      OUT_Data_Frag frag(v2f in_f)
      {
          OUT_Data_Frag out_f;
          u_xlat0_d.xy = TRANSFORM_TEX(in_f.texcoord.xy, _DistortTex);
          u_xlat0_d.xy = ((_Time.yy * _MainTexDistortParam.xy) + u_xlat0_d.xy);
          u_xlat16_0.x = tex2D(_DistortTex, u_xlat0_d.xy).x;
          u_xlat1_d.xy = (in_f.texcoord.xy + in_f.texcoord1.xy);
          u_xlat1_d.xy = TRANSFORM_TEX(u_xlat1_d.xy, _Texure);
          u_xlat0_d.xy = ((u_xlat16_0.xx * _MainTexDistortParam.zz) + u_xlat1_d.xy);
          u_xlat16_0 = tex2D(_Texure, u_xlat0_d.xy);
          u_xlat0_d.xyz = (u_xlat16_0.xyz * _Color.xyz);
          out_f.color.xyz = (u_xlat0_d.xyz * in_f.color.xyz);
          u_xlat0_d.x = (in_f.color.w * _Color.w);
          out_f.color.w = (u_xlat16_0.w * u_xlat0_d.x);
          return out_f;
      }
      
      
      ENDCG
      
    } // end phase
  }
  FallBack "Diffuse"
}
