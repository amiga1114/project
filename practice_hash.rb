student = {
  name: "john",
  age: 19,
  gender: "male",
  # 배열 사용
  # school: ["PFLHS", "YONSEI", "KAIST"]
  # 큰 hash안에 또 hash 사용 가능
  school: {
    highschool: ["PFLHS", "german"],
    college: ["yonsei", "cs"],
    graduate: ["kaist", "cs"]
  }
}

# puts student[:age]
# puts student[:gender]
puts student[:school][:graduate][0]
