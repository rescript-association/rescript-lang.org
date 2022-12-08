type mode =
  | NoAuto
  | AutoFadeTransition(int) //milliseconds

@react.component
let make = (~className="", ~imgClassName="", ~imgSrcs: array<string>, ~mode=NoAuto) => {
  let (index, setIndex) = React.useState(_ => 0)

  React.useEffect0(() => {
    switch mode {
    | NoAuto => None
    | AutoFadeTransition(ms) =>
      let timerId = Js.Global.setInterval(() => {
        setIndex(
          prev => {
            if prev === imgSrcs->Belt.Array.length - 1 {
              0
            } else {
              prev + 1
            }
          },
        )
      }, ms)

      Some(
        () => {
          Js.Global.clearInterval(timerId)
        },
      )
    }
  })

  let src = imgSrcs->Belt.Array.getExn(index)

  let lineEls = imgSrcs->Belt.Array.mapWithIndex((i, src) => {
    let bgColor = if i === index {
      "bg-gray-40"
    } else {
      "bg-gray-70"
    }
    let onClick = evt => {
      ReactEvent.Mouse.preventDefault(evt)

      setIndex(_ => i)
    }
    <div key={src} onClick className="group flex items-center hover:cursor-pointer h-8 w-8">
      <div className={`h-[1px] group-hover:bg-gray-40 w-full ${bgColor}`} />
    </div>
  })

  let onClick = evt => {
    ReactEvent.Mouse.preventDefault(evt)

    setIndex(prev => {
      if prev === imgSrcs->Belt.Array.length - 1 {
        0
      } else {
        prev + 1
      }
    })
  }

  <div className>
    <div className="w-full" onClick>
      <HeadlessUI.Transition
        key={src}
        show={true}
        appear={true}
        enter="transition-opacity duration-1000"
        enterFrom="opacity-0"
        enterTo="opacity-100"
        leave="transition-opacity duration-1000"
        leaveFrom="opacity-100"
        leaveTo="opacity-0">
        <img className=imgClassName src />
      </HeadlessUI.Transition>
    </div>
    <div className="flex space-x-2 mt-4"> {lineEls->React.array} </div>
  </div>
}
