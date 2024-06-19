import { css } from "uebersicht"

export const command = "solar.sh"

export const refreshFrequency = 15000

const container = css`
  display: flex;
  align-items: flex-end;
  justify-content: center;
  width: 100vw;
  height: 100vh;
  gap: 3rem;
`

const text = css`
  font-family: "SF Pro";
  color: #fff;
  margin-bottom: 1rem;
`

function battery(output) {
  const data = JSON.parse(output)

  let icon;
  if (data["battery_soc"] === 100)
    icon = "􀛨"
  else if (data["battery_soc"] > 75)
    icon = "􀺸"
  else if (data["battery_soc"] > 50)
    icon = "􀺶"
  else if (data["battery_soc"] > 25)
    icon = "􀛩"
  else
    icon = "􀛪"

  return `${icon} ${data["battery_soc"]}%`;
}

function ppv(output) {
  const data = JSON.parse(output)
  return `􀆭 ${data["ppv1"]}W`;
}

function load(output) {
  const data = JSON.parse(output)
  return `􀋥 ${data["house_consumption"]}W`;
}

export const render = ({ output, error }) => {
  return error ? (
    <div></div>
  ) : (
    <div className={container}>
      <div className={text}>{battery(output)}</div>
      <div className={text}>{ppv(output)}</div>
      <div className={text}>{load(output)}</div>
    </div>
  );
}
