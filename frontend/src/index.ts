import { RenderData, Streamlit } from "streamlit-component-lib"
import { Point, transform } from "./utils"

declare global {
  interface Window {
    Elm: any
  }
}

const app = window.Elm.Main.init({
  node: document.getElementById("root"),
})

/**
 * The component's render function. This will be called immediately after
 * the component is initially loaded, and then again every time the
 * component gets new data from Python.
 */
function onRender(event: Event): void {
  // Get the RenderData args from the event.
  const { args } = (event as CustomEvent<RenderData>).detail

  // RenderData args is the JSON dictionary of arguments
  // sent from the Python script.
  const chartData: Point[] = JSON.parse(args.data)
  const transformedChartData = transform(chartData)

  // Notify Elm that the chart data has changed.
  app.ports.fromJS.send(transformedChartData)
}

// Attach our `onRender` handler to Streamlit's render event.
Streamlit.events.addEventListener(Streamlit.RENDER_EVENT, onRender)

// Tell Streamlit we're ready to start receiving data. We won't get our
// first RENDER_EVENT until we call this function.
Streamlit.setComponentReady()

// Finally, tell Streamlit to update our initial height. We omit the
// `height` parameter here to have it default to our scrollHeight.
Streamlit.setFrameHeight()
