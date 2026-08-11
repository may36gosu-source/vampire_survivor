Shader "Ares/Particle/AlphaBlend_Mask_Tail" 
{
	Properties
	{
		_Color ("Main Color", Color) = (1, 1, 1, 1)
		_ColorMultiplier("Color Multipler",range(0,2)) = 2		
		_MainTex ("Effect Texture", 2D) = "black" {}
		_MaskTex ("Mask", 2D) = "white" {}
		_Alpha ( "Transparent ratio", Range( 0, 2 ) ) = 1
        [MaterialToggle] _UorV ("UorV Direct", Float ) = 1
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
            uniform fixed _UorV;
            uniform float _Alpha;

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

            VertexOutput vert (VertexInput v) 
			{
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.vertexColor = v.vertexColor;
                o.pos = UnityObjectToClipPos(v.vertex );
                return o;
            }
            float4 frag(VertexOutput i) : COLOR 
			{  
                float node_1228 = (i.vertexColor.a*-2.0+1.0);
                float2 _UroV_Par_var = lerp( (i.uv0+node_1228*float2(1,0)), (i.uv0+node_1228*float2(0,1)), _UorV );
                float4 _MainTex_var = tex2D(_MainTex,TRANSFORM_TEX(_UroV_Par_var, _MainTex));
                float4 _Mask_var = tex2D(_MaskTex,TRANSFORM_TEX(i.uv0, _MaskTex));
                float3 emissive = (_MainTex_var.rgb * _Mask_var.rgb*_ColorMultiplier * _Color.rgb*i.vertexColor.rgb);
                float3 finalColor = emissive;
                float alpha =((_Mask_var.rgb*_Mask_var.a).r * _Alpha *_Color.a* i.vertexColor.a*_MainTex_var.a);
                return fixed4(finalColor,alpha);
            }
            ENDCG
        }
	}
    Fallback "Gonbest/FallBack/FBNothing"
}
