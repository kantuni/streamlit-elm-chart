import { groupBy, omit, random } from "lodash"

export interface Point {
  Region: string
  x: number
  y: number
}

export function transform(data: Point[]) {
  const groupedByRegion = groupBy(data, "Region")
  return Object.entries(groupedByRegion).map(([region, data], index) => ({
    region,
    data: data.map((entry) => omit(entry, "Region")),
    color: getColor(index),
  }))
}

function getColor(index: number) {
  const beautifulColors = [
    [255, 75, 75],
    [255, 164, 33],
    [255, 227, 18],
    [33, 195, 84],
    [0, 212, 177],
    [0, 192, 242],
    [28, 131, 225],
    [128, 61, 245],
  ]
  return index < beautifulColors.length
    ? beautifulColors[index]
    : [random(0, 255), random(0, 255), random(0, 255)]
}
