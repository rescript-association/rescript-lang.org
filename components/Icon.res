open Util.ReactStuff

module Github = {
  @react.component
  let make = (~className: string) =>
    <svg
      className={"fill-current " ++ className}
      width="18.236"
      height="17.79"
      viewBox="0 0 18.236 17.79">
      <g transform="translate(8 -5.365)">
        <path
          d="M17.013,9.906a9.078,9.078,0,0,0-3.318-3.318A8.918,8.918,0,0,0,9.118,5.365,8.919,8.919,0,0,0,4.541,6.588,9.077,9.077,0,0,0,1.223,9.906,8.919,8.919,0,0,0,0,14.483a8.861,8.861,0,0,0,1.739,5.36,8.93,8.93,0,0,0,4.493,3.294.531.531,0,0,0,.475-.083.464.464,0,0,0,.154-.356q0-.036-.006-.641T6.85,21l-.273.047a3.484,3.484,0,0,1-.659.042,5.02,5.02,0,0,1-.825-.083,1.844,1.844,0,0,1-.8-.356,1.506,1.506,0,0,1-.522-.73l-.119-.273a2.966,2.966,0,0,0-.374-.605,1.432,1.432,0,0,0-.516-.451l-.083-.06a.871.871,0,0,1-.154-.143.651.651,0,0,1-.107-.166q-.036-.083.059-.137a.77.77,0,0,1,.344-.053l.237.035a1.733,1.733,0,0,1,.588.285,1.916,1.916,0,0,1,.576.617,2.093,2.093,0,0,0,.659.742,1.4,1.4,0,0,0,.778.255,3.376,3.376,0,0,0,.677-.059,2.362,2.362,0,0,0,.534-.178,1.924,1.924,0,0,1,.582-1.223,8.129,8.129,0,0,1-1.217-.214,4.845,4.845,0,0,1-1.116-.463,3.2,3.2,0,0,1-.956-.8,3.822,3.822,0,0,1-.623-1.247A5.928,5.928,0,0,1,3.3,14.007a3.463,3.463,0,0,1,.938-2.446A3.192,3.192,0,0,1,4.321,9.14a1.664,1.664,0,0,1,1.021.16,7.138,7.138,0,0,1,.991.457q.315.19.5.321a8.574,8.574,0,0,1,4.559,0l.451-.285a6.389,6.389,0,0,1,1.092-.522,1.556,1.556,0,0,1,.962-.13A3.161,3.161,0,0,1,14,11.562a3.463,3.463,0,0,1,.938,2.446,5.994,5.994,0,0,1-.243,1.787,3.674,3.674,0,0,1-.629,1.247,3.319,3.319,0,0,1-.962.789,4.855,4.855,0,0,1-1.116.463,8.121,8.121,0,0,1-1.217.214,2.115,2.115,0,0,1,.617,1.686v2.5a.473.473,0,0,0,.149.356.516.516,0,0,0,.469.083A8.929,8.929,0,0,0,16.5,19.842a8.863,8.863,0,0,0,1.739-5.36A8.926,8.926,0,0,0,17.013,9.906Z"
          transform="translate(-8 0)"
        />
      </g>
    </svg>
}

module Twitter = {
  @react.component
  let make = (~className: string) =>
    <svg className={"fill-current " ++ className} viewBox="0 0 15.53 12.71">
      <path
        d="M5.794,12.711a13.325,13.325,0,0,1-2.058-.163A9.659,9.659,0,0,1,.92,11.523L0,11.02l1-.328c1.089-.358,1.751-.58,2.571-.928A3.421,3.421,0,0,1,1.809,7.726l-.232-.7.19.029a3.456,3.456,0,0,1-.433-.534A3.276,3.276,0,0,1,.779,4.57l.044-.614L1.19,4.1a3.437,3.437,0,0,1-.333-.934A3.552,3.552,0,0,1,1.235.774l.32-.588L1.984.7A7.883,7.883,0,0,0,7.091,3.575a3.054,3.054,0,0,1,.185-1.623A3.038,3.038,0,0,1,8.511.536,3.71,3.71,0,0,1,10.664.008a3.439,3.439,0,0,1,2.114.872,7.1,7.1,0,0,0,.774-.258c.17-.064.362-.136.6-.219L15.042.1l-.579,1.652.119-.008L15.53,1.7l-.56.765c-.032.044-.04.056-.052.073-.045.068-.1.153-.87,1.179a1.448,1.448,0,0,0-.271.943,8.916,8.916,0,0,1-.487,3.586,6.346,6.346,0,0,1-1.7,2.524,7.524,7.524,0,0,1-3.566,1.724A10.979,10.979,0,0,1,5.794,12.711Zm0,0"
        transform="translate(0 -0.001)"
      />
    </svg>
}

module MagnifierGlass = {
  @react.component
  let make = (~className: string) =>
    <svg
      className={"stroke-current " ++ className}
      width="19.203"
      height="19.203"
      viewBox="0 0 19.203 19.203">
      <g fill="none" strokeLinecap="round" strokeWidth="2px" transform="translate(-2 -2)">
        <path
          d="M6.479,0A6.479,6.479,0,1,1,0,6.479,6.479,6.479,0,0,1,6.479,0Z"
          transform="translate(3 3)"
        />
        <line strokeLinejoin="round" x1="5.734" y1="5.734" transform="translate(14.055 14.055)" />
      </g>
    </svg>
}

module Caret = {
  type direction = [#Up | #Down]

  type size = [#Sm | #Md]

  @react.component
  let make = (~className: string="", ~size=#Sm, ~direction: direction) => {
    let width = switch size {
    | #Sm => "10"
    | #Md => "14"
    }
    <svg
      className={"stroke-current " ++ className}
      viewBox="0 0 10 5"
      width
      fill="none"
      strokeMiterlimit="10"
      strokeWidth="2">
      {switch direction {
      | #Up => <path d="M.6,4.022,4.509.8,8.476,4.087" fill="none" />
      | #Down => <path d="M.6.866,4.509,4.087,8.476.8" />
      }}
    </svg>
  }
}

module DrawerDots = {
  @react.component
  let make = (~className: string="") =>
    <svg
      className={"fill-current " ++ className}
      stroke="none"
      width="22"
      height="4"
      viewBox="0 0 22 4">
      <circle cx="2" cy="2" r="2" />
      <circle cx="2" cy="2" r="2" transform="translate(9)" />
      <circle cx="2" cy="2" r="2" transform="translate(18)" />
    </svg>
}

module CornerLeftUp = {
  @react.component
  let make = (~className: string="") =>
    <svg
      className={"stroke-current " ++ className}
      width="18.414"
      height="18"
      fill="none"
      strokeLinecap="round"
      strokeLinejoin="round"
      strokeWidth="2px">
      <path d="M11.414 6l-5-5-5 5" /> <path d="M17.414 17h-7a4 4 0 01-4-4V1" />
    </svg>
}

module Table = {
  @react.component
  let make = (~className: string="") =>
    <svg className={"stroke-current " ++ className} width="25" height="23">
      <defs>
        <style>
          {".prefix__a,.prefix__b,.prefix__d{fill:none}.prefix__a,.prefix__b{stroke-width:1.5px}.prefix__c{stroke:none}"->s}
        </style>
      </defs>
      <g className="prefix__a">
        <rect className="prefix__c" width="10" height="23" rx="2" />
        <rect className="prefix__d" x="0.75" y="0.75" width="8.5" height="21.5" rx="1.25" />
      </g>
      <g className="prefix__a">
        <rect className="prefix__c" width="25" height="23" rx="2" />
        <rect className="prefix__d" x="0.75" y="0.75" width="23.5" height="21.5" rx="1.25" />
      </g>
      <path className="prefix__b" d="M2.5 6.5h5M2.5 10.5h5" />
    </svg>
}

module Close = {
  @react.component
  let make = (~className: string="") =>
    <svg className={"fill-current " ++ className} width="12.728" height="12.728">
      <path d="M12.728 11.313l-1.414 1.414L0 1.414 1.414-.001z" />
      <path d="M11.314 0l1.414 1.414L1.415 12.728 0 11.314z" />
    </svg>
}

module ArrowRight = {
  @react.component
  let make = (~className: string="") =>
    <svg
      className={"fill-current " ++ className} width="18" height="11.769" viewBox="0 0 18 11.769">
      <defs>
        <clipPath id="prefix__a">
          <path
            d="M12.121-16.823a.67.67 0 00-.907 0 .566.566 0 000 .835l4.6 4.277H.635A.611.611 0 000-11.12a.617.617 0 00.635.6h15.179l-4.6 4.269a.576.576 0 000 .844.67.67 0 00.907 0L17.81-10.7a.553.553 0 000-.835z"
            transform="translate(0 17)"
            clipRule="evenodd"
            fill="current"
          />
        </clipPath>
        <clipPath id="prefix__b">
          <path
            className="prefix__b"
            d="M-297 336.231h747.692V-534H-297z"
            transform="translate(297 534)"
          />
        </clipPath>
      </defs>
      <g clipPath="url(#prefix__a)">
        <g transform="translate(-205.615 -357.923)" clipPath="url(#prefix__b)">
          <path className="prefix__b" d="M202.154 354.462h24.923v18.692h-24.923z" />
        </g>
      </g>
    </svg>
}

module Discourse = {
  @react.component
  let make = (~className: string="") =>
    <svg className={"fill-current " ++ className} viewBox="0 0 24 24">
      <path
        d="M12.103 0C18.666 0 24 5.485 24 11.997c0 6.51-5.33 11.99-11.9 11.99L0 24V11.79C0 5.28 5.532 0 12.103 0zm.116 4.563a7.395 7.395 0 00-6.337 3.57 7.247 7.247 0 00-.148 7.22L4.4 19.61l4.794-1.074a7.424 7.424 0 008.136-1.39 7.256 7.256 0 001.737-7.997 7.375 7.375 0 00-6.84-4.585h-.008z"
      />
    </svg>
}

module Hyperlink = {
  @react.component
  let make = (~className: string="") =>
    <svg
      className={"fill-current " ++ className}
      width="0.8em"
      height="0.8em"
      viewBox="0 0 20.003 19.944">
      <path
        d="M11.927 7.908a4.819 4.819 0 00-3.968-1.3 5.091 5.091 0 00-2.921 1.508L1.47 11.684a4.82 4.82 0 00.192 7.122 4.994 4.994 0 006.76-.4l3.7-3.776a.109.109 0 00-.067-.184s-.649.029-1.132.006a10.116 10.116 0 01-1.35-.226.308.308 0 00-.243.088l-2.529 2.609a2.733 2.733 0 01-3.583.319 2.64 2.64 0 01-.247-3.951l3.755-3.753a2.7 2.7 0 013.654-.073.108.108 0 00.15 0l1.4-1.4a.114.114 0 00-.003-.157z"
      />
      <path
        d="M8.076 12.036a4.822 4.822 0 003.967 1.3 5.089 5.089 0 002.922-1.509l3.568-3.568a4.818 4.818 0 00-.192-7.121 5 5 0 00-6.761.4l-3.7 3.777a.108.108 0 00.067.183s.648-.028 1.132-.006a10.151 10.151 0 011.35.226.3.3 0 00.243-.088l2.529-2.608a2.732 2.732 0 013.581-.319 2.638 2.638 0 01.249 3.95l-3.755 3.754a2.706 2.706 0 01-3.654.073.107.107 0 00-.15 0l-1.4 1.4a.113.113 0 00.004.156z"
      />
    </svg>
}

module TriangleDown = {
  @react.component
  let make = (~className: string="") =>
    <svg className={"fill-current " ++ className} width="8" height="5" viewBox="0 0 8 5">
      <path d="M4,0,8,5H0Z" transform="translate(8 5) rotate(180)" />
    </svg>
}
