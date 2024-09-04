Shader "ShaderReference/ShaderModule/Base/uvAnimation"
{
    Properties
    {
        _BaseMap("BaseMap" , 2D) = "white"{}
        _Color("Color",Color) = (1,1,1,1)
        _ScrollSpeedX("ScrollSpeedX" , float) = 0.1
        _ScrollSpeedY("ScrollSpeedY" , float) = 0.1
    }
    SubShader
    {
        Tags{"RenderPipeline" = "UniversalPipeline" "RenderType" = "Opaque" "Queue" = "Geometry"}

        LOD 100

        pass
        {
            Tags{"LightMode" = "UniversalForward"}
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            
            struct Attributes
            {
                float4 positionOS     : POSITION;
                float2 texcoord     : TEXCOORD;
            };
            struct Varyings
            {
                float4 positionHCS  : SV_POSITION;
                float2 uv           : TEXCOORD;
            };
            
            TEXTURE2D(_BaseMap);SAMPLER(sampler_BaseMap);

            CBUFFER_START(UnityPerMaterial)
                float4 _BaseMap_ST;
                float4 _Color;
                float  _ScrollSpeedX;
                float  _ScrollSpeedY;
            CBUFFER_END

            Varyings vert(Attributes v)
            {
                Varyings o = (Varyings)0;

                o.positionHCS = TransformObjectToHClip(v.positionOS.xyz);
                o.uv = TRANSFORM_TEX(v.texcoord , _BaseMap);

                //uv动画
                float2 scrollUV = float2(_ScrollSpeedX,_ScrollSpeedY) * _Time.y + o.uv;
                //将新得到的值赋予uv
                o.uv = scrollUV;

                return o;
            }

            half4 frag(Varyings i):SV_TARGET
            {
                half4 FinalColor;

                half4 baseMap = SAMPLE_TEXTURE2D(_BaseMap,sampler_BaseMap , i.uv);

                FinalColor = baseMap * _Color;

                return FinalColor;
            }
            ENDHLSL  
        }
    }
}
