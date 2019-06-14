Shader "Unlit/ConvertToPointPori"
{
	Properties{
		_Color("Color",Color) = (1,1,1,1)
	}
	SubShader{
		  Tags { "RenderType" = "Transparent" "Queue" = "Transparent" }
		  LOD 100

		Pass {
		  Cull Off
		  Blend SrcAlpha OneMinusSrcAlpha
		  ZWrite Off

		  CGPROGRAM
		  #pragma target 4.0
		  #pragma vertex vert
		  #pragma geometry geo
		  #pragma fragment frag
		  #pragma multi_compile_fog
		  #include "UnityCG.cginc"

		  struct appdata {
			float4 vertex : POSITION;
			float4 color : COLOR;
		  };

		  struct v2g {
			float4 vertex : POSITION;
			float4 color : TEXCOORD0;
			float3 normal : NORMAL;
		  };

		  struct g2f {
			float4 vertex : SV_POSITION;
			float4 color  : TEXCOORD0;

			UNITY_FOG_COORDS(1)
		  };

		  float4 _Color;

		  v2g vert(appdata v) {
			v2g o;
			o.vertex = v.vertex;
			o.color = v.color;

			return o;
		  }

		  [maxvertexcount(10)]
		  void geo(triangle v2g v[3], inout PointStream<g2f> Stream) {

			for (int i = 0; i < 3; i++) {
			  v2g vb = v[(i + 0) % 3];
			  v2g v1 = v[(i + 1) % 3];
			  v2g v2 = v[(i + 2) % 3];


			  g2f o;
			  o.color = _Color;


			  o.vertex = UnityObjectToClipPos(float4(vb.vertex.xyz, 1));
			  UNITY_TRANSFER_FOG(o, o.vertex);
			  Stream.Append(o);

			  /*
			  o.vertex = UnityObjectToClipPos(float4(v1.vertex.xyz, 1));
			  UNITY_TRANSFER_FOG(o, o.vertex);
			  Stream.Append(o);

			  o.vertex = UnityObjectToClipPos(float4(v2.vertex.xyz, 1));
			  UNITY_TRANSFER_FOG(o, o.vertex);
			  Stream.Append(o);

			  */

			  Stream.RestartStrip();


			}

		  }

		  fixed4 frag(g2f i) : SV_Target {
			fixed4 col = i.color;
			UNITY_APPLY_FOG(i.fogCoord, col);
			return col;
		  }
		  ENDCG
		}

	}
}
