Shader "Unlit/TrianglePlane"
{
    Properties{
	_MainTex("Texture", 2D) = "white" {}

	[Header(Wireframe)]
	_Color("Color", Color) = (1,1,1,1)
	_Width("Width", Float) = 0.005
	}

		SubShader{
		  Tags { "RenderType" = "Transparent" "Queue" = "Transparent" }
		  LOD 100

		// 0: wireframe pass
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
		  float _Width;

		  v2g vert(appdata_full v) {
			v2g o;
			o.vertex = v.vertex;
			o.normal = v.normal;
			o.color = v.color;
			
			return o;
		  }

		  [maxvertexcount(20)]
		  void geo(triangle v2g v[3], inout TriangleStream<g2f> PoiStream) {

			for (int i = 0; i < 3; i++) {
			  v2g vb = v[(i + 0) % 3];
			  v2g v1 = v[(i + 1) % 3];
			  v2g v2 = v[(i + 2) % 3];

			  float3 dir = normalize((v1.vertex.xyz + v2.vertex.xyz) * 0.5 - vb.vertex.xyz);

			  g2f o;
			  o.color = _Color;
				
			  
			  //原点周りを単振動する(法線＊sin)

			  

			  o.vertex = UnityObjectToClipPos(vb.vertex);
			  UNITY_TRANSFER_FOG(o, o.vertex);
			  PoiStream.Append(o);

			 
			  o.vertex = UnityObjectToClipPos(v1.vertex+(0,0,0,1));
			  UNITY_TRANSFER_FOG(o, o.vertex);
			  PoiStream.Append(o);

			  
			  o.vertex = UnityObjectToClipPos(v2.vertex);
			  UNITY_TRANSFER_FOG(o, o.vertex);
			  PoiStream.Append(o);


			 
			  PoiStream.RestartStrip();

			  
			}

		  }

		  fixed4 frag(g2f i) : SV_Target {
			fixed4 col = (1,0,0,sin(_Time));
			UNITY_APPLY_FOG(i.fogCoord, col);
			return col;
		  }
		  ENDCG
		}

	}
}
