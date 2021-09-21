require 'securerandom'
require 'base64'
require 'OpenSSL'
require 'net/http'
require 'uri'
require 'json'
#上面都內建，不用安裝。YA!

secrect = "請換成你的key"
nonce = SecureRandom.uuid
signature_uri = "/v3/payments/request"
body = {
  amount: 500,
  currency: "TWD",
  orderId: "order20210921005",
  packages: [
    {
      id: "nauosika0105",
      amount: 500,
      products: [
        {
          name: "買不起的iphone13pro",
          quantity: 1,
          price: 500
        }
      ]
    }
  ],
  redirectUrls: {
    confirmUrl: "http://127.0.0.1:3000/confitmUrl",
    cancelUrl: "http://127.0.0.1:3000/cancelUrl"
  }
}

def get_signature(secrect, signature_uri, body, nonce)
  message = "#{secrect}#{signature_uri}#{body.to_json}#{nonce}"
  hash = OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha256'), secrect, message)
  Base64.strict_encode64(hash)
end

signature = get_signature(secrect, signature_uri, body, nonce)

header = {"Content-Type": "application/json",
          "X-LINE-ChannelId": "請換成你的測試ID",
          "X-LINE-Authorization-Nonce": nonce,
          "X-LINE-Authorization": signature
}

uri = URI.parse("https://sandbox-api-pay.line.me/v3/payments/request")
http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = true #一定要開喔。

equest = Net::HTTP::Post.new(uri.request_uri, header)
request.body = body.to_json
#這兩行是帶資料進去，可以發現跟js很不同

response = http.request(request)
# http.request(request)方法內帶回傳所以用變數去指向。

puts response.body #實體方法。