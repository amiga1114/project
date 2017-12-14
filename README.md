### 4. 텔레그램 봇 만들기

> ### 1. 텔레그램 봇 만들기
>
> 우선 Telegram Desktop을 다운받자 !
>
> Telegram bot은 telegram의 the Botfather를 통해 만들 수 있다.
>
> 이후 접속 후 Telegram 검색창에 BotFather 검색
>
> ```
> BotFather를 실행 후 
> 1. /newbot Heesk 입력 후 Heesk란 봇프로그램 만들기. 
> 2. 이후 봇의 이름을 정해주자 => heees_bot 
> 그러면 Telegram에서 봇 API의 토큰을 준다 !
> 3. 봇에게 텍스트를 보낸 후 https://api.telegram.org/bot"토큰"/getUpdates을 통해 결과를 확인하자
> 4. 봇으로 사용자에게 텍스트를 보내고 싶다면
> https://api.telegram.org/bot"토큰"/sendmessage?chat_id="사용자id"&text="텍스트"
> 5. 결과값은 웹페이지에 json 형식으로 받아오는데 !
>   보기 편하고 싶다면 크롬 확장프로그램에 json viewer를 다운받아 보자 !
> 6. 이것만 하면 됨...
>
> ```
>
> #### json에서 정보를 받아올래면 Hash를 잘 알아야 한다 !
>
> 그러니 hash 연습을 해보자 !
>
> ```
> student = {
>  # :name => "john",
>  # :age => 19,
>  # :gender => "male"
>  name: "john",
>  age: 19,
>  gender: "male",
>  # school: ["PFLHS", "YONSEI", "KAIST"]
>  school: {
>    highschool: ["daeingo", "German"],
>    college: ["youngdong", "SW"],
>    graduate: ["KAIST", "CS"]
>  }
> }
>
> puts student[:age]
> puts student[:gender]
> puts student[:school][:graduate][0]
>
> # 결과값
> # 19
> # male
> # KAIST
> ```
>
> #### 2. 루비를 이용해서 5초마다 메세지를 보내주는 챗봇을 만들기 !
>
> ```
> # 자동 텔레그렘 updates
> require 'httparty'
> require 'awesome_print' # puts와 비슷한 아이인데 좀 더 이쁘게 출력해준다 ! 출력할땐 ap 변수명
> require 'json' #json을 ruby의 hash로 변환해주는 아이 !
> require 'uri' #url 한글을 코딩해주는 아이 !
>
> # API url
> url = "https://api.telegram.org/bot"
> #API 토큰 정보
> token = "bot API Key"
> # json의 결과를 response에 저장해라!
> response = HTTParty.get("#{url}#{token}/getUpdates")
> #json으로 된 자료를 ruby의 hash로 변환 해줘
> hash = JSON.parse(response.body)
>
> # 챗 아이디를 뽑아줘 !
> chat_id = hash["result"][0]["message"]["from"]["id"]
>
> # 챗 아이디를 뽑은 걸 활용하여 유저에게 메세지를 보내줘 !
> msg = "얌마"
>
> # 한글을 url로 코딩해줘 !
> encoded = URI.encode(msg)
> # 밑에 코드는 그냥 한번 보낼 때
> # HTTParty.get("#{url}#{token}/sendMessage?chat_id=#{chat_id}&text=#{encoded}")
>
> # 이거는 반복해서 메세지를 보낼 때
> # 5초마다 메세지를 보내줘 !
> while true
>  HTTParty.get("#{url}#{token}/sendMessage?chat_id=#{chat_id}&text=#{encoded}")
>  sleep(5)
> end
> ```
>
> #### 3. 이번에는 코스피 지수 및 로또 번호 알려주는 챗봇 만들기 !
>
> ```
> # 자동 텔레그렘 updates
> require 'httparty'
> require 'awesome_print' # puts와 비슷한 아이인데 좀 더 이쁘게 출력해준다 ! 출력할땐 ap 변수명
> require 'json' #json을 ruby의 hash로 변환해주는 아이 !
> require 'uri' #url 한글을 코딩해주는 아이 !
> require 'nokogiri'
>
> # API url
> url = "https://api.telegram.org/bot"
> #API 토큰 정보
> token = "bot API Key"
> # json의 결과를 response에 저장해라!
> response = HTTParty.get("#{url}#{token}/getUpdates")
> #json으로 된 자료를 ruby의 hash로 변환 해줘
> hash = JSON.parse(response.body)
>
> # 챗 아이디를 뽑아줘 !
> chat_id = hash["result"][0]["message"]["from"]["id"]
>
> # 밑에 코드는 그냥 한번 보낼 때
> # HTTParty.get("#{url}#{token}/sendMessage?chat_id=#{chat_id}&text=#{encoded}")
>
> # 이거는 반복해서 메세지를 보낼 때
> # 5초마다 메세지를 보내줘 !
> # while true
> #   HTTParty.get("#{url}#{token}/sendMessage?chat_id=#{chat_id}&text=#{encoded}")
> #   sleep(5)
> # end
>
> # Kospi 지수 스크랩 챗봇
> res = HTTParty.get("http://finance.naver.com/sise/")
> html = Nokogiri::HTML(res.body)
> kosipi = html.css("#KOSPI_now").text
>
> msg = "오늘 코스피 지수는 #{kosipi}"
> encode = URI.encode(msg)
>
> HTTParty.get("#{url}#{token}/sendMessage?chat_id=#{chat_id}&text=#{encode}")
> # 로또 API를 이용해서 번호 가져오기
> res_lotto = HTTParty.get("http://www.nlotto.co.kr/common.do?method=getLottoNumber&drwNo=784")
> hash_lotto = JSON.parse(res_lotto.body)
>
> lottoNum = []
>
> 6.times do |n|
>  lottoNum << hash_lotto["drwtNo"+"#{n+1}"]
> end
> msg = "이번주 로또번호는 #{lottoNum}"
> encode = URI.encode(msg)
>
> HTTParty.get("#{url}#{token}/sendMessage?chat_id=#{chat_id}&text=#{encode}")
>
> ```
>
> #### 4. 번외편... 사람들 괴롭히는 아재개그 스팸 챗봇 만들기
>
> ```
> # 자동 텔레그렘 updates
> require 'httparty'
> require 'awesome_print' # puts와 비슷한 아이인데 좀 더 이쁘게 출력해준다 ! 출력할땐 ap 변수명
> require 'json' #json을 ruby의 hash로 변환해주는 아이 !
> require 'uri' #url 한글을 코딩해주는 아이 !
> require 'nokogiri'
>
> # API url
> url = "https://api.telegram.org/bot"
> #API 토큰 정보
> token = "bot API Key"
> # json의 결과를 response에 저장
> response = HTTParty.get("#{url}#{token}/getUpdates")
> #json으로 된 자료를 ruby의 hash로 변환
> hash = JSON.parse(response.body)
>
> # 챗 아이디를 뽑아줘 !
> chat_id = hash["result"][0]["message"]["from"]["id"]
>
> # 굳이 해쉬 안써도 됨 ! 연습할려고 써봄 !
> hash = {
>  conv: ["코끼리를 냉장고에 넣는 방법은?", "냉장고 문을 열고 코끼리를 넣고 문을 닫는다.", "그러면 기린을 냉장고에 넣는 방법은?", "냉장고 문을 열고, 코끼리를 꺼낸 뒤, 기린을 넣는다.",
>  "사자가 모든 동물들이 참가하는 동물회의를 열었는데, 한 동물이 결석했다. 빠진 동물은?", "기린. 아직 냉장고에 있다.", "악어가 득실거려 들어가면 위험한 강을 건너려고 한다. 건너갈 수 있는 배도 없다. 어떻게 건너가면 될까?", "그냥 헤엄쳐서 건넌다. 악어들은 모두 동물회의에 갔다.",
>  "회의 중 사자가 목이 말라 음료수를 가져오라 했는데 누구한테 심부름을 시키는게 가장 효율적일까?", "기린에게 냉장고에서 나오면서 음료수를 가져오라 하면 된다."],
> }
> run = "true"
> while run
>  10.times do |n|
>  chat_msg = hash[:conv]["#{n}".to_i]
>
>  encoded_msg = URI.encode(chat_msg)
>
>  HTTParty.get("#{url}#{token}/sendMessage?chat_id=#{chat_id}&text=#{encoded_msg}")
>
>  sleep(3)
>  end
>  n = 9
>  run = "false"
> end
> ```