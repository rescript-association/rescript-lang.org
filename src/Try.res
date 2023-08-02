@react.component
let default = () => {
  let overlayState = React.useState(() => false)

  <>
    <Meta title="ReScript Playground" description="Try ReScript in the browser" />
    <Next.Head>
      <style> {React.string(j`body { background-color: #010427; } `)} </style>
    </Next.Head>
    <div className="text-16">
      <div className="text-gray-40 text-14">
        <Navigation fixed=false overlayState />
        <Playground />
      </div>
    </div>
  </>
}
