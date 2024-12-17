calculate_bus <- function(temp, wet_hours, humid_hours) {
  # ตรวจสอบเงื่อนไขอุณหภูมิ
  if (temp < 15 || temp > 38) {
    return(0)
  }
  
  # ตรวจสอบเงื่อนไขชั่วโมงใบเปียก
  if (wet_hours <= 9) {
    return(0)
  }
  
  # คำนวณ BUS ตามเงื่อนไข
  bus <- 0
  if (wet_hours > 9 | wet_hours <= 15) {
    bus <- 1
  } else if (wet_hours > 15 && wet_hours <= 21) {
    bus <- 2
  } else if (wet_hours > 21) {
    bus <- 3
  }
  
  if (temp >= 19 && temp <= 29) {
    bus <- bus + 1
  }
  if (temp >= 23 && temp <= 26) {
    bus <- bus + 1
  }
  if (humid_hours > 16) {
    bus <- bus + 1
  }
  
  return(bus)
}

# ตัวอย่างการใช้งาน
temp <- 25  # อุณหภูมิเฉลี่ย (องศาเซลเซียส)
wet_hours <- 12  # ชั่วโมงใบเปียก
humid_hours <- 18  # ชั่วโมงที่มีความชื้นสัมพัทธ์มากกว่า 90%

bus <- calculate_bus(temp, wet_hours, humid_hours)
print(paste("ค่า BUS:", bus))
#eos
