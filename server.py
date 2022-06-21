from flask import Flask
import requests
import urllib.parse

app = Flask(__name__)

# Set of headers that must be send to stats.nba.com to recieve responses.
stats_nba_headers = {
  'Host': 'stats.nba.com',
  'Referer': 'https://stats.nba.com/%22',
  'Connection': 'keep-alive',
  'Cache-Control': 'no-cache',
  'Pragma': "no-cache",
  'Upgrade-Insecure-Requests': '1',
  'User-Agent':
      'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:72.0) Gecko/20100101 Firefox/72.0',
  'Accept': 'application/json, text/plain, /',
  'Accept-Encoding': 'gzip, deflate, br',
  'Accept-Language': 'en-US,en;q=0.5',
};

# Mapping of request_url to json response.
cache = {}

# Needed to give flutter CORS capabilities.
@app.after_request
def after_request(response):
  response.headers.add('Access-Control-Allow-Origin', '*')
  response.headers.add('Access-Control-Allow-Headers', '*')
  response.headers.add('Access-Control-Allow-Methods', 'GET,PUT,POST,DELETE,OPTIONS')
  response.headers.add('Access-Control-Allow-Credentials', 'true')
  return response

# Proxies nba stats urls (without the https://).
@app.get("/proxy/<url>")
def proxy(url):
    if url in cache:
      return cache[url]

    absolute_url = "https://" + urllib.parse.unquote(url)
    print(absolute_url)
    data = requests.get(url=absolute_url, headers=stats_nba_headers, timeout=5).content
    print(len(data))
    cache[url] = data
    return data

@app.get("/proxy/headerless/<url>")
def proxyHeaderless(url):
    if url in cache:
      return cache[url]

    absolute_url = "https://" + urllib.parse.unquote(url)
    print(absolute_url)
    data = requests.get(url=absolute_url, timeout=5).content
    print(len(data))
    cache[url] = data
    return data

@app.route("/")
def home():
    print(f"Home page")
    return "Use /proxy."

app.run(debug = True) 