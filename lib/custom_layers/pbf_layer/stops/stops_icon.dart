
import 'stops_enum.dart';

const String _carpool = """
<svg xmlns="http://www.w3.org/2000/svg" width="20" height="27" viewBox="0 0 24 24">
    <path opacity="1" fill="#222" fill-opacity="1" fill-rule="nonzero" stroke="#9fc727" stroke-width="9.987" stroke-linejoin="round" stroke-miterlimit="2" stroke-opacity="1" paint-order="markers" d="M5.009 5.018h14.098v14.058H5.009z" />
    <path fill="#FFF" d="M21.429 9.05c.23 0 .342.276.371.52l.046.382c.084.702-.773.882-1.349.882l-.906-1.783zm-.974 1.745c.533 1.058.79 2.009.79 3.27 0 1.222-.332 2.259-.84 3.55v1.648c0 .492-.373.891-.834.891h-1.252c-.461 0-.835-.4-.835-.891v-.892H6.63v.892c0 .492-.374.891-.834.891H4.544c-.46 0-.834-.4-.834-.891v-1.648c-.508-1.291-.84-2.328-.84-3.55 0-1.261.257-2.139.79-3.196.692-1.371 1.546-3.153 2.446-4.758C6.798 4.88 7.16 4.59 8.008 4.427c1.279-.246 2.436-.326 4.05-.326 1.613 0 2.77.08 4.05.326.847.162 1.21.452 1.9 1.684.902 1.605 1.755 3.313 2.447 4.684zM7.072 14.566c0-.738-.561-1.337-1.252-1.337-.692 0-1.253.599-1.253 1.337 0 .739.561 1.338 1.253 1.338.69 0 1.252-.6 1.252-1.338zm8.416 1.381c0-.246-.187-.445-.417-.445H9.227c-.23 0-.417.2-.417.445 0 .247.187.446.417.446h5.844c.23 0 .417-.2.417-.446zm3.28-4.048s-1.534-4.1-2.278-5.273a1.114 1.114 0 0 0-.725-.505c-1.261-.243-2.367-.32-3.707-.32-1.341 0-2.446.077-3.708.32a1.107 1.107 0 0 0-.725.505C6.88 7.799 5.187 11.85 5.187 11.85c1.37.279 2.519.906 6.802.883 4.6-.023 5.41-.555 6.779-.834zm.849 2.594c0-.739-.561-1.338-1.253-1.338-.69 0-1.252.6-1.252 1.338 0 .738.561 1.338 1.252 1.338.692 0 1.253-.6 1.253-1.338zM4.34 9.405l-1.86.074c-.23.009-.418.2-.418.446v.455c0 .708.842.76 1.418.76z" stroke-width=".927" />
    <g fill="#FFF" stroke-width=".277">
        <path d="M11.297 11.599c-.817-.191-1.578-.359-1.21-1.063 1.122-2.144.298-3.29-.886-3.29-1.207 0-2.01 1.19-.887 3.29.38.708-.41.876-1.209 1.063-.73.17-.757.538-.755 1.18l.001.24h5.699v-.233c.004-.647-.02-1.016-.754-1.187z" />
        <path d="M16.995 11.599c-.817-.191-1.577-.359-1.209-1.063 1.121-2.144.297-3.29-.886-3.29-1.208 0-2.011 1.19-.887 3.29.38.708-.41.876-1.209 1.063-.73.17-.757.538-.755 1.18l.001.24h5.699v-.233c.003-.647-.021-1.016-.754-1.187z" />
    </g>
</svg>
""";
const String _bus = """
<svg xmlns="http://www.w3.org/2000/svg" width="20" height="27" viewBox="0 0 16 22">
  <g xmlns="http://www.w3.org/2000/svg" fill="none" fill-rule="evenodd">
    <g transform="translate(-52 -124)">
      <g transform="translate(36 108)">
        <g transform="translate(16.8 16.8)">
          <circle cx="7.2" cy="7.2" r="7.6" fill="#ff0000" stroke="#fff" stroke-width=".8" />
          <g transform="translate(2 2)">
            <g fill-rule="nonzero">
              <path d="m8.8806 10.088h-7.28c-0.68932 0-1.248-0.55868-1.248-1.248v-7.28c0-0.68932 0.55868-1.248 1.248-1.248h7.28c0.68932 0 1.248 0.55868 1.248 1.248v7.28c0 0.68932-0.55868 1.248-1.248 1.248z" fill="#fff" />
              <path d="m3.25e-4 1.2876c0-0.702 0.585-1.287 1.287-1.287h7.7994c0.728 0 1.313 0.585 1.313 1.287v7.7994c0 0.728-0.585 1.313-1.313 1.313h-7.7994c-0.702 0-1.287-0.585-1.287-1.313v-7.7994zm5.2127-0.169c-1.079 0-2.015 0.052-3.0417 0.195-0.312 0.039-0.494 0.221-0.494 0.494v6.0834c0 0.195 0.143 0.325 0.273 0.364l0.39 0.065v0.819c0 0.091 0.078 0.156 0.182 0.156h0.624c0.078 0 0.156-0.065 0.156-0.156v-0.728c0.507 0.065 1.196 0.091 1.885 0.091 0.702 0 1.417-0.026 1.911-0.091v0.728c0 0.091 0.091 0.156 0.169 0.156h0.624c0.104 0 0.182-0.065 0.182-0.156v-0.819l0.39-0.065c0.143-0.039 0.273-0.156 0.273-0.364v-6.0834c0-0.273-0.182-0.455-0.494-0.494-1.04-0.13-1.9887-0.195-3.0287-0.195h-6.5e-4zm2.6907 5.1867c-0.741 0.13-1.716 0.26-2.6647 0.26-1.001 0-1.9497-0.117-2.7037-0.286-0.208-0.039-0.286-0.117-0.286-0.286v-3.7957c0-0.169 0.078-0.286 0.286-0.286l5.3684 0.026c0.208 0 0.273 0.117 0.273 0.286v3.7957c0 0.169-0.065 0.26-0.273 0.286zm-5.4467 1.04c0.013-0.169 0.169-0.325 0.351-0.325s0.338 0.156 0.338 0.325c0 0.195-0.156 0.351-0.338 0.351-0.195-0.013-0.351-0.169-0.351-0.351zm4.7577 0c0.013-0.169 0.169-0.325 0.338-0.325 0.182 0 0.338 0.156 0.338 0.325 0 0.195-0.156 0.351-0.338 0.351-0.182-0.013-0.338-0.169-0.338-0.351z" fill="#ff0000" />
            </g>
          </g>
        </g>
        <path d="m23.2 31.2h1.6v5.6c0 0.44183-0.35817 0.8-0.8 0.8s-0.8-0.35817-0.8-0.8v-5.6z" fill="#333" />
      </g>
    </g>
  </g>
</svg>
""";
const String _rail = """
<svg xmlns="http://www.w3.org/2000/svg" width="20" height="27" viewBox="0 0 16 22">
  <g fill="none" fill-rule="evenodd">
    <g transform="translate(-52 -152)">
      <g transform="translate(36 136)">
        <g transform="translate(16.8 16.8)">
          <circle cx="7.2" cy="7.2" r="7.6" fill="#008000" stroke="#fff" stroke-width=".8" />
          <g transform="translate(2 2)">
            <g fill-rule="nonzero">
              <path d="m8.944 10.192h-7.28c-0.68932 0-1.248-0.55868-1.248-1.248v-7.28c0-0.68932 0.55868-1.248 1.248-1.248h7.28c0.68932 0 1.248 0.55868 1.248 1.248v7.28c0 0.68932-0.55868 1.248-1.248 1.248z" fill="#fff" />
              <path d="m0 1.2871c0-0.70204 0.58504-1.2871 1.2871-1.2871h7.7998c0.72805 0 1.3131 0.58504 1.3131 1.2871v7.7998c0 0.72805-0.58504 1.3131-1.3131 1.3131h-7.7998c-0.70204 0-1.2871-0.58504-1.2871-1.3131v-7.7998zm7.9818 0.039002c-0.28602-0.26002-1.5211-0.55903-2.7818-0.55903-1.2221 0-2.4828 0.29902-2.7558 0.55903-0.19501 0.16901-0.39002 0.55903-0.62404 1.0531-0.19501 0.42903-0.35102 0.83205-0.35102 1.0661v3.7569c0 0.29902 0.10401 0.42903 0.50703 0.74105 0.29902 0.23401 0.42903 0.33802 0.88406 0.33802h0.85805v0.55903h3.0029v-0.55903h0.84505c0.45503 0 0.58504-0.10401 0.87105-0.33802 0.40303-0.32502 0.49403-0.44203 0.49403-0.74105v-3.7569c0-0.23401-0.15601-0.63704-0.33802-1.0661-0.23401-0.49403-0.41603-0.88406-0.61104-1.0531h-3.2502e-4zm-0.35102 7.9038v-0.54603h-0.48103v0.54603h-3.8739v-0.54603h-0.49403v0.54603h-0.59804c-0.14301 0-0.26002 0.11701-0.26002 0.24702 0 0.14301 0.11701 0.26002 0.26002 0.26002h6.0577c0.14301 0 0.24702-0.11701 0.24702-0.26002 0-0.13001-0.10401-0.24702-0.24702-0.24702h-0.61104 3.2502e-4zm-0.27302-3.3149c-0.039002 0.22101-0.26002 0.39002-0.48103 0.39002h-3.3279c-0.22101 0-0.44203-0.16901-0.48103-0.39002l-0.61104-2.5868c-0.039002-0.22101 0.10401-0.39002 0.32502-0.39002h4.849c0.22101 0 0.37702 0.16901 0.32502 0.39002l-0.59804 2.5868zm-0.18201-4.1339v0.22101c0 0.16901-0.13001 0.31202-0.29902 0.31202h-3.3279c-0.16901 0-0.31202-0.14301-0.31202-0.31202v-0.22101h3.9389zm-3.9389 5.486c0-0.18201 0.13001-0.32502 0.31202-0.32502 0.18201 0 0.33802 0.14301 0.33802 0.32502 0 0.18201-0.15601 0.31202-0.33802 0.31202-0.18201 0-0.31202-0.13001-0.31202-0.31202zm3.3149-0.039002c0-0.18201 0.14301-0.32502 0.32502-0.32502 0.18201 0 0.32502 0.14301 0.32502 0.32502 0 0.18201-0.14301 0.31202-0.32502 0.31202-0.18201 0-0.32502-0.13001-0.32502-0.31202z" fill="#008000" />
            </g>
          </g>
        </g>
        <path d="m23.2 31.2h1.6v5.6c0 0.44183-0.35817 0.8-0.8 0.8s-0.8-0.35817-0.8-0.8v-5.6z" fill="#333" />
      </g>
    </g>
  </g>
</svg>
""";
const String _subway = """
<svg xmlns="http://www.w3.org/2000/svg" width="16" height="22" viewBox="0 0 16 22">
    <circle cx="8" cy="8" r="7.6" fill="#00f" stroke="#fff" stroke-width=".8" fill-rule="evenodd" />
    <path d="M7.2 15.2h1.6v5.6a.8.8 0 1 1-1.6 0z" fill="#333" fill-rule="evenodd" />
    <path fill="#fff" d="M4.395 3.7v3.163c0 1.056.003 1.866.007 2.43.002.282.005.502.008.662.003.16.007.257.01.294a4.549 4.549 0 0 0 .11.605 3.708 3.708 0 0 0 .187.544 3.143 3.143 0 0 0 .34.587 2.816 2.816 0 0 0 .428.455 2.549 2.549 0 0 0 .576.367 3.024 3.024 0 0 0 .463.173 4.28 4.28 0 0 0 .541.123 3.587 3.587 0 0 0 .347.042c.063.004.134.006.22.008l.312.003c.154 0 .284-.002.399-.006.115-.004.215-.01.309-.02.093-.009.18-.022.27-.039a4.572 4.572 0 0 0 .528-.137 3.35 3.35 0 0 0 .458-.194 2.975 2.975 0 0 0 .588-.403 2.763 2.763 0 0 0 .586-.736 3.094 3.094 0 0 0 .206-.448 3.547 3.547 0 0 0 .144-.5 4.19 4.19 0 0 0 .092-.868c.003-.17.006-.4.008-.686.005-.573.007-1.367.007-2.343V3.7H9.572L9.565 6.89l-.007 3.193-.052.246c-.019.088-.04.17-.063.248a2.284 2.284 0 0 1-.123.32 1.647 1.647 0 0 1-.16.26 1.266 1.266 0 0 1-.277.262 1.248 1.248 0 0 1-.258.136 1.598 1.598 0 0 1-.31.086 1.623 1.623 0 0 1-.138.008 8.172 8.172 0 0 1-.403.002 2.394 2.394 0 0 1-.136-.006.988.988 0 0 1-.184-.032 1.662 1.662 0 0 1-.306-.131 1.326 1.326 0 0 1-.395-.349 1.439 1.439 0 0 1-.172-.292 1.942 1.942 0 0 1-.126-.357 2.9 2.9 0 0 1-.07-.366 2.532 2.532 0 0 1-.01-.126 12.47 12.47 0 0 1-.014-.479 885.156 885.156 0 0 1-.013-2.68L6.34 3.7h-.97z" stroke-width=".012" />
</svg>
""";
const Map<StopsLayerIds, String> stopsIcons = {
  StopsLayerIds.carpool: _carpool,
  StopsLayerIds.bus: _bus,
  StopsLayerIds.rail: _rail,
  StopsLayerIds.subway: _subway,
};
