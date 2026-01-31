#let array-at(arr, pos) = { arr.at(calc.min(pos, arr.len()) - 1) }

#let str2bool(s) = {
  s = lower(s)
  if (s == "true" or s == "1" or s == "yes" or s == "on") {
    true
  } else if (s == "false" or s == "0" or s == "no" or s == "off") {
    false
  } else {
    panic("Cannot convert string to bool: " + s)
  }
}

#let extend(val, key, kwargs) = { val + kwargs.named().at(key, default: (:)) }

#let is-not-empty(c) = c not in (none, "", [])

#let display-zh(date) = {
  let date-map = (
    "0": "○",
    "1": "一",
    "2": "二",
    "3": "三",
    "4": "四",
    "5": "五",
    "6": "六",
    "7": "七",
    "8": "八",
    "9": "九",
    "10": "十",
    "11": "十一",
    "12": "十二",
  )

  str(date.year()).clusters().map(c => date-map.at(c)).sum() + "年" + date-map.at(str(date.month())) + "月"
}
