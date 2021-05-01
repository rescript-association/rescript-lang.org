@react.component
let make = (
  ~value: 'item,
  ~itemToString: 'item => string,
  ~onChange: option<'item => unit>=?,
  ~items: array<'item>=[],
) => {
  open HeadlessUI

  /*
  <Menu _as=#div>
    {({open_}) => {
      <>
        <Menu.Button className="p-4 rounded border border-gray-60-tr">
          {selected->itemToString->React.string}
        </Menu.Button>
        <Transition
          show={open_}
          enter="transition duration-100 ease-out"
          enterFrom="transform scale-95 opacity-0"
          enterTo="transform scale-100 opacity-100"
          leave="transition duration-75 ease-out"
          leaveFrom="transform scale-100 opacity-100"
          leaveTo="transform scale-95 opacity-0">
          <Menu.Items static=true>
            {items
            ->Js.Array2.map(item => {
              <Menu.Item>
                {state => {
                  let {active} = state
                  let onClick = switch onSelect {
                  | Some(onSelect) =>
                    Some(
                      e => {
                        ReactEvent.Mouse.preventDefault(e)
                        onSelect(item)
                      },
                    )
                  | None => None
                  }
                  <div ?onClick className={active ? "text-red-500" : ""}>
                    {item->itemToString->React.string}
                  </div>
                }}
              </Menu.Item>
            })
            ->React.array}
          </Menu.Items>
        </Transition>
      </>
    }}
  </Menu>
 */

  <Listbox value ?onChange>
    {({open_}) => {
      <>
        <Listbox.Button className="py-2 px-2 focus:outline-none rounded border border-gray-60-tr">
          {value->itemToString->React.string}
        </Listbox.Button>
        <Transition
          show={open_}
          leave="transition ease-in duration-100"
          leaveFrom="opacity-100"
          leaveTo="opacity-0">
          <Listbox.Options
            className="border border-gray-60-tr shadow-xs rounded focus:outline-none" static=true>
            {items
            ->Js.Array2.map(item => {
              let itemStr = itemToString(item)
              <Listbox.Option value={item} key={itemStr}>
                {state => {
                  let {selected, active} = state
                  <li className={active ? "text-red-500" : ""}>
                    {selected ? <Icon.Check className="inline-block w-4 h-4 mr-2" /> : React.null}
                    {itemStr->React.string}
                  </li>
                }}
              </Listbox.Option>
            })
            ->React.array}
          </Listbox.Options>
        </Transition>
      </>
    }}
  </Listbox>
}
