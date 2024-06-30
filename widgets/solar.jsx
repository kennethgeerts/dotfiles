import { css } from "uebersicht"

export const command = "solar.sh"

export const refreshFrequency = 15000

const container = css`
  display: flex;
  align-items: flex-start;
  justify-content: center;
  width: 100vw;
  height: 100vh;
  gap: 3rem;
`

const text = css`
  font-family: "FiraCode Nerd Font";
  color: #fff;
  margin-top : 0.5rem;
`

function battery(output) {
  const data = JSON.parse(output)

  let icon;
  if (data["battery_soc"] === 100)
    icon = "\uf240"
  else if (data["battery_soc"] > 75)
    icon = "\uf241"
  else if (data["battery_soc"] > 50)
    icon = "\uf242"
  else if (data["battery_soc"] > 25)
    icon = "\uf243"
  else
    icon = "\uf244"

  return `${icon} ${data["battery_soc"]}%`;
}

function ppv(output) {
  const data = JSON.parse(output)
  return `\uf522 ${data["ppv1"]}W`;
}

function load(output) {
  const data = JSON.parse(output)
  return `\udb85\udc0c${data["house_consumption"]}W`;
}

export const render = ({ output }) => {
  if (output) {
    return (
      <div className={container}>
        <div className={text}>{battery(output)}</div>
        <div className={text}>{ppv(output)}</div>
        <div className={text}>{load(output)}</div>
      </div>
    );
   } else {
    return (
      <div></div>
    );
   }
}
