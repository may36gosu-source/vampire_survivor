Shader "Ares/Particle/AlphaBlend_Mask_Flow" 
{
	Properties
	{
		_Color ("Main Color", Color) = (1, 1, 1, 1)
		_ColorMultiplier("Color Multipler",range(0,2)) = 2		
		_MainTex ("Effect Texture", 2D) = "black" {}
		_MaskTex ("Mask1", 2D) = "white" {}
        _MaskTex2 ("Mask2", 2D) = "white" {}
        _FlowSpeed("FlowSpeed",float) = 1
        [MaterialToggle] _UorV ("UorV Direct", Float ) = 1
        [MaterialToggle] _BlackcolorSwitch ("Blackcolor Switch", Float ) = 1
        _UseClip("UseClip",float) = 0
		_ClipRect("ClipRect",Vector)= (-50000,-50000,50000,50000)
		_BloomTex ("BloomTex", 2D) = "(0.5,0.5,0.5,0.5)" {}
		_BloomFactor("BloomFactor", float) = 0
	}

	SubShader
	{
		Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"  "GonbestBloomType"="BloomMask"}		
		Pass {           
            Blend SrcAlpha OneMinusSrcAlpha,Zero OneMinusSrcAlpha
            Cull Off
            ZWrite Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag            
            #include "UnityCG.cginc"
            //#pragma multi_compile_fwdbase
            //#pragma exclude_renderers gles3 metal d3d11_9x xbox360 xboxone ps3 ps4 psp2 
            //#pragma target 2.0
            uniform float4 _Color;
            uniform float _ColorMultiplier;
            uniform sampler2D _MainTex; 
            uniform float4 _MainTex_ST;
            uniform sampler2D _MaskTex; 
            uniform float4 _MaskTex_ST;
             uniform sampler2D _MaskTex2; 
            uniform float4 _MaskTex2_ST;
            uniform fixed _UorV;            
            uniform float4 _TimeEditor;
            uniform float _FlowSpeed;
            uniform fixed _BlackcolorSwitch;

            struct VertexInput {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
                float4 vertexColor : COLOR;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 vertexColor : COLOR;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.vertexColor = v.vertexColor;
                o.pos = UnityObjectToClipPos(v.vertex );
                return o;
            }
            float4 frag(VertexOutput i) : COLOR 
            {
                float4 node_2344 = _Time + _TimeEditor;
                float2 node_4986 = (i.uv0+(node_2344.r*_FlowSpeed)*float2(1,0));
                float4 _TEX_var = tex2D(_MainTex,TRANSFORM_TEX(node_4986, _MainTex));
                float node_8107 = (i.vertexColor.a*2.0+-1.0);
                float2 _maskUV_switch_var = lerp( (i.uv0+node_8107*float2(1,0)), (i.uv0+node_8107*float2(0,1)), _UorV );
                float4 _mask_var = tex2D(_MaskTex,TRANSFORM_TEX(_maskUV_switch_var, _MaskTex));
                float4 _mask2_var = tex2D(_MaskTex2,TRANSFORM_TEX(i.uv0, _MaskTex2));
                float3 emissive = ((_TEX_var.rgb*_mask_var.rgb*(_mask_var.a*_Color.rgb)*i.vertexColor.rgb*_ColorMultiplier)*_mask2_var.rgb);
                float3 finalColor = emissive;
                float a = (_mask_var.a*lerp( max(max(i.vertexColor.r,i.vertexColor.g),i.vertexColor.b), 1.0, _BlackcolorSwitch )*_mask2_var.a*_TEX_var.a);
                return fixed4(finalColor,a);
            }
            ENDCG
        }
	}
    Fallback "Gonbest/FallBack/FBNothing"
}
