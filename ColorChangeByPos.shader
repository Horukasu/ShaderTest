﻿Shader "Unlit/ColorChangeByPos"
{
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag noshodow
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
				fixed4 color : COLOR;
            };


            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
				float4 worldPos = mul(unity_ObjectToWorld, v.vertex); //各頂点のワールド座標を取得
				o.color = (abs(worldPos)); //マイナスにならないようにする
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
				fixed4 col = i.color;
                return col;
            }
            ENDCG
        }
    }
}
