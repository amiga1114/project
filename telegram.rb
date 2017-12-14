require 'httparty'
require 'awesome_print'
require 'json'
require 'uri'
require 'nokogiri'

url = "https://api.telegram.org/bot"
token = "451366308:AAEkIKFSYDekl9pLMnVqtHT31kpTIZiABPo"

response = HTTParty.get("#{url}#{token}/getUpdates")
hash = JSON.parse(response.body)
chat_id = hash["result"][0]["message"]["from"]["id"]

msg = "공부해"
encoded = URI.encode(msg)

# kospo 지수 스크랩
res = HTTParty.get("http://finance.naver.com/sise/")
html = Nokogiri::HTML(res.body)
kospi = html.css('#KOSPI_now').text

msg = kospi
encoded = URI.encode(msg)


# 로또 API로 로또 번호 가져오기
resp = HTTParty.get("http://www.nlotto.co.kr/common.do?method=getLottoNumber&drwNo=784")
lotto = JSON.parse(resp.body)

lucky = []

6.tiimes do |n|
  lucky << lotto["drwtNo#{n+1}"]
end

bonus = lotto["bnusNo"]
winner = lucky.to_s

msg = "로또 번호는 #{winner} #{bonus}"
encoded = URI.encode(msg)


# while true
  HTTParty.get("#{url}#{token}/sendMessage?chat_id=#{chat_id}&text=#{encoded}")
  # sleep(60)
# end
